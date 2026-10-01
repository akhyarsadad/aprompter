import 'package:aprompter/overlay/overlay_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('floating prompter fits a narrow phone without overflow', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(320, 260);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const OverlayApp());
    await tester.pumpAndSettle();
    expect(find.text('Open a script in APrompter'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
