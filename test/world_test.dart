import 'package:aprompter/l10n/l10n.dart';
import 'package:aprompter/main.dart';
import 'package:aprompter/models/prompter_settings.dart';
import 'package:aprompter/models/script_markup.dart';
import 'package:aprompter/services/app_state.dart';
import 'package:aprompter/services/storage.dart';
import 'package:aprompter/widgets/prompter_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('speaking time in any writing system', () {
    test('space-separated languages count words', () {
      expect(countWords('Hello brave new world'), 4);
      expect(countWords('مرحبا بالعالم'), 2); // Arabic
      expect(countWords('Привет, мир!'), 2); // Russian
      // Hindi vowel signs (matras) must not split words.
      expect(countWords('नमस्ते दुनिया'), 2);
      expect(countWords('வணக்கம் உலகம்'), 2); // Tamil
    });

    test('languages without spaces count characters', () {
      // 20 Chinese characters ≈ 10 English-word equivalents.
      expect(countWords('今天我们来聊一聊如何拍出更好的短视频吧朋'), 10);
      // Thai: one long run, not "1 word".
      expect(
        countWords('สวัสดีครับวันนี้เราจะมาเรียนรู้วิธีถ่ายวิดีโอ'),
        greaterThan(5),
      );
      // Japanese mixes kanji and kana.
      expect(countWords('こんにちは、今日は動画の撮り方を話します'), greaterThan(5));
    });

    test('long sentences are found with non-Latin punctuation', () {
      final long = List.filled(30, 'كلمة').join(' ');
      expect(longSentenceCount('$long؟ قصيرة.'), 1);
      final hindi = List.filled(30, 'शब्द').join(' ');
      expect(longSentenceCount('$hindi। छोटा।'), 1);
    });

    test('right-to-left detection follows most letters (R7)', () {
      expect(isRtlText('iPhone الجديد رائع جدا'), isTrue);
      expect(isRtlText('Read this: שלום'), isFalse);
      expect(isRtlText('שלום עולם'), isTrue);
      expect(isRtlText('2025 مرحبا'), isTrue);
      expect(isRtlText('سلام دنیا'), isTrue);
      expect(isRtlText('Hello مرحبا'), isFalse);
      expect(isRtlText('123'), isFalse);
    });
  });

  test('phone languages resolve to the right translation', () {
    Locale r(List<Locale> l) => resolveAppLocale(l);
    expect(r([const Locale('zh', 'TW')]).scriptCode, 'Hant');
    expect(r([const Locale('zh', 'HK')]).scriptCode, 'Hant');
    expect(
      r([Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')])
          .scriptCode,
      'Hant',
    );
    expect(r([const Locale('zh', 'CN')]), const Locale('zh'));
    expect(r([const Locale('pt', 'BR')]), const Locale('pt'));
    expect(r([const Locale('ar', 'EG')]), const Locale('ar'));
    expect(r([const Locale('nb', 'NO')]), const Locale('en'));
    expect(r([const Locale('nb'), const Locale('de')]), const Locale('de'));
  });

  test('every language has a native name and round-trips', () {
    for (final locale in AppLocalizations.supportedLocales) {
      final tag = localeTag(locale);
      expect(languageNames[tag], isNotNull, reason: tag);
      expect(parseLocaleTag(tag), locale);
    }
  });

  testWidgets('Arabic lines read right-to-left inside an English app', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: ScriptText(
          blocks: parseScript('# مقدمة\nمرحبا بالجميع\nHello everyone'),
          settings: const PrompterSettings(textAlign: TextAlign.left),
        ),
      ),
    );
    TextDirection? dir(String s) => tester
        .widgetList<RichText>(find.byType(RichText))
        .firstWhere((w) => w.text.toPlainText().contains(s))
        .textDirection;
    expect(dir('مرحبا'), TextDirection.rtl);
    expect(dir('Hello'), TextDirection.ltr);
    expect(dir('مقدمة'), TextDirection.rtl);
  });

  testWidgets('language picker switches the whole app', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final storage = await Storage.open();
    await tester.pumpWidget(AprompterApp(state: AppState(storage)));

    await tester.tap(find.byTooltip('Prompter settings'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).last, const Offset(0, -3000));
    await tester.pumpAndSettle();
    await tester.tap(find.text('App language'));
    await tester.pumpAndSettle();
    // Sorted by native name, so Español is near the top.
    await tester.tap(find.text('Español'));
    await tester.pumpAndSettle();
    expect(storage.loadLocale(), 'es');
    expect(find.text('Nuevo guion'), findsOneWidget);
  });

  // Every language on a small phone: no text may overflow its layout.
  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets('screens fit on a small phone in ${localeTag(locale)}', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({'app_locale': localeTag(locale)});
      tester.view.physicalSize = const Size(1080, 2220); // 360 x 740 dp
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final state = AppState(await Storage.open());
      await tester.pumpWidget(AprompterApp(state: state));
      await tester.pumpAndSettle();
      final l = lookupAppLocalizations(locale);
      expect(find.text(l.newScript), findsOneWidget);

      // Settings sheet, scrolled to the bottom.
      await tester.tap(find.byTooltip(l.prompterSettings));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(Scrollable).last, const Offset(0, -3000));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(180, 20)); // close sheet
      await tester.pumpAndSettle();

      // Template picker, then the editor.
      await tester.tap(find.text(l.newScript));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l.templateReview));
      await tester.pumpAndSettle();
      expect(find.text(l.toolSection), findsOneWidget);
      // pageBack() looks for the English "Back" tooltip.
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // The untouched template must not have been saved as a script.
      expect(state.scripts, hasLength(1));

      // Rehearse the welcome script (written in this language).
      await tester.tap(find.text(l.rehearse).first);
      await tester.pumpAndSettle();
      expect(find.byType(PrompterView), findsOneWidget);
    });
  }
}
