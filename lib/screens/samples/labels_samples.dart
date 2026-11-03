import 'package:flutter/material.dart';
import '../../common/ds.dart';
import '../../common/widgets/sample_section.dart';
import '../../components/labels/ds_caption.dart';
import '../../components/labels/ds_field_label.dart';
import '../../components/labels/ds_field_message.dart';
import '../../components/labels/ds_section_header.dart';

List<Widget> buildLabelsSamples(BuildContext context) => [
      const SampleSection(
        title: 'SectionHeader',
        description: 'Título de seção em caixa alta (12/16, 600, espaçamento +6%) na cor secundária. Serve para "Por gênero", o mês, "Na fila", "Dados", "Nota" e "Observação".',
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DsSectionHeader('Por gênero'),
              DsSectionHeader('Setembro de 2026'),
              DsSectionHeader('Na fila'),
            ],
          ),
        ],
      ),
      SampleSection(
        title: 'FieldLabel',
        description: 'Rótulo que fica acima do campo (13/18, peso 500), a 6 de distância. Quando o campo é opcional, o texto termina com "(opcional)".',
        children: [
          StateLabel(label: ComponentState.defaultState.label, child: const DsFieldLabel('Nome')),
          StateLabel(label: ComponentState.disabled.label, child: const DsFieldLabel('Nome', disabled: true)),
          StateLabel(label: 'Opcional', child: const DsFieldLabel('Observação (opcional)')),
        ],
      ),
      const SampleSection(
        title: 'FieldMessage',
        description: 'Mensagem abaixo do campo (13/18): ajuda em cor secundária, erro em error e sucesso em done. Em erro, o campo também troca a borda para error.',
        children: [
          StateLabel(label: 'Ajuda', child: DsFieldMessage('Use o e-mail da sua conta.')),
          StateLabel(label: 'Erro', child: DsFieldMessage('Informe um e-mail válido.', kind: DsMessageKind.error)),
          StateLabel(label: 'Sucesso', child: DsFieldMessage('E-mail confirmado.', kind: DsMessageKind.success)),
        ],
      ),
      const SampleSection(
        title: 'Caption',
        description: 'Texto auxiliar em cor secundária: a legenda do item (12/17) e a data curta da lista (11/15).',
        children: [
          StateLabel(label: 'Legenda', child: DsCaption('Ficção científica · Frank Herbert')),
          StateLabel(label: 'Data', child: DsCaption('06 set', kind: DsCaptionKind.date)),
        ],
      ),
    ];
