import 'package:flutter/widgets.dart';

import '../../app_dependencies.dart';
import '../../navigation/app_navigation.dart';
import 'login_coordinator.dart';
import 'login_view.dart';
import 'login_view_model.dart';
import 'server_login.dart';

/// Assembles the login scene, injecting its dependencies into the ViewModel.
abstract final class LoginFactory {
  static Widget make(
    AppDependencies dependencies, {
    required AppNavigation navigation,
  }) {
    final viewModel = LoginViewModel(
      serverLogin: ServerLoginImpl(auth: dependencies.auth),
      coordinator: DefaultLoginCoordinator(navigation: navigation),
    );
    return LoginView(viewModel: viewModel);
  }
}

/*
   server      = ServerLoginImpl(auth)
   coordinator = DefaultLoginCoordinator(navigation)
   viewModel   = LoginViewModel(server, coordinator) // dependency injection
   view        = LoginView(viewModel)                // dependency injection
   LoginFactory.make() -> View (screen ready to use, visual and logic)
 */
