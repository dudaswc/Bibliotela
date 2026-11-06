/// A calendar date with no time and no time zone (`2026-09-06`).
///
/// The API sends `startedAt` and `finishedAt` this way on purpose: they say
/// which day the person started or finished something, not an instant. As a
/// [DateTime] in UTC, finishing a book at 11 pm in Brazil would become the
/// next day.
class LocalDate implements Comparable<LocalDate> {
  const LocalDate(this.year, this.month, this.day);

  factory LocalDate.fromDateTime(DateTime dateTime) =>
      LocalDate(dateTime.year, dateTime.month, dateTime.day);

  factory LocalDate.today() => LocalDate.fromDateTime(DateTime.now());

  /// Strict `YYYY-MM-DD`. Throws a [FormatException] otherwise.
  factory LocalDate.parse(String value) =>
      tryParse(value) ??
      (throw FormatException('Invalid date (expected YYYY-MM-DD): $value'));

  /// Like [LocalDate.parse], but returns null for null or invalid input.
  static LocalDate? tryParse(String? value) {
    if (value == null) return null;
    final match = _pattern.firstMatch(value.trim());
    if (match == null) return null;
    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final day = int.parse(match.group(3)!);
    final probe = DateTime.utc(year, month, day);
    if (probe.year != year || probe.month != month || probe.day != day) {
      return null;
    }
    return LocalDate(year, month, day);
  }

  static final _pattern = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');

  final int year;
  final int month;
  final int day;

  /// `2026-09`, for grouping a list by month.
  String get monthKey => '${_pad(year, 4)}-${_pad(month, 2)}';

  DateTime toDateTime() => DateTime(year, month, day);

  bool isBefore(LocalDate other) => compareTo(other) < 0;

  bool isAfter(LocalDate other) => compareTo(other) > 0;

  String toJson() => toString();

  @override
  int compareTo(LocalDate other) {
    if (year != other.year) return year.compareTo(other.year);
    if (month != other.month) return month.compareTo(other.month);
    return day.compareTo(other.day);
  }

  @override
  bool operator ==(Object other) =>
      other is LocalDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  /// `2026-09-06`.
  @override
  String toString() => '${_pad(year, 4)}-${_pad(month, 2)}-${_pad(day, 2)}';

  static String _pad(int value, int width) => value.toString().padLeft(width, '0');
}
