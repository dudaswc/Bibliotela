import 'package:flutter_test/flutter_test.dart';
import 'package:bibliotela_ds_catalog/common/ds.dart';

void main() {
  group('formatInt', () {
    test('usa ponto como separador de milhar', () {
      expect(formatInt(3480), '3.480');
      expect(formatInt(264), '264');
      expect(formatInt(1250000), '1.250.000');
      expect(formatInt(0), '0');
    });
  });

  group('formatDecimal', () {
    test('usa vírgula decimal', () {
      expect(formatDecimal(7.8), '7,8');
      expect(formatDecimal(4.5), '4,5');
    });
  });

  group('datas', () {
    test('formatDate vira dd/mm/aaaa', () {
      expect(formatDate(DateTime(2026, 9, 6)), '06/09/2026');
    });

    test('formatShortDate vira dd mmm', () {
      expect(formatShortDate(DateTime(2026, 9, 6)), '06 set');
      expect(formatShortDate(DateTime(2026, 8, 18)), '18 ago');
    });
  });

  group('ratingLabel (nota ÷ 2, vírgula decimal)', () {
    test('notas inteiras de estrela', () {
      expect(ratingLabel(8), '8 de 10 · 4 estrelas');
      expect(ratingLabel(10), '10 de 10 · 5 estrelas');
      expect(ratingLabel(2), '2 de 10 · 1 estrela');
    });

    test('notas com meia estrela', () {
      expect(ratingLabel(9), '9 de 10 · 4,5 estrelas');
      expect(ratingLabel(3), '3 de 10 · 1,5 estrelas');
      expect(ratingLabel(1), '1 de 10 · meia estrela');
    });
  });

  group('statusLabel', () {
    test('livro usa ler, outros usam assistir', () {
      expect(statusLabel(MediaStatus.want, MediaType.book), 'Quero ler');
      expect(statusLabel(MediaStatus.inProgress, MediaType.book), 'Lendo');
      expect(statusLabel(MediaStatus.done, MediaType.book), 'Lido');
      expect(statusLabel(MediaStatus.want, MediaType.movie), 'Quero assistir');
      expect(statusLabel(MediaStatus.inProgress, MediaType.series), 'Assistindo');
      expect(statusLabel(MediaStatus.done, MediaType.movie), 'Assistido');
    });
  });
}
