import 'package:bibliotela/scenes/library/library_coordinator.dart';
import 'package:bibliotela/scenes/library/library_view.dart';
import 'package:bibliotela/scenes/library/library_view_model.dart';
import 'package:bibliotela/scenes/library/server_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_app.dart';

class _Coordinator implements LibraryCoordinator {
  int logouts = 0;

  @override
  void didLogout() => logouts++;
}

void main() {
  late _Coordinator coordinator;

  Future<void> open(WidgetTester tester) async {
    coordinator = _Coordinator();
    final viewModel = LibraryViewModel(
      server: DefaultServerLibrary(),
      coordinator: coordinator,
      initialYear: 2026,
    );
    await pumpScreen(tester, LibraryView(viewModel: viewModel));
    await tester.pumpAndSettle();
  }

  testWidgets('loads and shows the first month with its items', (tester) async {
    await open(tester);
    expect(find.text('Bibliotela'), findsOneWidget);
    expect(textIgnoringCase('Outubro de 2026'), findsOneWidget);
    expect(find.text('Titanic'), findsOneWidget);
    expect(find.text('Drácula'), findsOneWidget);
  });

  testWidgets('shows the subtitle of an item', (tester) async {
    await open(tester);
    expect(find.text('Terror · Bram Stoker'), findsOneWidget);
  });

  testWidgets('scrolling down reaches the "Na fila" group', (tester) async {
    await open(tester);
    await tester.dragUntilVisible(
      textIgnoringCase('Na fila'),
      find.byKey(const Key('library_list')),
      const Offset(0, -300),
    );
    expect(textIgnoringCase('Na fila'), findsOneWidget);
  });

  testWidgets('the logout button ends the session', (tester) async {
    await open(tester);
    await tester.tap(find.byKey(const Key('library_logout')));
    await tester.pumpAndSettle();
    expect(coordinator.logouts, 1);
  });
}
