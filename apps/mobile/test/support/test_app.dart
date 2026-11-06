import 'package:bibliotela_design_system/bibliotela_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The default font of `flutter test` draws every letter as a square of the
/// font size, much wider than a real font. Scaling the text down gives widths
/// close to a phone's, so the tests check the layout and not the test font.
const _realisticTextScale = 0.6;

/// Puts [child] on a phone-sized screen, in the light theme.
Future<void> pumpScreen(WidgetTester tester, Widget child) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(_realisticTextScale),
        ),
        child: child!,
      ),
      home: child,
    ),
  );
}

/// A [Text] whose content equals [text], ignoring case: the design system
/// writes section headings in capitals.
Finder textIgnoringCase(String text) => find.byWidgetPredicate(
  (widget) => widget is Text && (widget.data ?? '').toLowerCase() == text.toLowerCase(),
);
