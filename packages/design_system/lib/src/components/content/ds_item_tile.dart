import 'package:flutter/material.dart';
import '../../common/ds.dart';
import '../labels/ds_caption.dart';
import '../selectors/ds_star_rating.dart';
import '../selectors/ds_status_chip.dart';
import 'ds_media_cover.dart';

/// Linha da lista da biblioteca. À direita: estrelas e data (concluído com
/// nota) ou chip de status (quero, em andamento, ou concluído sem nota).
class DsItemTile extends StatelessWidget {
  const DsItemTile({
    super.key,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.status,
    this.rating,
    this.dateLabel,
    this.onTap,
    this.state = ComponentState.defaultState,
    this.showDivider = true,
  });

  final MediaType type;
  final String title;
  final String subtitle;
  final MediaStatus status;
  final int? rating;
  final String? dateLabel;
  final VoidCallback? onTap;
  final ComponentState state;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final withRating = status == MediaStatus.done && rating != null;
    final trailing = withRating
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              DsStarRating(rating: rating),
              if (dateLabel != null) ...[
                const SizedBox(height: 5),
                DsCaption(dateLabel!, kind: DsCaptionKind.date),
              ],
            ],
          )
        : DsStatusChip(status: status, type: type);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 88),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 11),
          decoration: BoxDecoration(
            color: state == ComponentState.pressed ? c.overlayPressed : null,
            border: showDivider ? Border(bottom: BorderSide(color: c.border)) : null,
          ),
          child: Row(
            children: [
              DsMediaCover(type: type),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.titleSmall.copyWith(color: c.onSurface)),
                    const SizedBox(height: AppSpacing.xs),
                    DsCaption(subtitle, maxLines: 2),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
