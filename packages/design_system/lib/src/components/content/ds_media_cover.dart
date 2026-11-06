import 'package:flutter/material.dart';
import '../../common/ds.dart';

/// Capa substituta: o ícone do tipo sobre a cor do tipo a 14%.
/// Pequena 48 x 64 (lista), grande 96 x 128 (detalhe). O app não usa imagens.
class DsMediaCover extends StatelessWidget {
  const DsMediaCover({super.key, required this.type, this.large = false});

  final MediaType type;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = c.forType(type);
    return Container(
      width: large ? 96 : 48,
      height: large ? 128 : 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: c.soft(color), borderRadius: large ? AppRadius.mdAll : AppRadius.smAll),
      child: Icon(type.icon, size: large ? 36 : 24, color: color),
    );
  }
}
