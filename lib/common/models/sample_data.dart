import 'media.dart';

class SampleItem {
  const SampleItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.status,
    this.rating,
    this.dateLabel,
  });

  final MediaType type;
  final String title;
  final String subtitle;
  final MediaStatus status;
  final int? rating;
  final String? dateLabel;
}

/// Dados de exemplo do catálogo (os mesmos do protótipo do Figma).
const List<SampleItem> sampleItems = [
  SampleItem(type: MediaType.book, title: 'Duna', subtitle: 'Ficção científica · Frank Herbert', status: MediaStatus.done, rating: 9, dateLabel: '06 set'),
  SampleItem(type: MediaType.book, title: 'Torto Arado', subtitle: 'Drama · Itamar Vieira Junior', status: MediaStatus.done, rating: 10, dateLabel: '18 ago'),
  SampleItem(type: MediaType.book, title: 'O Hobbit', subtitle: 'Fantasia · J. R. R. Tolkien', status: MediaStatus.inProgress),
  SampleItem(type: MediaType.book, title: 'Dom Casmurro', subtitle: 'Romance · Machado de Assis', status: MediaStatus.want),
  SampleItem(type: MediaType.movie, title: 'Oppenheimer', subtitle: 'Drama · 3 h 01 min', status: MediaStatus.done, rating: 8, dateLabel: '27 set'),
  SampleItem(type: MediaType.movie, title: 'Parasita', subtitle: 'Suspense · 2 h 12 min', status: MediaStatus.done, rating: 10, dateLabel: '03 set'),
  SampleItem(type: MediaType.movie, title: 'Interestelar', subtitle: 'Ficção científica · 2 h 49 min', status: MediaStatus.want),
  SampleItem(type: MediaType.movie, title: 'Ainda Estou Aqui', subtitle: 'Drama · 2 h 17 min', status: MediaStatus.done, dateLabel: '12 ago'),
  SampleItem(type: MediaType.series, title: 'Severance', subtitle: 'Suspense · 2 temporadas', status: MediaStatus.inProgress),
  SampleItem(type: MediaType.series, title: 'Stranger Things', subtitle: 'Ficção científica · 5 temporadas', status: MediaStatus.done, rating: 8, dateLabel: '25 jul'),
  SampleItem(type: MediaType.series, title: 'The Bear', subtitle: 'Comédia · 3 temporadas', status: MediaStatus.want),
];

/// Resumo do ano usado no catálogo.
class SampleYearSummary {
  const SampleYearSummary({required this.books, required this.pages, required this.movies, required this.series, required this.average});

  final int books;
  final int pages;
  final int movies;
  final int series;
  final double average;
}

const Map<int, SampleYearSummary> sampleSummaries = {
  2026: SampleYearSummary(books: 12, pages: 3480, movies: 30, series: 5, average: 7.8),
  2025: SampleYearSummary(books: 9, pages: 2650, movies: 24, series: 7, average: 8.1),
};

/// Gêneros do resumo (nome, quantidade) e o total.
const List<(String, int)> sampleGenres = [
  ('Drama', 14),
  ('Ficção científica', 10),
  ('Suspense', 8),
  ('Fantasia', 5),
  ('Comédia', 4),
];

const int sampleGenreTotal = 41;
