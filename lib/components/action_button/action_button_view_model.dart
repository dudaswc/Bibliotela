import 'package:flutter/widgets.dart';
import '../../common/models/component_state.dart';

enum ActionButtonVariant { primary, secondary, text, danger }

enum ActionButtonSize { compact, fullWidth }

class ActionButtonViewModel {
  const ActionButtonViewModel({
    required this.label,
    this.variant = ActionButtonVariant.primary,
    this.state = ComponentState.defaultState,
    this.size = ActionButtonSize.fullWidth,
    this.icon,
  });

  final String label;
  final ActionButtonVariant variant;
  final ComponentState state;
  final ActionButtonSize size;
  final IconData? icon;

  bool get isDisabled => state == ComponentState.disabled;
  bool get isLoading => state == ComponentState.loading;
  bool get isPressed => state == ComponentState.pressed;
}
