import 'item_status.dart';
import 'item_type.dart';
import 'json.dart';
import 'local_date.dart';

/// A book, series or movie in the person's library.
class Item {
  const Item({
    required this.id,
    required this.type,
    required this.title,
    required this.status,
    required this.addedAt,
    this.genre,
    this.startedAt,
    this.finishedAt,
    this.rating,
    this.note,
    this.pages,
    this.author,
    this.seasons,
    this.durationMinutes,
  });

  /// An item that was not saved yet. The repository assigns [id] and
  /// [addedAt].
  Item.draft({
    required this.type,
    required this.title,
    required this.status,
    this.genre,
    this.startedAt,
    this.finishedAt,
    this.rating,
    this.note,
    this.pages,
    this.author,
    this.seasons,
    this.durationMinutes,
  }) : id = '',
       addedAt = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

  factory Item.fromJson(Json json) => Item(
    id: json.readString('id'),
    type: ItemType.fromJson(json.readString('type')),
    title: json.readString('title'),
    genre: json.readOptionalString('genre'),
    status: ItemStatus.fromJson(json.readString('status')),
    startedAt: LocalDate.tryParse(json.readOptionalString('startedAt')),
    finishedAt: LocalDate.tryParse(json.readOptionalString('finishedAt')),
    rating: json.readOptionalInt('rating'),
    note: json.readOptionalString('note'),
    pages: json.readOptionalInt('pages'),
    author: json.readOptionalString('author'),
    seasons: json.readOptionalInt('seasons'),
    durationMinutes: json.readOptionalInt('durationMinutes'),
    addedAt: json.readDateTime('addedAt'),
  );

  final String id;
  final ItemType type;
  final String title;
  final String? genre;
  final ItemStatus status;

  /// Only the day. Required when [status] is in progress.
  final LocalDate? startedAt;

  /// Only the day. Required when [status] is done.
  final LocalDate? finishedAt;

  /// 1 to 10, only when done. The screens show it as stars (rating / 2).
  final int? rating;
  final String? note;

  /// Books only.
  final int? pages;
  final String? author;

  /// Series only.
  final int? seasons;

  /// Movies only.
  final int? durationMinutes;

  /// Set by the server.
  final DateTime addedAt;

  /// `finishedAt` for done items and `startedAt` for items in progress. Items
  /// the person only wants have none. This date decides the year filter, the
  /// order and the month group of the list.
  LocalDate? get readingDate => switch (status) {
    ItemStatus.done => finishedAt,
    ItemStatus.inProgress => startedAt,
    ItemStatus.want => null,
  };

  /// The same item with what does not apply to its status or type dropped
  /// (a rating on an item the person only wants, pages on a movie) and the
  /// texts cleaned. This is what the server returns, so a repository that
  /// works offline can behave the same way.
  Item normalized() {
    final done = status == ItemStatus.done;
    return Item(
      id: id,
      type: type,
      title: title.trim(),
      genre: _blankToNull(genre),
      status: status,
      startedAt: status == ItemStatus.want ? null : startedAt,
      finishedAt: done ? finishedAt : null,
      rating: done ? rating : null,
      note: _blankToNull(note),
      pages: type == ItemType.book ? pages : null,
      author: type == ItemType.book ? _blankToNull(author) : null,
      seasons: type == ItemType.series ? seasons : null,
      durationMinutes: type == ItemType.movie ? durationMinutes : null,
      addedAt: addedAt,
    );
  }

  Json toJson() => {
    'id': id,
    'type': type.toJson(),
    'title': title,
    'genre': genre,
    'status': status.toJson(),
    'startedAt': startedAt?.toJson(),
    'finishedAt': finishedAt?.toJson(),
    'rating': rating,
    'note': note,
    'pages': pages,
    'author': author,
    'seasons': seasons,
    'durationMinutes': durationMinutes,
    'addedAt': addedAt.toUtc().toIso8601String(),
  };

  /// Nullable fields take a function so that "set to null" and "keep" differ:
  /// `copyWith(rating: () => null)` clears the rating.
  Item copyWith({
    String? id,
    ItemType? type,
    String? title,
    String? Function()? genre,
    ItemStatus? status,
    LocalDate? Function()? startedAt,
    LocalDate? Function()? finishedAt,
    int? Function()? rating,
    String? Function()? note,
    int? Function()? pages,
    String? Function()? author,
    int? Function()? seasons,
    int? Function()? durationMinutes,
    DateTime? addedAt,
  }) => Item(
    id: id ?? this.id,
    type: type ?? this.type,
    title: title ?? this.title,
    genre: genre != null ? genre() : this.genre,
    status: status ?? this.status,
    startedAt: startedAt != null ? startedAt() : this.startedAt,
    finishedAt: finishedAt != null ? finishedAt() : this.finishedAt,
    rating: rating != null ? rating() : this.rating,
    note: note != null ? note() : this.note,
    pages: pages != null ? pages() : this.pages,
    author: author != null ? author() : this.author,
    seasons: seasons != null ? seasons() : this.seasons,
    durationMinutes: durationMinutes != null
        ? durationMinutes()
        : this.durationMinutes,
    addedAt: addedAt ?? this.addedAt,
  );

  @override
  bool operator ==(Object other) =>
      other is Item &&
      other.id == id &&
      other.type == type &&
      other.title == title &&
      other.genre == genre &&
      other.status == status &&
      other.startedAt == startedAt &&
      other.finishedAt == finishedAt &&
      other.rating == rating &&
      other.note == note &&
      other.pages == pages &&
      other.author == author &&
      other.seasons == seasons &&
      other.durationMinutes == durationMinutes &&
      other.addedAt == addedAt;

  @override
  int get hashCode => Object.hash(
    id,
    type,
    title,
    genre,
    status,
    startedAt,
    finishedAt,
    rating,
    note,
    pages,
    author,
    seasons,
    durationMinutes,
    addedAt,
  );

  @override
  String toString() => 'Item($id, ${type.name}, $title, ${status.json})';
}

String? _blankToNull(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}
