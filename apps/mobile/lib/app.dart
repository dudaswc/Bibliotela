import 'package:bibliotela_core/bibliotela_core.dart';
import 'package:bibliotela_design_system/bibliotela_design_system.dart';
import 'package:flutter/material.dart';

import 'app_dependencies.dart';
import 'navigation/app_router.dart';

class BibliotelaApp extends StatefulWidget {
  const BibliotelaApp({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  State<BibliotelaApp> createState() => _BibliotelaAppState();
}

class _BibliotelaAppState extends State<BibliotelaApp> {
  late final AppRouter _router = AppRouter(widget.dependencies);

  /// Restores the stored session once, to decide the first screen.
  late final Future<Result<Session?>> _restore = widget.dependencies.auth
      .restore();

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Bibliotela',
    debugShowCheckedModeBanner: false,
    navigatorKey: _router.navigatorKey,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    home: FutureBuilder<Result<Session?>>(
      future: _restore,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const _Splash();
        final session = snapshot.data!.valueOrNull;
        return session == null ? _router.login() : _router.library();
      },
    ),
  );
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: DsSpinner(size: 32)));
}
