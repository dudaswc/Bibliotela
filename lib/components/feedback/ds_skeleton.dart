import 'package:flutter/material.dart';
import '../../common/ds.dart';

/// Bloco de esqueleto: cor `track`, com um brilho suave (pulso) opcional.
class DsSkeletonBox extends StatefulWidget {
  const DsSkeletonBox({super.key, this.width, required this.height, this.radius = AppRadius.pill, this.animate = true});

  final double? width;
  final double height;
  final double radius;
  final bool animate;

  @override
  State<DsSkeletonBox> createState() => _DsSkeletonBoxState();
}

class _DsSkeletonBoxState extends State<DsSkeletonBox> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    if (widget.animate) {
      _controller.repeat(reverse: true);
    } else {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: Tween<double>(begin: 0.55, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(color: context.colors.track, borderRadius: BorderRadius.circular(widget.radius)),
        ),
      );
}

/// Esqueleto de uma linha da lista: capa, dois textos e a área da direita.
class DsSkeletonItemTile extends StatelessWidget {
  const DsSkeletonItemTile({super.key, this.showDivider = true, this.animate = true});

  final bool showDivider;
  final bool animate;

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(minHeight: 88),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 11),
        decoration: BoxDecoration(border: showDivider ? Border(bottom: BorderSide(color: context.colors.border)) : null),
        child: Row(children: [
          DsSkeletonBox(width: 48, height: 64, radius: AppRadius.sm, animate: animate),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              DsSkeletonBox(width: 130, height: 14, animate: animate),
              const SizedBox(height: AppSpacing.sm),
              DsSkeletonBox(width: 190, height: 12, animate: animate),
            ]),
          ),
          const SizedBox(width: AppSpacing.md),
          DsSkeletonBox(width: 56, height: 14, animate: animate),
        ]),
      );
}

/// Esqueleto do cartão de resumo: título e chip de ano, número, páginas e métricas.
class DsSkeletonSummaryCard extends StatelessWidget {
  const DsSkeletonSummaryCard({super.key, this.animate = true});

  final bool animate;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll, side: BorderSide(color: c.border)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            DsSkeletonBox(width: 100, height: 12, animate: animate),
            DsSkeletonBox(width: 64, height: 34, animate: animate),
          ]),
          const SizedBox(height: 14),
          DsSkeletonBox(width: 150, height: 44, radius: AppRadius.md, animate: animate),
          const SizedBox(height: 14),
          DsSkeletonBox(width: 130, height: 14, animate: animate),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(flex: 7, child: DsSkeletonBox(height: 36, radius: AppRadius.md, animate: animate)),
            const SizedBox(width: AppSpacing.md),
            Expanded(flex: 7, child: DsSkeletonBox(height: 36, radius: AppRadius.md, animate: animate)),
            const SizedBox(width: AppSpacing.md),
            Expanded(flex: 10, child: DsSkeletonBox(height: 36, radius: AppRadius.md, animate: animate)),
          ]),
        ]),
      ),
    );
  }
}
