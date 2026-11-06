class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String createdAt;

  /// Atualiza so nome e avatar; os outros campos nao mudam.
  User withProfile({required String name, required String? avatarUrl}) =>
      User(id: id, name: name, email: email, avatarUrl: avatarUrl, createdAt: createdAt);

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'avatarUrl': avatarUrl,
        'createdAt': createdAt,
      };
}

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

  final String id;
  final String type;
  final String title;
  final String? genre;
  final String status;
  final String? startedAt;
  final String? finishedAt;
  final int? rating;
  final String? note;
  final int? pages;
  final String? author;
  final int? seasons;
  final int? durationMinutes;
  final String addedAt;

  /// Data de leitura: finishedAt nos done e startedAt nos in_progress.
  /// Itens want nao tem data de leitura.
  String? get readingDate {
    if (status == 'done') return finishedAt;
    if (status == 'in_progress') return startedAt;
    return null;
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'genre': genre,
        'status': status,
        'startedAt': startedAt,
        'finishedAt': finishedAt,
        'rating': rating,
        'note': note,
        'pages': pages,
        'author': author,
        'seasons': seasons,
        'durationMinutes': durationMinutes,
        'addedAt': addedAt,
      };
}
