import 'package:flutter/material.dart';
import '../../common/ds.dart';
import '../feedback/ds_spinner.dart';
import 'action_button_view_model.dart';

class DsActionButton extends StatefulWidget {
  const DsActionButton({super.key, required this.viewModel, this.onPressed});

  final ActionButtonViewModel viewModel;
  final VoidCallback? onPressed;

  @override
  State<DsActionButton> createState() => _DsActionButtonState();
}

class _ButtonColors {
  const _ButtonColors(this.fill, this.foreground, this.border);
  final Color? fill;
  final Color foreground;
  final Color? border;
}

class _DsActionButtonState extends State<DsActionButton> {
  bool _down = false;

  _ButtonColors _colors(AppColorPalette c) => switch (widget.viewModel.variant) {
        ActionButtonVariant.primary => _ButtonColors(c.primary, c.onPrimary, null),
        ActionButtonVariant.secondary => _ButtonColors(c.surface, c.onSurface, c.border),
        ActionButtonVariant.text => _ButtonColors(null, c.primary, null),
        ActionButtonVariant.danger => _ButtonColors(c.error, c.onError, null),
      };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final vm = widget.viewModel;
    final colors = _colors(c);
    final inactive = vm.isDisabled || vm.isLoading;
    final pressed = vm.isPressed || _down;

    Color fill;
    if (pressed) {
      fill = colors.fill == null ? c.overlayPressed : Color.alphaBlend(c.overlayPressed, colors.fill!);
    } else {
      fill = colors.fill ?? Colors.transparent;
    }

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (vm.isLoading) ...[
          DsSpinner(size: 18, color: colors.foreground),
          const SizedBox(width: AppSpacing.sm),
        ] else if (vm.icon != null) ...[
          Icon(vm.icon, size: 20, color: colors.foreground),
          const SizedBox(width: AppSpacing.sm),
        ],
        Flexible(
          child: Text(
            vm.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelLarge.copyWith(color: colors.foreground),
          ),
        ),
      ],
    );

    final fullWidth = vm.size == ActionButtonSize.fullWidth;
    final button = Opacity(
      opacity: vm.isDisabled ? 0.7 : 1,
      child: Material(
        color: fill,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mdAll,
          side: colors.border == null ? BorderSide.none : BorderSide(color: colors.border!),
        ),
        child: InkWell(
          onTap: inactive ? null : (widget.onPressed ?? () {}),
          onHighlightChanged: (value) => setState(() => _down = value),
          child: SizedBox(
            height: 48,
            width: fullWidth ? double.infinity : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Center(widthFactor: fullWidth ? null : 1, child: content),
            ),
          ),
        ),
      ),
    );

    return fullWidth ? button : Align(alignment: Alignment.centerLeft, widthFactor: 1, child: button);
  }
}
