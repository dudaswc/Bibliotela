import 'package:flutter/widgets.dart';

import '../../common/theme/app_spacing.dart';

/// Vertical space between widgets, taken from the spacing scale.
///
/// `Gap.md()` is a `SizedBox(height: AppSpacing.md)`. Use [HGap] for the
/// horizontal one.
class Gap extends StatelessWidget {
  const Gap(this.size, {super.key});

  const Gap.xxs({super.key}) : size = AppSpacing.xxs;
  const Gap.xs({super.key}) : size = AppSpacing.xs;
  const Gap.sm({super.key}) : size = AppSpacing.sm;
  const Gap.md({super.key}) : size = AppSpacing.md;
  const Gap.lg({super.key}) : size = AppSpacing.lg;
  const Gap.xl({super.key}) : size = AppSpacing.xl;
  const Gap.xxl({super.key}) : size = AppSpacing.xxl;

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(height: size);
}

/// Horizontal space between widgets, taken from the spacing scale.
class HGap extends StatelessWidget {
  const HGap(this.size, {super.key});

  const HGap.xs({super.key}) : size = AppSpacing.xs;
  const HGap.sm({super.key}) : size = AppSpacing.sm;
  const HGap.md({super.key}) : size = AppSpacing.md;
  const HGap.lg({super.key}) : size = AppSpacing.lg;

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(width: size);
}
