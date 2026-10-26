// Saving takes to the gallery when iOS gives only limited photo access, and
// the Privacy Policy / Terms links every user can reach from Settings.
import 'package:aprompter/config/entitlements_config.dart';
import 'package:aprompter/l10n/l10n.dart';
import 'package:aprompter/main.dart';
import 'package:aprompter/services/app_state.dart';
import 'package:aprompter/services/entitlements.dart';
import 'package:aprompter/services/gallery.dart';
import 'package:aprompter/services/purchase_service.dart';
import 'package:aprompter/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gal/gal.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final en = lookupAppLocalizations(const Locale('en'));

  group('saving a take to the gallery', () {
    const gal = MethodChannel('gal');
    late List<String?> saves;

    /// The phone's answer to a save into [album] (null: no album).
    void phone(PlatformException? Function(String? album) answer) {
      saves = [];
      messenger.setMockMethodCallHandler(gal, (call) async {
        switch (call.method) {
          case 'hasAccess':
          case 'requestAccess':
            return true;
          case 'putVideo':
            final album = (call.arguments as Map)['album'] as String?;
            saves.add(album);
            final error = answer(album);
            if (error != null) throw error;
            return null;
        }
        return null;
      });
    }

    tearDown(() => messenger.setMockMethodCallHandler(gal, null));

    test('goes into the APrompter album when it can', () async {
      phone((_) => null);
      await saveTakeToGallery('/tmp/take.mp4');
      expect(saves, [takesAlbum]);
    });

    test('limited photo access: saved without the album', () async {
      // iOS refuses to find or make an album with limited access.
      phone(
        (album) =>
            album == null ? null : PlatformException(code: 'ACCESS_DENIED'),
      );
      await saveTakeToGallery('/tmp/take.mp4');
      expect(saves, [takesAlbum, null]);
    });

    test('a refusal or a full phone is still reported', () async {
      for (final code in ['ACCESS_DENIED', 'NOT_ENOUGH_SPACE']) {
        phone((_) => PlatformException(code: code));
        await expectLater(
          saveTakeToGallery('/tmp/take.mp4'),
          throwsA(isA<GalException>().having((e) => e.type.code, 'code', code)),
        );
        expect(saves, [takesAlbum, null]);
      }
    });
  });

  group('Privacy Policy and Terms of Use in Settings', () {
    const launcher = MethodChannel('plugins.flutter.io/url_launcher');
    late List<String> opened;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      opened = [];
      messenger.setMockMethodCallHandler(launcher, (call) async {
        if (call.method == 'launch') {
          opened.add((call.arguments as Map)['url'] as String);
        }
        return true;
      });
    });
    tearDown(() => messenger.setMockMethodCallHandler(launcher, null));

    for (final unlimited in [false, true]) {
      testWidgets('open from Settings (${unlimited ? 'Unlimited' : 'free'})', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(1080, 2340);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);
        final storage = await Storage.open();
        final entitlements = Entitlements(isUnlimited: unlimited);
        await tester.pumpWidget(
          AprompterApp(
            state: AppState(storage),
            entitlements: entitlements,
            purchaseService: PurchaseService(entitlements: entitlements),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip(en.prompterSettings));
        await tester.pumpAndSettle();

        for (final (title, url) in [
          (en.privacyPolicy, EntitlementsConfig.privacyUrl),
          (en.termsOfUse, EntitlementsConfig.termsUrl),
        ]) {
          final row = find.widgetWithText(ListTile, title);
          await tester.dragUntilVisible(
            row,
            find.descendant(
              of: find.byType(BottomSheet),
              matching: find.byType(ListView),
            ),
            const Offset(0, -300),
          );
          await tester.tap(row);
          await tester.pumpAndSettle();
          expect(opened.last, url);
        }
        expect(opened, hasLength(2));
      });
    }
  });
}
