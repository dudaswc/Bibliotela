import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bibliotela_ds_catalog/app.dart';

void main() {
  testWidgets('mostra todas as categorias do Design System', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BibliotelaCatalogApp());

    expect(find.text('Catálogo de componentes'), findsOneWidget);
    for (final title in const [
      'Ações',
      'Navegação',
      'Campos e filtros',
      'Seletores e controles',
      'Cards e conteúdo',
      'Feedback e carregamento',
      'Rótulos e texto',
      'Tokens',
    ]) {
      expect(find.text(title), findsOneWidget, reason: 'categoria "$title" deveria aparecer');
    }
  });

  testWidgets('abrir uma categoria mostra as amostras dos componentes', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BibliotelaCatalogApp());
    await tester.tap(find.text('Ações'));
    // Não usamos pumpAndSettle: a página tem spinners girando sem parar.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Button · Primário'), findsOneWidget);
    expect(find.text('Pressionado'), findsWidgets);
  });
}
