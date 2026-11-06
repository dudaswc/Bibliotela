import '../models/local_date.dart';

const _monthNames = [
  'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
  'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro',
];

const _monthAbbreviations = [
  'jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez',
];

/// `06/09/2026`
String formatLocalDate(LocalDate date) =>
    '${date.day.toString().padLeft(2, '0')}/'
    '${date.month.toString().padLeft(2, '0')}/${date.year}';

/// `06 set`
String formatShortDay(LocalDate date) =>
    '${date.day.toString().padLeft(2, '0')} ${_monthAbbreviations[date.month - 1]}';

/// `Setembro de 2026`, the heading of a month group.
String formatMonthHeading(LocalDate date) {
  final name = _monthNames[date.month - 1];
  return '${name[0].toUpperCase()}${name.substring(1)} de ${date.year}';
}
