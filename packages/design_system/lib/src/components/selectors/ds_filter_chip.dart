import 'package:flutter/material.dart';
import '../../common/ds.dart';

/// Chip de filtro (tipo): Todos os tipos, Livros, Séries, Filmes.
/// Altura 38, pílula. Selecionado: `primaryContainer` e texto `primary`.
class DsFilterChip extends StatelessWidget {
  const DsFilterChip({super.key, required this.label, required this.selected, this.enabled = true, this.onTap});

  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.6,
        child: Material(
          color: selected ? c.primaryContainer : c.surface,
          clipBehavior: Clip.antiAlias,
          shape: StadiumBorder(side: selected ? BorderSide.none : BorderSide(color: c.border)),
          child: InkWell(
            onTap: enabled ? (onTap ?? () {}) : null,
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: (selected ? AppTypography.bodySmallSemibold : AppTypography.bodySmall).copyWith(color: selected ? c.primary : c.onSurface),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
