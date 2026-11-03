import 'package:flutter/material.dart';
import '../../common/ds.dart';

class DsSegment<T> {
  const DsSegment({required this.value, required this.label});

  final T value;
  final String label;
}

/// Opções sobre um trilho: filtro de status, tipo e status do formulário.
/// Opção ativa em `primaryContainer`, texto `primary`.
class DsSegmentedControl<T> extends StatelessWidget {
  const DsSegmentedControl({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final List<DsSegment<T>> options;
  final T value;
  final ValueChanged<T> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final children = <Widget>[];
    for (var i = 0; i < options.length; i++) {
      final option = options[i];
      final selected = option.value == value;
      if (i > 0) children.add(const SizedBox(width: 3));
      children.add(
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: enabled ? () => onChanged(option.value) : null,
            child: Semantics(
              button: true,
              selected: selected,
              label: option.label,
              child: ExcludeSemantics(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: 40,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: selected ? c.primaryContainer : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      option.label,
                      maxLines: 1,
                      style: (selected ? AppTypography.labelSegmentActive : AppTypography.labelSegment)
                          .copyWith(color: selected ? c.primary : c.onSurfaceMuted),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Opacity(
      opacity: enabled ? 1 : 0.6,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(color: c.track, borderRadius: AppRadius.mdAll),
        child: Row(children: children),
      ),
    );
  }
}
