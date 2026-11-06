import 'package:flutter/material.dart';
import '../../common/ds.dart';

/// Título de seção em caixa alta: "Por gênero", mês, "Na fila", "Dados"...
class DsSectionHeader extends StatelessWidget {
  const DsSectionHeader(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title.toUpperCase(),
          style: AppTypography.labelSmall.copyWith(color: context.colors.onSurfaceMuted),
        ),
      );
}
