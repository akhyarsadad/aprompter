import 'package:aprompter/models/prompter_settings.dart';
import 'package:aprompter/services/floating_prompter.dart';
import 'package:aprompter/widgets/movable_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const area = Size(400, 800);

  test('prompter rect round-trips and stays on screen', () {
    const s = PrompterSettings();
    expect(s.prompterRect(area), const Rect.fromLTWH(0, 0, 400, 280));

    final moved = s.withPrompterRect(
      const Rect.fromLTWH(100, 400, 200, 200),
      area,
    );
    expect(moved.prompterRect(area), const Rect.fromLTWH(100, 400, 200, 200));

    // Dragged past the edge: pulled back inside.
    final off = s.withPrompterRect(
      const Rect.fromLTWH(-50, 900, 200, 200),
      area,
    );
    final r = off.prompterRect(area);
    expect(r.left, 0);
    expect(r.bottom, area.height);

    // Survives a save.
    expect(
      PrompterSettings.fromJson(moved.toJson()).prompterRect(area),
      moved.prompterRect(area),
    );
  });

  test('floating window reopens where it was, but never off screen', () {
    const screen = Size(400, 800);
    const window = Size(240, 300);
    expect(
      FloatingPrompter.startPosition(screen, window, null),
      const Offset(80, 32),
    );
    expect(
      FloatingPrompter.startPosition(screen, window, const Offset(10, 300)),
      const Offset(10, 300),
    );
    // Saved on a bigger screen / with a smaller window.
    expect(
      FloatingPrompter.startPosition(screen, window, const Offset(390, 790)),
      const Offset(160, 500),
    );
  });

  testWidgets('drag the grip to move, the corner to resize', (tester) async {
    var settings = const PrompterSettings();
    late StateSetter setState;
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox.fromSize(
            size: area,
            child: StatefulBuilder(
              builder: (context, set) {
                setState = set;
                return Stack(
                  children: [
                    MovablePrompterBox(
                      area: Offset.zero & area,
                      settings: settings,
                      onChanged: (s) => setState(() => settings = s),
                      child: const ColoredBox(color: Colors.black),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );

    // Shrink first so there is room to move sideways.
    await tester.drag(
      find.byKey(const ValueKey('prompter-resize')),
      const Offset(-160, 20),
    );
    await tester.pumpAndSettle();
    expect(settings.prompterRect(area).width, closeTo(240, 1));
    expect(settings.prompterRect(area).height, closeTo(300, 1));

    await tester.drag(
      find.byKey(const ValueKey('prompter-move')),
      const Offset(80, 300),
    );
    await tester.pumpAndSettle();
    final r = settings.prompterRect(area);
    expect(r.left, closeTo(80, 1));
    expect(r.top, closeTo(300, 1));
  });
}
