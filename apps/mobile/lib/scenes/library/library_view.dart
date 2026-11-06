import 'package:bibliotela_design_system/bibliotela_design_system.dart';
import 'package:flutter/material.dart';

import 'library_presenter.dart';
import 'library_view_model.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({required this.viewModel, super.key});

  final LibraryViewModel viewModel;

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.load();
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            DsTopBar(
              title: 'Bibliotela',
              actions: [
                DsIconButton(
                  key: const Key('library_logout'),
                  icon: Icons.logout_rounded,
                  tooltip: 'Sair da conta',
                  onPressed: viewModel.onLogoutTapped,
                ),
              ],
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: viewModel,
                builder: (context, _) => switch (viewModel.status) {
                  LibraryStatus.loading => const _Loading(),
                  LibraryStatus.error => DsStateView.error(
                    onAction: viewModel.load,
                  ),
                  LibraryStatus.loaded => _Loaded(viewModel: viewModel),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(AppSpacing.lg),
    children: [
      const DsSkeletonSummaryCard(),
      const Gap.lg(),
      DsListCard(
        children: [
          for (var i = 0; i < 5; i++) DsSkeletonItemTile(showDivider: i < 4),
        ],
      ),
    ],
  );
}

class _Loaded extends StatelessWidget {
  const _Loaded({required this.viewModel});

  final LibraryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final summary = viewModel.summary;
    return RefreshIndicator(
      onRefresh: viewModel.load,
      child: ListView(
        key: const Key('library_list'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          if (summary != null)
            DsSummaryCard(
              year: viewModel.year,
              years: viewModel.years,
              onYearChanged: viewModel.onYearChanged,
              booksFinished: summary.books.finished,
              pagesRead: summary.books.pages,
              movies: summary.movies.finished,
              series: summary.series.finished,
              averageRating: summary.averageRating,
            ),
          const Gap.lg(),
          if (viewModel.isEmpty)
            const SizedBox(height: 320, child: DsStateView.empty())
          else
            for (final group in viewModel.groups) ...[
              DsSectionHeader(group.title),
              DsListCard(
                children: [
                  for (var i = 0; i < group.items.length; i++)
                    DsItemTile(
                      type: mediaTypeOf(group.items[i].type),
                      title: group.items[i].title,
                      subtitle: subtitleOf(group.items[i]),
                      status: mediaStatusOf(group.items[i].status),
                      rating: group.items[i].rating,
                      dateLabel: dateLabelOf(group.items[i]),
                      showDivider: i != group.items.length - 1,
                    ),
                ],
              ),
              const Gap.lg(),
            ],
        ],
      ),
    );
  }
}
