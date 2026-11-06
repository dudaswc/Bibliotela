import 'dart:io';

import 'package:bibliotela_server/bibliotela_server.dart';

/// Sobe o servidor mock da Bibliotela.
///
/// Variaveis de ambiente (todas opcionais):
///   PORT            porta (padrao 8080)
///   LATENCY_MIN_MS  latencia minima por requisicao (padrao 300)
///   LATENCY_MAX_MS  latencia maxima por requisicao (padrao 800)
Future<void> main() async {
  final config = Config.fromEnv(Platform.environment);
  final server = await BibliotelaServer(config).start();
  stdout.writeln('Listening        on   http://localhost:${server.port}');
}
