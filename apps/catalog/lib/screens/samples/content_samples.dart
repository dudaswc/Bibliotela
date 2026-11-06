import 'package:flutter/material.dart';
import 'package:bibliotela_design_system/bibliotela_design_system.dart';
import '../../common/models/sample_data.dart';
import '../../common/widgets/sample_section.dart';

DsItemTile _tile(SampleItem i, {ComponentState state = ComponentState.defaultState, bool divider = true}) => DsItemTile(
      type: i.type,
      title: i.title,
      subtitle: i.subtitle,
      status: i.status,
      rating: i.rating,
      dateLabel: i.dateLabel,
      state: state,
      showDivider: divider,
    );

Widget _group(String title, List<int> indexes) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DsSectionHeader(title),
        DsListCard(
          children: [
            for (var k = 0; k < indexes.length; k++) _tile(sampleItems[indexes[k]], divider: k != indexes.length - 1),
          ],
        ),
      ],
    );

List<Widget> buildContentSamples(BuildContext context) => [
      SampleSection(
        title: 'ItemTile',
        description: 'Linha da lista. À direita: estrelas e data (concluído com nota) ou o chip de status. Altura mínima 88. Toque numa linha para ver o estado pressionado.',
        children: [
          StateLabel(label: 'Concluído com nota', child: _tile(sampleItems[0])),
          StateLabel(label: 'Em andamento', child: _tile(sampleItems[2])),
          StateLabel(label: 'Quero (na fila)', child: _tile(sampleItems[3])),
          StateLabel(label: 'Concluído sem nota', child: _tile(sampleItems[7])),
          StateLabel(label: ComponentState.pressed.label, child: _tile(sampleItems[1], state: ComponentState.pressed)),
        ],
      ),
      SampleSection(
        title: 'ListCard',
        description: 'Contêiner da lista, agrupada por mês pela data de leitura. Os itens "quero" ficam no grupo "Na fila", sempre no fim.',
        children: [
          _group('Setembro de 2026', const [0, 4, 5, 2, 8]),
          _group('Agosto de 2026', const [1, 7]),
          _group('Na fila', const [3, 6, 10]),
        ],
      ),
      SampleSection(
        title: 'SummaryCard',
        description: 'Resumo do ano no topo da biblioteca. Toque no chip de ano para trocar. As estrelas mostram a média arredondada ÷ 2; sem nenhuma nota, a média é "—".',
        children: [
          StateLabel(label: 'Interativo', child: _interactiveSummary()),
          StateLabel(
            label: 'Sem nenhuma nota no ano',
            child: DsSummaryCard(
              year: 2026,
              years: const [2026, 2025],
              onYearChanged: (_) {},
              booksFinished: 1,
              pagesRead: 264,
              movies: 0,
              series: 0,
            ),
          ),
        ],
      ),
      SampleSection(
        title: 'GenreBar',
        description: 'Barra de gênero: nome, contagem e porcentagem. Mostram-se os 5 maiores gêneros.',
        children: [
          Column(
            children: withGaps(
              [for (final g in sampleGenres) DsGenreBar(label: g.$1, count: g.$2, share: g.$2 / sampleGenreTotal)],
              11,
            ),
          ),
        ],
      ),
      SampleSection(
        title: 'MediaCover',
        description: 'Capa substituta: o ícone do tipo sobre a cor do tipo a 14%. Pequena 48 por 64 (lista), grande 96 por 128 (detalhe). O app não usa imagens de capa.',
        children: [
          Wrap(
            spacing: 20,
            runSpacing: 16,
            children: [
              for (final t in MediaType.values) StateLabel(label: '${t.label} · pequena', child: DsMediaCover(type: t)),
            ],
          ),
          Wrap(
            spacing: 20,
            runSpacing: 16,
            children: [
              for (final t in MediaType.values) StateLabel(label: '${t.label} · grande', child: DsMediaCover(type: t, large: true)),
            ],
          ),
        ],
      ),
      SampleSection(
        title: 'Avatar',
        description: 'Avatar circular com as iniciais do nome. 40 em listas e 96 no perfil.',
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StateLabel(label: '40', child: DsAvatar(name: 'Ana Ribeiro')),
              SizedBox(width: 24),
              StateLabel(label: '96', child: DsAvatar(name: 'Ana Ribeiro', size: 96)),
            ],
          ),
        ],
      ),
      const SampleSection(
        title: 'NoteCard',
        description: 'Bloco da observação no detalhe. Sem texto: "Sem observação" em itálico e cor secundária.',
        children: [
          StateLabel(label: 'Com texto', child: DsNoteCard(text: 'Um universo imenso e uma leitura que fica melhor a cada capítulo.')),
          StateLabel(label: 'Vazio', child: DsNoteCard()),
        ],
      ),
      const SampleSection(
        title: 'DetailRow',
        description: 'Linha de dado do detalhe: rótulo (42%) e valor à direita. O detalhe usa 5 linhas: Tipo, Gênero, Início, Fim e Páginas (ou Temporadas, ou Duração).',
        children: [
          Column(
            children: [
              DsDetailRow(label: 'Tipo', value: 'Livro'),
              DsDetailRow(label: 'Gênero', value: 'Ficção científica'),
              DsDetailRow(label: 'Início', value: '12/08/2026'),
              DsDetailRow(label: 'Fim', value: '06/09/2026'),
              DsDetailRow(label: 'Páginas', value: '680'),
              DsDetailRow(label: 'Observação', value: 'Sem observação', italic: true, showDivider: false),
            ],
          ),
        ],
      ),
    ];

Widget _interactiveSummary() {
  var year = 2026;
  return StatefulBuilder(
    builder: (context, setState) {
      final s = sampleSummaries[year]!;
      return DsSummaryCard(
        year: year,
        years: const [2026, 2025],
        onYearChanged: (y) => setState(() => year = y),
        booksFinished: s.books,
        pagesRead: s.pages,
        movies: s.movies,
        series: s.series,
        averageRating: s.average,
      );
    },
  );
}
