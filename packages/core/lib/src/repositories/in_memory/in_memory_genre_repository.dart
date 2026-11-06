import '../../result/result.dart';
import '../genre_repository.dart';
import 'sample_data.dart';

/// The fixed list of genres, no network involved.
class InMemoryGenreRepository implements GenreRepository {
  const InMemoryGenreRepository();

  @override
  Future<Result<List<String>>> list() async => Ok(List.of(SampleData.genres));
}
