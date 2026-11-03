import 'package:flutter/material.dart';
import '../../common/ds.dart';

/// Chip de status do item. Texto na cor do status sobre a própria cor a 14%.
class DsStatusChip extends StatelessWidget {
  const DsStatusChip({super.key, required this.status, required this.type});

  final MediaStatus status;
  final MediaType type;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = c.forStatus(status);
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(color: c.soft(color), borderRadius: AppRadius.pillAll),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(statusLabel(status, type), maxLines: 1, style: AppTypography.chip.copyWith(color: color)),
        ],
      ),
    );
  }
}
