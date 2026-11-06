import 'package:flutter/material.dart';
import '../../common/ds.dart';
import '../navigation/ds_year_chip.dart';
import '../selectors/ds_star_rating.dart';

/// Resumo do ano no topo da biblioteca: livros lidos, páginas, filmes, séries
/// e nota média, com o chip de ano. As estrelas mostram a média arredondada ÷ 2.
class DsSummaryCard extends StatelessWidget {
  const DsSummaryCard({
    super.key,
    required this.year,
    required this.years,
    required this.onYearChanged,
    required this.booksFinished,
    required this.pagesRead,
    required this.movies,
    required this.series,
    this.averageRating,
  });

  final int year;
  final List<int> years;
  final ValueChanged<int> onYearChanged;
  final int booksFinished;
  final int pagesRead;
  final int movies;
  final int series;

  /// Média de 0 a 10. Nulo quando não há nenhuma nota no ano.
  final double? averageRating;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final average = averageRating;
    final divider = BoxDecoration(border: Border(left: BorderSide(color: c.border)));
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll, side: BorderSide(color: c.border)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Resumo do ano', style: AppTypography.bodySmall.copyWith(color: c.onSurfaceMuted)),
                DsYearChip(year: year, years: years, onChanged: onYearChanged),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('$booksFinished', style: AppTypography.displayLarge.copyWith(color: c.onSurface)),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    booksFinished == 1 ? 'livro lido' : 'livros lidos',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.titleUnit.copyWith(color: c.onSurface),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text('${formatInt(pagesRead)} páginas lidas', style: AppTypography.bodyMediumStrong.copyWith(color: c.primary)),
            const SizedBox(height: 14),
            Container(height: 1, color: c.border),
            const SizedBox(height: AppSpacing.md),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 20, child: _Metric(value: '$movies', label: 'filmes')),
                  Expanded(
                    flex: 20,
                    child: Container(
                      decoration: divider,
                      padding: const EdgeInsets.only(left: AppSpacing.md),
                      child: _Metric(value: '$series', label: 'séries'),
                    ),
                  ),
                  Expanded(
                    flex: 27,
                    child: Container(
                      decoration: divider,
                      padding: const EdgeInsets.only(left: AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Nota média', style: AppTypography.labelMedium.copyWith(color: c.onSurfaceMuted)),
                          const SizedBox(height: 2),
                          if (average == null)
                            Text('—', style: AppTypography.metricValue.copyWith(color: c.onSurface))
                          else
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DsStarRating(rating: average.round()),
                                  const SizedBox(width: 5),
                                  Text(formatDecimal(average), style: AppTypography.metricValue.copyWith(color: c.onSurface)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: AppTypography.metricValue.copyWith(color: c.onSurface)),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.labelMedium.copyWith(color: c.onSurfaceMuted)),
      ],
    );
  }
}
