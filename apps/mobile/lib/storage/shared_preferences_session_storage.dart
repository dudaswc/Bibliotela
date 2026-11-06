import 'dart:convert';

import 'package:bibliotela_core/bibliotela_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keeps the session between app launches, on top of `shared_preferences`.
/// The core package only knows the [SessionStorage] interface.
class SharedPreferencesSessionStorage implements SessionStorage {
  static const _key = 'bibliotela.session';

  @override
  Future<Session?> read() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_key);
    if (raw == null) return null;
    try {
      return Session.fromJson(asJson(jsonDecode(raw)));
    } on FormatException {
      // A corrupted value must not lock the person out: start signed out.
      await preferences.remove(_key);
      return null;
    }
  }

  @override
  Future<void> write(Session session) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_key, jsonEncode(session.toJson()));
  }

  @override
  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_key);
  }
}
