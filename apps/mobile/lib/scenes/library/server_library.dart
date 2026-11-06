import 'package:bibliotela_core/bibliotela_core.dart';

/// Data the library scene reads from the backend.
abstract interface class ServerLibrary {
  Future<Result<Summary>> fetchSummary(int year);

  Future<Result<Page<Item>>> fetchItems(ItemFilter filter);

  /// Ends the session.
  Future<void> logout();
}

/// Offline [ServerLibrary] for development and previews: the 45 sample items.
class DefaultServerLibrary implements ServerLibrary {
  DefaultServerLibrary({ItemRepository? items, AuthRepository? auth})
    : _items = items ?? InMemoryItemRepository(),
      _auth = auth ?? InMemoryAuthRepository();

  final ItemRepository _items;
  final AuthRepository _auth;

  @override
  Future<Result<Summary>> fetchSummary(int year) => _items.summary(year);

  @override
  Future<Result<Page<Item>>> fetchItems(ItemFilter filter) =>
      _items.list(filter);

  @override
  Future<void> logout() async {
    await _auth.logout();
  }
}

/// Real [ServerLibrary], talking to the Bibliotela API.
class ServerLibraryImpl implements ServerLibrary {
  const ServerLibraryImpl({required this._items, required this._auth});

  final ItemRepository _items;
  final AuthRepository _auth;

  @override
  Future<Result<Summary>> fetchSummary(int year) => _items.summary(year);

  @override
  Future<Result<Page<Item>>> fetchItems(ItemFilter filter) =>
      _items.list(filter);

  @override
  Future<void> logout() async {
    // The local session is cleared even if the server says the token is gone.
    await _auth.logout();
  }
}
