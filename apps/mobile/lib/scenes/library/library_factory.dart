import 'package:flutter/widgets.dart';

import '../../app_dependencies.dart';
import '../../navigation/app_navigation.dart';
import 'library_coordinator.dart';
import 'library_view.dart';
import 'library_view_model.dart';
import 'server_library.dart';

/// Assembles the library scene, injecting its dependencies into the ViewModel.
abstract final class LibraryFactory {
  static Widget make(
    AppDependencies dependencies, {
    required AppNavigation navigation,
  }) {
    final viewModel = LibraryViewModel(
      server: ServerLibraryImpl(
        items: dependencies.items,
        auth: dependencies.auth,
      ),
      coordinator: DefaultLibraryCoordinator(navigation: navigation),
    );
    return LibraryView(viewModel: viewModel);
  }
}
