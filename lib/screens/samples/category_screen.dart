import 'package:flutter/material.dart';
import '../../common/ds.dart';
import '../../common/widgets/sample_section.dart';
import '../../common/widgets/theme_toggle_button.dart';
import '../home/category_data.dart';
import 'actions_samples.dart';
import 'content_samples.dart';
import 'feedback_samples.dart';
import 'inputs_samples.dart';
import 'labels_samples.dart';
import 'navigation_samples.dart';
import 'selectors_samples.dart';
import 'tokens_samples.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, required this.category});

  final CategoryData category;

  List<Widget> _sections(BuildContext context) => switch (category.id) {
        CatalogCategory.actions => buildActionsSamples(context),
        CatalogCategory.navigation => buildNavigationSamples(context),
        CatalogCategory.inputs => buildInputsSamples(context),
        CatalogCategory.selectors => buildSelectorsSamples(context),
        CatalogCategory.content => buildContentSamples(context),
        CatalogCategory.feedback => buildFeedbackSamples(context),
        CatalogCategory.labels => buildLabelsSamples(context),
        CatalogCategory.tokens => buildTokensSamples(context),
      };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      appBar: AppBar(title: Text(category.title), actions: const [ThemeToggleButton()]),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl - 4),
          children: [
            Text(category.subtitle, style: AppTypography.bodyMedium.copyWith(color: c.onSurfaceMuted)),
            const SizedBox(height: AppSpacing.lg),
            ...withGaps(_sections(context)),
          ],
        ),
      ),
    );
  }
}
