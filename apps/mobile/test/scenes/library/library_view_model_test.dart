import 'package:bibliotela_core/bibliotela_core.dart';
import 'package:bibliotela/scenes/library/library_coordinator.dart';
import 'package:bibliotela/scenes/library/library_view_model.dart';
import 'package:bibliotela/scenes/library/server_library.dart';
import 'package:flutter_test/flutter_test.dart';

class _Coordinator implements LibraryCoordinator {
  int logouts = 0;

  @override
  void didLogout() => logouts++;
}

/// Wraps the offline server and can be told to fail.
class _Server implements ServerLibrary {
  final _inner = DefaultServerLibrary();
  AppError? failure;
  int logouts = 0;

  @override
  Future<Result<Summary>> fetchSummary(int year) async =>
      failure != null ? Failure(failure!) : _inner.fetchSummary(year);

  @override
  Future<Result<Page<Item>>> fetchItems(ItemFilter filter) async =>
      failure != null ? Failure(failure!) : _inner.fetchItems(filter);

  @override
  Future<void> logout() async => logouts++;
}

void main() {
  late _Server server;
  late _Coordinator coordinator;
  late LibraryViewModel viewModel;

  setUp(() {
    server = _Server();
    coordinator = _Coordinator();
    viewModel = LibraryViewModel(server: server, coordinator: coordinator, initialYear: 2026);
  });
  tearDown(() => viewModel.dispose());

  int countItems() => viewModel.groups.fold(0, (sum, group) => sum + group.items.length);

  test('starts loading', () {
    expect(viewModel.status, LibraryStatus.loading);
    expect(viewModel.summary, isNull);
  });

  test('load reads the summary and the list of the year', () async {
    await viewModel.load();
    expect(viewModel.status, LibraryStatus.loaded);
    expect(viewModel.summary?.books, const BooksSummary(finished: 9, pages: 3024));
    expect(viewModel.summary?.averageRating, 8.5);
    expect(countItems(), 31); // 25 of 2026 + the 6 wanted ones
  });

  test('groups by month, newest first, with "Na fila" at the end', () async {
    await viewModel.load();
    final titles = viewModel.groups.map((g) => g.title).toList();
    expect(titles.first, 'Outubro de 2026');
    expect(titles.last, 'Na fila');
    expect(titles, contains('Setembro de 2026'));
    expect(viewModel.groups.last.items.length, 6);
    expect(viewModel.groups.first.items.first.title, 'Titanic');
  });

  test('changing the year reloads both the summary and the list', () async {
    await viewModel.load();
    await viewModel.onYearChanged(2025);
    expect(viewModel.year, 2025);
    expect(viewModel.summary?.books.finished, 6);
    expect(viewModel.groups.first.title, 'Dezembro de 2025');
    expect(countItems(), 20); // 14 of 2025 + the 6 wanted ones
  });

  test('choosing the same year does not reload', () async {
    await viewModel.load();
    var notifications = 0;
    viewModel.addListener(() => notifications++);
    await viewModel.onYearChanged(2026);
    expect(notifications, 0);
  });

  test('a failure becomes the error state with the message', () async {
    server.failure = const NetworkError();
    await viewModel.load();
    expect(viewModel.status, LibraryStatus.error);
    expect(viewModel.errorMessage, const NetworkError().message);
  });

  test('loading again after a failure recovers', () async {
    server.failure = const NetworkError();
    await viewModel.load();
    server.failure = null;
    await viewModel.load();
    expect(viewModel.status, LibraryStatus.loaded);
    expect(viewModel.errorMessage, isNull);
  });

  test('a year with nothing but the wanted items still lists them', () async {
    await viewModel.onYearChanged(1999);
    expect(viewModel.status, LibraryStatus.loaded);
    expect(viewModel.summary?.books.finished, 0);
    expect(viewModel.groups.single.title, 'Na fila');
  });

  test('the year chip offers the current year and the one before', () {
    expect(viewModel.years.length, 2);
    expect(viewModel.years.first - viewModel.years.last, 1);
    expect(viewModel.years.first, greaterThanOrEqualTo(2026));
  });

  test('logout ends the session and tells the coordinator', () async {
    await viewModel.onLogoutTapped();
    expect(server.logouts, 1);
    expect(coordinator.logouts, 1);
  });
}
