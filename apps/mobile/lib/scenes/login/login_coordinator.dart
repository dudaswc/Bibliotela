import 'package:bibliotela_core/bibliotela_core.dart';

import '../../navigation/app_navigation.dart';

/// Navigation out of the login scene.
abstract interface class LoginCoordinator {
  /// The person signed in.
  void didLogin(Session session);
}

class DefaultLoginCoordinator implements LoginCoordinator {
  const DefaultLoginCoordinator({required this._navigation});

  final AppNavigation _navigation;

  @override
  void didLogin(Session session) => _navigation.showLibrary();
}
