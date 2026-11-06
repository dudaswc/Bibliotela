import 'package:bibliotela_core/bibliotela_core.dart';

/// Authentication backend used by the login scene.
abstract interface class ServerLogin {
  Future<Result<Session>> fetchLogin({
    required String email,
    required String password,
  });
}

/// Offline [ServerLogin] for development and previews: accepts the sample user
/// (`ana@bibliotela.dev` / `123456`) and nothing else.
class DefaultServerLogin implements ServerLogin {
  DefaultServerLogin({AuthRepository? auth})
    : _auth = auth ?? InMemoryAuthRepository();

  final AuthRepository _auth;

  @override
  Future<Result<Session>> fetchLogin({
    required String email,
    required String password,
  }) => _auth.login(email: email, password: password);
}

/// Real [ServerLogin], talking to the Bibliotela API through [AuthRepository].
class ServerLoginImpl implements ServerLogin {
  const ServerLoginImpl({required this._auth});

  final AuthRepository _auth;

  @override
  Future<Result<Session>> fetchLogin({
    required String email,
    required String password,
  }) => _auth.login(email: email, password: password);
}
