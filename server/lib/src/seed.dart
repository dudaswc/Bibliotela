import 'models.dart';

/// Usuario de teste e senha. Todos usam a senha 123456.
class SeedUser {
  const SeedUser(this.user, this.password);

  final User user;
  final String password;
}

const List<SeedUser> seedUsers = [
  SeedUser(
    User(id: 'usr_01', name: 'Ana Ribeiro', email: 'ana@bibliotela.dev', avatarUrl: null, createdAt: '2024-03-11T09:00:00Z'),
    '123456',
  ),
  SeedUser(
    User(id: 'usr_02', name: 'Bruno Costa', email: 'bruno@bibliotela.dev', avatarUrl: null, createdAt: '2024-05-02T14:30:00Z'),
    '123456',
  ),
];

SeedUser? findSeedUser(String email) {
  for (final seed in seedUsers) {
    if (seed.user.email == email) return seed;
  }
  return null;
}

/// Copia do seed de um usuario (uma por sessao): 45 itens da Ana e 15 do Bruno,
/// concluidos em 2025 e 2026, nos tres tipos e nos tres status, com e sem
/// genero, nota, observacao e autor.
List<Item> seedItemsFor(String userId) {
  if (userId == 'usr_01') return List<Item>.of(_anaItems);
  if (userId == 'usr_02') return List<Item>.of(_brunoItems);
  return <Item>[];
}

