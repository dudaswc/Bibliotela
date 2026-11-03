import 'package:flutter/material.dart';
import '../../common/ds.dart';

enum DsInlineKind { error, success }

/// Mensagem em linha, abaixo do formulário ou do botão.
class DsInlineMessage extends StatelessWidget {
  const DsInlineMessage(this.text, {super.key, this.kind = DsInlineKind.error});

  final String text;
  final DsInlineKind kind;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isError = kind == DsInlineKind.error;
    return Text(
      text,
      style: (isError ? AppTypography.bodySmall : AppTypography.bodySmallStrong).copyWith(color: isError ? c.error : c.done),
    );
  }
}
