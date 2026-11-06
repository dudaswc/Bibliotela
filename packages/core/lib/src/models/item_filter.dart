import 'item_status.dart';
import 'item_type.dart';

/// Query used to list items.
class ItemFilter {
  const ItemFilter({
    this.year,
    this.status,
    this.type,
    this.genre,
    this.query,
    this.page = 1,
    this.pageSize = 20,
  });

  /// Filters by reading date. Items the person only wants have none and show
  /// up in every year.
  final int? year;
  final ItemStatus? status;
  final ItemType? type;

  /// One of the values of `GET /genres`.
  final String? genre;

  /// Case-insensitive search on title and author.
  final String? query;
  final int page;
  final int pageSize;

  Map<String, String> toQueryParameters() => {
    if (year != null) 'year': year!.toString().padLeft(4, '0'),
    if (status != null) 'status': status!.toJson(),
    if (type != null) 'type': type!.toJson(),
    if (genre != null && genre!.isNotEmpty) 'genre': genre!,
    if (query != null && query!.trim().isNotEmpty) 'q': query!.trim(),
    'page': '$page',
    'pageSize': '$pageSize',
  };

  ItemFilter copyWith({
    int? Function()? year,
    ItemStatus? Function()? status,
    ItemType? Function()? type,
    String? Function()? genre,
    String? Function()? query,
    int? page,
    int? pageSize,
  }) => ItemFilter(
    year: year != null ? year() : this.year,
    status: status != null ? status() : this.status,
    type: type != null ? type() : this.type,
    genre: genre != null ? genre() : this.genre,
    query: query != null ? query() : this.query,
    page: page ?? this.page,
    pageSize: pageSize ?? this.pageSize,
  );

  ItemFilter nextPage() => copyWith(page: page + 1);

  @override
  bool operator ==(Object other) =>
      other is ItemFilter &&
      other.year == year &&
      other.status == status &&
      other.type == type &&
      other.genre == genre &&
      other.query == query &&
      other.page == page &&
      other.pageSize == pageSize;

  @override
  int get hashCode =>
      Object.hash(year, status, type, genre, query, page, pageSize);

  @override
  String toString() => 'ItemFilter(${toQueryParameters()})';
}
