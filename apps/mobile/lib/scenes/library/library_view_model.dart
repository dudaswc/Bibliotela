import 'dart:math';

import 'package:bibliotela_core/bibliotela_core.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

import 'library_coordinator.dart';
import 'server_library.dart';

enum LibraryStatus { loading, loaded, error }

/// A month of the list (or the "Na fila" group) with its items.
class LibraryGroup {
  const LibraryGroup({required this.title, required this.items});

  final String title;
  final List<Item> items;
}

/// State and actions of the library scene.
class LibraryViewModel extends ChangeNotifier {
  LibraryViewModel({
    required this._server,
    required this._coordinator,
    int? initialYear,
  }) : _year = initialYear ?? DateTime.now().year;

  final ServerLibrary _server;
  final LibraryCoordinator _coordinator;

  int _year;
  LibraryStatus _status = LibraryStatus.loading;
  String? _errorMessage;
  Summary? _summary;
  List<LibraryGroup> _groups = const [];
  bool _disposed = false;

  int get year => _year;

  /// The years the chip offers: the current one and the one before.
  List<int> get years {
    final top = max(DateTime.now().year, _year);
    return [top, top - 1];
  }

  LibraryStatus get status => _status;

  /// The reason of the last failure, in Portuguese.
  String? get errorMessage => _errorMessage;

  Summary? get summary => _summary;

  /// The items of [year] grouped by month of the reading date, newest first,
  /// with the ones the person only wants in the last group.
  List<LibraryGroup> get groups => _groups;

  bool get isEmpty => _groups.isEmpty;

  /// Loads the summary and the list of the selected year.
  Future<void> load() async {
    final requestedYear = _year;
    _status = LibraryStatus.loading;
    _errorMessage = null;
    _notify();

    final summaryFuture = _server.fetchSummary(requestedYear);
    final itemsFuture = _server.fetchItems(
      ItemFilter(year: requestedYear, pageSize: 100),
    );
    final summary = await summaryFuture;
    final items = await itemsFuture;

    // The person changed the year while this was loading: ignore the answer.
    if (requestedYear != _year) return;

    final error = summary.errorOrNull ?? items.errorOrNull;
    if (error != null) {
      _status = LibraryStatus.error;
      _errorMessage = error.message;
    } else {
      _summary = summary.valueOrNull;
      _groups = _group(items.valueOrNull?.items ?? const []);
      _status = LibraryStatus.loaded;
    }
    _notify();
  }

  Future<void> onYearChanged(int year) {
    if (year == _year) return Future.value();
    _year = year;
    return load();
  }

  Future<void> onLogoutTapped() async {
    await _server.logout();
    _coordinator.didLogout();
  }

  static List<LibraryGroup> _group(List<Item> items) {
    final byMonth = groupBy(items, (Item item) => item.readingDate?.monthKey);
    return [
      for (final entry in byMonth.entries)
        LibraryGroup(
          title: entry.key == null
              ? 'Na fila'
              : formatMonthHeading(entry.value.first.readingDate!),
          items: entry.value,
        ),
    ];
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
