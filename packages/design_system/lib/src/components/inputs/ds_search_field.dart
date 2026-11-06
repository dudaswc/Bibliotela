import 'package:flutter/material.dart';
import '../../common/ds.dart';
import 'ds_text_field.dart';

/// Busca por título ou autor, sem rótulo visível.
class DsSearchField extends StatelessWidget {
  const DsSearchField({
    super.key,
    this.state = ComponentState.defaultState,
    this.initialText,
    this.hint = 'Buscar por título ou autor',
    this.onChanged,
  });

  final ComponentState state;
  final String? initialText;
  final String hint;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => DsTextField(
        hint: hint,
        initialText: initialText,
        state: state,
        prefixIcon: Icons.search_rounded,
        textInputAction: TextInputAction.search,
        onChanged: onChanged,
      );
}
