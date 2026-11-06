import 'package:flutter/material.dart';
import '../../common/ds.dart';
import 'ds_field_shell.dart';

class DsDropdownItem<T> {
  const DsDropdownItem({required this.value, required this.label});

  final T value;
  final String label;
}

/// Lista de opções (gênero). `value` nulo mostra a dica.
class DsDropdown<T> extends StatelessWidget {
  const DsDropdown({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.hint = 'Sem gênero',
    this.onChanged,
    this.state = ComponentState.defaultState,
    this.errorText,
  });

  final String label;
  final List<DsDropdownItem<T>> items;
  final T? value;
  final String hint;
  final ValueChanged<T?>? onChanged;
  final ComponentState state;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final disabled = state == ComponentState.disabled;
    return DsFieldShell(
      label: label,
      state: state,
      errorText: errorText,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: value,
          hint: Text(hint, style: AppTypography.bodyMedium.copyWith(color: c.onSurfaceMuted)),
          icon: Icon(Icons.expand_more_rounded, size: 18, color: c.onSurfaceMuted),
          borderRadius: AppRadius.mdAll,
          dropdownColor: c.surface,
          style: AppTypography.bodyMedium.copyWith(color: disabled ? c.onSurfaceMuted : c.onSurface),
          items: [
            for (final item in items) DropdownMenuItem<T>(value: item.value, child: Text(item.label)),
          ],
          onChanged: disabled ? null : (onChanged ?? (_) {}),
        ),
      ),
    );
  }
}
