import 'package:flutter/material.dart';
import '../../common/ds.dart';
import '../action_button/action_button.dart';
import '../action_button/action_button_view_model.dart';

/// Cartão do diálogo de confirmação: surface, raio lg, sombra `dialog`.
class DsConfirmDialogCard extends StatelessWidget {
  const DsConfirmDialogCard({
    super.key,
    required this.title,
    required this.message,
    this.cancelLabel = 'Cancelar',
    this.confirmLabel = 'Confirmar',
    this.destructive = false,
    this.onCancel,
    this.onConfirm,
  });

  final String title;
  final String message;
  final String cancelLabel;
  final String confirmLabel;
  final bool destructive;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(color: c.surface, borderRadius: AppRadius.lgAll, boxShadow: const [AppShadows.dialog]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.titleUnit.copyWith(color: c.onSurface)),
          const SizedBox(height: AppSpacing.sm),
          Text(message, style: AppTypography.bodyMedium.copyWith(color: c.onSurfaceMuted)),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DsActionButton(
                viewModel: ActionButtonViewModel(label: cancelLabel, variant: ActionButtonVariant.text, size: ActionButtonSize.compact),
                onPressed: onCancel,
              ),
              const SizedBox(width: 6),
              DsActionButton(
                viewModel: ActionButtonViewModel(
                  label: confirmLabel,
                  variant: destructive ? ActionButtonVariant.danger : ActionButtonVariant.primary,
                  size: ActionButtonSize.compact,
                ),
                onPressed: onConfirm,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Abre o diálogo de confirmação. Devolve `true` se a pessoa confirmou.
Future<bool> showDsConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String cancelLabel = 'Cancelar',
  String confirmLabel = 'Confirmar',
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black54,
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: DsConfirmDialogCard(
        title: title,
        message: message,
        cancelLabel: cancelLabel,
        confirmLabel: confirmLabel,
        destructive: destructive,
        onCancel: () => Navigator.of(dialogContext).pop(false),
        onConfirm: () => Navigator.of(dialogContext).pop(true),
      ),
    ),
  );
  return result ?? false;
}
