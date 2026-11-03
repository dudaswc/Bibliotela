import 'package:flutter/material.dart';
import '../../common/ds.dart';

/// Botão de ícone com alvo de 44 x 44. `danger` serve para ações destrutivas.
class DsIconButton extends StatefulWidget {
  const DsIconButton({
    super.key,
    required this.icon,
    this.danger = false,
    this.state = ComponentState.defaultState,
    this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final bool danger;
  final ComponentState state;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  State<DsIconButton> createState() => _DsIconButtonState();
}

class _DsIconButtonState extends State<DsIconButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final disabled = widget.state == ComponentState.disabled;
    final pressed = widget.state == ComponentState.pressed || _down;
    final button = Opacity(
      opacity: disabled ? 0.7 : 1,
      child: Material(
        color: pressed ? c.primaryContainer : Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: disabled ? null : (widget.onPressed ?? () {}),
          onHighlightChanged: (value) => setState(() => _down = value),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(widget.icon, size: 22, color: widget.danger ? c.error : c.onSurface),
          ),
        ),
      ),
    );
    return Semantics(
      button: true,
      enabled: !disabled,
      label: widget.tooltip,
      child: widget.tooltip == null ? button : Tooltip(message: widget.tooltip!, child: button),
    );
  }
}
