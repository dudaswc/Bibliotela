import 'package:bibliotela_core/bibliotela_core.dart';
import 'package:test/test.dart';

void main() {
  test('lists the 12 genres, with Outros last', () async {
    final genres = (await const InMemoryGenreRepository().list()).valueOrNull!;
    expect((genres.length, genres.first, genres.last), (12, 'Ação', 'Outros'));
    expect(genres, contains('Ficção científica'));
  });
}
