import 'package:flutter/material.dart';
import 'package:bibliotela_design_system/bibliotela_design_system.dart';
import '../../common/widgets/sample_section.dart';
import 'feedback_demo_screen.dart';

void _openDemo(BuildContext context, DemoKind kind) {
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => FeedbackDemoScreen(kind: kind)));
}

Widget _demoButton(BuildContext context, String label, DemoKind kind) => DsActionButton(
      viewModel: ActionButtonViewModel(label: label, variant: ActionButtonVariant.secondary),
      onPressed: () => _openDemo(context, kind),
    );

List<Widget> buildFeedbackSamples(BuildContext context) => [
      SampleSection(
        title: 'Telas de exemplo',
        description: 'As mesmas peças compondo telas inteiras: barra superior, conteúdo e abas. A de carregamento mostra esqueletos e depois vira a lista; a de erro tem "Tentar novamente".',
        children: [
          _demoButton(context, 'Abrir tela carregando', DemoKind.loading),
          _demoButton(context, 'Abrir tela vazia', DemoKind.empty),
          _demoButton(context, 'Abrir tela com erro', DemoKind.error),
        ],
      ),
      const SampleSection(
        title: 'Spinner',
        description: 'Indicador circular de carregamento, em primary. 18 dentro de botões e 32 em telas inteiras.',
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StateLabel(label: '18', child: DsSpinner(size: 18)),
              SizedBox(width: 32),
              StateLabel(label: '32', child: DsSpinner(size: 32)),
            ],
          ),
        ],
      ),
      const SampleSection(
        title: 'Skeleton',
        description: 'Esqueletos no lugar do conteúdo enquanto carrega: blocos em track com um brilho suave. Um para a linha da lista e outro para o cartão de resumo.',
        children: [
          StateLabel(label: 'SkeletonItemTile', child: DsListCard(children: [DsSkeletonItemTile(showDivider: false)])),
          StateLabel(label: 'SkeletonSummaryCard', child: DsSkeletonSummaryCard()),
        ],
      ),
      SampleSection(
        title: 'StateView',
        description: 'Estados de tela inteira: carregando, vazio, vazio com filtro (ação "Limpar filtros") e erro (ação "Tentar novamente").',
        children: [
          const StateLabel(label: 'Carregando', child: SampleFrame(height: 220, child: DsStateView.loading())),
          const StateLabel(label: 'Vazio', child: SampleFrame(height: 240, child: DsStateView.empty())),
          StateLabel(label: 'Vazio com filtro', child: SampleFrame(height: 260, child: DsStateView.emptyFiltered(onAction: () {}))),
          StateLabel(label: 'Erro', child: SampleFrame(height: 280, child: DsStateView.error(onAction: () {}))),
        ],
      ),
      SampleSection(
        title: 'ConfirmDialog',
        description: 'Diálogo de confirmação para ações destrutivas. Cartão surface com raio lg e sombra dialog; Cancelar (texto) e Excluir (perigo). Aparece sobre um fundo escurecido.',
        children: [
          SampleFrame(
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: const DsConfirmDialogCard(
                title: 'Excluir item?',
                message: 'Essa ação não pode ser desfeita.',
                confirmLabel: 'Excluir',
                destructive: true,
              ),
            ),
          ),
          DsActionButton(
            viewModel: const ActionButtonViewModel(label: 'Abrir o diálogo de verdade', variant: ActionButtonVariant.secondary),
            onPressed: () async {
              final confirmed = await showDsConfirmDialog(
                context,
                title: 'Excluir item?',
                message: 'Essa ação não pode ser desfeita.',
                confirmLabel: 'Excluir',
                destructive: true,
              );
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(confirmed ? 'Item excluído (simulação).' : 'Exclusão cancelada.')),
              );
            },
          ),
        ],
      ),
      const SampleSection(
        title: 'InlineMessage',
        description: 'Mensagem em linha, abaixo do formulário ou do botão: erro (cor error) e sucesso (cor done).',
        children: [
          StateLabel(label: 'Erro', child: DsInlineMessage('E-mail ou senha incorretos.')),
          StateLabel(label: 'Sucesso', child: DsInlineMessage('Perfil atualizado.', kind: DsInlineKind.success)),
        ],
      ),
    ];
