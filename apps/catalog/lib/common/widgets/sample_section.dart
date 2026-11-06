import 'package:flutter/material.dart';
import 'package:bibliotela_design_system/bibliotela_design_system.dart';

/// Intercala um espaço entre os widgets.
List<Widget> withGaps(List<Widget> items, [double gap = AppSpacing.lg]) {
  final result = <Widget>[];
  for (var i = 0; i < items.length; i++) {
    if (i > 0) result.add(SizedBox(height: gap));
    result.add(items[i]);
  }
  return result;
}

/// Seção de amostra: título, descrição e os componentes, num cartão.
class SampleSection extends StatelessWidget {
  const SampleSection({super.key, required this.title, this.description, required this.children});

  final String title;
  final String? description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final desc = description;
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll, side: BorderSide(color: c.border)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTypography.titleSmall.copyWith(color: c.onSurface)),
            if (desc != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(desc, style: AppTypography.bodySmall.copyWith(color: c.onSurfaceMuted)),
            ],
            const SizedBox(height: AppSpacing.lg),
            ...withGaps(children),
          ],
        ),
      ),
    );
  }
}

/// Rótulo do estado (Padrão, Pressionado...) acima do componente.
class StateLabel extends StatelessWidget {
  const StateLabel({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTypography.labelMedium.copyWith(color: context.colors.onSurfaceMuted)),
          const SizedBox(height: 6),
          child,
        ],
      );
}

/// Moldura que imita uma área da tela do app (borda, raio lg, fundo da tela).
class SampleFrame extends StatelessWidget {
  const SampleFrame({super.key, required this.child, this.height});

  final Widget child;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: c.background, borderRadius: AppRadius.lgAll, border: Border.all(color: c.border)),
      child: child,
    );
  }
}
