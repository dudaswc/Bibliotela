import 'dart:math';

import 'models.dart';
import 'seed.dart';

/// Uma sessao de login: cada uma tem a sua copia do seed.
class Session {
  Session({required this.token, required this.seed})
      : user = seed.user,
        items = seedItemsFor(seed.user.id),
        _nextNumber = _firstFreeNumber(seedItemsFor(seed.user.id));

  final String token;
  final SeedUser seed;
  User user;
  List<Item> items;
  int _nextNumber;

  static int _firstFreeNumber(List<Item> items) {
    var max = 0;
    for (final item in items) {
      final number = int.tryParse(item.id.replaceFirst('it_', '')) ?? 0;
      if (number > max) max = number;
    }
    return max + 1;
  }

  /// Proximo id livre (nao consome: so avanca em [add]).
  String peekItemId() => 'it_${_nextNumber.toString().padLeft(4, '0')}';

  void add(Item item) {
    items.add(item);
    _nextNumber++;
  }

  Item? find(String id) {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  void replace(Item item) {
    final index = items.indexWhere((i) => i.id == item.id);
    if (index >= 0) items[index] = item;
  }

  bool remove(String id) {
    final before = items.length;
    items.removeWhere((i) => i.id == id);
    return items.length < before;
  }

  /// Devolve usuario e itens ao estado do seed. O token continua valido.
  void reset() {
    user = seed.user;
    items = seedItemsFor(seed.user.id);
    _nextNumber = _firstFreeNumber(items);
  }
}

class SessionStore {
  SessionStore({Random? random}) : _random = random ?? Random.secure();

  final Random _random;
  final Map<String, Session> _sessions = {};

  static const _alphabet = 'abcdefghijklmnopqrstuvwxyz0123456789';

  String _newToken() {
    final buffer = StringBuffer('tok_');
    for (var i = 0; i < 24; i++) {
      buffer.write(_alphabet[_random.nextInt(_alphabet.length)]);
    }
    return buffer.toString();
  }

  Session login(SeedUser seed) {
    final session = Session(token: _newToken(), seed: seed);
    _sessions[session.token] = session;
    return session;
  }

  Session? byToken(String token) => _sessions[token];

  void logout(String token) => _sessions.remove(token);
}
