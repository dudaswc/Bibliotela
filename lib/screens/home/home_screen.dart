import 'package:flutter/material.dart';
import '../../common/ds.dart';
import '../../common/widgets/theme_toggle_button.dart';
import '../samples/category_screen.dart';
import 'category_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bibliotela DS', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: const [ThemeToggleButton()],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Catálogo de componentes', style: AppTypography.headlineMedium.copyWith(color: c.onSurface)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Explore os componentes, variações e estados do Design System da Bibliotela, o app de livros, séries e filmes.',
              style: AppTypography.bodyMedium.copyWith(color: c.onSurfaceMuted),
            ),
            const SizedBox(height: AppSpacing.xl),
            for (final category in catalogCategories) ...[
              _CategoryCard(category: category),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});

  final CategoryData category;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: c.border)),
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => CategoryScreen(category: category))),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(color: c.primaryContainer, borderRadius: BorderRadius.circular(16)),
                child: Icon(category.icon, color: c.primary),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: c.onSurface)),
                    const SizedBox(height: 3),
                    Text(category.subtitle, style: TextStyle(color: c.onSurfaceMuted)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: c.onSurfaceMuted),
            ],
          ),
        ),
      ),
    );
  }
}
