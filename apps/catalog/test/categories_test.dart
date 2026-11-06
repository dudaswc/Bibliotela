import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bibliotela_design_system/bibliotela_design_system.dart';
import 'package:bibliotela_ds_catalog/screens/home/category_data.dart';
import 'package:bibliotela_ds_catalog/screens/samples/category_screen.dart';

/// A fonte padrão do `flutter test` é uma fonte de teste em que cada letra é um
/// quadrado do tamanho do texto, bem mais larga que as fontes reais. Por isso o
/// teste reduz o texto para ficar com larguras parecidas com as de um celular.
const double _larguraRealistaDoTexto = 0.6;

/// Renderiza cada categoria inteira, nos dois temas, numa tela de celular bem
/// alta (para a lista construir todas as seções), e falha se algo estourar o
/// layout ou lançar exceção.
void main() {
  for (final dark in [false, true]) {
    for (final category in catalogCategories) {
      testWidgets('${category.title} renderiza sem erros no tema ${dark ? 'escuro' : 'claro'}', (tester) async {
        tester.view.physicalSize = const Size(390, 14000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(MaterialApp(
          theme: dark ? AppTheme.dark : AppTheme.light,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(_larguraRealistaDoTexto)),
            child: child!,
          ),
          home: CategoryScreen(category: category),
        ));
        await tester.pump();

        expect(tester.takeException(), isNull);
        expect(find.text(category.title), findsWidgets);
      });
    }
  }
}
