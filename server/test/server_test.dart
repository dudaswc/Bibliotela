import 'dart:convert';
import 'dart:io';

import 'package:bibliotela_server/bibliotela_server.dart';
import 'package:test/test.dart';

class Reply {
  Reply(this.status, this.headers, this.text);

  final int status;
  final HttpHeaders headers;
  final String text;

  dynamic get json => jsonDecode(text);
  Map<String, dynamic> get error => (json as Map<String, dynamic>)['error'] as Map<String, dynamic>;
  Map<String, dynamic> get fields => error['fields'] as Map<String, dynamic>;
}

class Case {
  const Case(this.name, this.body, this.field, this.message);

  final String name;
  final Map<String, Object?> body;
  final String field;
  final String message;
}

void main() {
  late BibliotelaServer app;
  late String base;

  setUpAll(() async {
    app = BibliotelaServer(const Config(port: 0, latencyMinMs: 0, latencyMaxMs: 0, timeoutHoldMs: 300));
    final server = await app.start();
    base = 'http://127.0.0.1:${server.port}';
  });

  tearDownAll(() => app.stop());

  Future<Reply> call(
    String method,
    String path, {
    String? token,
    Object? body,
    String? rawBody,
    Map<String, String> headers = const {},
  }) async {
    final client = HttpClient();
    try {
      final request = await client.openUrl(method, Uri.parse('$base$path'));
      if (token != null) request.headers.set('authorization', 'Bearer $token');
      for (final entry in headers.entries) {
        request.headers.set(entry.key, entry.value);
      }
      if (body != null || rawBody != null) {
        request.headers.contentType = ContentType.json;
        request.write(rawBody ?? jsonEncode(body));
      }
      final response = await request.close();
      final text = await response.transform(utf8.decoder).join();
      return Reply(response.statusCode, response.headers, text);
    } finally {
      client.close(force: true);
    }
  }

  Future<String> login([String email = 'ana@bibliotela.dev']) async {
    final reply = await call('POST', '/auth/login', body: {'email': email, 'password': '123456'});
    expect(reply.status, 200);
    return reply.json['token'] as String;
  }

  Future<List<dynamic>> items(String token, [String query = '']) async {
    final reply = await call('GET', '/items?pageSize=100$query', token: token);
    expect(reply.status, 200);
    return reply.json['items'] as List<dynamic>;
  }

  List<String> titles(List<dynamic> list) => [
        for (final item in list) (item as Map<String, dynamic>)['title'] as String,
      ];

  Future<Map<String, dynamic>> findByTitle(String token, String title) async {
    final list = await items(token, '&q=${Uri.encodeQueryComponent(title)}');
    return list.firstWhere((i) => (i as Map<String, dynamic>)['title'] == title) as Map<String, dynamic>;
  }

  final isoSeconds = RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$');

  Map<String, Object?> doneBook({String title = 'Livro novo', int? pages = 100, Object? rating}) => {
        'type': 'book',
        'title': title,
        'status': 'done',
        'startedAt': '2026-10-01',
        'finishedAt': '2026-10-10',
        'pages': pages,
        'rating': rating,
      };

  group('rotas publicas', () {
    test('GET /health responde ok com a versao', () async {
      final reply = await call('GET', '/health');
      expect(reply.status, 200);
      expect(reply.json, {'status': 'ok', 'version': '0.1.0'});
      expect(reply.headers.contentType?.mimeType, 'application/json');
      expect(reply.headers.contentType?.charset, 'utf-8');
    });

    test('OPTIONS responde 204 com CORS aberto', () async {
      final reply = await call('OPTIONS', '/items');
      expect(reply.status, 204);
      expect(reply.headers.value('access-control-allow-origin'), '*');
    });

    test('login devolve token e usuario', () async {
      final reply = await call('POST', '/auth/login', body: {'email': 'ana@bibliotela.dev', 'password': '123456'});
      expect(reply.status, 200);
      final token = reply.json['token'] as String;
      expect(token, startsWith('tok_'));
      expect(token.length, 28);
      expect(reply.json['user'], {
        'id': 'usr_01',
        'name': 'Ana Ribeiro',
        'email': 'ana@bibliotela.dev',
        'avatarUrl': null,
        'createdAt': '2024-03-11T09:00:00Z',
      });
    });

    test('login com senha errada da 401 invalid_credentials', () async {
      final reply = await call('POST', '/auth/login', body: {'email': 'ana@bibliotela.dev', 'password': 'errada'});
      expect(reply.status, 401);
      expect(reply.error['code'], 'invalid_credentials');
    });

    test('login com campos vazios da 422 com fields', () async {
      final reply = await call('POST', '/auth/login', body: {'email': '', 'password': ''});
      expect(reply.status, 422);
      expect(reply.error['code'], 'validation');
      expect(reply.fields, {'email': 'must not be empty', 'password': 'must not be empty'});
    });

    test('login com JSON malformado da 400', () async {
      final reply = await call('POST', '/auth/login', rawBody: '{oops');
      expect(reply.status, 400);
      expect(reply.error, {'code': 'bad_request', 'message': 'Malformed JSON body'});
    });
  });

  group('autenticacao', () {
    test('rota protegida sem token da 401 unauthorized', () async {
      final reply = await call('GET', '/me');
      expect(reply.status, 401);
      expect(reply.error['code'], 'unauthorized');
    });

    test('token desconhecido e cabecalho sem Bearer dao 401', () async {
      expect((await call('GET', '/me', token: 'tok_inexistente')).status, 401);
      final reply = await call('GET', '/me', headers: {'authorization': 'abc'});
      expect(reply.status, 401);
    });

    test('logout encerra a sessao: o token passa a dar 401', () async {
      final token = await login();
      expect((await call('POST', '/auth/logout', token: token)).status, 204);
      final reply = await call('GET', '/me', token: token);
      expect(reply.status, 401);
      expect(reply.error['code'], 'unauthorized');
    });

    test('rota inexistente: 401 sem token e 404 com token', () async {
      expect((await call('GET', '/nada')).status, 401);
      final token = await login();
      final reply = await call('GET', '/nada', token: token);
      expect(reply.status, 404);
      expect(reply.error, {'code': 'not_found', 'message': 'Route /nada not found'});
    });
  });

  group('perfil', () {
    test('GET /me devolve o usuario da sessao', () async {
      final token = await login('bruno@bibliotela.dev');
      final reply = await call('GET', '/me', token: token);
      expect(reply.status, 200);
      expect(reply.json['id'], 'usr_02');
      expect(reply.json['name'], 'Bruno Costa');
    });

    test('PUT /me atualiza nome e avatar e mantem o resto', () async {
      final token = await login();
      final reply = await call('PUT', '/me', token: token, body: {'name': '  Ana R.  ', 'avatarUrl': ''});
      expect(reply.status, 200);
      expect(reply.json['name'], 'Ana R.');
      expect(reply.json['avatarUrl'], isNull);
      expect(reply.json['email'], 'ana@bibliotela.dev');
      expect(reply.json['createdAt'], '2024-03-11T09:00:00Z');
    });

    test('PUT /me com nome vazio da 422 e com JSON ruim da 400', () async {
      final token = await login();
      final invalid = await call('PUT', '/me', token: token, body: {'name': '   '});
      expect(invalid.status, 422);
      expect(invalid.fields, {'name': 'must not be empty'});
      expect((await call('PUT', '/me', token: token, rawBody: 'nao e json')).status, 400);
    });
  });

  group('generos', () {
    test('lista os 12 generos, com Outros no fim', () async {
      final token = await login();
      final reply = await call('GET', '/genres', token: token);
      expect(reply.status, 200);
      final list = reply.json['items'] as List<dynamic>;
      expect(list.length, 12);
      expect(list.first, 'Ação');
      expect(list.last, 'Outros');
      expect(list, contains('Ficção científica'));
    });
  });

  group('listagem de itens', () {
    test('Ana tem 45 itens e Bruno tem 15', () async {
      final ana = await call('GET', '/items?pageSize=1', token: await login());
      final bruno = await call('GET', '/items?pageSize=1', token: await login('bruno@bibliotela.dev'));
      expect(ana.json['total'], 45);
      expect(bruno.json['total'], 15);
    });

    test('padrao: pagina 1, 20 por pagina', () async {
      final reply = await call('GET', '/items', token: await login());
      expect(reply.json['page'], 1);
      expect(reply.json['pageSize'], 20);
      expect((reply.json['items'] as List<dynamic>).length, 20);
      expect(reply.json['total'], 45);
    });

    test('ordenacao: data de leitura do mais recente para o mais antigo, e os want no fim', () async {
      final list = titles(await items(await login()));
      expect(list.take(6).toList(), ['Titanic', 'Drácula', 'Neuromancer', 'Oppenheimer', 'Severance', 'Os Miseráveis']);
      expect(list.skip(list.length - 6).toList(), ['Grande Sertão: Veredas', 'Fahrenheit 451', 'Interestelar', 'Sociedade da Neve', 'The Bear', 'Succession']);
    });

    test('paginacao: a segunda pagina continua de onde a primeira parou', () async {
      final token = await login();
      final page2 = await call('GET', '/items?pageSize=20&page=2', token: token);
      expect((page2.json['items'] as List<dynamic>).length, 20);
      expect((page2.json['items'] as List<dynamic>).first['title'], 'Blade Runner 2049');
      final page3 = await call('GET', '/items?pageSize=20&page=3', token: token);
      expect((page3.json['items'] as List<dynamic>).length, 45 - 40);
    });

    test('uma pagina alem do fim devolve lista vazia, nao erro', () async {
      final reply = await call('GET', '/items?page=99', token: await login());
      expect(reply.status, 200);
      expect(reply.json['items'], isEmpty);
      expect(reply.json['total'], 45);
    });

    test('filtros de ano, status, tipo e genero', () async {
      final token = await login();
      Future<int> total(String query) async => (await call('GET', '/items?pageSize=1$query', token: token)).json['total'] as int;
      expect(await total('&year=2025'), 20);
      expect(await total('&year=2026'), 31);
      expect(await total('&status=want'), 6);
      expect(await total('&status=in_progress'), 4);
      expect(await total('&status=done'), 35);
      expect(await total('&type=book'), 19);
      expect(await total('&genre=Fantasia'), 2);
      expect(await total('&year=2026&status=done&type=book'), 9);
    });

    test('o filtro de ano mantem os itens want (nao tem data de leitura)', () async {
      final list = titles(await items(await login(), '&year=2025'));
      expect(list, containsAll(['Fahrenheit 451', 'Grande Sertão: Veredas', 'Interestelar', 'Sociedade da Neve', 'Succession', 'The Bear']));
    });

    test('busca em titulo e autor, sem diferenciar maiusculas', () async {
      final token = await login();
      expect(titles(await items(token, '&q=duna'))..sort(), ['Duna', 'Duna: Parte Dois']);
      expect(titles(await items(token, '&q=DUNA'))..sort(), ['Duna', 'Duna: Parte Dois']);
      expect(titles(await items(token, '&q=tolkien'))..sort(), ['O Hobbit']);
    });

    test('parametros invalidos dao 422 com uma mensagem por campo', () async {
      final reply = await call(
        'GET',
        '/items?year=26&status=lendo&type=x&genre=Nada&page=0&pageSize=101',
        token: await login(),
      );
      expect(reply.status, 422);
      expect(reply.fields.keys.toSet(), {'year', 'status', 'type', 'genre', 'page', 'pageSize'});
      expect(reply.fields['year'], 'must be in the format YYYY');
      expect(reply.fields['status'], 'must be one of: want, in_progress, done');
    });
  });

  group('um item', () {
    test('GET /items/:id devolve o item, com todos os campos', () async {
      final reply = await call('GET', '/items/it_0001', token: await login());
      expect(reply.status, 200);
      expect(reply.json['title'], 'Duna');
      expect((reply.json as Map<String, dynamic>).keys.toList(), [
        'id', 'type', 'title', 'genre', 'status', 'startedAt', 'finishedAt', 'rating', 'note',
        'pages', 'author', 'seasons', 'durationMinutes', 'addedAt',
      ]);
    });

    test('GET de id inexistente da 404', () async {
      final reply = await call('GET', '/items/it_9999', token: await login());
      expect(reply.status, 404);
      expect(reply.error, {'code': 'not_found', 'message': 'Item it_9999 not found'});
    });

    test('POST cria o item: 201, id e addedAt gerados pelo servidor', () async {
      final token = await login();
      final reply = await call('POST', '/items', token: token, body: {
        'id': 'it_0001',
        'addedAt': '1999-01-01T00:00:00Z',
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
      });
      expect(reply.status, 201);
      expect(reply.json['id'], 'it_0046');
      expect(isoSeconds.hasMatch(reply.json['addedAt'] as String), isTrue);
      expect(reply.json['addedAt'], isNot('1999-01-01T00:00:00Z'));
      expect(reply.json['seasons'], isNull);
      expect(reply.json['durationMinutes'], isNull);
      expect((await call('GET', '/items/it_0046', token: token)).status, 200);
      expect((await call('GET', '/items?pageSize=1', token: token)).json['total'], 45 + 1);
    });

    test('POST descarta o que nao vale para o status ou para o tipo', () async {
      final reply = await call('POST', '/items', token: await login(), body: {
        'type': 'movie',
        'title': 'Filme',
        'status': 'want',
        'startedAt': '2026-01-01',
        'finishedAt': '2026-01-02',
        'rating': 9,
        'pages': 300,
        'author': 'Alguem',
        'seasons': 3,
        'durationMinutes': 120,
      });
      expect(reply.status, 201);
      expect(reply.json['startedAt'], isNull);
      expect(reply.json['finishedAt'], isNull);
      expect(reply.json['rating'], isNull);
      expect(reply.json['pages'], isNull);
      expect(reply.json['author'], isNull);
      expect(reply.json['seasons'], isNull);
      expect(reply.json['durationMinutes'], 120);
    });

    test('POST em andamento descarta finishedAt e nota', () async {
      final reply = await call('POST', '/items', token: await login(), body: {
        'type': 'series',
        'title': 'Serie',
        'status': 'in_progress',
        'startedAt': '2026-10-01',
        'finishedAt': '2026-10-05',
        'rating': 8,
        'seasons': 2,
      });
      expect(reply.status, 201);
      expect(reply.json['startedAt'], '2026-10-01');
      expect(reply.json['finishedAt'], isNull);
      expect(reply.json['rating'], isNull);
    });

    test('POST normaliza textos: espacos nas pontas e vazio vira null', () async {
      final reply = await call('POST', '/items', token: await login(), body: {
        'type': 'book',
        'title': '  Duna  ',
        'genre': '',
        'status': 'want',
        'note': '   ',
        'author': ' ',
      });
      expect(reply.status, 201);
      expect(reply.json['title'], 'Duna');
      expect(reply.json['genre'], isNull);
      expect(reply.json['note'], isNull);
      expect(reply.json['author'], isNull);
    });

    test('POST vazio da 422 nos campos obrigatorios', () async {
      final reply = await call('POST', '/items', token: await login(), body: <String, Object?>{});
      expect(reply.status, 422);
      expect(reply.error['code'], 'validation');
      expect(reply.error['message'], 'Invalid item');
      expect(reply.fields.keys.toSet(), {'type', 'title', 'status'});
      expect(reply.fields['type'], 'must be one of: book, series, movie');
      expect(reply.fields['title'], 'must not be empty');
    });

    test('POST valida as regras por status e por campo', () async {
      final token = await login();
      final cases = <Case>[
        const Case('done sem finishedAt', {'type': 'book', 'title': 'A', 'status': 'done'}, 'finishedAt', 'is required when status is done'),
        const Case('em andamento sem startedAt', {'type': 'book', 'title': 'A', 'status': 'in_progress'}, 'startedAt', 'is required when status is in_progress'),
        const Case(
          'startedAt depois de finishedAt',
          {'type': 'book', 'title': 'A', 'status': 'done', 'startedAt': '2026-09-10', 'finishedAt': '2026-09-01'},
          'startedAt',
          'must not be after finishedAt',
        ),
        const Case('nota 11', {'type': 'book', 'title': 'A', 'status': 'done', 'finishedAt': '2026-09-01', 'rating': 11}, 'rating', 'must be an integer from 1 to 10'),
        const Case('nota 0', {'type': 'book', 'title': 'A', 'status': 'done', 'finishedAt': '2026-09-01', 'rating': 0}, 'rating', 'must be an integer from 1 to 10'),
        const Case('paginas zero', {'type': 'book', 'title': 'A', 'status': 'want', 'pages': 0}, 'pages', 'must be greater than zero'),
        const Case('genero fora da lista', {'type': 'book', 'title': 'A', 'status': 'want', 'genre': 'Nada'}, 'genre', 'must be one of the values from /genres'),
        const Case('data inexistente', {'type': 'book', 'title': 'A', 'status': 'done', 'finishedAt': '2026-02-30'}, 'finishedAt', 'must be a date in the format YYYY-MM-DD'),
      ];
      for (final c in cases) {
        final reply = await call('POST', '/items', token: token, body: c.body);
        expect(reply.status, 422, reason: c.name);
        expect(reply.fields[c.field], c.message, reason: c.name);
      }
    });

    test('POST com JSON malformado da 400', () async {
      final reply = await call('POST', '/items', token: await login(), rawBody: '{oops');
      expect(reply.status, 400);
      expect(reply.error['code'], 'bad_request');
    });

    test('PUT substitui o item inteiro, mantem o addedAt e o id do caminho prevalece', () async {
      final token = await login();
      final original = await findByTitle(token, 'Severance');
      final reply = await call('PUT', '/items/${original['id']}', token: token, body: {
        'id': 'it_9999',
        'addedAt': '1999-01-01T00:00:00Z',
        'type': 'series',
        'title': 'Severance',
        'genre': 'Suspense',
        'status': 'done',
        'startedAt': '2026-09-20',
        'finishedAt': '2026-09-28',
        'rating': 9,
        'note': null,
        'seasons': 2,
      });
      expect(reply.status, 200);
      expect(reply.json['id'], original['id']);
      expect(reply.json['addedAt'], original['addedAt']);
      expect(reply.json['status'], 'done');
      expect(reply.json['rating'], 9);
      expect(reply.json['note'], isNull);
    });

    test('PUT: a validacao vem antes do 404', () async {
      final token = await login();
      final invalid = await call('PUT', '/items/it_9999', token: token, body: <String, Object?>{});
      expect(invalid.status, 422);
      final missing = await call('PUT', '/items/it_9999', token: token, body: doneBook());
      expect(missing.status, 404);
      expect((await call('PUT', '/items/it_9999', token: token, rawBody: 'x')).status, 400);
    });

    test('DELETE remove o item; apagar de novo da 404', () async {
      final token = await login();
      expect((await call('DELETE', '/items/it_0001', token: token)).status, 204);
      expect((await call('GET', '/items/it_0001', token: token)).status, 404);
      expect((await call('DELETE', '/items/it_0001', token: token)).status, 404);
      expect((await call('GET', '/items?pageSize=1', token: token)).json['total'], 45 - 1);
    });
  });

  group('resumo do ano', () {
    final Map<String, Object?> expected2026 = {'books': {'finished': 9, 'pages': 3024}, 'movies': {'finished': 8, 'minutes': 1102}, 'series': {'finished': 4, 'seasons': 11}, 'averageRating': 8.5, 'byGenre': [{'genre': 'Ficção científica', 'count': 5}, {'genre': 'Drama', 'count': 4}, {'genre': 'Comédia', 'count': 3}, {'genre': null, 'count': 2}, {'genre': 'Romance', 'count': 2}, {'genre': 'Suspense', 'count': 2}, {'genre': 'Fantasia', 'count': 1}, {'genre': 'Outros', 'count': 1}, {'genre': 'Terror', 'count': 1}]};
    final Map<String, Object?> expected2025 = {'books': {'finished': 6, 'pages': 1864}, 'movies': {'finished': 5, 'minutes': 663}, 'series': {'finished': 3, 'seasons': 20}, 'averageRating': 8.6, 'byGenre': [{'genre': 'Ação', 'count': 2}, {'genre': 'Drama', 'count': 2}, {'genre': 'Ficção científica', 'count': 2}, {'genre': 'Romance', 'count': 2}, {'genre': 'Aventura', 'count': 1}, {'genre': 'Biografia', 'count': 1}, {'genre': 'Comédia', 'count': 1}, {'genre': 'Fantasia', 'count': 1}, {'genre': 'Suspense', 'count': 1}, {'genre': 'Terror', 'count': 1}]};
    final Map<String, Object?> expectedBruno2026 = {'books': {'finished': 2, 'pages': 576}, 'movies': {'finished': 2, 'minutes': 288}, 'series': {'finished': 2, 'seasons': 12}, 'averageRating': 8.8, 'byGenre': [{'genre': 'Comédia', 'count': 2}, {'genre': 'Drama', 'count': 2}, {'genre': 'Fantasia', 'count': 1}, {'genre': 'Suspense', 'count': 1}]};

    void expectSummary(Reply reply, int year, Map<String, Object?> expected) {
      expect(reply.status, 200);
      final body = reply.json as Map<String, dynamic>;
      expect(body['year'], year);
      for (final key in ['books', 'movies', 'series', 'averageRating', 'byGenre']) {
        expect(body[key], expected[key], reason: key);
      }
    }

    test('2026 da Ana', () async {
      expectSummary(await call('GET', '/summary?year=2026', token: await login()), 2026, expected2026);
    });

    test('2025 da Ana', () async {
      expectSummary(await call('GET', '/summary?year=2025', token: await login()), 2025, expected2025);
    });

    test('2026 do Bruno', () async {
      final token = await login('bruno@bibliotela.dev');
      expectSummary(await call('GET', '/summary?year=2026', token: token), 2026, expectedBruno2026);
    });

    test('um ano sem nada concluido devolve zeros, media nula e lista vazia', () async {
      final reply = await call('GET', '/summary?year=1999', token: await login());
      expect(reply.status, 200);
      expect(reply.json, {
        'year': 1999,
        'books': {'finished': 0, 'pages': 0},
        'movies': {'finished': 0, 'minutes': 0},
        'series': {'finished': 0, 'seasons': 0},
        'averageRating': null,
        'byGenre': <Object?>[],
      });
    });

    test('ano invalido da 422', () async {
      final reply = await call('GET', '/summary?year=26', token: await login());
      expect(reply.status, 422);
      expect(reply.fields, {'year': 'must be in the format YYYY'});
    });

    test('concluir um livro atualiza o resumo', () async {
      final token = await login();
      final before = (await call('GET', '/summary?year=2026', token: token)).json as Map<String, dynamic>;
      final created = await call('POST', '/items', token: token, body: doneBook(pages: 100));
      expect(created.status, 201);
      final after = (await call('GET', '/summary?year=2026', token: token)).json as Map<String, dynamic>;
      expect(after['books']['finished'], (before['books']['finished'] as int) + 1);
      expect(after['books']['pages'], (before['books']['pages'] as int) + 100);
      expect(after['books']['pages'], 3024 + 100);
    });
  });

  group('sessoes', () {
    test('cada login tem token proprio e dados isolados', () async {
      final a = await login();
      final b = await login();
      expect(a, isNot(b));
      expect((await call('DELETE', '/items/it_0001', token: a)).status, 204);
      expect((await call('GET', '/items?pageSize=1', token: a)).json['total'], 45 - 1);
      expect((await call('GET', '/items?pageSize=1', token: b)).json['total'], 45);
    });

    test('POST /reset devolve itens e perfil ao seed, e o token continua valido', () async {
      final token = await login();
      await call('DELETE', '/items/it_0001', token: token);
      await call('PUT', '/me', token: token, body: {'name': 'Outro nome'});
      expect((await call('POST', '/reset', token: token)).status, 204);
      expect((await call('GET', '/items?pageSize=1', token: token)).json['total'], 45);
      final me = await call('GET', '/me', token: token);
      expect(me.status, 200);
      expect(me.json['name'], 'Ana Ribeiro');
    });
  });

  group('cabecalhos de simulacao', () {
    test('X-Fail: 500 devolve 500 internal', () async {
      final reply = await call('GET', '/health', headers: {'x-fail': '500'});
      expect(reply.status, 500);
      expect(reply.error, {'code': 'internal', 'message': 'Simulated failure'});
    });

    test('X-Fail: expired devolve 401 token_expired, ate sem token (vem antes da autenticacao)', () async {
      final reply = await call('GET', '/me', headers: {'x-fail': 'expired'});
      expect(reply.status, 401);
      expect(reply.error, {'code': 'token_expired', 'message': 'Token has expired'});
    });

    test('X-Fail: timeout segura a requisicao e responde 504 em texto puro', () async {
      final watch = Stopwatch()..start();
      final reply = await call('GET', '/health', headers: {'x-fail': 'timeout'});
      expect(reply.status, 504);
      expect(reply.headers.contentType?.mimeType, 'text/plain');
      expect(reply.text, 'Gateway Timeout');
      expect(watch.elapsedMilliseconds, greaterThanOrEqualTo(250));
    });

    test('X-Delay-Ms usa exatamente a latencia pedida', () async {
      final watch = Stopwatch()..start();
      final reply = await call('GET', '/health', headers: {'x-delay-ms': '250'});
      expect(reply.status, 200);
      expect(watch.elapsedMilliseconds, greaterThanOrEqualTo(240));
    });
  });
}
