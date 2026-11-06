import 'package:flutter/material.dart';
import '../../common/ds.dart';

/// Indicador de carregamento circular. 18 dentro de botões, 32 em telas.
class DsSpinner extends StatelessWidget {
  const DsSpinner({super.key, this.size = 18, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(strokeWidth: 2, color: color ?? context.colors.primary),
      );
}
