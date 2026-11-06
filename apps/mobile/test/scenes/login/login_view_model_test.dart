import 'package:bibliotela_core/bibliotela_core.dart';
import 'package:bibliotela/scenes/login/login_coordinator.dart';
import 'package:bibliotela/scenes/login/login_view_model.dart';
import 'package:bibliotela/scenes/login/server_login.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeServer implements ServerLogin {
  _FakeServer(this.result);

  Result<Session> result;
  final calls = <(String, String)>[];

  @override
  Future<Result<Session>> fetchLogin({required String email, required String password}) async {
    calls.add((email, password));
    return result;
  }
}

class _FakeCoordinator implements LoginCoordinator {
  final logins = <Session>[];

  @override
  void didLogin(Session session) => logins.add(session);
}

void main() {
  final session = Session(token: 'tok_x', user: SampleData.user);
  late _FakeServer server;
  late _FakeCoordinator coordinator;
  late LoginViewModel viewModel;

  setUp(() {
    server = _FakeServer(Ok(session));
    coordinator = _FakeCoordinator();
    viewModel = LoginViewModel(serverLogin: server, coordinator: coordinator);
  });
  tearDown(() => viewModel.dispose());

  void fill({String email = 'ana@bibliotela.dev', String password = '123456'}) {
    viewModel.onEmailChanged(email);
    viewModel.onPasswordChanged(password);
  }

  test('starts empty and idle', () {
    expect((viewModel.email, viewModel.password, viewModel.isLoading), ('', '', false));
    expect((viewModel.emailError, viewModel.passwordError, viewModel.errorMessage), (null, null, null));
  });

  test('an empty form shows both field errors and does not call the server', () async {
    await viewModel.submit();
    expect(viewModel.emailError, isNotNull);
    expect(viewModel.passwordError, isNotNull);
    expect(server.calls, isEmpty);
  });

  test('an invalid e-mail is reported on the e-mail field only', () async {
    fill(email: 'ana@');
    await viewModel.submit();
    expect(viewModel.emailError, 'E-mail inválido.');
    expect(viewModel.passwordError, isNull);
    expect(server.calls, isEmpty);
  });

  test('typing clears the error of that field', () async {
    await viewModel.submit();
    viewModel.onEmailChanged('a');
    expect(viewModel.emailError, isNull);
    expect(viewModel.passwordError, isNotNull);
  });

  test('a valid form signs in and tells the coordinator', () async {
    fill();
    await viewModel.submit();
    expect(server.calls, [('ana@bibliotela.dev', '123456')]);
    expect(coordinator.logins, [session]);
    expect(viewModel.isLoading, isFalse);
    expect(viewModel.errorMessage, isNull);
  });

  test('wrong credentials show the message and do not navigate', () async {
    server.result = const Failure(UnauthorizedError(invalidCredentials: true));
    fill(password: 'errada1');
    await viewModel.submit();
    expect(viewModel.errorMessage, 'E-mail ou senha incorretos.');
    expect(coordinator.logins, isEmpty);
    expect(viewModel.isLoading, isFalse);
  });

  test('a network failure shows its message', () async {
    server.result = const Failure(NetworkError());
    fill();
    await viewModel.submit();
    expect(viewModel.errorMessage, const NetworkError().message);
  });

  test('is loading while the server answers, and a second tap is ignored', () async {
    fill();
    final first = viewModel.submit();
    expect(viewModel.isLoading, isTrue);
    await viewModel.submit();
    await first;
    expect(server.calls.length, 1);
    expect(viewModel.isLoading, isFalse);
  });

  test('editing after a failure clears the message', () async {
    server.result = const Failure(NetworkError());
    fill();
    await viewModel.submit();
    viewModel.onPasswordChanged('654321');
    expect(viewModel.errorMessage, isNull);
  });

  test('notifies its listeners when the state changes', () async {
    var notifications = 0;
    viewModel.addListener(() => notifications++);
    fill();
    await viewModel.submit();
    expect(notifications, greaterThanOrEqualTo(4));
  });
}
