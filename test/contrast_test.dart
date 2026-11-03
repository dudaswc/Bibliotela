import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:bibliotela_ds_catalog/common/ds.dart';

/// Razão de contraste (WCAG 2.1) entre duas cores opacas.
double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

/// Garante que uma troca de cor não quebre a acessibilidade sem ninguém notar.
/// Mínimos: 4,5 para texto pequeno e 3,0 para ícones e estrelas.
void main() {
  final themes = <String, AppColorPalette>{'claro': AppColors.light, 'escuro': AppColors.dark};

  for (final entry in themes.entries) {
    final p = entry.value;
    group('contraste no tema ${entry.key}', () {
      test('texto principal e secundário', () {
        expect(contrast(p.onSurface, p.background), greaterThanOrEqualTo(4.5));
        expect(contrast(p.onSurfaceMuted, p.background), greaterThanOrEqualTo(4.5));
        expect(contrast(p.onSurfaceMuted, p.surface), greaterThanOrEqualTo(4.5));
      });

      test('primária: links, aba ativa e botão', () {
        expect(contrast(p.primary, p.background), greaterThanOrEqualTo(4.5));
        expect(contrast(p.primary, p.primaryContainer), greaterThanOrEqualTo(4.5));
        expect(contrast(p.onPrimary, p.primary), greaterThanOrEqualTo(4.5));
      });

      test('erro: mensagem e botão de perigo', () {
        expect(contrast(p.error, p.surface), greaterThanOrEqualTo(4.5));
        expect(contrast(p.onError, p.error), greaterThanOrEqualTo(4.5));
      });

      test('texto dos chips de status sobre o fundo suave (14%)', () {
        for (final color in [p.want, p.progress, p.done]) {
          expect(contrast(color, p.soft(color)), greaterThanOrEqualTo(4.5));
        }
      });

      test('ícones de tipo sobre o fundo suave da capa', () {
        for (final color in [p.book, p.series, p.movie]) {
          expect(contrast(color, p.soft(color)), greaterThanOrEqualTo(3.0));
        }
      });

      test('estrela cheia sobre a superfície', () {
        expect(contrast(p.starFilled, p.surface), greaterThanOrEqualTo(3.0));
      });
    });
  }

  test('claro e escuro têm exatamente os mesmos campos', () {
    // Se um campo fosse esquecido, o código nem compilaria; aqui só conferimos
    // que nenhum par de cores essenciais ficou igual entre os temas.
    expect(AppColors.light.background, isNot(AppColors.dark.background));
    expect(AppColors.light.primary, isNot(AppColors.dark.primary));
    expect(AppColors.light.onSurface, isNot(AppColors.dark.onSurface));
  });
}
