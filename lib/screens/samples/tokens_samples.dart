import 'package:flutter/material.dart';
import '../../common/ds.dart';
import '../../common/widgets/sample_section.dart';

final List<(String, Color Function(AppColorPalette))> _paletteFields = [
  ('background', (p) => p.background),
  ('surface', (p) => p.surface),
  ('border', (p) => p.border),
  ('track', (p) => p.track),
  ('onSurface', (p) => p.onSurface),
  ('onSurfaceMuted', (p) => p.onSurfaceMuted),
  ('primary', (p) => p.primary),
  ('onPrimary', (p) => p.onPrimary),
  ('primaryContainer', (p) => p.primaryContainer),
  ('error', (p) => p.error),
  ('onError', (p) => p.onError),
  ('want', (p) => p.want),
  ('progress', (p) => p.progress),
  ('done', (p) => p.done),
  ('book', (p) => p.book),
  ('series', (p) => p.series),
  ('movie', (p) => p.movie),
  ('starFilled', (p) => p.starFilled),
  ('starEmpty', (p) => p.starEmpty),
];

/// Código hex do tema claro, só para exibir (evita depender de APIs recentes de Color).
const Map<String, String> _lightHex = {
  'background': '#F8F6F3',
  'surface': '#FFFFFF',
  'border': '#E3DFD8',
  'track': '#ECE9E4',
  'onSurface': '#1F2328',
  'onSurfaceMuted': '#6B7075',
  'primary': '#0F6E8C',
  'onPrimary': '#FFFFFF',
  'primaryContainer': '#DCEEF4',
  'error': '#B5473E',
  'onError': '#FFFFFF',
  'want': '#46627F',
  'progress': '#8A5A0F',
  'done': '#25694B',
  'book': '#0F6E8C',
  'series': '#7A5BA6',
  'movie': '#C2603F',
  'starFilled': '#A87300',
  'starEmpty': '#D5D1C9',
};

List<Widget> buildTokensSamples(BuildContext context) => [
      SampleSection(
        title: 'Cores',
        description: 'Os mesmos nomes das variáveis do Figma (coleção Cor). Claro e escuro têm exatamente os mesmos campos. Use o botão de tema no topo para ver o app inteiro no outro modo.',
        children: [
          Column(
            children: withGaps(
              [for (final f in _paletteFields) _ColorRow(name: f.$1, light: f.$2(AppColors.light), dark: f.$2(AppColors.dark), hex: _lightHex[f.$1] ?? '')],
              10,
            ),
          ),
        ],
      ),
      SampleSection(
        title: 'Tipografia',
        description: 'Escala única, com os nomes dos estilos do Figma. Fonte do sistema (como na Carteira); a Inter pode ser empacotada como asset.',
        children: [
          for (final entry in AppTypography.catalog)
            Builder(
              builder: (context) {
                final c = context.colors;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.$3, style: entry.$2.copyWith(color: c.onSurface)),
                    const SizedBox(height: 2),
                    Text(entry.$1, style: AppTypography.labelMedium.copyWith(color: c.onSurfaceMuted)),
                  ],
                );
              },
            ),
        ],
      ),
      SampleSection(
        title: 'Espaçamento e raios',
        description: 'Escala de 4 pt (igual à da Carteira). Margem lateral das telas: lg (16).',
        children: [
          const _SpacingRow(name: 'xxs', value: AppSpacing.xxs),
          const _SpacingRow(name: 'xs', value: AppSpacing.xs),
          const _SpacingRow(name: 'sm', value: AppSpacing.sm),
          const _SpacingRow(name: 'md', value: AppSpacing.md),
          const _SpacingRow(name: 'lg', value: AppSpacing.lg),
          const _SpacingRow(name: 'xl', value: AppSpacing.xl),
          const _SpacingRow(name: 'xxl', value: AppSpacing.xxl),
          const _SpacingRow(name: 'xxxl', value: AppSpacing.xxxl),
          const Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _RadiusSample(name: 'sm', value: AppRadius.sm),
              _RadiusSample(name: 'md', value: AppRadius.md),
              _RadiusSample(name: 'lg', value: AppRadius.lg),
              _RadiusSample(name: 'xl', value: AppRadius.xl),
              _RadiusSample(name: 'pill', value: AppRadius.pill),
            ],
          ),
        ],
      ),
      const SampleSection(
        title: 'Sombras',
        description: 'Quatro sombras: fab (botão flutuante), appIcon (ícone do app), menu (menu do chip de ano) e dialog (diálogo).',
        children: [
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              _ShadowSample(name: 'fab', shadow: AppShadows.fab),
              _ShadowSample(name: 'appIcon', shadow: AppShadows.appIcon),
              _ShadowSample(name: 'menu', shadow: AppShadows.menu),
              _ShadowSample(name: 'dialog', shadow: AppShadows.dialog),
            ],
          ),
        ],
      ),
    ];

class _ColorRow extends StatelessWidget {
  const _ColorRow({required this.name, required this.light, required this.dark, required this.hex});

  final String name;
  final Color light;
  final Color dark;
  final String hex;

  Widget _swatch(Color color, Color border) => Container(
        width: 40,
        height: 28,
        decoration: BoxDecoration(color: color, borderRadius: AppRadius.smAll, border: Border.all(color: border)),
      );

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        Expanded(child: Text(name, style: AppTypography.bodyMedium.copyWith(color: c.onSurface))),
        _swatch(light, AppColors.light.border),
        const SizedBox(width: AppSpacing.sm),
        _swatch(dark, AppColors.dark.border),
        const SizedBox(width: AppSpacing.md),
        SizedBox(width: 64, child: Text(hex, style: AppTypography.labelMedium.copyWith(color: c.onSurfaceMuted))),
      ],
    );
  }
}

class _SpacingRow extends StatelessWidget {
  const _SpacingRow({required this.name, required this.value});

  final String name;
  final double value;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        SizedBox(width: 84, child: Text('$name · ${value.toInt()}', style: AppTypography.labelMedium.copyWith(color: c.onSurfaceMuted))),
        Container(width: value * 3, height: 12, color: c.primary),
      ],
    );
  }
}

class _RadiusSample extends StatelessWidget {
  const _RadiusSample({required this.name, required this.value});

  final String name;
  final double value;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: c.primaryContainer,
            borderRadius: BorderRadius.circular(value),
            border: Border.all(color: c.primary, width: 1.5),
          ),
        ),
        const SizedBox(height: 6),
        Text('$name · ${value.toInt()}', style: AppTypography.labelMedium.copyWith(color: c.onSurfaceMuted)),
      ],
    );
  }
}

class _ShadowSample extends StatelessWidget {
  const _ShadowSample({required this.name, required this.shadow});

  final String name;
  final BoxShadow shadow;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(color: c.surface, borderRadius: AppRadius.lgAll, boxShadow: [shadow]),
        ),
        const SizedBox(height: 10),
        Text(name, style: AppTypography.labelMedium.copyWith(color: c.onSurfaceMuted)),
      ],
    );
  }
}
