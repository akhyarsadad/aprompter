import 'package:aprompter/l10n/l10n.dart';
import 'package:aprompter/main.dart';
import 'package:aprompter/models/prompter_settings.dart';
import 'package:aprompter/models/templates.dart';
import 'package:aprompter/services/app_state.dart';
import 'package:aprompter/services/storage.dart';
import 'package:aprompter/widgets/prompter_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<AppState> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final state = AppState(await Storage.open());
    await tester.pumpWidget(AprompterApp(state: state));
    return state;
  }

  testWidgets('follows an Indonesian device language', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('id', 'ID')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await pumpApp(tester);
    expect(find.text('Naskah baru'), findsOneWidget);
    expect(find.text('Selamat datang di APrompter'), findsOneWidget);
    expect(find.text('Rekam'), findsOneWidget);

    await tester.tap(find.text('Naskah baru'));
    await tester.pumpAndSettle();
    expect(find.text('Review produk'), findsOneWidget);
  });

  testWidgets('delete can be undone', (tester) async {
    final state = await pumpApp(tester);
    await tester.tap(find.byIcon(Icons.more_vert).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(state.scripts, isEmpty);
    expect(find.text('No scripts yet'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(state.scripts, hasLength(1));
    expect(find.text('Welcome to APrompter'), findsOneWidget);
  });

  testWidgets('duplicate creates a fresh draft copy', (tester) async {
    final state = await pumpApp(tester);
    await tester.tap(find.byIcon(Icons.more_vert).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Duplicate'));
    await tester.pumpAndSettle();
    expect(state.scripts, hasLength(2));
    final copy = state.scripts.firstWhere((s) => s.title.endsWith('(copy)'));
    expect(copy.takes, 0);
    expect(copy.body, state.scripts.last.body);
    expect(find.text('Welcome to APrompter (copy)'), findsOneWidget);
  });

  testWidgets('pinch resizes text and keeps the reading position', (
    tester,
  ) async {
    var settings = const PrompterSettings(fontSize: 30);
    final controller = PrompterController();
    late StateSetter setState;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: SizedBox(
          height: 400,
          child: StatefulBuilder(
            builder: (context, set) {
              setState = set;
              return PrompterView(
                text: List.filled(300, 'word').join(' '),
                settings: settings,
                controller: controller,
                onFontSizeChanged: (v) =>
                    setState(() => settings = settings.copyWith(fontSize: v)),
              );
            },
          ),
        ),
      ),
    );
    final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
    scrollable.position.jumpTo(scrollable.position.maxScrollExtent / 2);
    await tester.pump();
    expect(controller.progress.value, closeTo(0.5, 0.01));

    final center = tester.getCenter(find.byType(PrompterView));
    final a = await tester.startGesture(center - const Offset(0, 40));
    final b = await tester.startGesture(center + const Offset(0, 40));
    await tester.pump();
    for (var i = 1; i <= 10; i++) {
      await a.moveTo(center - Offset(0, 40.0 + i * 4));
      await b.moveTo(center + Offset(0, 40.0 + i * 4));
      await tester.pump();
    }
    await a.up();
    await b.up();
    await tester.pumpAndSettle();

    expect(settings.fontSize, greaterThan(40));
    expect(controller.progress.value, closeTo(0.5, 0.05));
  });

  test('templates exist in both languages with sections', () {
    for (final locale in AppLocalizations.supportedLocales) {
      final l = lookupAppLocalizations(locale);
      final templates = scriptTemplates(l);
      expect(templates, hasLength(5));
      expect(templates[1].body, contains('# ${l.secHook}'));
    }
  });

  test('recording options survive a save', () {
    const s = PrompterSettings(
      videoQuality: VideoQuality.uhd,
      autoStopRecording: false,
    );
    final copy = PrompterSettings.fromJson(s.toJson());
    expect(copy.videoQuality, VideoQuality.uhd);
    expect(copy.autoStopRecording, isFalse);
    expect(const PrompterSettings().videoQuality, VideoQuality.fullHd);
  });
}
