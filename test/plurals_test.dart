// Counts read right in every language: a "=1" branch is also picked for
// other numbers in some languages (Filipino: most of them; French,
// Portuguese and Hindi: 0), so it must not hard-code "1".
import 'package:aprompter/l10n/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  AppLocalizations l(String tag) => lookupAppLocalizations(Locale(tag));

  test('Filipino shows the real number', () {
    final fil = l('fil');
    expect(fil.trashHint(30), contains('30 araw'));
    expect(fil.trashHint(30), isNot(contains('1 araw')));
    expect(fil.importedNewScripts(2), 'Na-import ang 2 script');
    expect(fil.importedScripts(3), 'Na-restore ang 3 script');
    expect(fil.words(500), '500 salita');
    expect(fil.words(1), '1 salita');
    expect(fil.takes(10), '10 take');
    expect(fil.longSentences(5), startsWith('5 '));
    expect(fil.importFreeLimit(5), startsWith('Hanggang 5 script'));
  });

  test('no words is not "1 word" in French, Portuguese or Hindi', () {
    expect(l('fr').words(0), '0 mot');
    expect(l('pt').words(0), '0 palavras');
    expect(l('hi').words(0), '0 शब्द');
    expect(l('fr').words(1), '1 mot');
    expect(l('pt').words(1), '1 palavra');
    expect(l('hi').words(1), '1 शब्द');
    expect(l('fr').words(2), '2 mots');
  });

  test('Vietnamese "Retake" no longer reads as "Back"', () {
    expect(l('vi').retake, 'Quay lần nữa');
  });

  test('every language shows the number for counts other than 1', () {
    for (final locale in AppLocalizations.supportedLocales) {
      final s = lookupAppLocalizations(locale);
      // 2 is left out: Arabic and Hebrew have words for "two days".
      for (final n in [3, 5, 11, 21, 22, 30, 101, 500]) {
        for (final (name, text) in [
          ('words', s.words(n)),
          ('takes', s.takes(n)),
          ('longSentences', s.longSentences(n)),
          ('trashHint', s.trashHint(n)),
          ('importedScripts', s.importedScripts(n)),
          ('importedNewScripts', s.importedNewScripts(n)),
          ('importFreeLimit', s.importFreeLimit(n)),
        ]) {
          expect(text, contains('$n'), reason: '$locale $name($n)');
        }
      }
    }
  });
}
