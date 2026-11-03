import 'package:flutter/material.dart';
import '../../common/ds.dart';
import '../../common/widgets/sample_section.dart';
import '../../components/inputs/ds_date_field.dart';
import '../../components/inputs/ds_dropdown.dart';
import '../../components/inputs/ds_password_field.dart';
import '../../components/inputs/ds_search_field.dart';
import '../../components/inputs/ds_text_area.dart';
import '../../components/inputs/ds_text_field.dart';

const _genreNames = [
  'Ação', 'Aventura', 'Biografia', 'Comédia', 'Documentário', 'Drama', 'Fantasia', 'Ficção científica', 'Romance', 'Suspense', 'Terror', 'Outros',
];

final List<DsDropdownItem<String>> _genres = [
  for (final g in _genreNames) DsDropdownItem<String>(value: g, label: g),
];

List<Widget> buildInputsSamples(BuildContext context) => [
      SampleSection(
        title: 'TextField',
        description: 'Campo de texto de verdade, com rótulo acima (não flutuante). Altura mínima 48, raio md, anel de foco de 3. Toque nele para ver o foco real.',
        children: [
          StateLabel(label: ComponentState.defaultState.label, child: const DsTextField(label: 'E-mail', hint: 'voce@exemplo.com', prefixIcon: Icons.mail_outline_rounded)),
          StateLabel(label: ComponentState.focused.label, child: const DsTextField(label: 'E-mail', hint: 'voce@exemplo.com', prefixIcon: Icons.mail_outline_rounded, state: ComponentState.focused)),
          StateLabel(label: ComponentState.filled.label, child: const DsTextField(label: 'E-mail', initialText: 'ana@bibliotela.dev', prefixIcon: Icons.mail_outline_rounded)),
          StateLabel(
            label: ComponentState.error.label,
            child: const DsTextField(label: 'E-mail', initialText: 'ana@', prefixIcon: Icons.mail_outline_rounded, errorText: 'Informe um e-mail válido.'),
          ),
          StateLabel(
            label: ComponentState.disabled.label,
            child: const DsTextField(label: 'E-mail', initialText: 'ana@bibliotela.dev', prefixIcon: Icons.mail_outline_rounded, state: ComponentState.disabled),
          ),
        ],
      ),
      SampleSection(
        title: 'PasswordField',
        description: 'Campo de senha com cadeado e botão de mostrar ou ocultar (área de toque de 44).',
        children: [
          const StateLabel(label: 'Oculta', child: DsPasswordField(initialText: '123456')),
          const StateLabel(label: 'Visível', child: DsPasswordField(initialText: '123456', initiallyObscured: false)),
          const StateLabel(
            label: 'Erro',
            child: DsPasswordField(initialText: '123', errorText: 'A senha precisa ter pelo menos 6 caracteres.'),
          ),
          StateLabel(label: ComponentState.disabled.label, child: const DsPasswordField(initialText: '123456', state: ComponentState.disabled)),
        ],
      ),
      SampleSection(
        title: 'SearchField',
        description: 'Busca por título ou autor, sem rótulo visível. Filtra a lista em tempo real.',
        children: [
          StateLabel(label: ComponentState.defaultState.label, child: const DsSearchField()),
          StateLabel(label: ComponentState.focused.label, child: const DsSearchField(state: ComponentState.focused)),
          StateLabel(label: ComponentState.filled.label, child: const DsSearchField(initialText: 'duna')),
          StateLabel(label: ComponentState.disabled.label, child: const DsSearchField(state: ComponentState.disabled)),
        ],
      ),
      SampleSection(
        title: 'Dropdown',
        description: 'Lista de opções, usada para o gênero. "Sem gênero" vira genre nulo na API.',
        children: [
          StateLabel(label: '${ComponentState.defaultState.label} (toque para escolher)', child: _interactiveDropdown()),
          StateLabel(
            label: ComponentState.filled.label,
            child: DsDropdown<String>(label: 'Gênero', items: _genres, value: 'Ficção científica', onChanged: (_) {}),
          ),
          StateLabel(
            label: ComponentState.focused.label,
            child: DsDropdown<String>(label: 'Gênero', items: _genres, value: 'Ficção científica', onChanged: (_) {}, state: ComponentState.focused),
          ),
          StateLabel(
            label: ComponentState.error.label,
            child: DsDropdown<String>(label: 'Gênero', items: _genres, onChanged: (_) {}, errorText: 'Escolha um gênero.'),
          ),
          StateLabel(
            label: ComponentState.disabled.label,
            child: DsDropdown<String>(label: 'Gênero', items: _genres, state: ComponentState.disabled),
          ),
        ],
      ),
      SampleSection(
        title: 'DateField',
        description: 'Abre o calendário. Aparece como dd/mm/aaaa e vai para a API como YYYY-MM-DD.',
        children: [
          StateLabel(label: '${ComponentState.defaultState.label} (toque para escolher)', child: _interactiveDate()),
          StateLabel(label: ComponentState.filled.label, child: DsDateField(label: 'Data de fim', value: DateTime(2026, 9, 6))),
          StateLabel(label: ComponentState.error.label, child: const DsDateField(label: 'Data de fim', errorText: 'Informe a data de fim.')),
          StateLabel(label: ComponentState.disabled.label, child: const DsDateField(label: 'Data de início', state: ComponentState.disabled)),
        ],
      ),
      SampleSection(
        title: 'TextArea',
        description: 'Campo de observação com três linhas, sem redimensionar.',
        children: [
          StateLabel(label: ComponentState.defaultState.label, child: const DsTextArea()),
          StateLabel(label: ComponentState.focused.label, child: const DsTextArea(state: ComponentState.focused)),
          StateLabel(
            label: ComponentState.filled.label,
            child: const DsTextArea(initialText: 'Um universo imenso e uma leitura que fica melhor a cada capítulo.'),
          ),
        ],
      ),
    ];

Widget _interactiveDropdown() {
  String? value;
  return StatefulBuilder(
    builder: (context, setState) => DsDropdown<String>(
      label: 'Gênero',
      items: _genres,
      value: value,
      onChanged: (v) => setState(() => value = v),
    ),
  );
}

Widget _interactiveDate() {
  DateTime? value;
  return StatefulBuilder(
    builder: (context, setState) => DsDateField(
      label: 'Data de início',
      value: value,
      onChanged: (d) => setState(() => value = d),
    ),
  );
}
