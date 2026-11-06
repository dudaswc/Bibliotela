import 'package:flutter/material.dart';
import 'package:bibliotela_design_system/bibliotela_design_system.dart';
import 'common/theme/theme_controller.dart';
import 'screens/home/home_screen.dart';

class BibliotelaCatalogApp extends StatelessWidget {
  const BibliotelaCatalogApp({super.key});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<ThemeMode>(
        valueListenable: themeModeNotifier,
        builder: (context, mode, _) => MaterialApp(
          title: 'Bibliotela DS',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,
          home: const HomeScreen(),
        ),
      );
}
