import 'package:flutter/material.dart';
import '../../common/ds.dart';

/// Avatar circular com as iniciais do nome. 40 em listas e 96 no perfil.
class DsAvatar extends StatelessWidget {
  const DsAvatar({super.key, required this.name, this.size = 40});

  final String name;
  final double size;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      final word = parts.first;
      return (word.length >= 2 ? word.substring(0, 2) : word).toUpperCase();
    }
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: c.primaryContainer, shape: BoxShape.circle),
      child: Text(
        initials,
        style: (size >= 80 ? AppTypography.headlineMedium : AppTypography.titleSmall).copyWith(color: c.primary),
      ),
    );
  }
}
