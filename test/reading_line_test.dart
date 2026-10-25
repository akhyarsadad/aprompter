// The reading line: where on the prompter the line being read sits. Phones
// have the front camera at the top, so it defaults close to it and can be
// moved (settings slider, or by dragging its left arrow while prompting).
import 'dart:convert';

import 'package:aprompter/l10n/l10n.dart';
import 'package:aprompter/main.dart';
import 'package:aprompter/models/prompter_settings.dart';
import 'package:aprompter/models/script.dart';
import 'package:aprompter/overlay/overlay_app.dart';
import 'package:aprompter/services/app_state.dart';
import 'package:aprompter/services/entitlements.dart';
import 'package:aprompter/services/purchase_service.dart';
import 'package:aprompter/services/storage.dart';
import 'package:aprompter/widgets/prompter_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _guideKey = ValueKey('reading-guide');
const _handleKey = ValueKey('reading-guide-handle');
const _sliderKey = ValueKey('reading-line-slider');
const _previewGuideKey = ValueKey('preview-reading-guide');

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  final en = lookupAppLocalizations(const Locale('en'));

  group('setting', () {
    test('defaults near the camera and round-trips through JSON', () {
      expect(const PrompterSettings().guidePosition, 0.15);
      const s = PrompterSettings(guidePosition: 0.42);
      expect(PrompterSettings.fromJson(s.toJson()).guidePosition, 0.42);
      expect(
        PrompterSettings.fromJson(
          jsonDecode(jsonEncode(s.toJson())) as Map<String, dynamic>,
        ).guidePosition,
        0.42,
      );
    });

    test('settings saved before it existed get the default', () {
      final old = const PrompterSettings(fontSize: 40).toJson()
        ..remove('guidePosition');
      final loaded = PrompterSettings.fromJson(old);
      expect(loaded.guidePosition, PrompterSettings.defaultGuidePosition);
      expect(loaded.fontSize, 40);
    });

    test('is clamped between 5% and 60% of the prompter', () {
      expect(
        PrompterSettings.fromJson({'guidePosition': 0.95}).guidePosition,
        0.6,
      );
      expect(
        PrompterSettings.fromJson({'guidePosition': -1}).guidePosition,
        0.05,
      );
      expect(
        PrompterSettings.fromJson({'guidePosition': 0}).guidePosition,
        0.05,
      );
      const s = PrompterSettings();
      expect(s.copyWith(guidePosition: 3).guidePosition, 0.6);
      expect(s.copyWith(guidePosition: 0.01).guidePosition, 0.05);
      expect(s.copyWith(guidePosition: 0.3).guidePosition, 0.3);
    });

    test('setup presets put the line where each setup reads', () {
      const s = PrompterSettings(guidePosition: 0.5);
      expect(SetupPreset.handheld.apply(s).guidePosition, 0.12);
      expect(SetupPreset.tripod.apply(s).guidePosition, 0.25);
      expect(SetupPreset.glass.apply(s).guidePosition, 0.4);
    });

    test('a line moved in the floating window reaches the app', () async {
      final state = AppState(await Storage.open());
      final storage = await Storage.open();
      await storage.saveSettings(
        state.settings.copyWith(guidePosition: 0.33, wpm: 170),
      );
      await state.reloadSettings();
      expect(state.settings.guidePosition, 0.33);
      expect(state.settings.wpm, 170);
    });
  });

  group('prompter', () {
    const height = 400.0;
    final body = [
      '# Intro',
      List.filled(60, 'one').join(' '),
      '# Second',
      List.filled(60, 'two').join(' '),
    ].join('\n');

    Future<void> pump(
      WidgetTester tester,
      PrompterController controller, {
      PrompterSettings settings = const PrompterSettings(),
      ValueChanged<double>? onGuidePositionChanged,
      String? text,
    }) => tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Center(
          child: SizedBox(
            width: 360,
            height: height,
            child: PrompterView(
              text: text ?? body,
              settings: settings,
              controller: controller,
              onGuidePositionChanged: onGuidePositionChanged,
            ),
          ),
        ),
      ),
    );

    double top(WidgetTester tester, Finder f) =>
        tester.getTopLeft(f).dy -
        tester.getTopLeft(find.byType(PrompterView)).dy;

    EdgeInsets padding(WidgetTester tester) =>
        tester
                .widget<SingleChildScrollView>(
                  find.descendant(
                    of: find.byType(PrompterView),
                    matching: find.byType(SingleChildScrollView),
                  ),
                )
                .padding!
            as EdgeInsets;

    for (final fraction in [0.15, 0.05, 0.4, 0.6]) {
      testWidgets('guide and scroll padding sit at $fraction', (tester) async {
        final controller = PrompterController();
        addTearDown(controller.dispose);
        await pump(
          tester,
          controller,
          settings: PrompterSettings(guidePosition: fraction),
        );
        // The marker row starts 2 dp above the line.
        expect(
          top(tester, find.byKey(_guideKey)),
          closeTo(height * fraction - 2, 0.01),
        );
        final p = padding(tester);
        expect(p.top, closeTo(height * fraction, 0.01));
        expect(p.bottom, closeTo(height * (1 - fraction), 0.01));
        // The first line starts on the reading line.
        expect(
          top(tester, find.text('Intro')),
          closeTo(height * fraction, 0.5),
        );
      });
    }

    testWidgets('section jumps land on the configured line', (tester) async {
      final controller = PrompterController();
      addTearDown(controller.dispose);
      await pump(
        tester,
        controller,
        settings: const PrompterSettings(guidePosition: 0.45),
      );
      controller.jumpToSection(1);
      await tester.pump();
      expect(top(tester, find.text('Second')), closeTo(height * 0.45, 0.5));
    });

    testWidgets('dragging the left arrow moves the line, saved on release', (
      tester,
    ) async {
      final controller = PrompterController();
      addTearDown(controller.dispose);
      final saved = <double>[];
      await pump(tester, controller, onGuidePositionChanged: saved.add);
      final handle = find.byKey(_handleKey);
      expect(tester.getSize(handle), const Size(48, 48));
      final scrollable = tester.state<ScrollableState>(
        find.descendant(
          of: find.byType(PrompterView),
          matching: find.byType(Scrollable),
        ),
      );

      final gesture = await tester.startGesture(tester.getCenter(handle));
      await gesture.moveBy(const Offset(0, 40));
      await gesture.moveBy(const Offset(0, 40));
      await tester.pump();
      // Live while dragging, the text follows; nothing saved yet.
      expect(
        top(tester, find.byKey(_guideKey)),
        closeTo(height * 0.35 - 2, 0.5),
      );
      expect(top(tester, find.text('Intro')), closeTo(height * 0.35, 0.5));
      expect(saved, isEmpty);
      await gesture.up();
      await tester.pump();

      expect(saved, [0.35]);
      // Not a scroll, not a tap.
      expect(scrollable.position.pixels, 0);
      expect(controller.playing, isFalse);
      expect(controller.jumpedDuringRun, isFalse);
    });

    testWidgets('the line stays inside the prompter', (tester) async {
      final controller = PrompterController();
      addTearDown(controller.dispose);
      final saved = <double>[];
      await pump(tester, controller, onGuidePositionChanged: saved.add);
      await tester.drag(find.byKey(_handleKey), const Offset(0, -300));
      await tester.pump();
      expect(saved.last, PrompterSettings.minGuidePosition);
      await pump(
        tester,
        controller,
        settings: const PrompterSettings(guidePosition: 0.05),
        onGuidePositionChanged: saved.add,
      );
      // Even at the very top the handle keeps its full 48 dp inside.
      expect(top(tester, find.byKey(_handleKey)), greaterThanOrEqualTo(0));
      await tester.drag(find.byKey(_handleKey), const Offset(0, 600));
      await tester.pump();
      expect(saved.last, PrompterSettings.maxGuidePosition);
    });

    testWidgets('other gestures keep working around the handle', (
      tester,
    ) async {
      final controller = PrompterController();
      addTearDown(controller.dispose);
      final saved = <double>[];
      await pump(tester, controller, onGuidePositionChanged: saved.add);
      final handle = tester.getRect(find.byKey(_handleKey));

      // A drag anywhere else still scrolls the text.
      final scrollable = tester.state<ScrollableState>(
        find.descendant(
          of: find.byType(PrompterView),
          matching: find.byType(Scrollable),
        ),
      );
      await tester.dragFrom(
        tester.getCenter(find.byType(PrompterView)),
        const Offset(0, -60),
      );
      await tester.pump();
      expect(scrollable.position.pixels, greaterThan(0));
      expect(saved, isEmpty);

      // A tap on the handle still plays, outside the edge dead zone...
      await tester.tapAt(Offset(handle.left + 40, handle.center.dy));
      await tester.pump();
      expect(controller.playing, isTrue);
      controller.pause();
      // ...and is ignored at the very edge, like everywhere else (R1).
      await tester.tapAt(Offset(handle.left + 8, handle.center.dy));
      await tester.pump();
      expect(controller.playing, isFalse);
      expect(saved, isEmpty);
    });

    testWidgets('a take starting mid-drag drops the unsaved line', (
      tester,
    ) async {
      final controller = PrompterController();
      addTearDown(controller.dispose);
      final saved = <double>[];
      await pump(tester, controller, onGuidePositionChanged: saved.add);
      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(_handleKey)),
      );
      await gesture.moveBy(const Offset(0, 80));
      await tester.pump();
      expect(
        top(tester, find.byKey(_guideKey)),
        closeTo(height * 0.35 - 2, 0.5),
      );
      // Record turns the handle off while recording.
      await pump(tester, controller);
      expect(
        top(tester, find.byKey(_guideKey)),
        closeTo(height * 0.15 - 2, 0.5),
      );
      await gesture.up();
      await tester.pump();
      expect(saved, isEmpty);
      expect(
        top(tester, find.byKey(_guideKey)),
        closeTo(height * 0.15 - 2, 0.5),
      );
    });

    testWidgets('no handle without the guide or without a callback', (
      tester,
    ) async {
      final controller = PrompterController();
      addTearDown(controller.dispose);
      await pump(
        tester,
        controller,
        settings: const PrompterSettings(showGuide: false),
        onGuidePositionChanged: (_) {},
      );
      expect(find.byKey(_guideKey), findsNothing);
      expect(find.byKey(_handleKey), findsNothing);
      // Text still starts at the configured line.
      expect(padding(tester).top, closeTo(height * 0.15, 0.01));

      await pump(tester, controller);
      expect(find.byKey(_guideKey), findsOneWidget);
      expect(find.byKey(_handleKey), findsNothing);
    });

    testWidgets('screen readers move the line like a slider', (tester) async {
      final handle = tester.ensureSemantics();
      final controller = PrompterController();
      addTearDown(controller.dispose);
      final saved = <double>[];
      await pump(tester, controller, onGuidePositionChanged: saved.add);
      final node = find.semantics.byLabel(en.readingLine);
      expect(node, findsOne);
      expect(
        tester.getSemantics(find.byKey(_handleKey)),
        matchesSemantics(
          label: en.readingLine,
          value: '15%',
          increasedValue: '20%',
          decreasedValue: '10%',
          isSlider: true,
          hasIncreaseAction: true,
          hasDecreaseAction: true,
        ),
      );
      tester.semantics.increase(node);
      await tester.pump();
      expect(saved, [0.2]);
      handle.dispose();
    });
  });

  group('app', () {
    Future<(AppState, Storage)> pumpApp(
      WidgetTester tester, {
      Map<String, Object> prefs = const {},
    }) async {
      SharedPreferences.setMockInitialValues(prefs);
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final storage = await Storage.open();
      final state = AppState(storage);
      final entitlements = Entitlements(isUnlimited: true);
      await tester.pumpWidget(
        AprompterApp(
          state: state,
          entitlements: entitlements,
          purchaseService: PurchaseService(entitlements: entitlements),
        ),
      );
      await tester.pumpAndSettle();
      return (state, storage);
    }

    Future<void> openLayout(WidgetTester tester, AppLocalizations l) async {
      await tester.tap(find.byTooltip(l.prompterSettings));
      await tester.pumpAndSettle();
      await tester.dragUntilVisible(
        find.byKey(_sliderKey),
        find.descendant(
          of: find.byType(BottomSheet),
          matching: find.byType(ListView),
        ),
        const Offset(0, -150),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('the settings slider moves the line and the preview', (
      tester,
    ) async {
      final (state, storage) = await pumpApp(tester);
      await openLayout(tester, en);
      expect(find.text(en.readingLineNearCamera), findsOneWidget);
      expect(find.text(en.readingLineMiddle), findsOneWidget);
      expect(find.text('15%'), findsOneWidget);
      final previewBefore = tester.getTopLeft(find.byKey(_previewGuideKey)).dy;

      await tester.drag(find.byKey(_sliderKey), const Offset(600, 0));
      await tester.pumpAndSettle();
      expect(state.settings.guidePosition, PrompterSettings.maxGuidePosition);
      expect(
        storage.loadSettings().guidePosition,
        PrompterSettings.maxGuidePosition,
      );
      expect(find.text('60%'), findsOneWidget);
      // 150 dp preview: the marker moved down by (0.6 - 0.15) of it.
      expect(
        tester.getTopLeft(find.byKey(_previewGuideKey)).dy - previewBefore,
        closeTo(150 * 0.45, 0.5),
      );

      await tester.drag(find.byKey(_sliderKey), const Offset(-600, 0));
      await tester.pumpAndSettle();
      expect(state.settings.guidePosition, PrompterSettings.minGuidePosition);
    });

    testWidgets('right to left, "near camera" is at the slider\'s start', (
      tester,
    ) async {
      final (state, _) = await pumpApp(tester, prefs: {'app_locale': 'ar'});
      final ar = lookupAppLocalizations(const Locale('ar'));
      await openLayout(tester, ar);
      final near = tester.getCenter(find.text(ar.readingLineNearCamera)).dx;
      final middle = tester.getCenter(find.text(ar.readingLineMiddle)).dx;
      expect(near, greaterThan(middle));
      // Dragging towards "middle" (left) lowers the line.
      await tester.drag(find.byKey(_sliderKey), const Offset(-600, 0));
      await tester.pumpAndSettle();
      expect(state.settings.guidePosition, PrompterSettings.maxGuidePosition);
    });

    testWidgets('dragging the line in Rehearse is kept', (tester) async {
      final (state, storage) = await pumpApp(tester);
      await tester.tap(find.text(en.rehearse).first);
      await tester.pumpAndSettle();
      final view = find.byType(PrompterView);
      final h = tester.getSize(view).height;
      final guideBefore = tester.getTopLeft(find.byKey(_guideKey)).dy;

      await tester.drag(find.byKey(_handleKey), const Offset(0, 120));
      await tester.pumpAndSettle();

      final expected = ((0.15 + 120 / h) * 100).round() / 100;
      expect(state.settings.guidePosition, closeTo(expected, 0.0001));
      expect(
        storage.loadSettings().guidePosition,
        state.settings.guidePosition,
      );
      expect(
        tester.getTopLeft(find.byKey(_guideKey)).dy - guideBefore,
        closeTo((expected - 0.15) * h, 0.5),
      );
      // The drag neither started the countdown nor scrolled.
      expect(find.byType(Countdown), findsNothing);
      expect(find.byIcon(Icons.pause_circle), findsOneWidget);
    });
  });

  testWidgets('the floating window keeps a line moved there for the app', (
    tester,
  ) async {
    final script = Script(
      id: 's',
      title: 'Float',
      body: 'Hello there',
      updatedAt: DateTime(2026),
    );
    SharedPreferences.setMockInitialValues({
      'active_script': jsonEncode(script.toJson()),
      'settings': jsonEncode(const PrompterSettings(wpm: 170).toJson()),
    });
    tester.view.physicalSize = const Size(360, 300);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(const OverlayApp());
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
    expect(find.byType(PrompterView), findsOneWidget);
    // Drags move the window there, so the arrow is not a drag handle...
    final handle = find.byKey(_handleKey);
    expect(
      find.descendant(of: handle, matching: find.byType(GestureDetector)),
      findsNothing,
    );
    // ...but screen readers can still move the line, and the app keeps it.
    tester.semantics.increase(find.semantics.byLabel(en.readingLine));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
    final storage = await Storage.open();
    expect(storage.loadSettings().guidePosition, 0.2);
    expect(storage.loadSettings().wpm, 170);
    semantics.dispose();
  });
}
