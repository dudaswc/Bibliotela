import 'item.dart';
import 'item_status.dart';
import 'item_type.dart';
import 'json.dart';

/// Books finished in the year.
class BooksSummary {
  const BooksSummary({required this.finished, required this.pages});

  factory BooksSummary.fromJson(Json json) => BooksSummary(
    finished: json.readInt('finished', fallback: 0),
    pages: json.readInt('pages', fallback: 0),
  );

  final int finished;
  final int pages;

  Json toJson() => {'finished': finished, 'pages': pages};

  @override
  bool operator ==(Object other) =>
      other is BooksSummary && other.finished == finished && other.pages == pages;

  @override
  int get hashCode => Object.hash(finished, pages);
}

/// Movies finished in the year.
class MoviesSummary {
  const MoviesSummary({required this.finished, required this.minutes});

  factory MoviesSummary.fromJson(Json json) => MoviesSummary(
    finished: json.readInt('finished', fallback: 0),
    minutes: json.readInt('minutes', fallback: 0),
  );

  final int finished;
  final int minutes;

  Json toJson() => {'finished': finished, 'minutes': minutes};

  @override
  bool operator ==(Object other) =>
      other is MoviesSummary && other.finished == finished && other.minutes == minutes;

  @override
  int get hashCode => Object.hash(finished, minutes);
}

/// Series finished in the year.
class SeriesSummary {
  const SeriesSummary({required this.finished, required this.seasons});

  factory SeriesSummary.fromJson(Json json) => SeriesSummary(
    finished: json.readInt('finished', fallback: 0),
    seasons: json.readInt('seasons', fallback: 0),
  );

  final int finished;
  final int seasons;

  Json toJson() => {'finished': finished, 'seasons': seasons};

  @override
  bool operator ==(Object other) =>
      other is SeriesSummary && other.finished == finished && other.seasons == seasons;

  @override
  int get hashCode => Object.hash(finished, seasons);
}

/// How many finished items have a genre. A null [genre] means "no genre".
class GenreCount {
  const GenreCount({required this.genre, required this.count});

  factory GenreCount.fromJson(Json json) => GenreCount(
    genre: json.readOptionalString('genre'),
    count: json.readInt('count', fallback: 0),
  );

  final String? genre;
  final int count;

  Json toJson() => {'genre': genre, 'count': count};

  @override
  bool operator ==(Object other) =>
      other is GenreCount && other.genre == genre && other.count == count;

  @override
  int get hashCode => Object.hash(genre, count);

  @override
  String toString() => 'GenreCount($genre, $count)';
}

/// What the person finished in one year.
class Summary {
  const Summary({
    required this.year,
    required this.books,
    required this.movies,
    required this.series,
    required this.byGenre,
    this.averageRating,
  });

  factory Summary.fromJson(Json json) {
    final rawGenres = json['byGenre'];
    return Summary(
      year: json.readInt('year'),
      books: BooksSummary.fromJson(json.readObject('books')),
      movies: MoviesSummary.fromJson(json.readObject('movies')),
      series: SeriesSummary.fromJson(json.readObject('series')),
      averageRating: json['averageRating'] is num
          ? (json['averageRating']! as num).toDouble()
          : null,
      byGenre: rawGenres is List
          ? [for (final entry in rawGenres) GenreCount.fromJson(asJson(entry))]
          : const [],
    );
  }

  /// Computes the summary of [year] from [items], the same way the server
  /// does: only done items whose `finishedAt` is in that year count.
  /// `byGenre` goes from the largest to the smallest; on a tie, "no genre"
  /// comes first and then the alphabetical order.
  factory Summary.fromItems(Iterable<Item> items, int year) {
    final done = [
      for (final item in items)
        if (item.status == ItemStatus.done && item.finishedAt?.year == year)
          item,
    ];

    int count(ItemType type) => done.where((i) => i.type == type).length;
    int total(ItemType type, int? Function(Item) pick) => done
        .where((i) => i.type == type)
        .fold(0, (sum, item) => sum + (pick(item) ?? 0));

    final ratings = [
      for (final item in done)
        if (item.rating != null) item.rating!,
    ];
    double? average;
    if (ratings.isNotEmpty) {
      final raw = ratings.reduce((a, b) => a + b) / ratings.length;
      average = double.parse(raw.toStringAsFixed(1));
    }

    final counts = <String?, int>{};
    for (final item in done) {
      counts[item.genre] = (counts[item.genre] ?? 0) + 1;
    }
    final genres = [
      for (final entry in counts.entries)
        GenreCount(genre: entry.key, count: entry.value),
    ]..sort(_compareGenres);

    return Summary(
      year: year,
      books: BooksSummary(
        finished: count(ItemType.book),
        pages: total(ItemType.book, (i) => i.pages),
      ),
      movies: MoviesSummary(
        finished: count(ItemType.movie),
        minutes: total(ItemType.movie, (i) => i.durationMinutes),
      ),
      series: SeriesSummary(
        finished: count(ItemType.series),
        seasons: total(ItemType.series, (i) => i.seasons),
      ),
      averageRating: average,
      byGenre: genres,
    );
  }

  final int year;
  final BooksSummary books;
  final MoviesSummary movies;
  final SeriesSummary series;

  /// Average of the ratings of the items finished in the year, with one
  /// decimal. Null when none has a rating.
  final double? averageRating;
  final List<GenreCount> byGenre;

  Json toJson() => {
    'year': year,
    'books': books.toJson(),
    'movies': movies.toJson(),
    'series': series.toJson(),
    'averageRating': averageRating,
    'byGenre': [for (final entry in byGenre) entry.toJson()],
  };

  @override
  bool operator ==(Object other) =>
      other is Summary &&
      other.year == year &&
      other.books == books &&
      other.movies == movies &&
      other.series == series &&
      other.averageRating == averageRating &&
      _sameGenres(other.byGenre, byGenre);

  @override
  int get hashCode =>
      Object.hash(year, books, movies, series, averageRating, byGenre.length);

  @override
  String toString() => 'Summary($year, ${books.finished} books)';
}

int _compareGenres(GenreCount a, GenreCount b) {
  if (a.count != b.count) return b.count.compareTo(a.count);
  if (a.genre == null) return b.genre == null ? 0 : -1;
  if (b.genre == null) return 1;
  return a.genre!.compareTo(b.genre!);
}

bool _sameGenres(List<GenreCount> a, List<GenreCount> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
