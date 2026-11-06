import 'package:bibliotela_core/bibliotela_core.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

import 'login_coordinator.dart';
import 'server_login.dart';

/// State and actions of the login scene.
class LoginViewModel extends ChangeNotifier {
  LoginViewModel({
    required this._serverLogin,
    required this._coordinator,
  });

  final ServerLogin _serverLogin;
  final LoginCoordinator _coordinator;

  String _email = '';
  String _password = '';
  bool _isLoading = false;
  bool _disposed = false;
  String? _emailError;
  String? _passwordError;
  String? _errorMessage;

  String get email => _email;
  String get password => _password;

  /// True while the server is answering.
  bool get isLoading => _isLoading;

  /// Message under the e-mail field, when it is invalid.
  String? get emailError => _emailError;

  /// Message under the password field, when it is invalid.
  String? get passwordError => _passwordError;

  /// A failure that is not about one field (wrong credentials, no network).
  String? get errorMessage => _errorMessage;

  void onEmailChanged(String value) {
    _email = value;
    _emailError = null;
    _errorMessage = null;
    _notify();
  }

  void onPasswordChanged(String value) {
    _password = value;
    _passwordError = null;
    _errorMessage = null;
    _notify();
  }

  /// Validates the form and, if it is valid, signs in. A second tap while the
  /// first is still running is ignored.
  Future<void> submit() async {
    if (_isLoading) return;

    _emailError = validateEmail(_email);
    _passwordError = validatePassword(_password);
    _errorMessage = null;
    if (_emailError != null || _passwordError != null) {
      _notify();
      return;
    }

    _isLoading = true;
    _notify();

    final result = await _serverLogin.fetchLogin(
      email: _email,
      password: _password,
    );

    _isLoading = false;
    switch (result) {
      case Ok(:final value):
        _coordinator.didLogin(value);
      case Failure(:final error):
        _errorMessage = error.message;
    }
    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
