import 'package:bibliotela_core/bibliotela_core.dart';
import 'package:test/test.dart';

Json _duna() => {
  'id': 'it_0001',
  'type': 'book',
  'title': 'Duna',
  'genre': 'Ficção científica',
  'status': 'done',
  'startedAt': '2026-08-12',
  'finishedAt': '2026-09-06',
  'rating': 9,
  'note': 'Final inesperado',
  'pages': 680,
  'author': 'Frank Herbert',
  'seasons': null,
  'durationMinutes': null,
  'addedAt': '2026-07-30T18:20:00Z',
};

Item _item({
  ItemType type = ItemType.book,
  ItemStatus status = ItemStatus.want,
  String title = 'Algo',
  String? genre,
  LocalDate? startedAt,
  LocalDate? finishedAt,
  int? rating,
  String? note,
  int? pages,
  String? author,
  int? seasons,
  int? durationMinutes,
}) => Item(
  id: 'it_1',
  type: type,
  title: title,
  status: status,
  genre: genre,
  startedAt: startedAt,
  finishedAt: finishedAt,
  rating: rating,
  note: note,
  pages: pages,
  author: author,
  seasons: seasons,
  durationMinutes: durationMinutes,
  addedAt: DateTime.utc(2026, 7, 30, 18, 20),
);

void main() {
  test('fromJson reads every field of the contract', () {
    final item = Item.fromJson(_duna());
    expect(item.id, 'it_0001');
    expect(item.type, ItemType.book);
    expect(item.title, 'Duna');
    expect(item.genre, 'Ficção científica');
    expect(item.status, ItemStatus.done);
    expect(item.startedAt, LocalDate(2026, 8, 12));
    expect(item.finishedAt, LocalDate(2026, 9, 6));
    expect(item.rating, 9);
    expect(item.note, 'Final inesperado');
    expect(item.pages, 680);
    expect(item.author, 'Frank Herbert');
    expect(item.seasons, isNull);
    expect(item.durationMinutes, isNull);
    expect(item.addedAt, DateTime.utc(2026, 7, 30, 18, 20));
  });

  test('toJson then fromJson gives back the same item', () {
    final item = Item.fromJson(_duna());
    expect(Item.fromJson(item.toJson()), item);
    expect(item.toJson()['startedAt'], '2026-08-12');
    expect(item.toJson()['status'], 'done');
  });

  test('fromJson maps in_progress and tolerates missing optional keys', () {
    final item = Item.fromJson({
      'id': 'it_2',
      'type': 'series',
      'title': 'Severance',
      'status': 'in_progress',
      'startedAt': '2026-09-20',
      'addedAt': '2026-09-14T21:40:00Z',
    });
    expect(item.status, ItemStatus.inProgress);
    expect(item.genre, isNull);
    expect(item.finishedAt, isNull);
    expect(item.seasons, isNull);
  });

  test('fromJson rejects an unknown type or status', () {
    expect(() => Item.fromJson({..._duna(), 'type': 'livro'}), throwsFormatException);
    expect(() => Item.fromJson({..._duna(), 'status': 'lendo'}), throwsFormatException);
  });

  test('readingDate is finishedAt when done, startedAt when in progress, none when wanted', () {
    expect(_item(status: ItemStatus.done, finishedAt: LocalDate(2026, 9, 6), startedAt: LocalDate(2026, 8, 1)).readingDate, LocalDate(2026, 9, 6));
    expect(_item(status: ItemStatus.inProgress, startedAt: LocalDate(2026, 9, 20)).readingDate, LocalDate(2026, 9, 20));
    expect(_item(status: ItemStatus.want).readingDate, isNull);
  });

  test('normalized drops what does not apply to the status', () {
    final wanted = _item(
      type: ItemType.movie,
      startedAt: LocalDate(2026, 10, 1),
      finishedAt: LocalDate(2026, 10, 2),
      rating: 9,
      durationMinutes: 169,
    ).normalized();
    expect((wanted.startedAt, wanted.finishedAt, wanted.rating, wanted.durationMinutes), (null, null, null, 169));

    final inProgress = _item(
      status: ItemStatus.inProgress,
      startedAt: LocalDate(2026, 10, 1),
      finishedAt: LocalDate(2026, 10, 5),
      rating: 8,
    ).normalized();
    expect((inProgress.startedAt, inProgress.finishedAt, inProgress.rating), (LocalDate(2026, 10, 1), null, null));
  });

  test('normalized drops what does not apply to the type', () {
    final movie = _item(type: ItemType.movie, pages: 300, author: 'X', seasons: 3, durationMinutes: 120).normalized();
    expect((movie.pages, movie.author, movie.seasons, movie.durationMinutes), (null, null, null, 120));
    final series = _item(type: ItemType.series, pages: 300, seasons: 3, durationMinutes: 120).normalized();
    expect((series.pages, series.seasons, series.durationMinutes), (null, 3, null));
    final book = _item(pages: 300, author: 'Autor', seasons: 3).normalized();
    expect((book.pages, book.author, book.seasons), (300, 'Autor', null));
  });

  test('normalized trims the title and turns blank texts into null', () {
    final item = _item(title: '  Duna  ', genre: '', note: '   ', author: ' ').normalized();
    expect((item.title, item.genre, item.note, item.author), ('Duna', null, null, null));
  });

  test('copyWith keeps what you do not pass and clears with a function', () {
    final item = Item.fromJson(_duna());
    expect(item.copyWith(title: 'Duna 2').rating, 9);
    final cleared = item.copyWith(rating: () => null, note: () => null);
    expect((cleared.rating, cleared.note, cleared.title), (null, null, 'Duna'));
    expect(item.copyWith(status: ItemStatus.want).status, ItemStatus.want);
  });

  test('draft has no id yet', () {
    final draft = Item.draft(type: ItemType.book, title: 'Novo', status: ItemStatus.want);
    expect(draft.id, '');
    expect(draft.addedAt, DateTime.fromMillisecondsSinceEpoch(0, isUtc: true));
  });
}
