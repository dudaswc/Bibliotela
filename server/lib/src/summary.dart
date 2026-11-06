import 'models.dart';

/// Resumo do ano: so entram itens done cujo finishedAt cai em [year] (YYYY).
Map<String, Object?> computeSummary(List<Item> items, String year) {
  final prefix = '$year-';
  final done = items.where((i) => i.status == 'done' && (i.finishedAt ?? '').startsWith(prefix)).toList();

  int finished(String type) => done.where((i) => i.type == type).length;

  int total(String type, int? Function(Item) pick) =>
      done.where((i) => i.type == type).fold(0, (sum, i) => sum + (pick(i) ?? 0));

  final ratings = [
    for (final i in done)
      if (i.rating != null) i.rating!,
  ];
  double? averageRating;
  if (ratings.isNotEmpty) {
    final raw = ratings.reduce((a, b) => a + b) / ratings.length;
    averageRating = double.parse(raw.toStringAsFixed(1));
  }

  final counts = <String?, int>{};
  for (final item in done) {
    counts[item.genre] = (counts[item.genre] ?? 0) + 1;
  }
  final byGenre = counts.entries.toList()
    ..sort((a, b) {
      if (a.value != b.value) return b.value.compareTo(a.value); // maior para o menor
      if (a.key == null) return -1; // empate: "sem genero" primeiro, depois alfabetico
      if (b.key == null) return 1;
      return a.key!.compareTo(b.key!);
    });

  return {
    'year': int.parse(year),
    'books': {'finished': finished('book'), 'pages': total('book', (i) => i.pages)},
    'movies': {'finished': finished('movie'), 'minutes': total('movie', (i) => i.durationMinutes)},
    'series': {'finished': finished('series'), 'seasons': total('series', (i) => i.seasons)},
    'averageRating': averageRating,
    'byGenre': [
      for (final entry in byGenre) {'genre': entry.key, 'count': entry.value},
    ],
  };
}
