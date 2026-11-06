import 'package:bibliotela_core/bibliotela_core.dart';
import 'package:test/test.dart';

Item _done(String genre, int? rating, {ItemType type = ItemType.book, int? pages}) => Item(
  id: 'it_x',
  type: type,
  title: 'T',
  genre: genre.isEmpty ? null : genre,
  status: ItemStatus.done,
  finishedAt: LocalDate(2026, 5, 1),
  rating: rating,
  pages: pages,
  addedAt: DateTime.utc(2026, 4, 1),
);

void main() {
  test('fromJson reads the contract, including a null genre', () {
    final summary = Summary.fromJson({
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
    expect(summary.books, const BooksSummary(finished: 9, pages: 3024));
    expect(summary.movies, const MoviesSummary(finished: 8, minutes: 1102));
    expect(summary.series, const SeriesSummary(finished: 4, seasons: 11));
    expect(summary.averageRating, 8.5);
    expect(summary.byGenre.last, const GenreCount(genre: null, count: 2));
  });

  test('fromJson accepts a year with nothing finished', () {
    final summary = Summary.fromJson({
      'year': 1999,
      'books': {'finished': 0, 'pages': 0},
      'movies': {'finished': 0, 'minutes': 0},
      'series': {'finished': 0, 'seasons': 0},
      'averageRating': null,
      'byGenre': <Object?>[],
    });
    expect(summary.averageRating, isNull);
    expect(summary.byGenre, isEmpty);
  });

  test('toJson then fromJson gives back the same summary', () {
    final summary = Summary.fromItems(SampleData.items(), 2026);
    expect(Summary.fromJson(summary.toJson()), summary);
  });

  test('fromItems of 2026 matches what the mock server returns for Ana', () {
    final summary = Summary.fromItems(SampleData.items(), 2026);
    expect(summary.books, const BooksSummary(finished: 9, pages: 3024));
    expect(summary.movies, const MoviesSummary(finished: 8, minutes: 1102));
    expect(summary.series, const SeriesSummary(finished: 4, seasons: 11));
    expect(summary.averageRating, 8.5);
    expect(
      [for (final g in summary.byGenre) (g.genre, g.count)],
      [
        ('Ficção científica', 5),
        ('Drama', 4),
        ('Comédia', 3),
        (null, 2),
        ('Romance', 2),
        ('Suspense', 2),
        ('Fantasia', 1),
        ('Outros', 1),
        ('Terror', 1),
      ],
    );
  });

  test('fromItems of 2025 matches what the mock server returns for Ana', () {
    final summary = Summary.fromItems(SampleData.items(), 2025);
    expect(summary.books, const BooksSummary(finished: 6, pages: 1864));
    expect(summary.movies, const MoviesSummary(finished: 5, minutes: 663));
    expect(summary.series, const SeriesSummary(finished: 3, seasons: 20));
    expect(summary.averageRating, 8.6);
  });

  test('a year with nothing finished has zeros, no average and no genres', () {
    final summary = Summary.fromItems(SampleData.items(), 1999);
    expect(summary.books.finished, 0);
    expect(summary.averageRating, isNull);
    expect(summary.byGenre, isEmpty);
  });

  test('items that are not done, or done in another year, do not count', () {
    final items = [
      _done('Drama', 8),
      _done('Drama', 6).copyWith(finishedAt: () => LocalDate(2025, 5, 1)),
      _done('Drama', 6).copyWith(status: ItemStatus.inProgress, startedAt: () => LocalDate(2026, 5, 1)),
    ];
    final summary = Summary.fromItems(items, 2026);
    expect(summary.books.finished, 1);
    expect(summary.averageRating, 8);
  });

  test('a book without pages counts zero pages', () {
    final summary = Summary.fromItems([_done('', null, pages: 100), _done('', null)], 2026);
    expect(summary.books, const BooksSummary(finished: 2, pages: 100));
    expect(summary.averageRating, isNull);
  });

  test('on a tie, no genre comes first and then the alphabetical order', () {
    final summary = Summary.fromItems(
      [_done('Terror', 5), _done('Ação', 5), _done('', 5), _done('Drama', 5), _done('Drama', 5)],
      2026,
    );
    expect([for (final g in summary.byGenre) g.genre], ['Drama', null, 'Ação', 'Terror']);
  });
}