const List<Item> _anaItems = [
  Item(id: 'it_0001', type: 'book', title: 'Duna', status: 'done', addedAt: '2026-07-30T18:20:00Z', genre: 'Ficção científica', startedAt: '2026-08-12', finishedAt: '2026-09-06', note: 'Final inesperado', author: 'Frank Herbert', rating: 9, pages: 680),
  Item(id: 'it_0002', type: 'book', title: 'Torto Arado', status: 'done', addedAt: '2026-07-26T10:05:00Z', genre: 'Drama', startedAt: '2026-08-01', finishedAt: '2026-08-18', author: 'Itamar Vieira Junior', rating: 10, pages: 264),
  Item(id: 'it_0003', type: 'book', title: 'Sapiens', status: 'done', addedAt: '2026-07-08T21:40:00Z', genre: 'Outros', finishedAt: '2026-07-14', author: 'Yuval Noah Harari', rating: 7, pages: 464),
  Item(id: 'it_0004', type: 'book', title: 'A Hora da Estrela', status: 'done', addedAt: '2026-05-27T12:30:00Z', genre: 'Romance', startedAt: '2026-06-02', finishedAt: '2026-06-09', note: 'Curto e intenso', author: 'Clarice Lispector', rating: 8, pages: 88),
  Item(id: 'it_0005', type: 'book', title: 'O Nome do Vento', status: 'done', addedAt: '2026-04-04T09:15:00Z', genre: 'Fantasia', startedAt: '2026-04-10', finishedAt: '2026-05-21', author: 'Patrick Rothfuss', rating: 9, pages: 656),
  Item(id: 'it_0006', type: 'book', title: 'Admirável Mundo Novo', status: 'done', addedAt: '2026-03-24T18:20:00Z', genre: 'Ficção científica', finishedAt: '2026-03-30', author: 'Aldous Huxley', rating: 7),
  Item(id: 'it_0007', type: 'book', title: 'Memórias Póstumas de Brás Cubas', status: 'done', addedAt: '2026-01-28T10:05:00Z', genre: 'Romance', startedAt: '2026-02-03', finishedAt: '2026-02-19', note: 'Releitura', author: 'Machado de Assis', pages: 288),
  Item(id: 'it_0008', type: 'book', title: 'O Pequeno Príncipe', status: 'done', addedAt: '2025-12-30T21:40:00Z', startedAt: '2026-01-05', finishedAt: '2026-01-06', rating: 10, pages: 96),
  Item(id: 'it_0009', type: 'book', title: 'Drácula', status: 'done', addedAt: '2026-09-25T12:30:00Z', genre: 'Terror', startedAt: '2026-10-01', finishedAt: '2026-10-14', author: 'Bram Stoker', rating: 8, pages: 488),
  Item(id: 'it_0010', type: 'movie', title: 'Oppenheimer', status: 'done', addedAt: '2026-09-21T09:15:00Z', genre: 'Drama', startedAt: '2026-09-27', finishedAt: '2026-09-27', rating: 8, durationMinutes: 181),
  Item(id: 'it_0011', type: 'movie', title: 'Parasita', status: 'done', addedAt: '2026-08-28T18:20:00Z', genre: 'Suspense', startedAt: '2026-09-03', finishedAt: '2026-09-03', note: 'Reassistido', rating: 10, durationMinutes: 132),
  Item(id: 'it_0012', type: 'movie', title: 'Ainda Estou Aqui', status: 'done', addedAt: '2026-08-06T10:05:00Z', genre: 'Drama', startedAt: '2026-08-12', finishedAt: '2026-08-12', durationMinutes: 137),
  Item(id: 'it_0013', type: 'movie', title: 'Duna: Parte Dois', status: 'done', addedAt: '2026-06-09T21:40:00Z', genre: 'Ficção científica', startedAt: '2026-06-15', finishedAt: '2026-06-15', rating: 9, durationMinutes: 166),
  Item(id: 'it_0014', type: 'movie', title: 'Divertida Mente 2', status: 'done', addedAt: '2026-06-28T12:30:00Z', genre: 'Comédia', startedAt: '2026-07-04', finishedAt: '2026-07-04', rating: 7, durationMinutes: 96),
  Item(id: 'it_0015', type: 'movie', title: 'O Auto da Compadecida', status: 'done', addedAt: '2026-04-25T09:15:00Z', genre: 'Comédia', startedAt: '2026-05-01', finishedAt: '2026-05-01', note: 'Clássico', rating: 10, durationMinutes: 104),
  Item(id: 'it_0016', type: 'movie', title: 'Blade Runner 2049', status: 'done', addedAt: '2026-03-02T18:20:00Z', genre: 'Ficção científica', startedAt: '2026-03-08', finishedAt: '2026-03-08', rating: 8, durationMinutes: 164),
  Item(id: 'it_0017', type: 'movie', title: 'Coringa', status: 'done', addedAt: '2026-02-08T10:05:00Z', startedAt: '2026-02-14', finishedAt: '2026-02-14', rating: 6, durationMinutes: 122),
  Item(id: 'it_0018', type: 'series', title: 'Stranger Things', status: 'done', addedAt: '2026-06-26T21:40:00Z', genre: 'Ficção científica', startedAt: '2026-07-02', finishedAt: '2026-07-25', rating: 8, seasons: 5),
  Item(id: 'it_0019', type: 'series', title: 'Chernobyl', status: 'done', addedAt: '2026-04-12T12:30:00Z', genre: 'Drama', startedAt: '2026-04-18', finishedAt: '2026-04-20', note: 'Perturbador', rating: 10, seasons: 1),
  Item(id: 'it_0020', type: 'series', title: 'Dark', status: 'done', addedAt: '2026-01-04T09:15:00Z', genre: 'Suspense', startedAt: '2026-01-10', finishedAt: '2026-02-28', rating: 9, seasons: 3),
  Item(id: 'it_0021', type: 'series', title: 'Fleabag', status: 'done', addedAt: '2026-05-24T18:20:00Z', genre: 'Comédia', startedAt: '2026-05-30', finishedAt: '2026-06-01', seasons: 2),
  Item(id: 'it_0022', type: 'book', title: 'Dom Casmurro', status: 'done', addedAt: '2025-10-28T10:05:00Z', genre: 'Romance', startedAt: '2025-11-03', finishedAt: '2025-11-20', author: 'Machado de Assis', rating: 9, pages: 256),
  Item(id: 'it_0023', type: 'book', title: '1984', status: 'done', addedAt: '2025-08-26T21:40:00Z', genre: 'Ficção científica', startedAt: '2025-09-01', finishedAt: '2025-09-18', author: 'George Orwell', rating: 10, pages: 416),
  Item(id: 'it_0024', type: 'book', title: 'O Hobbit', status: 'done', addedAt: '2025-06-29T12:30:00Z', genre: 'Fantasia', startedAt: '2025-07-05', finishedAt: '2025-07-29', author: 'J. R. R. Tolkien', rating: 8, pages: 336),
  Item(id: 'it_0025', type: 'book', title: 'Quarto de Despejo', status: 'done', addedAt: '2025-05-06T09:15:00Z', genre: 'Biografia', finishedAt: '2025-05-12', note: 'Muito forte', author: 'Carolina Maria de Jesus', rating: 9, pages: 200),
  Item(id: 'it_0026', type: 'book', title: 'Cem Anos de Solidão', status: 'done', addedAt: '2025-02-23T18:20:00Z', genre: 'Romance', startedAt: '2025-03-01', finishedAt: '2025-04-02', author: 'Gabriel García Márquez', rating: 7, pages: 448),
  Item(id: 'it_0027', type: 'book', title: 'O Alquimista', status: 'done', addedAt: '2025-01-09T10:05:00Z', genre: 'Aventura', finishedAt: '2025-01-15', author: 'Paulo Coelho', pages: 208),
  Item(id: 'it_0028', type: 'movie', title: 'Cidade de Deus', status: 'done', addedAt: '2025-11-30T21:40:00Z', genre: 'Drama', startedAt: '2025-12-06', finishedAt: '2025-12-06', rating: 10, durationMinutes: 130),
  Item(id: 'it_0029', type: 'movie', title: 'Matrix', status: 'done', addedAt: '2025-10-05T12:30:00Z', genre: 'Ação', startedAt: '2025-10-11', finishedAt: '2025-10-11', rating: 9, durationMinutes: 136),
  Item(id: 'it_0030', type: 'movie', title: 'Mad Max: Estrada da Fúria', status: 'done', addedAt: '2025-08-16T09:15:00Z', genre: 'Ação', startedAt: '2025-08-22', finishedAt: '2025-08-22', rating: 8, durationMinutes: 120),
  Item(id: 'it_0031', type: 'movie', title: 'Bacurau', status: 'done', addedAt: '2025-06-08T18:20:00Z', genre: 'Suspense', startedAt: '2025-06-14', finishedAt: '2025-06-14', note: 'Vi no cinema', durationMinutes: 131),
  Item(id: 'it_0032', type: 'movie', title: 'O Iluminado', status: 'done', addedAt: '2025-10-25T10:05:00Z', genre: 'Terror', startedAt: '2025-10-31', finishedAt: '2025-10-31', rating: 7, durationMinutes: 146),
  Item(id: 'it_0033', type: 'series', title: 'Breaking Bad', status: 'done', addedAt: '2025-04-29T21:40:00Z', genre: 'Drama', startedAt: '2025-05-05', finishedAt: '2025-08-10', rating: 10, seasons: 5),
  Item(id: 'it_0034', type: 'series', title: 'The Office', status: 'done', addedAt: '2025-01-26T12:30:00Z', genre: 'Comédia', startedAt: '2025-02-01', finishedAt: '2025-04-30', rating: 8, seasons: 9),
  Item(id: 'it_0035', type: 'series', title: 'Black Mirror', status: 'done', addedAt: '2025-12-09T09:15:00Z', genre: 'Ficção científica', finishedAt: '2025-12-15', rating: 8, seasons: 6),
  Item(id: 'it_0036', type: 'book', title: 'Os Miseráveis', status: 'in_progress', addedAt: '2026-09-14T18:20:00Z', genre: 'Drama', startedAt: '2026-09-20', note: 'Vou devagar', author: 'Victor Hugo', pages: 1488),
  Item(id: 'it_0037', type: 'book', title: 'Neuromancer', status: 'in_progress', addedAt: '2026-09-29T10:05:00Z', genre: 'Ficção científica', startedAt: '2026-10-05', author: 'William Gibson', pages: 320),
  Item(id: 'it_0038', type: 'series', title: 'Severance', status: 'in_progress', addedAt: '2026-09-14T21:40:00Z', genre: 'Suspense', startedAt: '2026-09-20', note: 'Segunda temporada', seasons: 2),
  Item(id: 'it_0039', type: 'movie', title: 'Titanic', status: 'in_progress', addedAt: '2026-10-24T12:30:00Z', genre: 'Romance', startedAt: '2026-10-30', durationMinutes: 195),
  Item(id: 'it_0040', type: 'book', title: 'Grande Sertão: Veredas', status: 'want', addedAt: '2026-10-20T11:00:00Z', genre: 'Romance', author: 'João Guimarães Rosa', pages: 608),
  Item(id: 'it_0041', type: 'book', title: 'Fahrenheit 451', status: 'want', addedAt: '2026-10-18T19:30:00Z', genre: 'Ficção científica', author: 'Ray Bradbury'),
  Item(id: 'it_0042', type: 'movie', title: 'Interestelar', status: 'want', addedAt: '2026-09-30T08:45:00Z', genre: 'Ficção científica', durationMinutes: 169),
  Item(id: 'it_0043', type: 'movie', title: 'Sociedade da Neve', status: 'want', addedAt: '2026-09-12T22:10:00Z'),
  Item(id: 'it_0044', type: 'series', title: 'The Bear', status: 'want', addedAt: '2026-08-25T14:00:00Z', genre: 'Comédia', seasons: 3),
  Item(id: 'it_0045', type: 'series', title: 'Succession', status: 'want', addedAt: '2026-08-02T16:20:00Z', genre: 'Drama', note: 'Indicação do Bruno'),
];

