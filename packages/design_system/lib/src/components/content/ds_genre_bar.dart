import 'package:flutter/material.dart';
import '../../common/ds.dart';

/// Barra de gênero: nome, contagem e porcentagem. Barra de 6 de altura
/// (trilho `track`, preenchimento `primary`). `share` vai de 0 a 1.
class DsGenreBar extends StatelessWidget {
  const DsGenreBar({super.key, required this.label, required this.count, required this.share});

  final String label;
  final int count;
  final double share;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final double fraction = share < 0 ? 0.0 : (share > 1 ? 1.0 : share);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.bodySmall.copyWith(color: c.onSurface))),
            Text('$count · ${(fraction * 100).round()}%', style: AppTypography.bodySmall.copyWith(color: c.onSurfaceMuted)),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: AppRadius.pillAll,
          child: SizedBox(
            height: 6,
            child: Stack(
              children: [
                Positioned.fill(child: ColoredBox(color: c.track)),
                Positioned.fill(
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: fraction,
                    child: ColoredBox(color: c.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
