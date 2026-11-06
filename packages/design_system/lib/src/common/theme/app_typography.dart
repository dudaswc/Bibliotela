import 'package:flutter/painting.dart';

/// Escala de texto única, com os mesmos nomes dos estilos do Figma.
/// Sem cor: cada componente aplica a sua (`copyWith(color: ...)`).
/// Fonte: a do sistema, como na Carteira. Para usar a Inter, empacote-a como
/// asset e defina `fontFamily` no tema.
abstract final class AppTypography {
  static const displayLarge = TextStyle(fontSize: 40, height: 44 / 40, fontWeight: FontWeight.w600, letterSpacing: -1.6);
  static const headlineMedium = TextStyle(fontSize: 28, height: 34 / 28, fontWeight: FontWeight.w600);
  static const titleLarge = TextStyle(fontSize: 24, height: 32 / 24, fontWeight: FontWeight.w600);
  static const titleMedium = TextStyle(fontSize: 22, height: 28 / 22, fontWeight: FontWeight.w600);
  static const titleUnit = TextStyle(fontSize: 20, height: 24 / 20, fontWeight: FontWeight.w600);
  static const titleSmall = TextStyle(fontSize: 15, height: 20 / 15, fontWeight: FontWeight.w600);
  static const bodyLarge = TextStyle(fontSize: 15, height: 22 / 15, fontWeight: FontWeight.w400);
  static const bodyLargeItalic = TextStyle(fontSize: 15, height: 22 / 15, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic);
  static const bodyMedium = TextStyle(fontSize: 14, height: 20 / 14, fontWeight: FontWeight.w400);
  static const bodyMediumStrong = TextStyle(fontSize: 14, height: 20 / 14, fontWeight: FontWeight.w500);
  static const bodyMediumItalic = TextStyle(fontSize: 14, height: 20 / 14, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic);
  static const bodySmall = TextStyle(fontSize: 13, height: 18 / 13, fontWeight: FontWeight.w400);
  static const bodySmallStrong = TextStyle(fontSize: 13, height: 18 / 13, fontWeight: FontWeight.w500);
  static const bodySmallSemibold = TextStyle(fontSize: 13, height: 18 / 13, fontWeight: FontWeight.w600);
  static const labelLarge = TextStyle(fontSize: 15, height: 20 / 15, fontWeight: FontWeight.w600);
  static const labelMedium = TextStyle(fontSize: 12, height: 17 / 12, fontWeight: FontWeight.w400);
  static const labelSmall = TextStyle(fontSize: 12, height: 16 / 12, fontWeight: FontWeight.w600, letterSpacing: 0.72);
  static const labelSegment = TextStyle(fontSize: 12, height: 15 / 12, fontWeight: FontWeight.w400);
  static const labelSegmentActive = TextStyle(fontSize: 12, height: 15 / 12, fontWeight: FontWeight.w600);
  static const metricValue = TextStyle(fontSize: 16, height: 20 / 16, fontWeight: FontWeight.w600);
  static const chip = TextStyle(fontSize: 11, height: 15 / 11, fontWeight: FontWeight.w600);
  static const chipRegular = TextStyle(fontSize: 11, height: 15 / 11, fontWeight: FontWeight.w400);

  /// Todos os estilos, na ordem do catálogo (nome, estilo, texto de exemplo).
  static const List<(String, TextStyle, String)> catalog = [
    ('displayLarge · 40/44 · 600', displayLarge, '12 livros'),
    ('headlineMedium · 28/34 · 600', headlineMedium, 'Bibliotela'),
    ('titleLarge · 24/32 · 600', titleLarge, 'Título da tela'),
    ('titleMedium · 22/28 · 600', titleMedium, 'Duna'),
    ('titleUnit · 20/24 · 600', titleUnit, 'livros lidos'),
    ('titleSmall · 15/20 · 600', titleSmall, 'Título do item'),
    ('bodyLarge · 15/22 · 400', bodyLarge, 'Um universo imenso e uma leitura que fica melhor a cada capítulo.'),
    ('bodyMedium · 14/20 · 400', bodyMedium, 'Ficção científica'),
    ('bodyMediumStrong · 14/20 · 500', bodyMediumStrong, '3.480 páginas lidas'),
    ('bodySmall · 13/18 · 400', bodySmall, 'Informe um e-mail válido.'),
    ('bodySmallStrong · 13/18 · 500', bodySmallStrong, 'Rótulo do campo'),
    ('bodySmallSemibold · 13/18 · 600', bodySmallSemibold, '2026'),
    ('labelLarge · 15/20 · 600', labelLarge, 'Entrar'),
    ('labelMedium · 12/17 · 400', labelMedium, 'Ficção científica · Frank Herbert'),
    ('labelSmall · 12/16 · 600 · CAIXA ALTA', labelSmall, 'POR GÊNERO'),
    ('chip · 11/15 · 600', chip, 'Lendo'),
    ('chipRegular · 11/15 · 400', chipRegular, '06 set'),
  ];
}
