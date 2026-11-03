import 'package:flutter/material.dart';
import '../../common/ds.dart';
import 'ds_field_shell.dart';

/// Campo de data. Abre o calendário; aparece como dd/mm/aaaa e vai para a API
/// como YYYY-MM-DD.
class DsDateField extends StatelessWidget {
  const DsDateField({
    super.key,
    required this.label,
    this.value,
    this.onChanged,
    this.state = ComponentState.defaultState,
    this.errorText,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime>? onChanged;
  final ComponentState state;
  final String? errorText;

  Future<void> _pick(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) onChanged?.call(picked);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final disabled = state == ComponentState.disabled;
    final text = value == null ? 'dd/mm/aaaa' : formatDate(value!);
    return DsFieldShell(
      label: label,
      state: state,
      errorText: errorText,
      child: InkWell(
        onTap: disabled ? null : () => _pick(context),
        child: SizedBox(
          height: 46,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: AppTypography.bodyMedium.copyWith(color: value == null || disabled ? c.onSurfaceMuted : c.onSurface),
                ),
              ),
              Icon(Icons.calendar_today_outlined, size: 19, color: c.onSurfaceMuted),
            ],
          ),
        ),
      ),
    );
  }
}
