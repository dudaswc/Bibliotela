import 'package:flutter/material.dart';
import '../../common/ds.dart';
import 'ds_text_field.dart';

/// Campo de várias linhas (3 linhas, sem redimensionar), para a observação.
class DsTextArea extends StatelessWidget {
  const DsTextArea({
    super.key,
    this.label = 'Observação (opcional)',
    this.hint = 'Escreva o que achou...',
    this.initialText,
    this.state = ComponentState.defaultState,
    this.onChanged,
  });

  final String label;
  final String hint;
  final String? initialText;
  final ComponentState state;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => DsTextField(
        label: label,
        hint: hint,
        initialText: initialText,
        state: state,
        maxLines: 3,
        keyboardType: TextInputType.multiline,
        onChanged: onChanged,
      );
}
