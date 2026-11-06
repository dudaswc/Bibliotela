import 'package:bibliotela_core/bibliotela_core.dart';
import 'package:test/test.dart';

Item _draft({
  ItemType type = ItemType.book,
  ItemStatus status = ItemStatus.want,
  String title = 'Livro novo',
  String? genre,
  LocalDate? startedAt,
  LocalDate? finishedAt,
  int? rating,
  int? pages,
}) => Item.draft(
  type: type,
  title: title,
  status: status,
  genre: genre,
  startedAt: startedAt,
  finishedAt: finishedAt,
  rating: rating,
  pages: pages,
);

void main() {
  late InMemoryItemRepository repository;

  setUp(() => repository = InMemoryItemRepository());
  tearDown(() => repository.dispose());

  Future<Page<Item>> list(ItemFilter filter) async => (await repository.list(filter)).valueOrNull!;
  List<String> titles(Page<Item> page) => [for (final item in page.items) item.title];

  group('list', () {
    test('has the 45 sample items and 20 per page by default', () async {
      final page = await list(const ItemFilter());
      expect((page.total, page.items.length, page.page, page.pageSize), (45, 20, 1, 20));
      expect(page.hasMore, isTrue);
    });

    test('orders by reading date, newest first, with the wanted ones at the end', () async {
      final all = titles(await list(const ItemFilter(pageSize: 100)));
      expect(all.take(6).toList(), ['Titanic', 'Drácula', 'Neuromancer', 'Oppenheimer', 'Severance', 'Os Miseráveis']);
      expect(
        all.skip(all.length - 6).toList(),
        ['Grande Sertão: Veredas', 'Fahrenheit 451', 'Interestelar', 'Sociedade da Neve', 'The Bear', 'Succession'],
      );
    });

    test('paginates and returns an empty page past the end', () async {
      final second = await list(const ItemFilter(page: 2));
      expect((second.items.length, second.items.first.title), (20, 'Blade Runner 2049'));
      expect((await list(const ItemFilter(page: 3))).items.length, 5);
      final past = await list(const ItemFilter(page: 99));
      expect(past.items, isEmpty);
      expect(past.total, 45);
    });

    test('filters by status, type and genre', () async {
      expect((await list(const ItemFilter(status: ItemStatus.want))).total, 6);
      expect((await list(const ItemFilter(status: ItemStatus.inProgress))).total, 4);
      expect((await list(const ItemFilter(status: ItemStatus.done))).total, 35);
      expect((await list(const ItemFilter(type: ItemType.book))).total, 19);
      expect((await list(const ItemFilter(genre: 'Fantasia'))).total, 2);
    });

    test('the year filter uses the reading date and keeps the wanted items', () async {
      expect((await list(const ItemFilter(year: 2025))).total, 20);
      expect((await list(const ItemFilter(year: 2026))).total, 31);
      final in2025 = titles(await list(const ItemFilter(year: 2025, pageSize: 100)));
      expect(in2025, containsAll(['The Bear', 'Succession', 'Interestelar']));
      expect(in2025, isNot(contains('Duna')));
    });

    test('combines filters and searches title and author, ignoring case', () async {
      final page = await list(const ItemFilter(year: 2026, status: ItemStatus.done, type: ItemType.book));
      expect((page.total, page.items.first.title), (9, 'Drácula'));
      expect(titles(await list(const ItemFilter(query: 'DUNA'))).toSet(), {'Duna', 'Duna: Parte Dois'});
      expect(titles(await list(const ItemFilter(query: 'tolkien'))), ['O Hobbit']);
    });

    test('rejects a page below 1 and a page size outside 1 to 100', () async {
      final error = (await repository.list(const ItemFilter(page: 0, pageSize: 101))).errorOrNull;
      expect((error! as ValidationError).fields.keys.toSet(), {'page', 'pageSize'});
    });
  });

  test('getById finds an item and reports a missing one', () async {
    expect((await repository.getById('it_0001')).valueOrNull?.title, 'Duna');
    expect((await repository.getById('it_9999')).errorOrNull, isA<NotFoundError>());
  });

  group('create', () {
    test('assigns the next id and the date, and normalizes the item', () async {
      final created = (await repository.create(
        _draft(type: ItemType.movie, title: '  Interestelar  ', rating: 9, pages: 300),
      )).valueOrNull!;
      expect((created.id, created.title, created.rating, created.pages), ('it_0046', 'Interestelar', null, null));
      expect(created.addedAt.isUtc, isTrue);
      expect((await list(const ItemFilter())).total, 46);
    });

    test('does not reuse the id of a deleted item', () async {
      await repository.create(_draft());
      await repository.delete('it_0046');
      expect((await repository.create(_draft())).valueOrNull?.id, 'it_0047');
    });

    test('validates like the server', () async {
      Future<Map<String, String>> fields(Item item) async =>
          ((await repository.create(item)).errorOrNull! as ValidationError).fields;

      expect(await fields(_draft(title: '  ')), {'title': 'must not be empty'});
      expect(await fields(_draft(genre: 'Nada')), {'genre': 'must be one of the values from /genres'});
      expect(await fields(_draft(status: ItemStatus.done)), {'finishedAt': 'is required when status is done'});
      expect(await fields(_draft(status: ItemStatus.inProgress)), {'startedAt': 'is required when status is in_progress'});
      expect(
        await fields(_draft(status: ItemStatus.done, startedAt: LocalDate(2026, 9, 10), finishedAt: LocalDate(2026, 9, 1))),
        {'startedAt': 'must not be after finishedAt'},
      );
      expect(
        await fields(_draft(status: ItemStatus.done, finishedAt: LocalDate(2026, 9, 1), rating: 11)),
        {'rating': 'must be an integer from 1 to 10'},
      );
      expect(await fields(_draft(pages: 0)), {'pages': 'must be greater than zero'});
    });
  });

  group('update', () {
    test('replaces the item and keeps the original addedAt', () async {
      final original = (await repository.getById('it_0038')).valueOrNull!;
      final updated = (await repository.update(
        original.copyWith(status: ItemStatus.done, finishedAt: () => LocalDate(2026, 9, 28), rating: () => 9),
      )).valueOrNull!;
      expect((updated.status, updated.rating, updated.addedAt), (ItemStatus.done, 9, original.addedAt));
      expect((await repository.getById('it_0038')).valueOrNull, updated);
    });

    test('validation comes before not-found', () async {
      expect((await repository.update(_draft(title: '').copyWith(id: 'it_9999'))).errorOrNull, isA<ValidationError>());
      expect((await repository.update(_draft().copyWith(id: 'it_9999'))).errorOrNull, isA<NotFoundError>());
    });
  });

  test('delete removes the item; deleting it again is NotFoundError', () async {
    expect((await repository.delete('it_0001')).isOk, isTrue);
    expect((await repository.getById('it_0001')).errorOrNull, isA<NotFoundError>());
    expect((await repository.delete('it_0001')).errorOrNull, isA<NotFoundError>());
    expect((await list(const ItemFilter())).total, 44);
  });

  group('summary', () {
    test('2026 matches what the mock server returns for Ana', () async {
      final summary = (await repository.summary(2026)).valueOrNull!;
      expect(summary.books, const BooksSummary(finished: 9, pages: 3024));
      expect(summary.movies, const MoviesSummary(finished: 8, minutes: 1102));
      expect(summary.series, const SeriesSummary(finished: 4, seasons: 11));
      expect(summary.averageRating, 8.5);
    });

    test('changes after finishing an item', () async {
      final before = (await repository.summary(2026)).valueOrNull!;
      await repository.create(_draft(status: ItemStatus.done, finishedAt: LocalDate(2026, 10, 10), pages: 100));
      final after = (await repository.summary(2026)).valueOrNull!;
      expect((after.books.finished, after.books.pages), (before.books.finished + 1, before.books.pages + 100));
    });
  });

  group('watch', () {
    test('emits the full list after a successful mutation', () async {
      final next = repository.watch().first;
      await repository.delete('it_0001');
      final emitted = await next;
      expect(emitted.length, 44);
      expect(emitted.any((item) => item.id == 'it_0001'), isFalse);
    });

    test('does not emit after a failed mutation', () async {
      var emissions = 0;
      final subscription = repository.watch().listen((_) => emissions++);
      await repository.delete('it_9999');
      await Future<void>.delayed(Duration.zero);
      expect(emissions, 0);
      await subscription.cancel();
    });
  });
}
