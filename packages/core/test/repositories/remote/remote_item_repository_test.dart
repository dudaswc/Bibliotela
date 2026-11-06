import 'dart:typed_data';

import 'package:bibliotela_core/bibliotela_core.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';

import 'fake_server.dart';

void main() {
  late FakeServer server;
  late RemoteItemRepository repository;

  final duna = SampleData.items().first; // it_0001, a finished book

  setUp(() {
    server = FakeServer();
    repository = RemoteItemRepository(client: ApiClient(baseUrl: 'http://localhost:8080', adapter: server));
  });
  tearDown(() => repository.dispose());

  test('list sends the filter as query parameters and reads the page', () async {
    server.on('GET', '/items', 200, {'items': [duna.toJson()], 'page': 1, 'pageSize': 20, 'total': 1});
    final result = await repository.list(const ItemFilter(year: 2026, status: ItemStatus.done, query: ' duna '));
    expect(server.last.url.queryParameters, {
      'year': '2026',
      'status': 'done',
      'q': 'duna',
      'page': '1',
      'pageSize': '20',
    });
    expect((result.valueOrNull!.total, result.valueOrNull!.items.single), (1, duna));
  });

  test('getById reads one item and maps 404 to NotFoundError', () async {
    server.on('GET', '/items/it_0001', 200, duna.toJson());
    expect((await repository.getById('it_0001')).valueOrNull, duna);
    server.onError('GET', '/items/it_9999', 404, 'not_found');
    expect((await repository.getById('it_9999')).errorOrNull, isA<NotFoundError>());
  });

  test('create posts the item without id and addedAt', () async {
    server.on('POST', '/items', 201, duna.toJson());
    final result = await repository.create(
      Item.draft(
        type: ItemType.book,
        title: 'Duna',
        status: ItemStatus.done,
        startedAt: LocalDate(2026, 8, 12),
        finishedAt: LocalDate(2026, 9, 6),
        rating: 9,
        pages: 680,
      ),
    );
    expect(result.valueOrNull, duna);
    final body = server.lastBody;
    expect((body.containsKey('id'), body.containsKey('addedAt')), (false, false));
    expect((body['status'], body['startedAt'], body['finishedAt'], body['rating']), ('done', '2026-08-12', '2026-09-06', 9));
    expect(server.last.method, 'POST');
  });

  test('create maps a 422 to ValidationError with the fields', () async {
    server.on('POST', '/items', 422, {
      'error': {'code': 'validation', 'message': 'Invalid item', 'fields': {'title': 'must not be empty'}},
    });
    final error = (await repository.create(Item.draft(type: ItemType.book, title: '', status: ItemStatus.want))).errorOrNull;
    expect((error! as ValidationError).fields, {'title': 'must not be empty'});
  });

  test('update puts to the id of the item, without id in the body', () async {
    server.on('PUT', '/items/it_0001', 200, duna.toJson());
    expect((await repository.update(duna)).valueOrNull, duna);
    expect(server.last.method, 'PUT');
    expect(server.lastBody.containsKey('id'), isFalse);
  });

  test('delete returns Ok on 204 and NotFoundError on 404', () async {
    server.on('DELETE', '/items/it_0001', 204);
    expect((await repository.delete('it_0001')).isOk, isTrue);
    server.onError('DELETE', '/items/it_9999', 404, 'not_found');
    expect((await repository.delete('it_9999')).errorOrNull, isA<NotFoundError>());
  });

  test('summary asks for the year and reads the totals', () async {
    server.on('GET', '/summary', 200, {
      'year': 2026,
      'books': {'finished': 9, 'pages': 3024},
      'movies': {'finished': 8, 'minutes': 1102},
      'series': {'finished': 4, 'seasons': 11},
      'averageRating': 8.5,
      'byGenre': [
        {'genre': 'Drama', 'count': 4},
        {'genre': null, 'count': 2},
      ],
    });
    final summary = (await repository.summary(2026)).valueOrNull!;
    expect(server.last.url.queryParameters, {'year': '2026'});
    expect((summary.books.pages, summary.averageRating, summary.byGenre.last.genre), (3024, 8.5, null));
  });

  test('summary maps a 422 to ValidationError', () async {
    server.on('GET', '/summary', 422, {
      'error': {'code': 'validation', 'message': 'Invalid query', 'fields': {'year': 'must be in the format YYYY'}},
    });
    expect((await repository.summary(26)).errorOrNull, isA<ValidationError>());
  });

  test('watch emits the refreshed list after a successful create', () async {
    server.on('POST', '/items', 201, duna.toJson());
    server.on('GET', '/items', 200, {'items': [duna.toJson()], 'page': 1, 'pageSize': 100, 'total': 1});
    final next = repository.watch().first;
    await repository.create(Item.draft(type: ItemType.book, title: 'Duna', status: ItemStatus.want));
    expect((await next).single, duna);
  });

  test('a network failure is a NetworkError, not an exception', () async {
    final offline = RemoteItemRepository(client: ApiClient(baseUrl: 'http://localhost:1', adapter: _Offline()));
    expect((await offline.list(const ItemFilter())).errorOrNull, isA<NetworkError>());
    offline.dispose();
  });
}

/// A server that cannot be reached.
class _Offline extends FakeServer {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => throw DioException(requestOptions: options, type: DioExceptionType.connectionError);
}
