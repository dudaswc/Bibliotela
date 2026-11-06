import 'package:bibliotela_core/bibliotela_core.dart';
import 'package:bibliotela/storage/shared_preferences_session_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final session = Session(token: 'tok_abc', user: SampleData.user);
  late SharedPreferencesSessionStorage storage;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    storage = SharedPreferencesSessionStorage();
  });

  test('nothing stored reads as no session', () async {
    expect(await storage.read(), isNull);
  });

  test('write then read gives back the same session', () async {
    await storage.write(session);
    expect(await storage.read(), session);
  });

  test('clear removes the session', () async {
    await storage.write(session);
    await storage.clear();
    expect(await storage.read(), isNull);
  });

  test('a corrupted value reads as no session and is dropped', () async {
    SharedPreferences.setMockInitialValues({'bibliotela.session': 'not json'});
    expect(await storage.read(), isNull);
    expect((await SharedPreferences.getInstance()).containsKey('bibliotela.session'), isFalse);
  });
}
