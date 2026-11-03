/// Estados que o catálogo mostra (os mesmos da legenda do Figma).
enum ComponentState { defaultState, focused, filled, pressed, selected, unselected, disabled, loading, error }

extension ComponentStateLabel on ComponentState {
  String get label => switch (this) {
        ComponentState.defaultState => 'Padrão',
        ComponentState.focused => 'Foco',
        ComponentState.filled => 'Preenchido',
        ComponentState.pressed => 'Pressionado',
        ComponentState.selected => 'Selecionado',
        ComponentState.unselected => 'Não selecionado',
        ComponentState.disabled => 'Desabilitado',
        ComponentState.loading => 'Carregando',
        ComponentState.error => 'Erro',
      };
}
