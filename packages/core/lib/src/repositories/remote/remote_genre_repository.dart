import '../../api/api_client.dart';
import '../../models/json.dart';
import '../../result/result.dart';
import '../genre_repository.dart';

/// Genres against the API.
class RemoteGenreRepository implements GenreRepository {
  RemoteGenreRepository({required this._client});

  final ApiClient _client;

  @override
  Future<Result<List<String>>> list() async {
    final result = await _client.get('/genres');
    return result.map((json) {
      final raw = asJson(json)['items'];
      if (raw is! List) {
        throw FormatException('Field "items" must be a list, got: $raw');
      }
      return [for (final genre in raw) '$genre'];
    });
  }
}
