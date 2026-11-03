import 'package:flutter/material.dart';
import '../theme/theme_controller.dart';

/// Alterna entre tema claro e escuro.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      tooltip: dark ? 'Tema claro' : 'Tema escuro',
      icon: Icon(dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
      onPressed: () => themeModeNotifier.value = dark ? ThemeMode.light : ThemeMode.dark,
    );
  }
}
