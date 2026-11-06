import 'package:flutter/material.dart';
import '../../common/ds.dart';

/// Rótulo que fica acima do campo (13/18, peso 500).
class DsFieldLabel extends StatelessWidget {
  const DsFieldLabel(this.text, {super.key, this.disabled = false});

  final String text;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Text(
      text,
      style: AppTypography.bodySmallStrong.copyWith(color: disabled ? c.onSurfaceMuted : c.onSurface),
    );
  }
}
