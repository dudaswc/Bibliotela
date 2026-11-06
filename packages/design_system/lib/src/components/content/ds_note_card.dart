import 'package:flutter/material.dart';
import '../../common/ds.dart';

/// Bloco da observação no detalhe. Sem texto: "Sem observação" em itálico.
class DsNoteCard extends StatelessWidget {
  const DsNoteCard({super.key, this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hasText = text != null && text!.trim().isNotEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: c.surface, borderRadius: AppRadius.mdAll, border: Border.all(color: c.border)),
      child: Text(
        hasText ? text! : 'Sem observação',
        style: (hasText ? AppTypography.bodyLarge : AppTypography.bodyLargeItalic).copyWith(color: hasText ? c.onSurface : c.onSurfaceMuted),
      ),
    );
  }
}
