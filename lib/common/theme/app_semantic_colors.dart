import 'package:flutter/material.dart';
import 'app_colors.dart';
import '../models/media.dart';

/// Extensão do tema que carrega a paleta inteira. Os componentes nunca leem
/// uma cor direto: sempre `context.colors`.
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors(this.palette);

  final AppColorPalette palette;

  @override
  AppSemanticColors copyWith({AppColorPalette? palette}) => AppSemanticColors(palette ?? this.palette);

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return t < 0.5 ? this : other;
  }
}

extension AppColorsContext on BuildContext {
  AppColorPalette get colors => Theme.of(this).extension<AppSemanticColors>()?.palette ?? AppColors.light;
}

extension AppMediaColors on AppColorPalette {
  Color forType(MediaType type) => switch (type) {
        MediaType.book => book,
        MediaType.series => series,
        MediaType.movie => movie,
      };

  Color forStatus(MediaStatus status) => switch (status) {
        MediaStatus.want => want,
        MediaStatus.inProgress => progress,
        MediaStatus.done => done,
      };
}
