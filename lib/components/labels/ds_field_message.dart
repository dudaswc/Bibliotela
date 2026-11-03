import 'package:flutter/material.dart';
import '../../common/ds.dart';

enum DsMessageKind { help, error, success }

/// Mensagem abaixo do campo: ajuda, erro ou sucesso.
class DsFieldMessage extends StatelessWidget {
  const DsFieldMessage(this.text, {super.key, this.kind = DsMessageKind.help});

  const DsFieldMessage.error(this.text, {super.key}) : kind = DsMessageKind.error;

  final String text;
  final DsMessageKind kind;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = switch (kind) {
      DsMessageKind.help => c.onSurfaceMuted,
      DsMessageKind.error => c.error,
      DsMessageKind.success => c.done,
    };
    return Text(text, style: AppTypography.bodySmall.copyWith(color: color));
  }
}
