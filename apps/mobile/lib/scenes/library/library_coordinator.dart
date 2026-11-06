import '../../navigation/app_navigation.dart';

/// Navigation out of the library scene. Item detail and new item are added as
/// those scenes exist.
abstract interface class LibraryCoordinator {
  /// The person signed out.
  void didLogout();
}

class DefaultLibraryCoordinator implements LibraryCoordinator {
  const DefaultLibraryCoordinator({required this._navigation});

  final AppNavigation _navigation;

  @override
  void didLogout() => _navigation.showLogin();
}
