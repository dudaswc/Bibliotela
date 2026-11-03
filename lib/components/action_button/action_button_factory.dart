import 'package:flutter/widgets.dart';
import '../../common/models/component_state.dart';
import 'action_button.dart';
import 'action_button_view_model.dart';

/// Monta o botão do catálogo para cada variante e estado.
abstract final class ActionButtonFactory {
  static DsActionButton primary(ComponentState state, {String label = 'Entrar'}) =>
      _make(ActionButtonVariant.primary, state, label, ActionButtonSize.fullWidth);

  static DsActionButton secondary(ComponentState state, {String label = 'Entrar'}) =>
      _make(ActionButtonVariant.secondary, state, label, ActionButtonSize.fullWidth);

  static DsActionButton text(ComponentState state, {String label = 'Entrar'}) =>
      _make(ActionButtonVariant.text, state, label, ActionButtonSize.compact);

  static DsActionButton danger(ComponentState state, {String label = 'Excluir'}) =>
      _make(ActionButtonVariant.danger, state, label, ActionButtonSize.fullWidth);

  static DsActionButton compact(ActionButtonVariant variant, ComponentState state, {String label = 'Salvar', IconData? icon}) => DsActionButton(
        viewModel: ActionButtonViewModel(label: label, variant: variant, state: state, size: ActionButtonSize.compact, icon: icon),
      );

  static DsActionButton of(ActionButtonVariant variant, ComponentState state, {String label = 'Entrar'}) =>
      _make(variant, state, label, variant == ActionButtonVariant.text ? ActionButtonSize.compact : ActionButtonSize.fullWidth);

  static DsActionButton _make(ActionButtonVariant variant, ComponentState state, String label, ActionButtonSize size) => DsActionButton(
        viewModel: ActionButtonViewModel(label: label, variant: variant, state: state, size: size),
      );
}
