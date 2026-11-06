import 'package:bibliotela_core/bibliotela_core.dart';
import 'package:test/test.dart';

void main() {
  test('groups preserving first-appearance order', () {
    final groups = groupBy([1, 2, 3, 4, 5], (n) => n.isEven ? 'even' : 'odd');
    expect(groups.keys.toList(), ['odd', 'even']);
    expect(groups['odd'], [1, 3, 5]);
    expect(groups['even'], [2, 4]);
  });

  test('groups the library by month of the reading date, the wanted ones apart', () {
    final byMonth = groupBy(InMemoryItemRepository().items, (item) => item.readingDate?.monthKey);
    expect(byMonth.values.every((list) => list.isNotEmpty), isTrue);
    expect(byMonth.keys.first, '2026-10');
    expect(byMonth.keys.last, isNull);
    expect(byMonth.length, lessThan(SampleData.items().length));
  });
}
