import 'package:flutter/material.dart';
import '../../common/ds.dart';
import '../actions/ds_icon_button.dart';

/// Barra superior de 64 de altura, com divisória embaixo.
/// Variações: só título, com voltar, e com voltar e ações.
class DsTopBar extends StatelessWidget {
  const DsTopBar({super.key, required this.title, this.showBack = false, this.onBack, this.actions = const []});

  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final back = showBack || onBack != null;
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 10),
      decoration: BoxDecoration(color: c.background, border: Border(bottom: BorderSide(color: c.border))),
      child: Row(
        children: [
          if (back) ...[
            DsIconButton(icon: Icons.chevron_left_rounded, tooltip: 'Voltar', onPressed: onBack),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.titleLarge.copyWith(color: c.onSurface)),
          ),
          ...actions,
        ],
      ),
    );
  }
}
