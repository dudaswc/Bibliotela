import 'dart:convert';
import 'dart:io';

import 'package:bibliotela_server/bibliotela_server.dart';

/// Captura as respostas reais do servidor para documentar a API.
///
/// Uso (dentro da pasta server):  dart run tool/capture.dart
/// Gera tool/capture.json com cada requisicao e a resposta que o servidor deu.
///
/// O script sobe o servidor (o mesmo codigo de bin/server.dart) numa porta livre,
/// sem latencia, e chama as rotas por HTTP de verdade. Nao precisa de nada rodando.
Future<void> main() async {
  final app = BibliotelaServer(
    const Config(port: 0, latencyMinMs: 0, latencyMaxMs: 0, timeoutHoldMs: 500),
  );
  final server = await app.start();
  final base = 'http://127.0.0.1:${server.port}';
  final entries = <Map<String, Object?>>[];
  String? token;

  Future<Map<String, Object?>> call(
    String id,
    String title,
    String method,
    String path, {
    Object? body,
    String? rawBody,
    bool auth = true,
    bool doc = true,
    Map<String, String> headers = const {},
  }) async {
    final client = HttpClient();
    try {
      final request = await client.openUrl(method, Uri.parse('$base$path'));
      final requestHeaders = <String, String>{};
      if (auth && token != null) {
        request.headers.set('authorization', 'Bearer $token');
        requestHeaders['Authorization'] = 'Bearer <token>';
      }
      for (final entry in headers.entries) {
        request.headers.set(entry.key, entry.value);
        requestHeaders[entry.key] = entry.value;
      }
      if (body != null || rawBody != null) {
        request.headers.contentType = ContentType.json;
        requestHeaders['Content-Type'] = 'application/json';
        request.write(rawBody ?? jsonEncode(body));
      }
      final watch = Stopwatch()..start();
      final response = await request.close();
      final text = await response.transform(utf8.decoder).join();
      watch.stop();

      Object? parsed;
      if (text.isNotEmpty) {
        try {
          parsed = jsonDecode(text);
        } on FormatException {
          parsed = text;
        }
      }
      final responseHeaders = <String, String>{};
      response.headers.forEach((name, values) {
        if (name == 'content-type' || name.startsWith('access-control')) {
          responseHeaders[name] = values.join(', ');
        }
      });

      final entry = <String, Object?>{
        'id': id,
        'title': title,
        'doc': doc,
        'method': method,
        'path': path,
        'requestHeaders': requestHeaders,
        'requestBody': rawBody ?? body,
        'status': response.statusCode,
        'responseHeaders': responseHeaders,
        'responseBody': parsed,
        'elapsedMs': watch.elapsedMilliseconds,
      };
      entries.add(entry);
      stdout.writeln('${method.padRight(7)} ${path.padRight(52)} ${response.statusCode}  ${watch.elapsedMilliseconds}ms');
      return entry;
    } finally {
      client.close(force: true);
    }
  }

  Map<String, dynamic> bodyOf(Map<String, Object?> entry) => entry['responseBody'] as Map<String, dynamic>;

  // ---------------------------------------------------------------- saude e login
  await call('health', 'Saude', 'GET', '/health', auth: false);

  final login = await call('login_ok', 'Login', 'POST', '/auth/login',
      auth: false, body: {'email': 'ana@bibliotela.dev', 'password': '123456'});
  token = bodyOf(login)['token'] as String;

  await call('login_invalid', 'Login com senha errada', 'POST', '/auth/login',
      auth: false, body: {'email': 'ana@bibliotela.dev', 'password': 'errada'});
  await call('login_empty', 'Login com campos vazios', 'POST', '/auth/login',
      auth: false, body: {'email': '', 'password': ''});
  await call('login_malformed', 'Login com JSON malformado', 'POST', '/auth/login',
      auth: false, rawBody: '{"email": ');

  // ---------------------------------------------------------------- perfil e generos
  await call('me_get', 'Usuario da sessao', 'GET', '/me');
  await call('me_put', 'Atualizar nome e avatar', 'PUT', '/me', body: {'name': 'Ana R.', 'avatarUrl': null});
  await call('me_put_invalid', 'Atualizar com nome vazio', 'PUT', '/me', body: {'name': '   '});
  await call('me_restore', 'Restaurar o nome', 'PUT', '/me', doc: false, body: {'name': 'Ana Ribeiro', 'avatarUrl': null});
  await call('genres', 'Generos', 'GET', '/genres');

  // ---------------------------------------------------------------- resumo (antes de mexer nos dados)
  await call('summary_2026', 'Resumo de 2026', 'GET', '/summary?year=2026');
  await call('summary_empty', 'Resumo de um ano sem nada concluido', 'GET', '/summary?year=1999');
  await call('summary_invalid', 'Resumo com ano invalido', 'GET', '/summary?year=26');

  // ---------------------------------------------------------------- listagem
  await call('items_default', 'Lista, duas por pagina', 'GET', '/items?pageSize=2');
  await call('items_filtered', 'Lista com filtros', 'GET', '/items?year=2026&status=done&type=book&pageSize=2');
  await call('items_search', 'Busca por titulo ou autor', 'GET', '/items?q=tolkien');
  await call('items_past_end', 'Pagina alem do fim', 'GET', '/items?page=99');
  await call('items_invalid', 'Parametros invalidos', 'GET', '/items?year=26&status=lendo&page=0');

  // ---------------------------------------------------------------- um item
  await call('item_get', 'Um item', 'GET', '/items/it_0001');
  await call('item_404', 'Item inexistente', 'GET', '/items/it_9999');

  final created = await call('item_create', 'Criar um item', 'POST', '/items', body: {
    'type': 'book',
    'title': 'Duna',
    'genre': 'Ficção científica',
    'status': 'done',
    'startedAt': '2026-08-12',
    'finishedAt': '2026-09-06',
    'rating': 9,
    'note': 'Final inesperado',
    'pages': 680,
    'author': 'Frank Herbert',
    'seasons': null,
    'durationMinutes': null,
  });
  final createdId = bodyOf(created)['id'] as String;

  final discarded = await call('item_create_discard', 'Criar descartando o que nao vale', 'POST', '/items', body: {
    'type': 'movie',
    'title': '  Interestelar  ',
    'genre': '',
    'status': 'want',
    'startedAt': '2026-10-01',
    'rating': 9,
    'pages': 300,
    'durationMinutes': 169,
  });
  final discardedId = bodyOf(discarded)['id'] as String;

  await call('item_create_invalid', 'Criar com varios erros', 'POST', '/items', body: {
    'type': 'book',
    'title': '',
    'genre': 'Nada',
    'status': 'done',
    'startedAt': '2026-09-10',
    'finishedAt': '2026-09-01',
    'rating': 11,
    'pages': 0,
  });
  await call('item_create_invalid_enums', 'Criar com tipo e status invalidos', 'POST', '/items',
      body: {'type': 'livro', 'status': 'lendo'});
  await call('item_create_malformed', 'Criar com JSON malformado', 'POST', '/items', rawBody: '{oops');

  final severance = await call('find_severance', 'Busca para o PUT', 'GET', '/items?q=Severance', doc: false);
  final severanceId = ((bodyOf(severance)['items'] as List<dynamic>).first as Map<String, dynamic>)['id'] as String;

  await call('item_put', 'Terminar uma serie em andamento', 'PUT', '/items/$severanceId', body: {
    'type': 'series',
    'title': 'Severance',
    'genre': 'Suspense',
    'status': 'done',
    'startedAt': '2026-09-20',
    'finishedAt': '2026-09-28',
    'rating': 9,
    'note': null,
    'pages': null,
    'author': null,
    'seasons': 2,
    'durationMinutes': null,
  });
  await call('item_put_invalid', 'PUT com corpo invalido em id inexistente', 'PUT', '/items/it_9999', body: {'title': ''});
  await call('item_put_404', 'PUT valido em id inexistente', 'PUT', '/items/it_9999', body: {
    'type': 'book',
    'title': 'Qualquer',
    'status': 'want',
  });

  await call('item_delete', 'Remover um item', 'DELETE', '/items/$createdId');
  await call('item_delete_again', 'Remover o mesmo id de novo', 'DELETE', '/items/$createdId');
  await call('item_delete_other', 'Limpeza', 'DELETE', '/items/$discardedId', doc: false);

  // ---------------------------------------------------------------- reset e logout
  await call('reset', 'Voltar ao seed', 'POST', '/reset');
  await call('after_reset', 'Total depois do reset', 'GET', '/items?pageSize=1', doc: false);
  await call('logout', 'Logout', 'POST', '/auth/logout');
  await call('after_logout', 'Token encerrado', 'GET', '/me');

  // ---------------------------------------------------------------- simulacao, CORS e rota inexistente
  await call('fail_500', 'X-Fail: 500', 'GET', '/health', auth: false, headers: {'X-Fail': '500'});
  await call('fail_expired', 'X-Fail: expired', 'GET', '/me', auth: false, headers: {'X-Fail': 'expired'});
  await call('fail_timeout', 'X-Fail: timeout', 'GET', '/health', auth: false, headers: {'X-Fail': 'timeout'});
  await call('delay', 'X-Delay-Ms: 250', 'GET', '/health', auth: false, headers: {'X-Delay-Ms': '250'});
  await call('cors', 'OPTIONS (CORS)', 'OPTIONS', '/items', auth: false);

  final second = await call('login_again', 'Novo login', 'POST', '/auth/login',
      auth: false, doc: false, body: {'email': 'bruno@bibliotela.dev', 'password': '123456'});
  token = bodyOf(second)['token'] as String;
  await call('route_404', 'Rota inexistente com token', 'GET', '/nada');
  await call('route_401', 'Rota inexistente sem token', 'GET', '/nada', auth: false);

  // ---------------------------------------------------------------- grava o arquivo
  final output = File('tool/capture.json');
  await output.parent.create(recursive: true);
  await output.writeAsString(const JsonEncoder.withIndent('  ').convert({
    'generatedAt': DateTime.now().toUtc().toIso8601String(),
    'serverVersion': '0.1.0',
    'entries': entries,
  }));
  await app.stop();
  stdout.writeln('\nPronto: ${entries.length} requisicoes gravadas em tool/capture.json');
}
