import 'package:flutter/material.dart';
import 'package:bibliotela_design_system/bibliotela_design_system.dart';
import '../../common/widgets/sample_section.dart';

const _statusOptions = <DsSegment<String>>[
  DsSegment(value: 'all', label: 'Todos'),
  DsSegment(value: 'want', label: 'Quero'),
  DsSegment(value: 'progress', label: 'Em andamento'),
  DsSegment(value: 'done', label: 'Concluídos'),
];

List<Widget> buildSelectorsSamples(BuildContext context) => [
      SampleSection(
        title: 'SegmentedControl',
        description: 'Filtro de status: Todos, Quero, Em andamento, Concluídos. O mesmo controle serve para o tipo e o status do formulário. Toque nas opções.',
        children: [
          StateLabel(label: 'Padrão (interativo)', child: _interactiveSegmented()),
          StateLabel(
            label: ComponentState.disabled.label,
            child: DsSegmentedControl<String>(options: _statusOptions, value: 'want', onChanged: (_) {}, enabled: false),
          ),
        ],
      ),
      SampleSection(
        title: 'FilterChip',
        description: 'Chip de filtro por tipo, numa linha que rola na horizontal. Selecionado: primaryContainer e texto primary. Altura 38, pílula.',
        children: [
          StateLabel(label: 'Grupo (interativo)', child: _interactiveChips()),
          Wrap(
            spacing: 24,
            runSpacing: 16,
            children: [
              StateLabel(label: ComponentState.selected.label, child: const DsFilterChip(label: 'Livros', selected: true)),
              StateLabel(label: ComponentState.unselected.label, child: const DsFilterChip(label: 'Livros', selected: false)),
              StateLabel(label: ComponentState.disabled.label, child: const DsFilterChip(label: 'Livros', selected: false, enabled: false)),
            ],
          ),
        ],
      ),
      SampleSection(
        title: 'StarRating',
        description: 'Leitura da nota: de 0 a 10 mostrada como estrelas (nota ÷ 2, com meia estrela). 8 = 4 estrelas, 9 = 4,5 estrelas. Tamanhos 14 (lista e resumo) e 28 (detalhe).',
        children: [
          StateLabel(label: 'Pequena (14)', child: _ratingColumn(DsStarSize.small)),
          StateLabel(label: 'Grande (28)', child: _ratingColumn(DsStarSize.large)),
        ],
      ),
      SampleSection(
        title: 'StarRatingInput',
        description: 'Entrada da nota no formulário (só com status Concluído). Cada estrela tem alvo de 36 por 44: metade esquerda dá meia estrela, direita dá estrela inteira.',
        children: [_interactiveRating()],
      ),
      SampleSection(
        title: 'StatusChip',
        description: 'Chip de status. Livro: Quero ler, Lendo, Lido. Série e filme: Quero assistir, Assistindo, Assistido. Texto na cor do status sobre a própria cor a 14%.',
        children: [
          StateLabel(
            label: 'Livro',
            child: Wrap(spacing: 8, runSpacing: 8, children: [
              for (final s in MediaStatus.values) DsStatusChip(status: s, type: MediaType.book),
            ]),
          ),
          StateLabel(
            label: 'Série e filme',
            child: Wrap(spacing: 8, runSpacing: 8, children: [
              for (final s in MediaStatus.values) DsStatusChip(status: s, type: MediaType.movie),
            ]),
          ),
        ],
      ),
    ];

Widget _interactiveSegmented() {
  var value = 'all';
  return StatefulBuilder(
    builder: (context, setState) => DsSegmentedControl<String>(
      options: _statusOptions,
      value: value,
      onChanged: (v) => setState(() => value = v),
    ),
  );
}

Widget _interactiveChips() {
  var selected = 0;
  const labels = ['Todos os tipos', 'Livros', 'Séries', 'Filmes'];
  return StatefulBuilder(
    builder: (context, setState) => Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < labels.length; i++)
          DsFilterChip(label: labels[i], selected: selected == i, onTap: () => setState(() => selected = i)),
      ],
    ),
  );
}

Widget _ratingColumn(DsStarSize size) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final r in const [0, 1, 5, 8, 9, 10])
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 64,
                  child: Builder(
                    builder: (context) => Text(
                      r == 0 ? 'sem nota' : 'nota $r',
                      style: AppTypography.labelMedium.copyWith(color: context.colors.onSurfaceMuted),
                    ),
                  ),
                ),
                DsStarRating(rating: r, size: size),
              ],
            ),
          ),
      ],
    );

Widget _interactiveRating() {
  int? value;
  return StatefulBuilder(
    builder: (context, setState) => DsStarRatingInput(value: value, onChanged: (v) => setState(() => value = v)),
  );
}
