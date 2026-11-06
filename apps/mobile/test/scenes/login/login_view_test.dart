import 'package:bibliotela_core/bibliotela_core.dart';
import 'package:bibliotela/scenes/login/login_coordinator.dart';
import 'package:bibliotela/scenes/login/login_view.dart';
import 'package:bibliotela/scenes/login/login_view_model.dart';
import 'package:bibliotela/scenes/login/server_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_app.dart';

class _Coordinator implements LoginCoordinator {
  final logins = <Session>[];

  @override
  void didLogin(Session session) => logins.add(session);
}

void main() {
  late _Coordinator coordinator;

  Future<void> open(WidgetTester tester) async {
    coordinator = _Coordinator();
    final viewModel = LoginViewModel(serverLogin: DefaultServerLogin(), coordinator: coordinator);
    await pumpScreen(tester, LoginView(viewModel: viewModel));
  }

  Finder field(String key) => find.descendant(of: find.byKey(Key(key)), matching: find.byType(TextField));

  testWidgets('shows the brand and the form', (tester) async {
    await open(tester);
    expect(find.text('Bibliotela'), findsOneWidget);
    expect(find.text('Tudo que você leu e assistiu.'), findsOneWidget);
    expect(field('login_email'), findsOneWidget);
    expect(field('login_password'), findsOneWidget);
    expect(find.byKey(const Key('login_submit')), findsOneWidget);
  });

  testWidgets('an empty form shows the field errors', (tester) async {
    await open(tester);
    await tester.tap(find.byKey(const Key('login_submit')));
    await tester.pump();
    expect(find.text('Informe o e-mail.'), findsOneWidget);
    expect(find.text('Informe a senha.'), findsOneWidget);
    expect(coordinator.logins, isEmpty);
  });

  testWidgets('the sample user signs in', (tester) async {
    await open(tester);
    await tester.enterText(field('login_email'), 'ana@bibliotela.dev');
    await tester.enterText(field('login_password'), '123456');
    await tester.tap(find.byKey(const Key('login_submit')));
    await tester.pumpAndSettle();
    expect(coordinator.logins.length, 1);
    expect(coordinator.logins.single.user.email, 'ana@bibliotela.dev');
  });

  testWidgets('a wrong password shows the message', (tester) async {
    await open(tester);
    await tester.enterText(field('login_email'), 'ana@bibliotela.dev');
    await tester.enterText(field('login_password'), 'errada1');
    await tester.tap(find.byKey(const Key('login_submit')));
    await tester.pumpAndSettle();
    expect(find.text('E-mail ou senha incorretos.'), findsOneWidget);
    expect(coordinator.logins, isEmpty);
  });
}
