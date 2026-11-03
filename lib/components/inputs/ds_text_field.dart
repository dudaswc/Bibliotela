import 'package:flutter/material.dart';
import '../../common/ds.dart';
import 'ds_field_shell.dart';

/// Campo de texto de verdade, com o visual do Design System. O parâmetro
/// `state` força um estado visual (útil no catálogo); o foco real também
/// acende o anel de foco.
class DsTextField extends StatefulWidget {
  const DsTextField({
    super.key,
    this.label,
    this.hint,
    this.initialText,
    this.controller,
    this.prefixIcon,
    this.suffix,
    this.state = ComponentState.defaultState,
    this.errorText,
    this.helperText,
    this.obscureText = false,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
  });

  final String? label;
  final String? hint;
  final String? initialText;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final Widget? suffix;
  final ComponentState state;
  final String? errorText;
  final String? helperText;
  final bool obscureText;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;

  @override
  State<DsTextField> createState() => _DsTextFieldState();
}

class _DsTextFieldState extends State<DsTextField> {
  final FocusNode _focus = FocusNode();
  TextEditingController? _own;

  TextEditingController get _controller => widget.controller ?? _own!;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChanged);
    if (widget.controller == null) _own = TextEditingController(text: widget.initialText ?? '');
  }

  void _onFocusChanged() => setState(() {});

  @override
  void dispose() {
    _focus.removeListener(_onFocusChanged);
    _focus.dispose();
    _own?.dispose();
    super.dispose();
  }

  ComponentState get _effectiveState {
    if (widget.state == ComponentState.disabled) return ComponentState.disabled;
    if (widget.errorText != null || widget.state == ComponentState.error) return ComponentState.error;
    if (_focus.hasFocus || widget.state == ComponentState.focused) return ComponentState.focused;
    return widget.state;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final disabled = widget.state == ComponentState.disabled;
    final multiline = widget.maxLines > 1;
    final field = TextField(
      controller: _controller,
      focusNode: _focus,
      enabled: !disabled,
      obscureText: widget.obscureText,
      minLines: widget.maxLines,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      cursorColor: c.primary,
      style: AppTypography.bodyMedium.copyWith(color: disabled ? c.onSurfaceMuted : c.onSurface),
      decoration: InputDecoration(
        isCollapsed: true,
        border: InputBorder.none,
        hintText: widget.hint,
        hintStyle: AppTypography.bodyMedium.copyWith(color: c.onSurfaceMuted),
        contentPadding: EdgeInsets.symmetric(vertical: multiline ? 12 : 14),
      ),
    );
    return DsFieldShell(
      label: widget.label,
      state: _effectiveState,
      errorText: widget.errorText,
      helperText: widget.helperText,
      minHeight: multiline ? 96 : 48,
      child: Row(
        crossAxisAlignment: multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          if (widget.prefixIcon != null) ...[
            Padding(
              padding: EdgeInsets.only(top: multiline ? 12 : 0),
              child: Icon(widget.prefixIcon, size: 19, color: c.onSurfaceMuted),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(child: field),
          if (widget.suffix != null) ...[
            const SizedBox(width: 10),
            widget.suffix!,
          ],
        ],
      ),
    );
  }
}
