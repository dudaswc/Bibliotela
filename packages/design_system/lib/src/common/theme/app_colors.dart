import 'package:flutter/material.dart';

/// Paleta completa de um tema. Claro e escuro têm exatamente os mesmos campos,
/// com os mesmos nomes das variáveis do Figma (coleção "Cor").
class AppColorPalette {
  const AppColorPalette({
    required this.background,
    required this.surface,
    required this.border,
    required this.track,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.error,
    required this.onError,
    required this.want,
    required this.progress,
    required this.done,
    required this.book,
    required this.series,
    required this.movie,
    required this.starFilled,
    required this.starEmpty,
    required this.overlayPressed,
  });

  final Color background;
  final Color surface;
  final Color border;
  final Color track;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color error;
  final Color onError;

  /// Status do item.
  final Color want;
  final Color progress;
  final Color done;

  /// Tipo do item.
  final Color book;
  final Color series;
  final Color movie;

  /// Estrelas da nota.
  final Color starFilled;
  final Color starEmpty;

  /// Sobreposição do estado "pressionado".
  final Color overlayPressed;

  /// Fundo suave de chips e capas: a própria cor a 14% sobre a superfície.
  Color soft(Color color) => Color.lerp(surface, color, 0.14)!;
}

abstract final class AppColors {
  static const light = AppColorPalette(
    background: Color(0xFFF8F6F3),
    surface: Color(0xFFFFFFFF),
    border: Color(0xFFE3DFD8),
    track: Color(0xFFECE9E4),
    onSurface: Color(0xFF1F2328),
    onSurfaceMuted: Color(0xFF6B7075),
    primary: Color(0xFF0F6E8C),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFDCEEF4),
    error: Color(0xFFB5473E),
    onError: Color(0xFFFFFFFF),
    want: Color(0xFF46627F),
    progress: Color(0xFF8A5A0F),
    done: Color(0xFF25694B),
    book: Color(0xFF0F6E8C),
    series: Color(0xFF7A5BA6),
    movie: Color(0xFFC2603F),
    starFilled: Color(0xFFA87300),
    starEmpty: Color(0xFFD5D1C9),
    overlayPressed: Color(0x1F000000),
  );

  static const dark = AppColorPalette(
    background: Color(0xFF16181D),
    surface: Color(0xFF1F2228),
    border: Color(0xFF2C3038),
    track: Color(0xFF2C3038),
    onSurface: Color(0xFFECEAE6),
    onSurfaceMuted: Color(0xFF9AA0A6),
    primary: Color(0xFF7DB8D0),
    onPrimary: Color(0xFF0D2630),
    primaryContainer: Color(0xFF1F3A47),
    error: Color(0xFFE0877E),
    onError: Color(0xFF2A0F0B),
    want: Color(0xFF8FB0D1),
    progress: Color(0xFFE0A94A),
    done: Color(0xFF6FBF9A),
    book: Color(0xFF7DB8D0),
    series: Color(0xFFB79AE0),
    movie: Color(0xFFC2603F),
    starFilled: Color(0xFFD9A21B),
    starEmpty: Color(0xFF3A3E46),
    overlayPressed: Color(0x24FFFFFF),
  );
}
