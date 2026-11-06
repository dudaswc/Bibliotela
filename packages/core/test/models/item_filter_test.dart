import 'package:bibliotela_core/bibliotela_core.dart';
import 'package:test/test.dart';

void main() {
  test('the default filter only asks for the first page', () {
    expect(const ItemFilter().toQueryParameters(), {'page': '1', 'pageSize': '20'});
  });

  test('every field becomes a query parameter, with the contract names', () {
    const filter = ItemFilter(
      year: 2026,
      status: ItemStatus.inProgress,
      type: ItemType.book,
      genre: 'Fantasia',
      query: ' duna ',
      page: 2,
      pageSize: 5,
    );
    expect(filter.toQueryParameters(), {
      'year': '2026',
      'status': 'in_progress',
      'type': 'book',
      'genre': 'Fantasia',
      'q': 'duna',
      'page': '2',
      'pageSize': '5',
    });
  });

  test('a blank search and an empty genre are left out', () {
    final params = const ItemFilter(query: '   ', genre: '').toQueryParameters();
    expect(params.containsKey('q'), isFalse);
    expect(params.containsKey('genre'), isFalse);
  });

  test('copyWith, nextPage and equality', () {
    const filter = ItemFilter(year: 2026, status: ItemStatus.done);
    expect(filter.copyWith(year: () => 2025).year, 2025);
    expect(filter.copyWith(year: () => null).year, isNull);
    expect(filter.copyWith(type: () => ItemType.movie).status, ItemStatus.done);
    expect(filter.nextPage().page, 2);
    expect(filter.nextPage().year, 2026);
    expect(const ItemFilter(year: 2026), const ItemFilter(year: 2026));
    expect(const ItemFilter(year: 2026), isNot(const ItemFilter(year: 2025)));
  });
}
