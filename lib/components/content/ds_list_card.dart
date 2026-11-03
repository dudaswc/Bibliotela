import 'package:flutter/material.dart';
import '../../common/ds.dart';

/// Contêiner da lista: cartão com borda e raio lg; os itens ficam separados
/// por divisória de 1. Itens do mesmo mês ficam juntos sob um DsSectionHeader.
class DsListCard extends StatelessWidget {
  const DsListCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll, side: BorderSide(color: c.border)),
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}
