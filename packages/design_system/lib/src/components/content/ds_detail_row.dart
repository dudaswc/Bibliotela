import 'package:flutter/material.dart';
import '../../common/ds.dart';

/// Linha de dado do detalhe: rótulo (42%) e valor à direita. Valor vazio
/// aparece como "—"; `italic` serve para "Sem observação".
class DsDetailRow extends StatelessWidget {
  const DsDetailRow({super.key, required this.label, this.value, this.italic = false, this.showDivider = true});

  final String label;
  final String? value;
  final bool italic;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = (value == null || value!.isEmpty) ? '—' : value!;
    return Container(
      constraints: const BoxConstraints(minHeight: 46),
      decoration: BoxDecoration(border: showDivider ? Border(bottom: BorderSide(color: c.border)) : null),
      child: Row(
        children: [
          Expanded(flex: 42, child: Text(label, style: AppTypography.bodyMedium.copyWith(color: c.onSurfaceMuted))),
          Expanded(
            flex: 58,
            child: Text(
              text,
              textAlign: TextAlign.end,
              style: (italic ? AppTypography.bodyMediumItalic : AppTypography.bodyMediumStrong).copyWith(color: italic ? c.onSurfaceMuted : c.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
