import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aprompter/services/storage.dart';

void main() {
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
}
