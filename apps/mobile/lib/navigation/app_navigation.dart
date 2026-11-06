/// Where the coordinators can send the person. The scenes only know this
/// interface; [AppRouter] is the one that builds the screens.
abstract interface class AppNavigation {
  /// Signed in: goes to the library and forgets the login screen.
  void showLibrary();

  /// Signed out: goes to the login and forgets everything else.
  void showLogin();
}
