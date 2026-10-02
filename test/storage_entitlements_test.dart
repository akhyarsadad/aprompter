import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aprompter/services/storage.dart';

void main() {
  // Creating the auto-seeded welcome script reads the device locale via
  // WidgetsBinding, which a plain `test()` doesn't initialize by default.
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('word cap migration flag defaults to false, then persists true', () async {
    final storage = await Storage.open();
    expect(storage.wordCapMigrationDone, isFalse);
    await storage.setWordCapMigrationDone();
    expect(storage.wordCapMigrationDone, isTrue);
  });

  test('grandfathered word cap ids default to empty, then persist', () async {
    final storage = await Storage.open();
    expect(storage.grandfatheredWordCapIds, isEmpty);
    await storage.saveGrandfatheredWordCapIds({'a', 'b'});
    expect(storage.grandfatheredWordCapIds, {'a', 'b'});
  });

  test('signed-in uid defaults to null, then persists and clears', () async {
    final storage = await Storage.open();
    expect(storage.loadSignedInUid(), isNull);
    await storage.saveSignedInUid('user-123');
    expect(storage.loadSignedInUid(), 'user-123');
    await storage.saveSignedInUid(null);
    expect(storage.loadSignedInUid(), isNull);
  });

  test(
    'a fresh install records the auto-seeded welcome script as the seed id',
    () async {
      final storage = await Storage.open();
      final scripts = storage.loadScripts();
      expect(scripts, hasLength(1));
      expect(storage.loadSeedScriptId(), scripts.single.id);
    },
  );

  test('seed script id is null when the library was not freshly seeded', () async {
    SharedPreferences.setMockInitialValues({'script_index': <String>[]});
    final storage = await Storage.open();
    expect(storage.loadSeedScriptId(), isNull);
  });
}
