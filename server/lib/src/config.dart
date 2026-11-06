/// Configuracao do servidor, lida das variaveis de ambiente.
class Config {
  const Config({
    this.port = 8080,
    this.latencyMinMs = 300,
    this.latencyMaxMs = 800,
    this.timeoutHoldMs = 60000,
    this.version = '0.1.0',
  });

  factory Config.fromEnv(Map<String, String> env) {
    int read(String key, int fallback) {
      final value = int.tryParse(env[key] ?? '');
      return value == null || value < 0 ? fallback : value;
    }

    final min = read('LATENCY_MIN_MS', 300);
    final max = read('LATENCY_MAX_MS', 800);
    return Config(
      port: read('PORT', 8080),
      latencyMinMs: min,
      latencyMaxMs: max < min ? min : max,
    );
  }

  /// Porta de escuta. Com 0, o sistema escolhe uma porta livre (usado nos testes).
  final int port;

  /// Latencia aleatoria por requisicao, em milissegundos.
  final int latencyMinMs;
  final int latencyMaxMs;

  /// Quanto tempo `X-Fail: timeout` segura a requisicao antes do 504 (60 s no uso real).
  final int timeoutHoldMs;

  final String version;
}
