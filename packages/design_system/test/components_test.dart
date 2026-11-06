import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bibliotela_design_system/bibliotela_design_system.dart';

Widget host(Widget child, {ThemeData? theme}) => MaterialApp(
      theme: theme ?? AppTheme.light,
      home: Scaffold(body: Center(child: SingleChildScrollView(child: child))),
    );

void main() {
  group('DsActionButton', () {
    testWidgets('chama onPressed ao tocar', (tester) async {
      var taps = 0;
      await tester.pumpWidget(host(DsActionButton(viewModel: const ActionButtonViewModel(label: 'Entrar'), onPressed: () => taps++)));
      await tester.tap(find.text('Entrar'));
      expect(taps, 1);
    });

    testWidgets('desabilitado e carregando não respondem ao toque', (tester) async {
      var taps = 0;
      await tester.pumpWidget(host(Column(children: [
        DsActionButton(viewModel: const ActionButtonViewModel(label: 'A', state: ComponentState.disabled), onPressed: () => taps++),
        DsActionButton(viewModel: const ActionButtonViewModel(label: 'B', state: ComponentState.loading), onPressed: () => taps++),
      ])));
      await tester.tap(find.text('A'));
      await tester.tap(find.text('B'));
      expect(taps, 0);
    });

    testWidgets('carregando mostra o spinner', (tester) async {
      await tester.pumpWidget(host(const DsActionButton(viewModel: ActionButtonViewModel(label: 'Salvar', state: ComponentState.loading))));
      expect(find.byType(DsSpinner), findsOneWidget);
    });
  });

  group('StarRating', () {
    List<double> fills(WidgetTester tester) => tester.widgetList<DsStarGlyph>(find.byType(DsStarGlyph)).map((g) => g.fill).toList();

    testWidgets('nota 9 mostra 4 estrelas e meia', (tester) async {
      await tester.pumpWidget(host(const DsStarRating(rating: 9)));
      expect(fills(tester), [1, 1, 1, 1, 0.5]);
    });

    testWidgets('nota 8 mostra 4 estrelas', (tester) async {
      await tester.pumpWidget(host(const DsStarRating(rating: 8)));
      expect(fills(tester), [1, 1, 1, 1, 0]);
    });

    testWidgets('sem nota mostra todas vazias', (tester) async {
      await tester.pumpWidget(host(const DsStarRating(rating: null)));
      expect(fills(tester), [0, 0, 0, 0, 0]);
    });

    testWidgets('entrada: metade esquerda dá meia estrela, direita dá inteira', (tester) async {
      int? value;
      await tester.pumpWidget(host(DsStarRatingInput(value: value, onChanged: (v) => value = v)));
      final star = tester.getTopLeft(find.byType(DsStarGlyph).at(2)); // terceira estrela
      final y = star.dy + 14;

      await tester.tapAt(Offset(star.dx - 4 + 5, y)); // metade esquerda do alvo de 36
      expect(value, 5);

      await tester.tapAt(Offset(star.dx - 4 + 30, y)); // metade direita
      expect(value, 6);
    });
  });

  group('DsSegmentedControl', () {
    testWidgets('tocar numa opção chama onChanged', (tester) async {
      String? chosen;
      await tester.pumpWidget(host(DsSegmentedControl<String>(
        options: const [DsSegment(value: 'all', label: 'Todos'), DsSegment(value: 'want', label: 'Quero')],
        value: 'all',
        onChanged: (v) => chosen = v,
      )));
      await tester.tap(find.text('Quero'));
      expect(chosen, 'want');
    });

    testWidgets('desabilitado não responde', (tester) async {
      String? chosen;
      await tester.pumpWidget(host(DsSegmentedControl<String>(
        options: const [DsSegment(value: 'all', label: 'Todos'), DsSegment(value: 'want', label: 'Quero')],
        value: 'all',
        enabled: false,
        onChanged: (v) => chosen = v,
      )));
      await tester.tap(find.text('Quero'));
      expect(chosen, isNull);
    });
  });

  group('DsItemTile', () {
    testWidgets('concluído com nota mostra estrelas e data', (tester) async {
      await tester.pumpWidget(host(const DsItemTile(
        type: MediaType.book,
        title: 'Duna',
        subtitle: 'Ficção científica · Frank Herbert',
        status: MediaStatus.done,
        rating: 9,
        dateLabel: '06 set',
      )));
      expect(find.byType(DsStarRating), findsOneWidget);
      expect(find.byType(DsStatusChip), findsNothing);
      expect(find.text('06 set'), findsOneWidget);
    });

    testWidgets('em andamento e concluído sem nota mostram o chip de status', (tester) async {
      await tester.pumpWidget(host(const Column(children: [
        DsItemTile(type: MediaType.book, title: 'O Hobbit', subtitle: 'Fantasia', status: MediaStatus.inProgress),
        DsItemTile(type: MediaType.movie, title: 'Ainda Estou Aqui', subtitle: 'Drama', status: MediaStatus.done),
      ])));
      expect(find.byType(DsStarRating), findsNothing);
      expect(find.text('Lendo'), findsOneWidget);
      expect(find.text('Assistido'), findsOneWidget);
    });
  });

  group('DsSummaryCard', () {
    DsSummaryCard card({int books = 12, double? average = 7.8}) => DsSummaryCard(
          year: 2026,
          years: const [2026, 2025],
          onYearChanged: (_) {},
          booksFinished: books,
          pagesRead: 3480,
          movies: 30,
          series: 5,
          averageRating: average,
        );

    testWidgets('mostra os números no formato brasileiro', (tester) async {
      await tester.pumpWidget(host(card()));
      expect(find.text('12'), findsOneWidget);
      expect(find.text('livros lidos'), findsOneWidget);
      expect(find.text('3.480 páginas lidas'), findsOneWidget);
      expect(find.text('7,8'), findsOneWidget);
    });

    testWidgets('um livro usa o singular e sem nota a média é traço', (tester) async {
      await tester.pumpWidget(host(card(books: 1, average: null)));
      expect(find.text('livro lido'), findsOneWidget);
      expect(find.text('—'), findsOneWidget);
    });
  });

  group('outros', () {
    testWidgets('DsAvatar tira as iniciais do nome', (tester) async {
      await tester.pumpWidget(host(const Column(children: [DsAvatar(name: 'Ana Ribeiro'), DsAvatar(name: 'madonna')])));
      expect(find.text('AR'), findsOneWidget);
      expect(find.text('MA'), findsOneWidget);
    });

    testWidgets('DsGenreBar mostra contagem e porcentagem', (tester) async {
      await tester.pumpWidget(host(const DsGenreBar(label: 'Drama', count: 14, share: 14 / 41)));
      expect(find.text('Drama'), findsOneWidget);
      expect(find.text('14 · 34%'), findsOneWidget);
    });

    testWidgets('o tema escuro também carrega a paleta', (tester) async {
      late AppColorPalette palette;
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.dark,
        home: Builder(builder: (context) {
          palette = context.colors;
          return const SizedBox();
        }),
      ));
      expect(palette.background, AppColors.dark.background);
    });
  });
}
