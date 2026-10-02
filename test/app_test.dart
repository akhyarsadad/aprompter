import 'package:aprompter/l10n/l10n.dart';
import 'package:aprompter/main.dart';
import 'package:aprompter/models/prompter_settings.dart';
import 'package:aprompter/models/script.dart';
import 'package:aprompter/services/app_state.dart';
import 'package:aprompter/services/auth_service.dart';
import 'package:aprompter/services/entitlements.dart';
import 'package:aprompter/services/storage.dart';
import 'package:aprompter/widgets/prompter_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<Storage> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final storage = await Storage.open();
    final entitlements = Entitlements();
    await tester.pumpWidget(
      AprompterApp(
        state: AppState(storage),
        entitlements: entitlements,
        authService: AuthService(entitlements: entitlements, storage: storage),
      ),
    );
    return storage;
  }

  testWidgets('J1/J2: create a script from a template with a target', (
    tester,
  ) async {
    final storage = await pumpApp(tester);
    expect(find.text('Welcome to APrompter'), findsOneWidget);

    await tester.tap(find.text('New script'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hook → Value → CTA'));
    await tester.pumpAndSettle();

    // Template sets a 60 s target and shows the timing bar.
    expect(find.textContaining('/ 1:00 at 150 wpm'), findsOneWidget);
    await tester.ensureVisible(find.text('30s'));
    await tester.tap(find.text('30s'));
    await tester.pump();
    expect(find.textContaining('/ 0:30'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'My video');
    await tester.tap(find.text('Emphasis'));
    await tester.pump();
    expect(
      tester.widget<TextField>(find.byType(TextField).last).controller!.text,
      contains('**'),
    );
    await tester.pageBack();
    await tester.pumpAndSettle();

    final saved = storage.loadScripts().firstWhere(
      (s) => s.title == 'My video',
    );
    expect(saved.targetSeconds, 30);
    expect(saved.sections, ['Hook', 'Value', 'CTA']);
    expect(find.text('My video'), findsOneWidget);
  });

  testWidgets('J7: filter by status', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Draft (0)'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome to APrompter'), findsNothing);
    await tester.ensureVisible(find.text('Ready (1)'));
    await tester.tap(find.text('Ready (1)'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome to APrompter'), findsOneWidget);
  });

  testWidgets('J4: settings sheet applies a setup preset', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byTooltip('Prompter settings'));
    await tester.pumpAndSettle();
    expect(find.text('Preview'), findsOneWidget);
    await tester.tap(find.text('Tripod / distance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Energetic 180'));
    await tester.pumpAndSettle();
    final state = tester
        .element(find.byType(Scaffold).first)
        .getInheritedWidgetOfExactType<AppScope>()!
        .notifier!;
    expect(state.settings.fontSize, 56);
    expect(state.settings.wpm, 180);
  });

  Widget prompter(PrompterController c, String text) => MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: SizedBox(
      height: 300,
      child: PrompterView(
        text: text,
        settings: const PrompterSettings(),
        controller: c,
      ),
    ),
  );

  testWidgets('J3: scroll time follows words per minute', (tester) async {
    final words = List.filled(60, 'word').join(' ');
    final controller = PrompterController(wpm: 120); // 60 words → 30 s
    await tester.pumpWidget(prompter(controller, words));
    final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
    final max = scrollable.position.maxScrollExtent;

    controller.play();
    await tester.pump();
    await tester.pump(const Duration(seconds: 15));
    expect(scrollable.position.pixels / max, closeTo(0.5, 0.05));
    expect(controller.progress.value, closeTo(0.5, 0.05));

    await tester.tap(find.byType(PrompterView)); // tap pauses
    await tester.pump(const Duration(seconds: 1));
    expect(controller.playing, isFalse);

    controller.restart();
    await tester.pump();
    expect(scrollable.position.pixels, 0);
  });

  testWidgets('J5/J6: remote keys and section jumps', (tester) async {
    final body = [
      '# Intro',
      List.filled(80, 'one').join(' '),
      '# Middle',
      List.filled(80, 'two').join(' '),
      '# End',
      'bye',
    ].join('\n');
    final controller = PrompterController();
    await tester.pumpWidget(prompter(controller, body));
    await tester.pump();
    final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));

    controller.jumpToSection(1);
    await tester.pump();
    final middle = scrollable.position.pixels;
    expect(middle, greaterThan(0));

    controller.nextSection();
    await tester.pump();
    expect(scrollable.position.pixels, greaterThan(middle));

    await tester.sendKeyEvent(LogicalKeyboardKey.pageUp);
    await tester.pump();
    expect(scrollable.position.pixels, closeTo(middle, 1));

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    expect(controller.wpm, 160);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(controller.playing, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.pageDown);
    expect(controller.playing, isFalse);
  });

  test('recordTake counts takes and marks recorded', () async {
    final state = AppState(await Storage.open());
    final id = state.scripts.first.id;
    await state.recordTake(id);
    expect(state.byId(id)!.takes, 1);
    expect(state.byId(id)!.status, ScriptStatus.recorded);
  });
}
