import 'package:flutter/material.dart';
import '../../common/ds.dart';
import '../action_button/action_button.dart';
import '../action_button/action_button_view_model.dart';

enum DsStarSize {
  small(14),
  large(28);

  const DsStarSize(this.px);

  final double px;
}

/// Uma estrela com 0, meia (0.5) ou toda (1) cheia.
class DsStarGlyph extends StatelessWidget {
  const DsStarGlyph({super.key, required this.fill, required this.size});

  final double fill;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Icon(Icons.star_rounded, size: size, color: c.starEmpty),
          if (fill > 0)
            ClipRect(
              child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: fill,
                child: Icon(Icons.star_rounded, size: size, color: c.starFilled),
              ),
            ),
        ],
      ),
    );
  }
}

double _fillFor(double stars, int index) {
  if (stars >= index) return 1;
  if (stars >= index - 0.5) return 0.5;
  return 0;
}

/// Leitura da nota: nota de 0 a 10 mostrada como estrelas (nota ÷ 2, com meia
/// estrela). O rótulo falado é "Nota 9 de 10".
class DsStarRating extends StatelessWidget {
  const DsStarRating({super.key, required this.rating, this.size = DsStarSize.small});

  final int? rating;
  final DsStarSize size;

  @override
  Widget build(BuildContext context) {
    final stars = (rating ?? 0) / 2;
    return Semantics(
      label: rating == null ? 'Sem nota' : 'Nota $rating de 10',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 1; i <= 5; i++) ...[
              if (i > 1 && size == DsStarSize.large) const SizedBox(width: 2),
              DsStarGlyph(fill: _fillFor(stars, i), size: size.px),
            ],
          ],
        ),
      ),
    );
  }
}

/// Entrada da nota. Cada estrela tem alvo de 36 x 44: tocar na metade esquerda
/// dá meia estrela, na direita, estrela inteira. "Remover nota" aparece quando
/// há nota. Só existe com status concluído.
class DsStarRatingInput extends StatelessWidget {
  const DsStarRatingInput({super.key, required this.value, required this.onChanged});

  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final stars = (value ?? 0) / 2;
    final current = value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 1; i <= 5; i++)
              Semantics(
                button: true,
                label: '$i de 5 estrelas',
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) {
                    final half = details.localPosition.dx < 18;
                    onChanged(i * 2 - (half ? 1 : 0));
                  },
                  child: SizedBox(
                    width: 36,
                    height: 44,
                    child: Center(child: DsStarGlyph(fill: _fillFor(stars, i), size: 28)),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          current == null ? 'Toque nas estrelas para avaliar' : ratingLabel(current),
          style: AppTypography.bodySmallStrong.copyWith(color: current == null ? c.onSurfaceMuted : c.onSurface),
        ),
        if (current != null)
          DsActionButton(
            viewModel: const ActionButtonViewModel(label: 'Remover nota', variant: ActionButtonVariant.text, size: ActionButtonSize.compact),
            onPressed: () => onChanged(null),
          ),
      ],
    );
  }
}
