import 'package:flutter/material.dart';
import '../../common/ds.dart';

/// Botão flutuante de novo item: 56 x 56, raio lg, sombra `fab`.
class DsFab extends StatefulWidget {
  const DsFab({super.key, this.state = ComponentState.defaultState, this.onPressed, this.icon = Icons.add_rounded});

  final ComponentState state;
  final VoidCallback? onPressed;
  final IconData icon;

  @override
  State<DsFab> createState() => _DsFabState();
}

class _DsFabState extends State<DsFab> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final pressed = widget.state == ComponentState.pressed || _down;
    return Semantics(
      button: true,
      label: 'Novo item',
      child: DecoratedBox(
        decoration: const BoxDecoration(borderRadius: AppRadius.lgAll, boxShadow: [AppShadows.fab]),
        child: Material(
          color: pressed ? Color.alphaBlend(c.overlayPressed, c.primary) : c.primary,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onPressed ?? () {},
            onHighlightChanged: (value) => setState(() => _down = value),
            child: SizedBox(width: 56, height: 56, child: Icon(widget.icon, size: 28, color: c.onPrimary)),
          ),
        ),
      ),
    );
  }
}
