import 'package:flutter/material.dart';

/// Modo de tema do catálogo (claro, escuro ou do sistema).
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);
