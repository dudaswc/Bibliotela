import 'dart:async';

import '../../api/api_client.dart';
import '../../models/item.dart';
import '../../models/item_filter.dart';
import '../../models/json.dart';
import '../../models/page.dart';
import '../../models/summary.dart';
import '../../result/result.dart';
import '../item_repository.dart';

/// Items against the API.
class RemoteItemRepository implements ItemRepository {
  RemoteItemRepository({required this._client});

  final ApiClient _client;
  final _changes = StreamController<List<Item>>.broadcast();

  @override
  Future<Result<Page<Item>>> list(ItemFilter filter) async {
    final result = await _client.get('/items', query: filter.toQueryParameters());
    return result.map((json) => Page.fromJson(asJson(json), Item.fromJson));
  }

  @override
  Future<Result<Item>> getById(String id) async {
    final result = await _client.get('/items/$id');
    return result.map((json) => Item.fromJson(asJson(json)));
  }

  @override
  Future<Result<Item>> create(Item item) async {
    final result = await _client.post('/items', body: _body(item));
    final created = result.map((json) => Item.fromJson(asJson(json)));
    await _notify(created);
    return created;
  }

  @override
  Future<Result<Item>> update(Item item) async {
    final result = await _client.put('/items/${item.id}', body: _body(item));
    final updated = result.map((json) => Item.fromJson(asJson(json)));
    await _notify(updated);
    return updated;
  }

  @override
  Future<Result<void>> delete(String id) async {
    final result = await _client.delete('/items/$id');
    final deleted = result.map((_) {});
    await _notify(deleted);
    return deleted;
  }

  @override
  Future<Result<Summary>> summary(int year) async {
    final result = await _client.get(
      '/summary',
      query: {'year': year.toString().padLeft(4, '0')},
    );
    return result.map((json) => Summary.fromJson(asJson(json)));
  }

  @override
  Stream<List<Item>> watch() => _changes.stream;

  void dispose() => _changes.close();

  /// The server generates `id` and `addedAt` and ignores them in the body.
  Json _body(Item item) => item.toJson()
    ..remove('id')
    ..remove('addedAt');

  /// After a successful mutation, fetches the first page again and emits it.
  Future<void> _notify(Result<Object?> result) async {
    if (result.isFailure || _changes.isClosed || !_changes.hasListener) return;
    final refreshed = await list(const ItemFilter(pageSize: 100));
    final items = refreshed.valueOrNull?.items;
    if (items != null && !_changes.isClosed) _changes.add(items);
  }
}
