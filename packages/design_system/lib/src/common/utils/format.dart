/// 3480 -> "3.480" (formato brasileiro).
String formatInt(int value) {
  final digits = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return value < 0 ? '-$buffer' : buffer.toString();
}

/// 7.8 -> "7,8" (vírgula decimal).
String formatDecimal(double value, [int digits = 1]) => value.toStringAsFixed(digits).replaceAll('.', ',');

/// DateTime(2026, 9, 6) -> "06/09/2026".
String formatDate(DateTime date) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(date.day)}/${two(date.month)}/${date.year}';
}

const _months = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez'];

/// DateTime(2026, 9, 6) -> "06 set".
String formatShortDate(DateTime date) => '${date.day.toString().padLeft(2, '0')} ${_months[date.month - 1]}';

/// Nota de 1 a 10 mostrada como estrelas (nota ÷ 2).
/// 8 -> "8 de 10 · 4 estrelas", 9 -> "9 de 10 · 4,5 estrelas",
/// 2 -> "2 de 10 · 1 estrela", 1 -> "1 de 10 · meia estrela".
String ratingLabel(int rating) {
  final String stars;
  if (rating == 1) {
    stars = 'meia estrela';
  } else if (rating == 2) {
    stars = '1 estrela';
  } else if (rating.isEven) {
    stars = '${rating ~/ 2} estrelas';
  } else {
    stars = '${formatDecimal(rating / 2)} estrelas';
  }
  return '$rating de 10 · $stars';
}
