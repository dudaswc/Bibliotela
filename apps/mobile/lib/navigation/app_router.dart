import 'package:flutter/material.dart';

import '../app_dependencies.dart';
import '../scenes/library/library_factory.dart';
import '../scenes/login/login_factory.dart';
import 'app_navigation.dart';

/// Builds the screens and moves between them.
class AppRouter implements AppNavigation {
  AppRouter(this.dependencies);

  final AppDependencies dependencies;
  final navigatorKey = GlobalKey<NavigatorState>();

  Widget login() => LoginFactory.make(dependencies, navigation: this);

  Widget library() => LibraryFactory.make(dependencies, navigation: this);

  @override
  void showLibrary() => navigatorKey.currentState?.pushAndRemoveUntil(
    MaterialPageRoute<void>(builder: (_) => library()),
    (_) => false,
  );

  @override
  void showLogin() => navigatorKey.currentState?.pushAndRemoveUntil(
    MaterialPageRoute<void>(builder: (_) => login()),
    (_) => false,
  );
}
