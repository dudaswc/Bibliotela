import 'package:bibliotela_core/bibliotela_core.dart';

import 'storage/shared_preferences_session_storage.dart';

/// Everything the scenes need from the data layer, created once.
///
/// Scenes never build an `ApiClient` or a repository: their factories receive
/// this object and pick what they need (dependency injection).
final class AppDependencies {
  AppDependencies({
    required this.auth,
    required this.items,
    required this.users,
    required this.genres,
  });

  /// Talks to the mock server (or to any server that follows the contract).
  ///
  /// The address comes from `--dart-define=API_BASE_URL=...`. In a Codespace it
  /// is the public address of port 8080.
  factory AppDependencies.remote({
    String baseUrl = defaultBaseUrl,
    SessionStorage? storage,
  }) {
    final client = ApiClient(baseUrl: baseUrl);
    return AppDependencies(
      auth: RemoteAuthRepository(
        client: client,
        storage: storage ?? SharedPreferencesSessionStorage(),
      ),
      items: RemoteItemRepository(client: client),
      users: RemoteUserRepository(client: client),
      genres: RemoteGenreRepository(client: client),
    );
  }

  /// No network at all: the same 45 items the mock server starts with.
  factory AppDependencies.inMemory({Duration delay = Duration.zero}) =>
      AppDependencies(
        auth: InMemoryAuthRepository(delay: delay),
        items: InMemoryItemRepository(delay: delay),
        users: InMemoryUserRepository(delay: delay),
        genres: const InMemoryGenreRepository(),
      );

  /// Chooses the data source from `--dart-define`:
  /// `API_MODE=memory` for offline, otherwise the server at `API_BASE_URL`.
  factory AppDependencies.fromEnvironment() =>
      const String.fromEnvironment('API_MODE') == 'memory'
      ? AppDependencies.inMemory(delay: const Duration(milliseconds: 400))
      : AppDependencies.remote(
          baseUrl: const String.fromEnvironment(
            'API_BASE_URL',
            defaultValue: defaultBaseUrl,
          ),
        );

  static const defaultBaseUrl = 'http://localhost:8080';

  final AuthRepository auth;
  final ItemRepository items;
  final UserRepository users;
  final GenreRepository genres;
}
