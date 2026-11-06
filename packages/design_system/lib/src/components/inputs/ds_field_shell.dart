import 'package:flutter/material.dart';
import '../../common/ds.dart';
import '../labels/ds_field_label.dart';
import '../labels/ds_field_message.dart';

/// Casca comum dos campos: rótulo acima, caixa (48 de altura, raio md, borda)
/// e mensagem de erro ou ajuda abaixo. Estados: padrão, foco, preenchido,
/// erro e desabilitado.
class DsFieldShell extends StatelessWidget {
  const DsFieldShell({
    super.key,
    required this.child,
    this.label,
    this.state = ComponentState.defaultState,
    this.errorText,
    this.helperText,
    this.minHeight = 48,
  });

  final Widget child;
  final String? label;
  final ComponentState state;
  final String? errorText;
  final String? helperText;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final disabled = state == ComponentState.disabled;
    final hasError = state == ComponentState.error || errorText != null;
    final focused = state == ComponentState.focused && !hasError && !disabled;
    final borderColor = hasError ? c.error : (focused ? c.primary : c.border);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          DsFieldLabel(label!, disabled: disabled),
          const SizedBox(height: 6),
        ],
        Container(
          constraints: BoxConstraints(minHeight: minHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: disabled ? c.track : c.surface,
            borderRadius: AppRadius.mdAll,
            border: Border.all(color: borderColor),
            boxShadow: focused ? [BoxShadow(color: Color.lerp(c.surface, c.primary, 0.15)!, spreadRadius: 3)] : null,
          ),
          child: child,
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          DsFieldMessage.error(errorText!),
        ] else if (helperText != null) ...[
          const SizedBox(height: 6),
          DsFieldMessage(helperText!),
        ],
      ],
    );
  }
}
