import 'package:bibliotela_core/bibliotela_core.dart';
import 'package:test/test.dart';

void main() {
  test('formatLocalDate prints day/month/year', () {
    expect(formatLocalDate(LocalDate(2026, 9, 6)), '06/09/2026');
    expect(formatLocalDate(LocalDate(2026, 12, 31)), '31/12/2026');
  });

  test('formatShortDay prints the day and the month abbreviation', () {
    expect(formatShortDay(LocalDate(2026, 9, 6)), '06 set');
    expect(formatShortDay(LocalDate(2026, 3, 1)), '01 mar');
  });

  test('formatMonthHeading is the month name with a capital and the year', () {
    expect(formatMonthHeading(LocalDate(2026, 9, 6)), 'Setembro de 2026');
    expect(formatMonthHeading(LocalDate(2026, 3, 1)), 'Março de 2026');
  });
}
