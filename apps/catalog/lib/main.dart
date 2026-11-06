import 'dart:async';
import 'package:flutter/material.dart';
import 'app.dart';

/// Se algo der errado ao abrir, o erro aparece na tela (em vez de ficar tudo
/// preto), para podermos ver o que aconteceu.
void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      ErrorWidget.builder = (FlutterErrorDetails details) => _ErrorBox(details.exceptionAsString());
      runApp(const BibliotelaCatalogApp());
    },
    (Object error, StackTrace stack) => runApp(_ErrorApp('$error\n\n$stack')),
  );
}

/// Caixa vermelha que substitui um widget que falhou ao ser construído.
class _ErrorBox extends StatelessWidget {
  const _ErrorBox(this.message);

  final String message;

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.ltr,
        child: ColoredBox(
          color: const Color(0xFF7A1F1F),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Text(
                message,
                style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 13, decoration: TextDecoration.none),
              ),
            ),
          ),
        ),
      );
}

/// Tela inteira de erro, usada quando a falha acontece fora da construção de widgets.
class _ErrorApp extends StatelessWidget {
  const _ErrorApp(this.message);

  final String message;

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFF7A1F1F),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Erro ao iniciar o catálogo:\n\n$message',
                style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 13),
              ),
            ),
          ),
        ),
      );
}
