import 'package:flutter/material.dart';
import '../../common/ds.dart';

enum DsCaptionKind { legend, date }

/// Texto auxiliar: legenda do item (12/17) e data curta da lista (11/15).
class DsCaption extends StatelessWidget {
  const DsCaption(this.text, {super.key, this.kind = DsCaptionKind.legend, this.maxLines});

  final String text;
  final DsCaptionKind kind;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final style = kind == DsCaptionKind.legend ? AppTypography.labelMedium : AppTypography.chipRegular;
    return Text(
      text,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      style: style.copyWith(color: context.colors.onSurfaceMuted),
    );
  }
}
