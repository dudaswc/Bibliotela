import 'package:flutter/widgets.dart';

abstract final class AppShadows {
  static const BoxShadow fab = BoxShadow(color: Color(0x520F6E8C), offset: Offset(0, 8), blurRadius: 22);
  static const BoxShadow appIcon = BoxShadow(color: Color(0x420F6E8C), offset: Offset(0, 8), blurRadius: 20);
  static const BoxShadow menu = BoxShadow(color: Color(0x1F000000), offset: Offset(0, 10), blurRadius: 30);
  static const BoxShadow dialog = BoxShadow(color: Color(0x54000000), offset: Offset(0, 20), blurRadius: 50);
}