const List<Item> _brunoItems = [
  Item(id: 'it_0001', type: 'book', title: 'Ensaio sobre a Cegueira', status: 'done', addedAt: '2026-07-28T18:20:00Z', genre: 'Drama', startedAt: '2026-08-03', finishedAt: '2026-08-25', author: 'José Saramago', rating: 9, pages: 312),
  Item(id: 'it_0002', type: 'book', title: 'Harry Potter e a Pedra Filosofal', status: 'done', addedAt: '2026-05-26T10:05:00Z', genre: 'Fantasia', startedAt: '2026-06-01', finishedAt: '2026-06-10', note: 'Releitura', author: 'J. K. Rowling', rating: 10, pages: 264),
  Item(id: 'it_0003', type: 'movie', title: 'O Poderoso Chefão', status: 'done', addedAt: '2026-09-08T21:40:00Z', genre: 'Drama', startedAt: '2026-09-14', finishedAt: '2026-09-14', rating: 10, durationMinutes: 175),
  Item(id: 'it_0004', type: 'movie', title: 'Superbad', status: 'done', addedAt: '2026-05-14T12:30:00Z', genre: 'Comédia', startedAt: '2026-05-20', finishedAt: '2026-05-20', rating: 7, durationMinutes: 113),
  Item(id: 'it_0005', type: 'series', title: 'Round 6', status: 'done', addedAt: '2026-03-26T09:15:00Z', genre: 'Suspense', startedAt: '2026-04-01', finishedAt: '2026-04-09', rating: 8, seasons: 2),
  Item(id: 'it_0006', type: 'series', title: 'Friends', status: 'done', addedAt: '2026-02-21T18:20:00Z', genre: 'Comédia', finishedAt: '2026-02-27', seasons: 10),
  Item(id: 'it_0007', type: 'book', title: 'Percy Jackson e o Ladrão de Raios', status: 'done', addedAt: '2025-09-26T10:05:00Z', genre: 'Aventura', startedAt: '2025-10-02', finishedAt: '2025-10-12', author: 'Rick Riordan', rating: 8, pages: 400),
  Item(id: 'it_0008', type: 'movie', title: 'Velozes e Furiosos', status: 'done', addedAt: '2025-08-31T21:40:00Z', genre: 'Ação', startedAt: '2025-09-06', finishedAt: '2025-09-06', rating: 6, durationMinutes: 106),
  Item(id: 'it_0009', type: 'movie', title: 'Tubarão', status: 'done', addedAt: '2025-07-13T12:30:00Z', genre: 'Terror', startedAt: '2025-07-19', finishedAt: '2025-07-19', note: 'Clássico', rating: 8, durationMinutes: 124),
  Item(id: 'it_0010', type: 'series', title: 'Narcos', status: 'done', addedAt: '2025-03-04T09:15:00Z', genre: 'Drama', startedAt: '2025-03-10', finishedAt: '2025-05-02', rating: 9, seasons: 3),
  Item(id: 'it_0011', type: 'book', title: 'O Senhor dos Anéis: A Sociedade do Anel', status: 'in_progress', addedAt: '2026-10-06T18:20:00Z', genre: 'Fantasia', startedAt: '2026-10-12', author: 'J. R. R. Tolkien', pages: 576),
  Item(id: 'it_0012', type: 'series', title: 'The Last of Us', status: 'in_progress', addedAt: '2026-10-19T10:05:00Z', genre: 'Drama', startedAt: '2026-10-25', seasons: 2),
  Item(id: 'it_0013', type: 'movie', title: 'Duna', status: 'want', addedAt: '2026-10-22T20:00:00Z', genre: 'Ficção científica', durationMinutes: 155),
  Item(id: 'it_0014', type: 'book', title: 'O Guia do Mochileiro das Galáxias', status: 'want', addedAt: '2026-10-10T09:30:00Z', genre: 'Ficção científica', author: 'Douglas Adams', pages: 208),
  Item(id: 'it_0015', type: 'series', title: 'Arcane', status: 'want', addedAt: '2026-09-05T13:15:00Z', genre: 'Ação', seasons: 2),
];
