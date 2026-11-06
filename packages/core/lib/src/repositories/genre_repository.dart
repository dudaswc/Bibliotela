import '../result/result.dart';

/// The genres accepted in `Item.genre`.
abstract interface class GenreRepository {
  /// Alphabetical, with "Outros" last.
  Future<Result<List<String>>> list();
}
