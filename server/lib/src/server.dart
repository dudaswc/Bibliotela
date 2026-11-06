import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'config.dart';
import 'errors.dart';
import 'genres.dart';
import 'query.dart';
import 'seed.dart';
import 'session.dart';
import 'summary.dart';
import 'validation.dart';

/// Servidor mock da API da Bibliotela. Cumpre o contrato do PDF
/// "Referencia da API · Bibliotela": 13 rotas, JSON, token Bearer, dados por
/// sessao, latencia simulada e cabecalhos X-Delay-Ms e X-Fail.
class BibliotelaServer {
  BibliotelaServer(this.config, {Random? random})
      : _random = random ?? Random(),
        _sessions = SessionStore();

  final Config config;
  final Random _random;
  final SessionStore _sessions;
  HttpServer? _server;

  Future<HttpServer> start() async {
    final server = await HttpServer.bind(InternetAddress.anyIPv4, config.port);
    _server = server;
    server.listen(_onRequest);
    return server;
  }

  Future<void> stop() async {
    await _server?.close(force: true);
  }

  // ------------------------------------------------------------------ entrada

  Future<void> _onRequest(HttpRequest request) async {
    final watch = Stopwatch()..start();
    _setCors(request.response);
    try {
      await _dispatch(request);
    } on ApiException catch (error) {
      await _trySend(() => _sendJson(request, error.status, error.toJson()));
    } catch (error, stack) {
      stderr.writeln('Unexpected error on ${request.method} ${request.uri.path}: $error\n$stack');
      await _trySend(
        () => _sendJson(request, 500, const ApiException(500, 'internal', 'Unexpected error').toJson()),
      );
    }
    stdout.writeln('${request.method} ${request.uri.path} ${request.response.statusCode} ${watch.elapsedMilliseconds}ms');
  }

  Future<void> _trySend(Future<void> Function() send) async {
    try {
      await send();
    } catch (_) {
      // A resposta ja foi enviada, ou o cliente desistiu.
    }
  }

  bool _is(List<String> segments, List<String> expected) {
    if (segments.length != expected.length) return false;
    for (var i = 0; i < segments.length; i++) {
      if (segments[i] != expected[i]) return false;
    }
    return true;
  }

  Future<void> _dispatch(HttpRequest request) async {
    final method = request.method;

    // CORS: qualquer origem; OPTIONS responde 204 na hora.
    if (method == 'OPTIONS') {
      await _sendEmpty(request, 204);
      return;
    }

    // Cabecalhos de simulacao valem em qualquer rota, antes da autenticacao.
    if (await _simulate(request)) return;

    final segments = request.uri.pathSegments.where((s) => s.isNotEmpty).toList();

    // Rotas publicas.
    if (method == 'GET' && _is(segments, ['health'])) {
      await _sendJson(request, 200, {'status': 'ok', 'version': config.version});
      return;
    }
    if (method == 'POST' && _is(segments, ['auth', 'login'])) {
      await _login(request);
      return;
    }

    // Daqui em diante tudo exige token, inclusive rotas que nao existem.
    final session = _authenticate(request);

    if (method == 'POST' && _is(segments, ['auth', 'logout'])) {
      _sessions.logout(session.token);
      await _sendEmpty(request, 204);
      return;
    }

    if (_is(segments, ['me'])) {
      if (method == 'GET') {
        await _sendJson(request, 200, session.user.toJson());
        return;
      }
      if (method == 'PUT') {
        final profile = parseProfile(await _readJsonObject(request));
        session.user = session.user.withProfile(name: profile.name, avatarUrl: profile.avatarUrl);
        await _sendJson(request, 200, session.user.toJson());
        return;
      }
    }

    if (method == 'GET' && _is(segments, ['genres'])) {
      await _sendJson(request, 200, {'items': genres});
      return;
    }

    if (_is(segments, ['items'])) {
      if (method == 'GET') {
        final query = ItemQuery.fromParams(request.uri.queryParameters);
        await _sendJson(request, 200, listItems(session.items, query).toJson());
        return;
      }
      if (method == 'POST') {
        final body = await _readJsonObject(request);
        final item = parseItem(body, id: session.peekItemId(), addedAt: _nowIso());
        session.add(item);
        await _sendJson(request, 201, item.toJson());
        return;
      }
    }

    if (segments.length == 2 && segments[0] == 'items') {
      final id = segments[1];
      if (method == 'GET') {
        final item = session.find(id);
        if (item == null) throw ApiException.notFound('Item $id not found');
        await _sendJson(request, 200, item.toJson());
        return;
      }
      if (method == 'PUT') {
        final body = await _readJsonObject(request);
        final existing = session.find(id);
        // A validacao vem antes: corpo invalido para id inexistente da 422.
        final item = parseItem(body, id: id, addedAt: existing?.addedAt ?? _nowIso());
        if (existing == null) throw ApiException.notFound('Item $id not found');
        session.replace(item);
        await _sendJson(request, 200, item.toJson());
        return;
      }
      if (method == 'DELETE') {
        if (!session.remove(id)) throw ApiException.notFound('Item $id not found');
        await _sendEmpty(request, 204);
        return;
      }
    }

    if (method == 'GET' && _is(segments, ['summary'])) {
      final raw = request.uri.queryParameters['year'];
      final year = (raw == null || raw.trim().isEmpty) ? '${DateTime.now().year}' : raw.trim();
      if (!RegExp(r'^\d{4}$').hasMatch(year)) {
        throw ApiException.validation({'year': 'must be in the format YYYY'}, message: 'Invalid query');
      }
      await _sendJson(request, 200, computeSummary(session.items, year));
      return;
    }

    if (method == 'POST' && _is(segments, ['reset'])) {
      session.reset();
      await _sendEmpty(request, 204);
      return;
    }

    throw ApiException.notFound('Route ${request.uri.path} not found');
  }

