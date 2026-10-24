import 'package:flutter_test/flutter_test.dart';
import 'package:aprompter/models/script.dart';
import 'package:aprompter/services/entitlements.dart';

Script _script({String id = 'a', int words = 10}) => Script(
  id: id,
  title: 't',
  body: List.filled(words, 'word').join(' '),
  updatedAt: DateTime(2026),
);

void main() {
  group('canCreateScript', () {
    test('allows the first free script', () {
      expect(canCreateScript([], false), isTrue);
    });

    test('blocks a second free script', () {
      expect(canCreateScript([_script()], false), isFalse);
    });

    test('never blocks an unlimited account, however many scripts exist', () {
      final many = [for (var i = 0; i < 5; i++) _script(id: '$i')];
      expect(canCreateScript(many, true), isTrue);
    });
  });

  group('canExceedWordCap', () {
    test('blocks a fresh script over the cap on free', () {
      expect(canExceedWordCap(false, isGrandfathered: false), isFalse);
    });

    test('allows a grandfathered script on free', () {
      expect(canExceedWordCap(false, isGrandfathered: true), isTrue);
    });

    test('always allows on unlimited, grandfathered or not', () {
      expect(canExceedWordCap(true, isGrandfathered: false), isTrue);
      expect(canExceedWordCap(true, isGrandfathered: true), isTrue);
    });
  });

  group('computeGrandfatheredIds', () {
    test('includes only scripts already over the cap', () {
      final under = _script(id: 'under', words: 10);
      final over = _script(id: 'over', words: maxFreeWords + 1);
      expect(computeGrandfatheredIds([under, over]), {'over'});
    });

    test('is empty when nothing is over the cap', () {
      expect(computeGrandfatheredIds([_script(words: 5)]), isEmpty);
    });
  });

  group('Entitlements', () {
    test('defaults to not unlimited and notifies on change', () {
      final entitlements = Entitlements();
      expect(entitlements.isUnlimited, isFalse);
      var notified = false;
      entitlements.addListener(() => notified = true);
      entitlements.setUnlimited(true);
      expect(entitlements.isUnlimited, isTrue);
      expect(notified, isTrue);
    });

    test('does not notify when set to the same value', () {
      final entitlements = Entitlements(isUnlimited: true);
      var notifyCount = 0;
      entitlements.addListener(() => notifyCount++);
      entitlements.setUnlimited(true);
      expect(notifyCount, 0);
    });
  });
}
