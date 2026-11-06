import 'package:bibliotela_core/bibliotela_core.dart';
import 'package:test/test.dart';

void main() {
  test('parse reads YYYY-MM-DD and prints it back', () {
    final date = LocalDate.parse('2026-09-06');
    expect((date.year, date.month, date.day), (2026, 9, 6));
    expect(date.toString(), '2026-09-06');
    expect(date.toJson(), '2026-09-06');
  });

  test('tryParse rejects anything that is not a real calendar date', () {
    for (final bad in [null, '', 'abc', '2026-9-6', '2026-02-30', '2026-13-01', '2026-09-06T10:00:00Z']) {
      expect(LocalDate.tryParse(bad), isNull, reason: '$bad');
    }
    expect(() => LocalDate.parse('2026-02-30'), throwsFormatException);
  });

  test('accepts the 29th of February only in leap years', () {
    expect(LocalDate.tryParse('2028-02-29'), isNotNull);
    expect(LocalDate.tryParse('2026-02-29'), isNull);
  });

  test('compares by year, then month, then day', () {
    final a = LocalDate(2026, 9, 6);
    expect(a.isBefore(LocalDate(2026, 9, 7)), isTrue);
    expect(a.isAfter(LocalDate(2026, 8, 31)), isTrue);
    expect(a.isBefore(LocalDate(2027, 1, 1)), isTrue);
    expect(a.compareTo(LocalDate(2026, 9, 6)), 0);
    final sorted = [LocalDate(2026, 9, 6), LocalDate(2025, 12, 1), LocalDate(2026, 1, 20)]..sort();
    expect(sorted.map((d) => d.toString()).toList(), ['2025-12-01', '2026-01-20', '2026-09-06']);
  });

  test('equality, monthKey and conversion from DateTime', () {
    expect(LocalDate(2026, 9, 6), LocalDate(2026, 9, 6));
    expect(LocalDate(2026, 9, 6).hashCode, LocalDate(2026, 9, 6).hashCode);
    expect(LocalDate(2026, 9, 6), isNot(LocalDate(2026, 9, 7)));
    expect(LocalDate(2026, 9, 6).monthKey, '2026-09');
    expect(LocalDate.fromDateTime(DateTime(2026, 9, 6, 23, 59)), LocalDate(2026, 9, 6));
    expect(LocalDate(2026, 9, 6).toDateTime(), DateTime(2026, 9, 6));
  });
}
