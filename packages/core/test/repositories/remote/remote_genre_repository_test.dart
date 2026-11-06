import 'package:bibliotela_core/bibliotela_core.dart';
import 'package:test/test.dart';

import 'fake_server.dart';

void main() {
  late FakeServer server;
  late RemoteGenreRepository repository;

  setUp(() {
    server = FakeServer();
    repository = RemoteGenreRepository(client: ApiClient(baseUrl: 'http://localhost:8080', adapter: server));
  });

  test('list reads the genres of the contract', () async {
    server.on('GET', '/genres', 200, {'items': ['Ação', 'Drama', 'Outros']});
    expect((await repository.list()).valueOrNull, ['Ação', 'Drama', 'Outros']);
  });

  test('list maps a 401 to UnauthorizedError', () async {
    server.onError('GET', '/genres', 401, 'unauthorized');
    expect((await repository.list()).errorOrNull, isA<UnauthorizedError>());
  });
}
