/// Form validators. Return `null` when valid, a message in Portuguese
/// otherwise, which is the shape Flutter's `FormField.validator` expects.
library;

final _emailPattern = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');

String? validateEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return 'Informe o e-mail.';
  if (!_emailPattern.hasMatch(email)) return 'E-mail inválido.';
  return null;
}

String? validatePassword(String? value, {int minLength = 6}) {
  final password = value ?? '';
  if (password.isEmpty) return 'Informe a senha.';
  if (password.length < minLength) {
    return 'A senha precisa ter pelo menos $minLength caracteres.';
  }
  return null;
}

String? validateRequired(String? value, {String field = 'Este campo'}) {
  if (value == null || value.trim().isEmpty) return '$field é obrigatório.';
  return null;
}

/// An optional whole number greater than zero (pages, seasons, minutes).
/// Empty is valid.
String? validateOptionalPositiveInt(String? value, {String field = 'Este campo'}) {
  final number = parseOptionalInt(value);
  if ((value?.trim() ?? '').isEmpty) return null;
  if (number == null) return '$field precisa ser um número inteiro.';
  if (number <= 0) return '$field precisa ser maior que zero.';
  return null;
}

/// Parses a whole number typed by the user, or null when empty or invalid.
int? parseOptionalInt(String? value) {
  final raw = value?.trim() ?? '';
  if (raw.isEmpty) return null;
  return int.tryParse(raw);
}
