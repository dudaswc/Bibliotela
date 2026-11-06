import 'package:bibliotela_core/bibliotela_core.dart';
import 'package:test/test.dart';

void main() {
  test('validateEmail', () {
    expect(validateEmail(null), isNotNull);
    expect(validateEmail(' '), isNotNull);
    expect(validateEmail('ana@'), isNotNull);
    expect(validateEmail('ana@bibliotela.dev'), isNull);
    expect(validateEmail(' ana.r+x@mail.co.uk '), isNull);
  });

  test('validatePassword', () {
    expect(validatePassword(''), isNotNull);
    expect(validatePassword('123'), contains('6'));
    expect(validatePassword('123456'), isNull);
  });

  test('validateRequired', () {
    expect(validateRequired('  ', field: 'Título'), 'Título é obrigatório.');
    expect(validateRequired('Duna'), isNull);
  });

  test('validateOptionalPositiveInt accepts empty and whole numbers above zero', () {
    expect(validateOptionalPositiveInt(null), isNull);
    expect(validateOptionalPositiveInt('  '), isNull);
    expect(validateOptionalPositiveInt('680'), isNull);
    expect(validateOptionalPositiveInt('0', field: 'Páginas'), 'Páginas precisa ser maior que zero.');
    expect(validateOptionalPositiveInt('abc', field: 'Páginas'), 'Páginas precisa ser um número inteiro.');
    expect(validateOptionalPositiveInt('1,5'), isNotNull);
  });

  test('parseOptionalInt', () {
    expect(parseOptionalInt(' 680 '), 680);
    expect(parseOptionalInt(''), isNull);
    expect(parseOptionalInt('abc'), isNull);
  });
}