  // ------------------------------------------------------------------ rotas

  Future<void> _login(HttpRequest request) async {
    final body = await _readJsonObject(request);
    final email = body['email'];
    final password = body['password'];
    final emailText = email is String ? email.trim() : '';
    final passwordText = password is String ? password : '';

    final fields = <String, String>{};
    if (emailText.isEmpty) fields['email'] = 'must not be empty';
    if (passwordText.isEmpty) fields['password'] = 'must not be empty';
    if (fields.isNotEmpty) throw ApiException.validation(fields, message: 'Invalid login');

    final seed = findSeedUser(emailText.toLowerCase());
    if (seed == null || seed.password != passwordText) {
      throw const ApiException(401, 'invalid_credentials', 'Invalid email or password');
    }
    final session = _sessions.login(seed);
    await _sendJson(request, 200, {'token': session.token, 'user': session.user.toJson()});
  }

  Session _authenticate(HttpRequest request) {
    final header = request.headers.value('authorization') ?? '';
    if (!header.startsWith('Bearer ')) throw ApiException.unauthorized();
    final session = _sessions.byToken(header.substring(7).trim());
    if (session == null) throw ApiException.unauthorized();
    return session;
  }

  // ------------------------------------------------------------------ simulacao

  /// Aplica latencia e X-Fail. Devolve true se ja respondeu (timeout).
  Future<bool> _simulate(HttpRequest request) async {
    final fail = request.headers.value('x-fail');

    if (fail == 'timeout') {
      await Future<void>.delayed(Duration(milliseconds: config.timeoutHoldMs));
      await _sendText(request, 504, 'Gateway Timeout');
      return true;
    }

    final requested = int.tryParse(request.headers.value('x-delay-ms') ?? '');
    final delay = (requested != null && requested >= 0) ? requested : _randomLatency();
    if (delay > 0) await Future<void>.delayed(Duration(milliseconds: delay));

    if (fail == '500') throw const ApiException(500, 'internal', 'Simulated failure');
    if (fail == 'expired') throw const ApiException(401, 'token_expired', 'Token has expired');
    return false;
  }

  int _randomLatency() {
    final min = config.latencyMinMs;
    final max = config.latencyMaxMs;
    return max > min ? min + _random.nextInt(max - min + 1) : min;
  }

  // ------------------------------------------------------------------ corpo e resposta

  Object? _decode(String text) {
    try {
      return jsonDecode(text);
    } on FormatException {
      throw ApiException.badRequest('Malformed JSON body');
    }
  }

  Future<Map<String, dynamic>> _readJsonObject(HttpRequest request) async {
    final String text;
    try {
      text = await utf8.decoder.bind(request).join();
    } on FormatException {
      throw ApiException.badRequest('Malformed JSON body');
    }
    final decoded = _decode(text);
    if (decoded is! Map<String, dynamic>) {
      throw ApiException.badRequest('Body must be a JSON object');
    }
    return decoded;
  }

  void _setCors(HttpResponse response) {
    response.headers
      ..set('Access-Control-Allow-Origin', '*')
      ..set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
      ..set('Access-Control-Allow-Headers', 'Authorization, Content-Type, X-Delay-Ms, X-Fail')
      ..set('Access-Control-Max-Age', '86400');
  }

  Future<void> _sendJson(HttpRequest request, int status, Object? body) async {
    final response = request.response;
    response.statusCode = status;
    response.headers.contentType = ContentType('application', 'json', charset: 'utf-8');
    response.write(jsonEncode(body));
    await response.close();
  }

  Future<void> _sendEmpty(HttpRequest request, int status) async {
    final response = request.response;
    response.statusCode = status;
    await response.close();
  }

  Future<void> _sendText(HttpRequest request, int status, String text) async {
    final response = request.response;
    response.statusCode = status;
    response.headers.contentType = ContentType('text', 'plain', charset: 'utf-8');
    response.write(text);
    await response.close();
  }

  /// ISO 8601 em UTC, sem fracao de segundo: 2026-07-30T18:20:00Z.
  String _nowIso() {
    final iso = DateTime.now().toUtc().toIso8601String();
    return '${iso.substring(0, 19)}Z';
  }
}
