import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bibliotela_design_system/bibliotela_design_system.dart';
import '../../common/models/sample_data.dart';

enum DemoKind { loading, empty, error }

enum _View { loading, loaded, empty, error }

/// Tela inteira de exemplo: barra superior, conteúdo e abas. Mostra o estado
/// de carregamento (esqueletos que viram a lista), o vazio e o erro (com
/// "Tentar novamente", que volta a carregar).
class FeedbackDemoScreen extends StatefulWidget {
  const FeedbackDemoScreen({super.key, required this.kind});

  final DemoKind kind;

  @override
  State<FeedbackDemoScreen> createState() => _FeedbackDemoScreenState();
}

class _FeedbackDemoScreenState extends State<FeedbackDemoScreen> {
  late _View _view;
  Timer? _timer;
  int _tab = 0;
  int _year = 2026;

  @override
  void initState() {
    super.initState();
    _view = switch (widget.kind) {
      DemoKind.loading => _View.loading,
      DemoKind.empty => _View.empty,
      DemoKind.error => _View.error,
    };
    if (_view == _View.loading) _scheduleLoaded();
  }

  void _scheduleLoaded() {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() => _view = _View.loaded);
    });
  }

  void _retry() {
    setState(() => _view = _View.loading);
    _scheduleLoaded();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _title => switch (widget.kind) {
        DemoKind.loading => 'Tela · carregando',
        DemoKind.empty => 'Tela · vazia',
        DemoKind.error => 'Tela · erro',
      };

  Widget _body() {
    switch (_view) {
      case _View.loading:
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const DsSkeletonSummaryCard(),
            const SizedBox(height: AppSpacing.lg),
            DsListCard(children: [
              for (var i = 0; i < 5; i++) DsSkeletonItemTile(showDivider: i < 4),
            ]),
          ],
        );
      case _View.loaded:
        final s = sampleSummaries[_year]!;
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            DsSummaryCard(
              year: _year,
              years: const [2026, 2025],
              onYearChanged: (y) => setState(() => _year = y),
              booksFinished: s.books,
              pagesRead: s.pages,
              movies: s.movies,
              series: s.series,
              averageRating: s.average,
            ),
            const SizedBox(height: AppSpacing.lg),
            const DsSectionHeader('Setembro de 2026'),
            DsListCard(children: [
              for (var k = 0; k < 6; k++)
                DsItemTile(
                  type: sampleItems[k].type,
                  title: sampleItems[k].title,
                  subtitle: sampleItems[k].subtitle,
                  status: sampleItems[k].status,
                  rating: sampleItems[k].rating,
                  dateLabel: sampleItems[k].dateLabel,
                  showDivider: k != 5,
                ),
            ]),
          ],
        );
      case _View.empty:
        return const DsStateView.empty();
      case _View.error:
        return DsStateView.error(onAction: _retry);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              DsTopBar(
                title: _title,
                onBack: () => Navigator.of(context).pop(),
                actions: const [DsIconButton(icon: Icons.light_mode_outlined, tooltip: 'Tema')],
              ),
              Expanded(child: _body()),
              DsBottomTabs(selectedIndex: _tab, onChanged: (i) => setState(() => _tab = i)),
            ],
          ),
        ),
      );
}
