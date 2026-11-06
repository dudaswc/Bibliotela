import 'package:flutter/material.dart';
import '../../common/ds.dart';

/// Chip de ano do resumo. Abre um menu com os anos disponíveis.
class DsYearChip extends StatelessWidget {
  const DsYearChip({
    super.key,
    required this.year,
    required this.years,
    required this.onChanged,
    this.state = ComponentState.defaultState,
  });

  final int year;
  final List<int> years;
  final ValueChanged<int> onChanged;
  final ComponentState state;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final pressed = state == ComponentState.pressed;
    return PopupMenuButton<int>(
      tooltip: 'Escolher ano',
      initialValue: year,
      onSelected: onChanged,
      position: PopupMenuPosition.under,
      color: c.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll, side: BorderSide(color: c.border)),
      itemBuilder: (context) => [
        for (final y in years)
          PopupMenuItem<int>(
            value: y,
            child: Text('$y', style: AppTypography.bodySmall.copyWith(color: c.onSurface)),
          ),
      ],
      child: Container(
        height: 34,
        padding: const EdgeInsets.only(left: 12, right: 10),
        decoration: BoxDecoration(
          color: pressed ? Color.alphaBlend(c.overlayPressed, c.primaryContainer) : c.primaryContainer,
          borderRadius: AppRadius.pillAll,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$year', style: AppTypography.bodySmallSemibold.copyWith(color: c.primary)),
            const SizedBox(width: AppSpacing.xs),
            Icon(Icons.expand_more_rounded, size: 16, color: c.primary),
          ],
        ),
      ),
    );
  }
}
