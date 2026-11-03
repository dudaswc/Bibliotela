import 'package:flutter/material.dart';
import '../../common/ds.dart';
import '../../common/widgets/sample_section.dart';
import '../../components/actions/ds_icon_button.dart';
import '../../components/navigation/ds_bottom_tabs.dart';
import '../../components/navigation/ds_top_bar.dart';
import '../../components/navigation/ds_year_chip.dart';

List<Widget> buildNavigationSamples(BuildContext context) => [
      SampleSection(
        title: 'TopBar',
        description: 'Barra superior de 64 de altura, com divisória embaixo. Só título (com o botão de tema), com voltar, e com voltar e ações.',
        children: [
          const StateLabel(
            label: 'Só título',
            child: SampleFrame(
              child: DsTopBar(title: 'Bibliotela', actions: [DsIconButton(icon: Icons.light_mode_outlined, tooltip: 'Alternar tema')]),
            ),
          ),
          const StateLabel(label: 'Com voltar', child: SampleFrame(child: DsTopBar(title: 'Item', showBack: true))),
          const StateLabel(
            label: 'Com voltar e ações',
            child: SampleFrame(
              child: DsTopBar(
                title: 'Item',
                showBack: true,
                actions: [
                  DsIconButton(icon: Icons.edit_outlined, tooltip: 'Editar'),
                  DsIconButton(icon: Icons.delete_outline_rounded, danger: true, tooltip: 'Excluir'),
                ],
              ),
            ),
          ),
        ],
      ),
      SampleSection(
        title: 'BottomTabs',
        description: 'Barra de abas inferior, 72 de altura. Toque numa aba: a ativa fica com indicador em primaryContainer, ícone e texto em primary.',
        children: [_interactiveTabs()],
      ),
      SampleSection(
        title: 'YearChip e YearMenu',
        description: 'Chip de ano do resumo. Toque nele para abrir o menu de anos; o ano atual fica em destaque.',
        children: [
          Wrap(
            spacing: 24,
            runSpacing: 16,
            children: [
              StateLabel(label: ComponentState.defaultState.label, child: _interactiveYear()),
              StateLabel(
                label: ComponentState.pressed.label,
                child: DsYearChip(year: 2026, years: const [2026, 2025], onChanged: (_) {}, state: ComponentState.pressed),
              ),
            ],
          ),
        ],
      ),
    ];

Widget _interactiveTabs() {
  var selected = 0;
  return StatefulBuilder(
    builder: (context, setState) => SampleFrame(
      child: DsBottomTabs(selectedIndex: selected, onChanged: (i) => setState(() => selected = i)),
    ),
  );
}

Widget _interactiveYear() {
  var year = 2026;
  return StatefulBuilder(
    builder: (context, setState) => DsYearChip(year: year, years: const [2026, 2025], onChanged: (y) => setState(() => year = y)),
  );
}
