import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_semantic_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(AppColors.light, Brightness.light);
  static ThemeData get dark => _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppColorPalette p, Brightness brightness) {
    final scheme = ColorScheme.fromSeed(seedColor: p.primary, brightness: brightness).copyWith(
      primary: p.primary,
      onPrimary: p.onPrimary,
      primaryContainer: p.primaryContainer,
      onPrimaryContainer: p.primary,
      surface: p.surface,
      onSurface: p.onSurface,
      outline: p.border,
      outlineVariant: p.border,
      error: p.error,
      onError: p.onError,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.background,
      canvasColor: p.surface,
      dividerColor: p.border,
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        foregroundColor: p.onSurface,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        elevation: 0,
        titleTextStyle: AppTypography.titleLarge.copyWith(color: p.onSurface),
      ),
      extensions: [AppSemanticColors(p)],
    );
  }
}
