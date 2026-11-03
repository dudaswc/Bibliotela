import 'package:flutter/material.dart';

enum MediaType { book, series, movie }

/// `inProgress` corresponde a `in_progress` no contrato da API.
enum MediaStatus { want, inProgress, done }

extension MediaTypeX on MediaType {
  IconData get icon => switch (this) {
        MediaType.book => Icons.menu_book_outlined,
        MediaType.series => Icons.tv_outlined,
        MediaType.movie => Icons.movie_outlined,
      };

  String get label => switch (this) {
        MediaType.book => 'Livro',
        MediaType.series => 'Série',
        MediaType.movie => 'Filme',
      };
}

/// Livro: Quero ler, Lendo, Lido. Série e filme: Quero assistir, Assistindo, Assistido.
String statusLabel(MediaStatus status, MediaType type) {
  final book = type == MediaType.book;
  return switch (status) {
    MediaStatus.want => book ? 'Quero ler' : 'Quero assistir',
    MediaStatus.inProgress => book ? 'Lendo' : 'Assistindo',
    MediaStatus.done => book ? 'Lido' : 'Assistido',
  };
}
