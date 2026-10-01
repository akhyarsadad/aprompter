import 'package:aprompter/main.dart';
import 'package:aprompter/models/prompter_settings.dart';
import 'package:aprompter/services/app_state.dart';
import 'package:aprompter/services/storage.dart';
import 'package:aprompter/widgets/prompter_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('home shows welcome script and can create a new one', (
    tester,
  ) async {
    final storage = await Storage.open();
    await tester.pumpWidget(AprompterApp(state: AppState(storage)));
    expect(find.text('Welcome to APrompter'), findsOneWidget);
    expect(find.text('Record'), findsOneWidget);

    await tester.tap(find.text('New script'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'My video');
    await tester.enterText(find.byType(TextField).last, 'one two three');
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('My video'), findsOneWidget);
    expect(storage.loadScripts().map((s) => s.title), contains('My video'));
  });

  testWidgets('prompter scrolls while playing and stops when paused', (
    tester,
  ) async {
    final controller = PrompterController(speed: 100);
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          height: 300,
          child: PrompterView(
            text: List.filled(200, 'word').join(' '),
            settings: const PrompterSettings(),
            controller: controller,
          ),
        ),
      ),
    );
    final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
    expect(scrollable.position.pixels, 0);

    controller.play();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    final moved = scrollable.position.pixels;
    expect(moved, greaterThan(50));

    await tester.tap(find.byType(PrompterView)); // tap pauses
    await tester.pump(const Duration(seconds: 1));
    expect(controller.playing, isFalse);
    expect(scrollable.position.pixels, closeTo(moved, 1));

    controller.restart();
    await tester.pump();
    expect(scrollable.position.pixels, 0);
  });
}
