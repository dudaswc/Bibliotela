import 'package:flutter/material.dart';
import '../../common/ds.dart';
import '../action_button/action_button.dart';
import '../action_button/action_button_view_model.dart';
import 'ds_spinner.dart';

enum DsStateKind { loading, empty, emptyFiltered, error }

/// Estados de tela inteira: carregando, vazio, vazio com filtro e erro.
class DsStateView extends StatelessWidget {
  const DsStateView({super.key, required this.kind, this.onAction});

  const DsStateView.loading({super.key})
      : kind = DsStateKind.loading,
        onAction = null;

  const DsStateView.empty({super.key})
      : kind = DsStateKind.empty,
        onAction = null;

  const DsStateView.emptyFiltered({super.key, this.onAction}) : kind = DsStateKind.emptyFiltered;

  const DsStateView.error({super.key, this.onAction}) : kind = DsStateKind.error;

  final DsStateKind kind;
  final VoidCallback? onAction;

  IconData get _icon => switch (kind) {
        DsStateKind.loading => Icons.hourglass_empty_rounded,
        DsStateKind.empty => Icons.menu_book_outlined,
        DsStateKind.emptyFiltered => Icons.search_rounded,
        DsStateKind.error => Icons.error_outline_rounded,
      };

  String get _title => switch (kind) {
        DsStateKind.loading => 'Carregando sua biblioteca…',
        DsStateKind.empty => 'Sua biblioteca está vazia',
        DsStateKind.emptyFiltered => 'Nenhum item encontrado',
        DsStateKind.error => 'Não foi possível carregar sua biblioteca.',
      };

  String? get _description => switch (kind) {
        DsStateKind.loading => null,
        DsStateKind.empty => 'Toque em + para adicionar o primeiro item.',
        DsStateKind.emptyFiltered => 'Tente ajustar a busca ou os filtros.',
        DsStateKind.error => 'Verifique a conexão e tente de novo.',
      };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final description = _description;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (kind == DsStateKind.loading)
              const DsSpinner(size: 32)
            else
              Icon(_icon, size: 40, color: kind == DsStateKind.error ? c.error : c.onSurfaceMuted),
            const SizedBox(height: AppSpacing.md),
            Text(_title, textAlign: TextAlign.center, style: AppTypography.titleSmall.copyWith(color: c.onSurface)),
            if (description != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(description, textAlign: TextAlign.center, style: AppTypography.bodyMedium.copyWith(color: c.onSurfaceMuted)),
            ],
            if (kind == DsStateKind.emptyFiltered) ...[
              const SizedBox(height: AppSpacing.md),
              DsActionButton(
                viewModel: const ActionButtonViewModel(label: 'Limpar filtros', variant: ActionButtonVariant.text, size: ActionButtonSize.compact),
                onPressed: onAction,
              ),
            ],
            if (kind == DsStateKind.error) ...[
              const SizedBox(height: AppSpacing.md),
              DsActionButton(
                viewModel: const ActionButtonViewModel(label: 'Tentar novamente', variant: ActionButtonVariant.secondary, size: ActionButtonSize.compact),
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
