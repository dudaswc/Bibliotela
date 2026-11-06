import 'dart:async';

import '../../models/item.dart';
import '../../models/item_filter.dart';
import '../../models/item_status.dart';
import '../../models/item_type.dart';
import '../../models/page.dart';
import '../../models/summary.dart';
import '../../result/app_error.dart';
import '../../result/result.dart';
import '../item_repository.dart';
import 'sample_data.dart';

/// Stores items in a list. Behaves like the server: same filters, same order,
/// same validation, same errors.
class InMemoryItemRepository implements ItemRepository {
  InMemoryItemRepository({List<Item>? items, this.delay = Duration.zero})
    : _items = [...items ?? SampleData.items()] {
    _nextNumber = _firstFreeNumber(_items);
  }

  final List<Item> _items;
  final Duration delay;
  final _changes = StreamController<List<Item>>.broadcast();
  int _nextNumber = 1;

  /// Current items in the list order. Handy for tests.
  List<Item> get items => _sorted(_items);

  @override
  Future<Result<Page<Item>>> list(ItemFilter filter) async {
    await Future<void>.delayed(delay);
    final fields = <String, String>{
      if (filter.page < 1)
        'page': 'must be an integer greater than or equal to 1',
      if (filter.pageSize < 1 || filter.pageSize > 100)
        'pageSize': 'must be an integer from 1 to 100',
    };
    if (fields.isNotEmpty) return Failure(ValidationError(fields));

    final query = filter.query?.trim().toLowerCase();
    final filtered = _sorted(_items).where((item) {
      if (filter.status != null && item.status != filter.status) return false;
      if (filter.type != null && item.type != filter.type) return false;
      if (filter.genre != null && item.genre != filter.genre) return false;
      // Items the person only wants have no reading date: every year has them.
      final year = filter.year;
      if (year != null &&
          item.status != ItemStatus.want &&
          item.readingDate?.year != year) {
        return false;
      }
      if (query != null && query.isNotEmpty) {
        final inTitle = item.title.toLowerCase().contains(query);
        final inAuthor = (item.author ?? '').toLowerCase().contains(query);
        if (!inTitle && !inAuthor) return false;
      }
      return true;
    }).toList();

    final start = (filter.page - 1) * filter.pageSize;
    final end = start + filter.pageSize;
    final page = start >= filtered.length
        ? <Item>[]
        : filtered.sublist(start, end > filtered.length ? filtered.length : end);
    return Ok(
      Page(
        items: page,
        page: filter.page,
        pageSize: filter.pageSize,
        total: filtered.length,
      ),
    );
  }

  @override
  Future<Result<Item>> getById(String id) async {
    await Future<void>.delayed(delay);
    final found = _find(id);
    return found == null ? Failure(NotFoundError(id)) : Ok(found);
  }

  @override
  Future<Result<Item>> create(Item item) async {
    await Future<void>.delayed(delay);
    final error = _validate(item);
    if (error != null) return Failure(error);
    final number = (_nextNumber++).toString().padLeft(4, '0');
    final created = item.normalized().copyWith(
      id: 'it_$number',
      addedAt: DateTime.now().toUtc(),
    );
    _items.add(created);
    _emit();
    return Ok(created);
  }

  @override
  Future<Result<Item>> update(Item item) async {
    await Future<void>.delayed(delay);
    // Validation comes first, as on the server: an invalid body for an id that
    // does not exist is a validation error, not a not-found.
    final error = _validate(item);
    if (error != null) return Failure(error);
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index < 0) return Failure(NotFoundError(item.id));
    final updated = item.normalized().copyWith(addedAt: _items[index].addedAt);
    _items[index] = updated;
    _emit();
    return Ok(updated);
  }

  @override
  Future<Result<void>> delete(String id) async {
    await Future<void>.delayed(delay);
    final index = _items.indexWhere((i) => i.id == id);
    if (index < 0) return Failure(NotFoundError(id));
    _items.removeAt(index);
    _emit();
    return const Ok(null);
  }

  @override
  Future<Result<Summary>> summary(int year) async {
    await Future<void>.delayed(delay);
    return Ok(Summary.fromItems(_items, year));
  }

  @override
  Stream<List<Item>> watch() => _changes.stream;

  void dispose() => _changes.close();

  Item? _find(String id) {
    for (final item in _items) {
      if (item.id == id) return item;
    }
    return null;
  }

  void _emit() {
    if (!_changes.isClosed) _changes.add(items);
  }

  static int _firstFreeNumber(List<Item> items) {
    var max = 0;
    for (final item in items) {
      final number = int.tryParse(item.id.replaceFirst('it_', '')) ?? 0;
      if (number > max) max = number;
    }
    return max + 1;
  }

  /// Items with a reading date first, newest first (tie: newest `addedAt`).
  /// Then the ones the person only wants, newest first.
  static List<Item> _sorted(List<Item> items) => [...items]..sort(_compare);

  static int _compare(Item a, Item b) {
    final da = a.readingDate;
    final db = b.readingDate;
    if (da != null && db != null) {
      final byDate = db.compareTo(da);
      return byDate != 0 ? byDate : b.addedAt.compareTo(a.addedAt);
    }
    if (da != null) return -1;
    if (db != null) return 1;
    return b.addedAt.compareTo(a.addedAt);
  }

  static AppError? _validate(Item item) {
    final fields = <String, String>{};
    if (item.title.trim().isEmpty) fields['title'] = 'must not be empty';

    final genre = item.genre?.trim();
    if (genre != null && genre.isNotEmpty && !SampleData.genres.contains(genre)) {
      fields['genre'] = 'must be one of the values from /genres';
    }

    switch (item.status) {
      case ItemStatus.want:
        break;
      case ItemStatus.inProgress:
        if (item.startedAt == null) {
          fields['startedAt'] = 'is required when status is in_progress';
        }
      case ItemStatus.done:
        if (item.finishedAt == null) {
          fields['finishedAt'] = 'is required when status is done';
        }
        final started = item.startedAt;
        final finished = item.finishedAt;
        if (started != null && finished != null && started.isAfter(finished)) {
          fields['startedAt'] = 'must not be after finishedAt';
        }
        final rating = item.rating;
        if (rating != null && (rating < 1 || rating > 10)) {
          fields['rating'] = 'must be an integer from 1 to 10';
        }
    }

    if (item.type == ItemType.book && (item.pages ?? 1) <= 0) {
      fields['pages'] = 'must be greater than zero';
    }
    if (item.type == ItemType.series && (item.seasons ?? 1) <= 0) {
      fields['seasons'] = 'must be greater than zero';
    }
    if (item.type == ItemType.movie && (item.durationMinutes ?? 1) <= 0) {
      fields['durationMinutes'] = 'must be greater than zero';
    }
    return fields.isEmpty ? null : ValidationError(fields);
  }
}
