import 'package:flutter/material.dart';
import '../../common/ds.dart';
import 'ds_text_field.dart';

/// Campo de senha com cadeado e botão de mostrar ou ocultar.
class DsPasswordField extends StatefulWidget {
  const DsPasswordField({
    super.key,
    this.label = 'Senha',
    this.initialText,
    this.state = ComponentState.defaultState,
    this.errorText,
    this.initiallyObscured = true,
    this.onChanged,
  });

  final String label;
  final String? initialText;
  final ComponentState state;
  final String? errorText;
  final bool initiallyObscured;
  final ValueChanged<String>? onChanged;

  @override
  State<DsPasswordField> createState() => _DsPasswordFieldState();
}

class _DsPasswordFieldState extends State<DsPasswordField> {
  late bool _obscured = widget.initiallyObscured;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final disabled = widget.state == ComponentState.disabled;
    return DsTextField(
      label: widget.label,
      hint: '••••••',
      initialText: widget.initialText,
      state: widget.state,
      errorText: widget.errorText,
      obscureText: _obscured,
      prefixIcon: Icons.lock_outline_rounded,
      textInputAction: TextInputAction.done,
      onChanged: widget.onChanged,
      suffix: Semantics(
        button: true,
        label: _obscured ? 'Mostrar senha' : 'Ocultar senha',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: disabled ? null : () => setState(() => _obscured = !_obscured),
          child: SizedBox(
            width: 28,
            height: 44,
            child: Icon(_obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 19, color: c.onSurfaceMuted),
          ),
        ),
      ),
    );
  }
}
