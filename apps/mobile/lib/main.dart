import 'package:flutter/material.dart';

import 'app.dart';
import 'app_dependencies.dart';

void main() {
  runApp(BibliotelaApp(dependencies: AppDependencies.fromEnvironment()));
}
