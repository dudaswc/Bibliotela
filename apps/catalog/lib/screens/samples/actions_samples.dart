import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bibliotela_design_system/bibliotela_design_system.dart';
import '../../common/widgets/sample_section.dart';

const _buttonStates = [
  ComponentState.defaultState,
  ComponentState.pressed,
  ComponentState.disabled,
  ComponentState.loading,
];

List<Widget> buildActionsSamples(BuildContext context) => [
      _variantSection('Primário', ActionButtonVariant.primary, 'Ação principal da tela (entrar, salvar). Fundo primary, texto onPrimary. Altura 48, raio md.'),
      _variantSection('Secundário', ActionButtonVariant.secondary, 'Ação alternativa (tentar novamente, sair da conta). Fundo surface com borda.'),
      _variantSection('Texto', ActionButtonVariant.text, 'Ação de menor peso (cancelar, limpar filtros, remover nota). Sem fundo, texto primary.'),
      _variantSection('Perigo', ActionButtonVariant.danger, 'Ação destrutiva. Só aparece dentro de um diálogo de confirmação, nunca solta na tela.'),
      SampleSection(
        title: 'Button · Tamanho e ícone',
        description: 'Largura total ou compacto (que ocupa só o conteúdo), com ícone opcional.',
        children: [
          StateLabel(label: 'Largura total', child: ActionButtonFactory.primary(ComponentState.defaultState, label: 'Salvar')),
          StateLabel(label: 'Compacto', child: ActionButtonFactory.compact(ActionButtonVariant.primary, ComponentState.defaultState)),
          StateLabel(
            label: 'Compacto com ícone',
            child: ActionButtonFactory.compact(ActionButtonVariant.secondary, ComponentState.defaultState, label: 'Sair da conta', icon: Icons.logout_rounded),
          ),
        ],
      ),
      const SampleSection(
        title: 'Button · Carregando ao tocar',
        description: 'Toque no botão: ele entra em Carregando (spinner de 18) por um instante e fica inativo.',
        children: [_TapToLoadButton()],
      ),
      SampleSection(
        title: 'IconButton',
        description: 'Alvo de toque de 44 por 44. Pressionado: fundo primaryContainer. A variante Perigo serve para excluir.',
        children: [
          Wrap(
            spacing: 24,
            runSpacing: 16,
            children: [
              for (final s in [ComponentState.defaultState, ComponentState.pressed, ComponentState.disabled])
                StateLabel(label: s.label, child: DsIconButton(icon: Icons.edit_outlined, state: s, tooltip: 'Editar')),
            ],
          ),
          Wrap(
            spacing: 24,
            runSpacing: 16,
            children: [
              for (final s in [ComponentState.defaultState, ComponentState.pressed, ComponentState.disabled])
                StateLabel(label: 'Perigo · ${s.label}', child: DsIconButton(icon: Icons.delete_outline_rounded, danger: true, state: s, tooltip: 'Excluir')),
            ],
          ),
        ],
      ),
      SampleSection(
        title: 'FAB',
        description: 'Botão flutuante de novo item. 56 por 56, raio lg, sombra fab. Fica 16 acima da barra de abas, à direita.',
        children: [
          Wrap(
            spacing: 32,
            runSpacing: 16,
            children: [
              StateLabel(label: ComponentState.defaultState.label, child: const DsFab()),
              StateLabel(label: ComponentState.pressed.label, child: const DsFab(state: ComponentState.pressed)),
            ],
          ),
        ],
      ),
    ];

SampleSection _variantSection(String name, ActionButtonVariant variant, String description) => SampleSection(
      title: 'Button · $name',
      description: description,
      children: [
        for (final s in _buttonStates) StateLabel(label: s.label, child: ActionButtonFactory.of(variant, s)),
      ],
    );

class _TapToLoadButton extends StatefulWidget {
  const _TapToLoadButton();

  @override
  State<_TapToLoadButton> createState() => _TapToLoadButtonState();
}

class _TapToLoadButtonState extends State<_TapToLoadButton> {
  bool _loading = false;
  Timer? _timer;

  void _tap() {
    setState(() => _loading = true);
    _timer = Timer(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DsActionButton(
        viewModel: ActionButtonViewModel(
          label: 'Salvar',
          state: _loading ? ComponentState.loading : ComponentState.defaultState,
        ),
        onPressed: _tap,
      );
}
