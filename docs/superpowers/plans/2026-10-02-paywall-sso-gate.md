# Paywall + SSO Gate Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a free/paid split to APrompter — 1 active script capped at 500 spoken words for free, unlocked via Apple/Google sign-in (as a cross-device/cross-store entitlement key, not for sync) plus RevenueCat-brokered subscription or lifetime purchase.

**Architecture:** RevenueCat (`purchases_flutter`) is the sole system of record for entitlement — no custom backend. `google_sign_in` + `sign_in_with_apple` authenticate the person; the resulting stable UID is handed to `Purchases.logIn(uid)` so entitlement follows them across devices and stores. All gating logic (script count, word cap, grandfathering) is pure Dart, independent of the SDKs, and lives in one new service file for easy unit testing.

**Tech Stack:** Flutter/Dart, `purchases_flutter: ^10.14.0`, `google_sign_in: ^7.2.0`, `sign_in_with_apple` (latest), `shared_preferences` (already a dependency, used for the new persisted flags).

**Spec:** `docs/superpowers/specs/2026-10-02-paywall-sso-gate-design.md`

## Global Constraints

- Free tier: exactly **1 active (non-deleted) script**, capped at **500 words** of `countWords(spokenText(body))` — the same count the editor's timing bar already shows.
- Grandfathering: a script that already had >500 words *before this ships* is never blocked from further editing. A script that crosses 500 words *after* this ships gets the banner. Pre-existing script count is never retroactively punished — only *creating a new* script beyond the limit is blocked.
- No custom backend. RevenueCat is the only entitlement source of truth.
- Real API keys/product IDs are supplied later by the user via a git-ignored config file (`lib/config/entitlements_config.dart`), mirroring the existing `android/key.properties` pattern in this repo. The example/template file is tracked; the real one is not.
- No Xcode/Android SDK is available to the implementer in this environment — `flutter analyze` and `flutter test` are the available verification; real purchases/sign-in need manual sandbox testing later and are out of scope for this plan's automated checks.

## Review Focus

- A free user who already has 5 pre-existing scripts before this ships: must keep all 5, untouched, but be blocked from creating a 6th. (Task 8)
- A free user's single pre-existing script that was already 2000 words before this ships: must stay fully editable, no banner, ever. (Tasks 2, 9)
- A free user's script that is under 500 words when this ships, then they type past 500 words later: banner appears, but typing itself is never hard-blocked (they can keep typing; it's a nudge, not a wall). (Task 9)
- Sign-in cancelled or denied by the person: must return silently to where they were, no crash, no error toast (this is a normal, frequent outcome). (Task 7's `_isCancellation` check — this one can't get an automated test without disproportionate DI scaffolding around two third-party SDKs; verified by code inspection in Task 7 plus manual sandbox testing, not a unit/widget test. Documented here rather than silently skipped.)
- A paid/unlimited user: every gate (`canCreateScript`, `canExceedWordCap`) must return "allowed" unconditionally, regardless of script count or grandfathering state. (Task 3)

---

## Task 1: Add paywall/SSO dependencies

**Files:**
- Modify: `pubspec.yaml`

**Interfaces:**
- Produces: `purchases_flutter`, `google_sign_in`, `sign_in_with_apple` packages available to all later tasks.

- [ ] **Step 1: Add the dependencies**

In `pubspec.yaml`, under `dependencies:` (after `local_auth: ^3.0.2`), add:

```yaml
  purchases_flutter: ^10.14.0
  google_sign_in: ^7.2.0
  sign_in_with_apple: ^7.0.1
```

- [ ] **Step 2: Fetch packages**

Run: `flutter pub get`
Expected: "Got dependencies!" with no errors. (Version warnings about other outdated packages are pre-existing and unrelated — ignore them.)

- [ ] **Step 3: Confirm analyze is still clean**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "Add RevenueCat, Google Sign-In and Sign in with Apple dependencies"
```

---

## Task 2: Storage additions — grandfathering and signed-in identity

**Files:**
- Modify: `lib/services/storage.dart`
- Test: `test/storage_entitlements_test.dart` (new)

**Interfaces:**
- Consumes: nothing new.
- Produces (for later tasks):
  - `Storage.wordCapMigrationDone` (bool getter)
  - `Storage.setWordCapMigrationDone()` (`Future<void>`)
  - `Storage.grandfatheredWordCapIds` (`Set<String>` getter)
  - `Storage.saveGrandfatheredWordCapIds(Set<String> ids)` (`Future<void>`)
  - `Storage.loadSignedInUid()` (`String?`)
  - `Storage.saveSignedInUid(String? uid)` (`Future<void>`)

- [ ] **Step 1: Write the failing tests**

Create `test/storage_entitlements_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apromter/services/storage.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('word cap migration flag defaults to false, then persists true', () async {
    final storage = await Storage.open();
    expect(storage.wordCapMigrationDone, isFalse);
    await storage.setWordCapMigrationDone();
    expect(storage.wordCapMigrationDone, isTrue);
  });

  test('grandfathered word cap ids default to empty, then persist', () async {
    final storage = await Storage.open();
    expect(storage.grandfatheredWordCapIds, isEmpty);
    await storage.saveGrandfatheredWordCapIds({'a', 'b'});
    expect(storage.grandfatheredWordCapIds, {'a', 'b'});
  });

  test('signed-in uid defaults to null, then persists and clears', () async {
    final storage = await Storage.open();
    expect(storage.loadSignedInUid(), isNull);
    await storage.saveSignedInUid('user-123');
    expect(storage.loadSignedInUid(), 'user-123');
    await storage.saveSignedInUid(null);
    expect(storage.loadSignedInUid(), isNull);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/storage_entitlements_test.dart`
Expected: FAIL — `wordCapMigrationDone` (and the others) are not defined on `Storage`.

- [ ] **Step 3: Implement**

In `lib/services/storage.dart`, add after the existing `_cameraIntroKey` block (around line 356, right before `static const _mySetupKey`):

```dart
  static const _wordCapMigrationKey = 'word_cap_migration_done';

  /// Whether the one-time free-word-cap grandfathering snapshot has run.
  bool get wordCapMigrationDone =>
      _prefs.getBool(_wordCapMigrationKey) ?? false;
  Future<void> setWordCapMigrationDone() =>
      _prefs.setBool(_wordCapMigrationKey, true);

  static const _grandfatheredWordCapKey = 'grandfathered_word_cap_ids';

  /// Script ids exempt from the free word cap because they already had
  /// more than the cap's words before the paywall shipped.
  Set<String> get grandfatheredWordCapIds =>
      (_prefs.getStringList(_grandfatheredWordCapKey) ?? const []).toSet();

  Future<void> saveGrandfatheredWordCapIds(Set<String> ids) =>
      _prefs.setStringList(_grandfatheredWordCapKey, ids.toList());

  static const _signedInUidKey = 'signed_in_uid';

  /// The signed-in person's stable identity (Apple/Google), or null.
  String? loadSignedInUid() => _prefs.getString(_signedInUidKey);

  Future<void> saveSignedInUid(String? uid) => uid == null
      ? _prefs.remove(_signedInUidKey)
      : _prefs.setString(_signedInUidKey, uid);
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/storage_entitlements_test.dart`
Expected: PASS (3 tests).

- [ ] **Step 5: Commit**

```bash
git add lib/services/storage.dart test/storage_entitlements_test.dart
git commit -m "Add storage support for word-cap grandfathering and signed-in identity"
```

---

## Task 3: Entitlements service — pure gate logic + ChangeNotifier

**Files:**
- Create: `lib/services/entitlements.dart`
- Test: `test/entitlements_test.dart` (new)

**Interfaces:**
- Consumes: `Script` (`lib/models/script.dart`) — uses `script.id`, `script.wordCount`.
- Produces (for later tasks):
  - `const maxFreeScripts = 1`
  - `const maxFreeWords = 500`
  - `bool canCreateScript(List<Script> scripts, bool isUnlimited)`
  - `bool canExceedWordCap(bool isUnlimited, {required bool isGrandfathered})`
  - `Set<String> computeGrandfatheredIds(List<Script> scripts)`
  - `class Entitlements extends ChangeNotifier` with `bool get isUnlimited`, `void setUnlimited(bool value)`
  - `class EntitlementsScope extends InheritedNotifier<Entitlements>` with `.of(context)` / `.read(context)`, mirroring `AppScope` in `lib/services/app_state.dart:320-330`.

- [ ] **Step 1: Write the failing tests**

Create `test/entitlements_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:apromter/models/script.dart';
import 'package:apromter/services/entitlements.dart';

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
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/entitlements_test.dart`
Expected: FAIL — `package:apromter/services/entitlements.dart` does not exist.

- [ ] **Step 3: Implement**

Create `lib/services/entitlements.dart`:

```dart
import 'package:flutter/widgets.dart';

import '../models/script.dart';

/// Free tier: at most this many active scripts…
const maxFreeScripts = 1;

/// …each capped at this many spoken words (counted the same way the
/// editor's timing bar already does: [countWords] of [spokenText]).
const maxFreeWords = 500;

/// Whether a free account may create one more script. Always true once
/// [isUnlimited] (a paid account never has a script-count limit).
bool canCreateScript(List<Script> scripts, bool isUnlimited) =>
    isUnlimited || scripts.length < maxFreeScripts;

/// Whether a script may keep growing past [maxFreeWords]. [isGrandfathered]
/// is true only for a script that already had more than the cap's words
/// before the paywall shipped — it stays exempt forever, even on free.
bool canExceedWordCap(bool isUnlimited, {required bool isGrandfathered}) =>
    isUnlimited || isGrandfathered;

/// Ids of scripts that already exceed [maxFreeWords] — computed once at
/// migration time, before the gate can affect anyone's existing writing.
Set<String> computeGrandfatheredIds(List<Script> scripts) => {
  for (final s in scripts)
    if (s.wordCount > maxFreeWords) s.id,
};

/// Whether this device currently has the "unlimited" entitlement. Backed by
/// RevenueCat elsewhere ([lib/services/auth_service.dart]); this class only
/// holds the resulting bool so the rest of the app never touches RevenueCat
/// types directly.
class Entitlements extends ChangeNotifier {
  Entitlements({bool isUnlimited = false}) : _isUnlimited = isUnlimited;

  bool _isUnlimited;
  bool get isUnlimited => _isUnlimited;

  void setUnlimited(bool value) {
    if (_isUnlimited == value) return;
    _isUnlimited = value;
    notifyListeners();
  }
}

/// Makes [Entitlements] available to the widget tree, the same shape as
/// `AppScope` in `lib/services/app_state.dart`.
class EntitlementsScope extends InheritedNotifier<Entitlements> {
  const EntitlementsScope({
    super.key,
    required Entitlements entitlements,
    required super.child,
  }) : super(notifier: entitlements);

  static Entitlements of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<EntitlementsScope>()!
          .notifier!;

  static Entitlements read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<EntitlementsScope>()!.notifier!;
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/entitlements_test.dart`
Expected: PASS (9 tests).

- [ ] **Step 5: Commit**

```bash
git add lib/services/entitlements.dart test/entitlements_test.dart
git commit -m "Add entitlements service: pure gate logic + Entitlements notifier"
```

---

## Task 4: Placeholder config file (mirrors `android/key.properties`)

**Files:**
- Create: `lib/config/entitlements_config.dart.example`
- Create: `lib/config/entitlements_config.dart` (git-ignored, seeded with placeholders so the app compiles)
- Modify: `.gitignore`

**Interfaces:**
- Produces: `class EntitlementsConfig` with `revenueCatApiKeyIos`, `revenueCatApiKeyAndroid`, `entitlementId`, `googleServerClientId` — consumed by Task 5 (`auth_service.dart`) and Task 6 (`main.dart`).

- [ ] **Step 1: Create the tracked example file**

Create `lib/config/entitlements_config.dart.example`:

```dart
/// Copy this file to `entitlements_config.dart` in the same folder
/// (git-ignored) and fill in your own identifiers. See README.md →
/// "Paywall setup" for where each value comes from.
class EntitlementsConfig {
  /// RevenueCat public SDK key for iOS (RevenueCat dashboard → Project →
  /// API keys → Apple App Store).
  static const revenueCatApiKeyIos = 'REPLACE_WITH_IOS_REVENUECAT_API_KEY';

  /// RevenueCat public SDK key for Android (…→ API keys → Google Play).
  static const revenueCatApiKeyAndroid =
      'REPLACE_WITH_ANDROID_REVENUECAT_API_KEY';

  /// The RevenueCat entitlement identifier that means "unlimited" (set up
  /// under Project → Entitlements in the RevenueCat dashboard).
  static const entitlementId = 'unlimited';

  /// Google OAuth web client id (Google Cloud Console → Credentials →
  /// OAuth 2.0 Client IDs → Web client), required by google_sign_in.
  static const googleServerClientId =
      'REPLACE_WITH_GOOGLE_WEB_CLIENT_ID.apps.googleusercontent.com';
}
```

- [ ] **Step 2: Create the working (git-ignored) copy**

```bash
cp lib/config/entitlements_config.dart.example lib/config/entitlements_config.dart
```

This keeps the same placeholder values — the app compiles and all local tests pass, but real sign-in/purchases won't work until the user supplies real values (same as this repo's existing `android/key.properties` story in the README).

- [ ] **Step 3: Git-ignore the real file**

In `.gitignore`, add under the "Flutter/Dart/Pub related" section:

```
# Paywall/SSO config (real keys) — copy from entitlements_config.dart.example
lib/config/entitlements_config.dart
```

- [ ] **Step 4: Verify analyze is still clean**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 5: Commit**

```bash
git add lib/config/entitlements_config.dart.example .gitignore
git commit -m "Add git-ignored config placeholder for RevenueCat/Google identifiers"
```

Note: `lib/config/entitlements_config.dart` itself is intentionally **not** committed (it's git-ignored) — this step only commits the tracked example and the `.gitignore` change. The working copy stays on disk for the remaining tasks to compile against.

---

## Task 5: Auth service — Apple/Google sign-in tied to RevenueCat

**Files:**
- Create: `lib/services/auth_service.dart`
- Modify: `pubspec.yaml` is already done (Task 1)

**Interfaces:**
- Consumes: `Entitlements` (Task 3), `EntitlementsConfig` (Task 4), `Storage.loadSignedInUid` / `saveSignedInUid` (Task 2).
- Produces: `class AuthService` with:
  - `AuthService({required Entitlements entitlements, required Storage storage})`
  - `String? get signedInUid`
  - `Future<void> restoreSession()` — call once at startup
  - `Future<void> signInWithGoogle()`
  - `Future<void> signInWithApple()`
  - `Future<void> signOut()`
  - `class AuthServiceScope extends InheritedWidget` with `.of(context)`

This task has no automated test: it is a thin wrapper over three SDKs that each require a real device/account to exercise. Its logic is deliberately kept to "glue" (no branching worth unit-testing) — anything decision-worthy (the gate math) already lives in Task 3's pure functions.

- [ ] **Step 1: Implement**

Create `lib/services/auth_service.dart`:

```dart
import 'package:google_sign_in/google_sign_in.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/widgets.dart';

import '../config/entitlements_config.dart';
import 'entitlements.dart';
import 'storage.dart';

/// Signs in with Apple or Google purely to give RevenueCat a stable
/// identity, so a purchase is recognized across devices and across the
/// App Store / Play Store boundary. Not used for cloud sync of scripts.
class AuthService {
  AuthService({required this.entitlements, required this.storage});

  final Entitlements entitlements;
  final Storage storage;

  String? _uid;
  String? get signedInUid => _uid;

  bool _googleInitialized = false;

  Future<void> _ensureGoogleInitialized() async {
    if (_googleInitialized) return;
    await GoogleSignIn.instance.initialize(
      serverClientId: EntitlementsConfig.googleServerClientId,
    );
    _googleInitialized = true;
  }

  /// Call once at startup: if a session was persisted, re-establish it with
  /// RevenueCat silently, no user action.
  Future<void> restoreSession() async {
    final uid = storage.loadSignedInUid();
    if (uid == null) return;
    await _logIn(uid);
  }

  Future<void> signInWithGoogle() async {
    await _ensureGoogleInitialized();
    if (!GoogleSignIn.instance.supportsAuthenticate()) return;
    final account = await GoogleSignIn.instance.authenticate();
    await _logIn(account.id);
  }

  Future<void> signInWithApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: const [AppleIDAuthorizationScopes.email],
    );
    final uid = credential.userIdentifier;
    if (uid == null) return;
    await _logIn(uid);
  }

  Future<void> _logIn(String uid) async {
    _uid = uid;
    await storage.saveSignedInUid(uid);
    final result = await Purchases.logIn(uid);
    _applyCustomerInfo(result.customerInfo);
  }

  Future<void> signOut() async {
    _uid = null;
    await storage.saveSignedInUid(null);
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {
      // Not signed in with Google, or already signed out — fine either way.
    }
    final info = await Purchases.logOut();
    _applyCustomerInfo(info);
  }

  void _applyCustomerInfo(CustomerInfo info) {
    entitlements.setUnlimited(
      info.entitlements.active.containsKey(EntitlementsConfig.entitlementId),
    );
  }
}

/// Makes a single, app-lifetime [AuthService] available to the widget tree.
/// Plain [InheritedWidget], not [InheritedNotifier]: the service's identity
/// never changes — entitlement changes flow through [Entitlements] instead.
class AuthServiceScope extends InheritedWidget {
  const AuthServiceScope({
    super.key,
    required this.service,
    required super.child,
  });

  final AuthService service;

  @override
  bool updateShouldNotify(AuthServiceScope oldWidget) => false;

  static AuthService of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AuthServiceScope>()!.service;
}
```

- [ ] **Step 2: Verify analyze is clean**

Run: `flutter analyze`
Expected: `No issues found!` (This step will surface any mismatch between the exact `purchases_flutter`/`google_sign_in`/`sign_in_with_apple` API shown above and whatever version `flutter pub get` actually resolved in Task 1 — fix any such mismatch here against the resolved package's own `.dart` sources under `.dart_tool/`/the pub cache before moving on, since this is glue code with no test to catch it otherwise.)

- [ ] **Step 3: Commit**

```bash
git add lib/services/auth_service.dart
git commit -m "Add AuthService: Apple/Google sign-in tied to RevenueCat identity"
```

---

## Task 6: Wire startup — RevenueCat configure, scopes, silent restore, migration

**Files:**
- Modify: `lib/main.dart`

**Interfaces:**
- Consumes: `Entitlements`/`EntitlementsScope` (Task 3), `AuthService`/`AuthServiceScope` (Task 5), `EntitlementsConfig` (Task 4), `AppState.runWordCapMigrationIfNeeded`/`isGrandfatheredWordCap` (added in this task, since they belong next to the rest of `AppState`).

**Files (added to this task):**
- Modify: `lib/services/app_state.dart`

- [ ] **Step 1: Add the migration + grandfathering getter to `AppState`**

In `lib/services/app_state.dart`, add the import:

```dart
import 'entitlements.dart';
```

and this method, placed right after the constructor (before `final Storage storage;` stays where it is — add below the existing `bool _saveFailed = false;` field, i.e. right before `/// The last write...`):

```dart
  /// One-time: scripts already over the free word cap before the paywall
  /// shipped stay editable forever. Call once at startup, before the first
  /// frame — see `main()`.
  Future<void> runWordCapMigrationIfNeeded() async {
    if (storage.wordCapMigrationDone) return;
    await storage.saveGrandfatheredWordCapIds(computeGrandfatheredIds(_scripts));
    await storage.setWordCapMigrationDone();
  }

  /// Whether script [id] is exempt from the free word cap (Task 2/3).
  bool isGrandfatheredWordCap(String id) =>
      storage.grandfatheredWordCapIds.contains(id);
```

- [ ] **Step 2: Wire `main()`**

Replace the body of `main()` in `lib/main.dart`:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Content is filmed vertically (Reels, TikTok, Shorts); prompting screens
  // also allow landscape, tablets allow everything.
  await Orientations.app();
  final storage = await Storage.open();
  final state = AppState(storage);
  await state.runWordCapMigrationIfNeeded();

  await Purchases.setLogLevel(LogLevel.warn);
  await Purchases.configure(
    PurchasesConfiguration(
      defaultTargetPlatform == TargetPlatform.iOS
          ? EntitlementsConfig.revenueCatApiKeyIos
          : EntitlementsConfig.revenueCatApiKeyAndroid,
    ),
  );
  final entitlements = Entitlements();
  final authService = AuthService(entitlements: entitlements, storage: storage);
  await authService.restoreSession();

  runApp(
    AprompterApp(state: state, entitlements: entitlements, authService: authService),
  );
}
```

Add the imports this needs, at the top of `lib/main.dart`:

```dart
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:purchases_flutter/purchases_flutter.dart';

import 'config/entitlements_config.dart';
import 'services/auth_service.dart';
import 'services/entitlements.dart';
```

- [ ] **Step 3: Thread the new objects through `AprompterApp`**

Still in `lib/main.dart`, change the `AprompterApp` class:

```dart
class AprompterApp extends StatelessWidget {
  const AprompterApp({
    super.key,
    required this.state,
    required this.entitlements,
    required this.authService,
  });

  final AppState state;
  final Entitlements entitlements;
  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF7C4DFF);
    return AuthServiceScope(
      service: authService,
      child: EntitlementsScope(
        entitlements: entitlements,
        child: AppScope(
          state: state,
          child: ListenableBuilder(
            listenable: state,
            builder: (context, _) => MaterialApp(
              onGenerateTitle: (context) => context.l10n.appTitle,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: state.locale,
              localeListResolutionCallback: (locales, _) =>
                  resolveAppLocale(locales),
              debugShowCheckedModeBanner: false,
              theme: ThemeData(colorSchemeSeed: seed, useMaterial3: true),
              darkTheme: ThemeData(
                colorSchemeSeed: seed,
                brightness: Brightness.dark,
                useMaterial3: true,
              ),
              home: const HomeScreen(),
              builder: (context, child) => Column(
                children: [
                  if (state.saveFailed) const _SaveFailedBanner(),
                  Expanded(
                    // The banner already sits under the status bar.
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: state.saveFailed,
                      child: AppLockGate(child: child!),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

(Only the constructor and the opening/closing wrapper widgets change; `_SaveFailedBanner` and everything else in the file stays as-is.)

- [ ] **Step 4: Run the full test suite**

Run: `flutter test`
Expected: all existing tests still PASS. (`AprompterApp` now requires `entitlements`/`authService` — if any existing test constructs `AprompterApp` directly, it will fail to compile; fix each such call site by passing `Entitlements()` and `AuthService(entitlements: Entitlements(), storage: <that test's storage>)`, matching how the test already constructs its `AppState`.)

- [ ] **Step 5: Verify analyze is clean**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 6: Commit**

```bash
git add lib/main.dart lib/services/app_state.dart
git commit -m "Wire RevenueCat configuration, entitlements and auth into app startup"
```

---

## Task 7: Paywall + sign-in sheet

**Files:**
- Create: `lib/screens/paywall_screen.dart`

**Interfaces:**
- Consumes: `AuthServiceScope` (Task 5), `EntitlementsScope` (Task 3).
- Produces: `Future<bool> showUpgradeFlow(BuildContext context)` — returns `true` once `entitlements.isUnlimited` becomes true during the flow, `false` if the person backs out. Used by Task 8 and Task 9.

This task also has no automated test (it is purchase-flow UI exercising RevenueCat's `getOfferings`/`purchasePackage`, which need a real store connection). Task 8/9's widget tests exercise the *calling* code with a fake entitlements notifier instead of actually opening this sheet.

Note: the spec's design lists a separate `sign_in_screen.dart`; this task folds it into this file as `_SignInSheet` instead, since the two sheets are small, always used together as one flow, and share no state with anything else — "files that change together live together." If you'd rather keep them physically separate, that's a pure file-split with no behavior change; either is fine.

- [ ] **Step 1: Implement**

Create `lib/screens/paywall_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../l10n/l10n.dart';
import '../services/auth_service.dart';
import '../services/entitlements.dart';

/// Shows sign-in first if needed, then the plan picker. Returns true once
/// the person ends up unlimited (bought, restored, or already was).
Future<bool> showUpgradeFlow(BuildContext context) async {
  final entitlements = EntitlementsScope.read(context);
  if (entitlements.isUnlimited) return true;
  final auth = AuthServiceScope.of(context);
  if (auth.signedInUid == null) {
    final signedIn = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) => const _SignInSheet(),
    );
    if (signedIn != true || !context.mounted) return entitlements.isUnlimited;
  }
  if (!context.mounted) return entitlements.isUnlimited;
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => const _PaywallSheet(),
  );
  return entitlements.isUnlimited;
}

class _SignInSheet extends StatefulWidget {
  const _SignInSheet();

  @override
  State<_SignInSheet> createState() => _SignInSheetState();
}

class _SignInSheetState extends State<_SignInSheet> {
  bool _busy = false;
  String? _error;

  /// True for "the person backed out on purpose" — never shown as an error,
  /// per the spec: a cancelled sign-in returns silently, no error toast.
  static bool _isCancellation(Object error) =>
      (error is GoogleSignInException &&
          error.code == GoogleSignInExceptionCode.canceled) ||
      (error is SignInWithAppleAuthorizationException &&
          error.code == AuthorizationErrorCode.canceled);

  Future<void> _run(Future<void> Function() signIn) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await signIn();
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (_isCancellation(e)) {
        // Normal, frequent outcome: just stay on this sheet, no message.
      } else if (mounted) {
        setState(() => _error = context.l10n.signInFailed);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final auth = AuthServiceScope.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.signInTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(l.signInBody),
            const SizedBox(height: 20),
            if (_error != null) ...[
              Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              const SizedBox(height: 12),
            ],
            FilledButton.icon(
              onPressed: _busy ? null : () => _run(auth.signInWithApple),
              icon: const Icon(Icons.apple),
              label: Text(l.continueWithApple),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _busy ? null : () => _run(auth.signInWithGoogle),
              icon: const Icon(Icons.g_mobiledata),
              label: Text(l.continueWithGoogle),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaywallSheet extends StatefulWidget {
  const _PaywallSheet();

  @override
  State<_PaywallSheet> createState() => _PaywallSheetState();
}

class _PaywallSheetState extends State<_PaywallSheet> {
  Offering? _offering;
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (mounted) setState(() => _offering = offerings.current);
    } catch (_) {
      if (mounted) setState(() => _error = context.l10n.offeringsLoadFailed);
    }
  }

  Future<void> _buy(Package package) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await Purchases.purchasePackage(package);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      // A cancelled purchase is a normal, frequent outcome — same rule as a
      // cancelled sign-in: stay on this sheet, no error shown.
      final cancelled =
          e is PlatformException &&
          PurchasesErrorHelper.getErrorCode(e) ==
              PurchasesErrorCode.purchaseCancelledError;
      if (!cancelled && mounted) {
        setState(() => _error = context.l10n.purchaseFailed);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await Purchases.restorePurchases();
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) setState(() => _error = context.l10n.restoreFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final offering = _offering;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.upgradeTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(l.upgradeBody),
            const SizedBox(height: 20),
            if (_error != null) ...[
              Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              const SizedBox(height: 12),
            ],
            if (offering == null && _error == null)
              const Center(child: CircularProgressIndicator())
            else ...[
              if (offering?.monthly case final p?)
                _PlanButton(package: p, onTap: _busy ? null : () => _buy(p)),
              if (offering?.annual case final p?) ...[
                const SizedBox(height: 8),
                _PlanButton(package: p, onTap: _busy ? null : () => _buy(p)),
              ],
              if (offering?.lifetime case final p?) ...[
                const SizedBox(height: 8),
                _PlanButton(package: p, onTap: _busy ? null : () => _buy(p)),
              ],
            ],
            const SizedBox(height: 12),
            TextButton(
              onPressed: _busy ? null : _restore,
              child: Text(l.restorePurchases),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanButton extends StatelessWidget {
  const _PlanButton({required this.package, required this.onTap});

  final Package package;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: onTap,
    child: Text(
      '${package.storeProduct.title} — ${package.storeProduct.priceString}',
    ),
  );
}
```

- [ ] **Step 2: Add the new localized strings**

This screen uses nine new `context.l10n` keys: `signInTitle`, `signInBody`, `continueWithApple`, `continueWithGoogle`, `signInFailed`, `upgradeTitle`, `upgradeBody`, `offeringsLoadFailed`, `purchaseFailed`, `restoreFailed`, `restorePurchases`. Add each as a plain string to `lib/l10n/app_en.arb` (English source) with a one-line description, following the exact format of any existing entry in that file (e.g. `"saved"` / `"@saved"`). Do not translate them into the other 27 languages in this task — `test/translations_test.dart` only fails on a language that has *some* translations but is missing a key relative to English with a placeholder mismatch; confirm this by running the next step. If it fails, see that test's own message for which languages need the same string copied in verbatim as a placeholder (fix forward from its output rather than guessing).

- [ ] **Step 3: Run analyze and the translations test**

Run: `flutter analyze && flutter test test/translations_test.dart`
Expected: both clean/PASS. If `GoogleSignInExceptionCode.canceled` or `AuthorizationErrorCode.canceled` doesn't resolve, check the actual enum values in the resolved package (`.dart_tool/package_config.json` → its path → the `.dart` source defining that enum) and use the real member name there instead — the *intent* (never show an error for a user-initiated cancellation) is the part that must not change.

- [ ] **Step 4: Commit**

```bash
git add lib/screens/paywall_screen.dart lib/l10n/app_en.arb
git commit -m "Add paywall and sign-in sheets (showUpgradeFlow)"
```

---

## Task 8: Gate script creation on the home screen

**Files:**
- Modify: `lib/screens/home_screen.dart`
- Test: `test/home_gate_test.dart` (new)

**Interfaces:**
- Consumes: `canCreateScript`, `Entitlements`, `EntitlementsScope` (Task 3), `showUpgradeFlow` (Task 7).

- [ ] **Step 1: Write the failing test**

Create `test/home_gate_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:apromter/screens/home_screen.dart';
import 'package:apromter/services/app_state.dart';
import 'package:apromter/services/entitlements.dart';
import 'package:apromter/services/storage.dart';

Future<void> _pump(
  WidgetTester tester, {
  required bool isUnlimited,
}) async {
  SharedPreferences.setMockInitialValues({});
  final storage = await Storage.open();
  final state = AppState(storage);
  final entitlements = Entitlements(isUnlimited: isUnlimited);
  await tester.pumpWidget(
    MaterialApp(
      home: EntitlementsScope(
        entitlements: entitlements,
        child: AppScope(state: state, child: const HomeScreen()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('free account at the script limit shows the upgrade sheet '
      'instead of the template picker', (tester) async {
    await _pump(tester, isUnlimited: false);
    // The fresh app seeds one welcome script, already at the free limit.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Continue with Apple'), findsOneWidget);
    expect(find.byType(BottomSheet), findsOneWidget);
  });

  testWidgets('unlimited account opens the template picker normally',
      (tester) async {
    await _pump(tester, isUnlimited: true);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Continue with Apple'), findsNothing);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/home_gate_test.dart`
Expected: FAIL — tapping "+" currently always opens the template picker; "Continue with Apple" is never found for the free case.

- [ ] **Step 3: Implement the gate**

In `lib/screens/home_screen.dart`:

Add imports:

```dart
import '../services/entitlements.dart';
import 'paywall_screen.dart';
```

Change the `_newScript` function (currently `Future<void> _newScript(BuildContext context) async { ... }`) to check the gate first:

```dart
/// J1: pick a template, then open the editor. Free accounts at the script
/// limit are routed to the upgrade flow instead.
Future<void> _newScript(BuildContext context) async {
  final state = AppScope.read(context);
  final entitlements = EntitlementsScope.read(context);
  if (!canCreateScript(state.scripts, entitlements.isUnlimited)) {
    await showUpgradeFlow(context);
    return;
  }
  final l = context.l10n;
  final template = await showModalBottomSheet<ScriptTemplate>(
    // ...the rest of the existing function body is unchanged...
```

(Only the new three lines before the existing `final l = context.l10n;` are added; everything else in `_newScript` stays exactly as it is today.)

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/home_gate_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 5: Run the full suite**

Run: `flutter test`
Expected: all tests PASS (no regressions in the existing home-screen tests).

- [ ] **Step 6: Commit**

```bash
git add lib/screens/home_screen.dart test/home_gate_test.dart
git commit -m "Gate new-script creation behind the free script limit"
```

---

## Task 9: Gate the word cap in the editor

**Files:**
- Modify: `lib/screens/editor_screen.dart`
- Test: `test/editor_gate_test.dart` (new)

**Interfaces:**
- Consumes: `canExceedWordCap`, `EntitlementsScope` (Task 3), `AppState.isGrandfatheredWordCap` / `AppState.runWordCapMigrationIfNeeded` (Task 6), `showUpgradeFlow` (Task 7), `countWords`/`spokenText` (already imported in this file via `script_markup.dart`).

- [ ] **Step 1: Write the failing test**

Create `test/editor_gate_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:apromter/models/script.dart';
import 'package:apromter/screens/editor_screen.dart';
import 'package:apromter/services/app_state.dart';
import 'package:apromter/services/entitlements.dart';
import 'package:apromter/services/storage.dart';

Future<AppState> _pump(
  WidgetTester tester, {
  required Script script,
  required bool isUnlimited,
  bool runMigrationBeforeEditing = false,
}) async {
  SharedPreferences.setMockInitialValues({});
  final storage = await Storage.open();
  final state = AppState(storage);
  await state.upsert(script);
  // Simulates this script already existing, already over the cap, at the
  // moment the paywall gate shipped — the grandfathering snapshot runs
  // once, before any further editing.
  if (runMigrationBeforeEditing) await state.runWordCapMigrationIfNeeded();
  final entitlements = Entitlements(isUnlimited: isUnlimited);
  await tester.pumpWidget(
    MaterialApp(
      home: EntitlementsScope(
        entitlements: entitlements,
        child: AppScope(
          state: state,
          child: EditorScreen(script: script),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return state;
}

Script _script({required int words}) => Script(
  id: 'script-1',
  title: 'Test',
  body: List.filled(words, 'word').join(' '),
  updatedAt: DateTime(2026),
);

void main() {
  testWidgets('free account sees the upgrade banner past the word cap',
      (tester) async {
    await _pump(tester, script: _script(words: 501), isUnlimited: false);
    expect(find.text('Upgrade'), findsOneWidget);
  });

  testWidgets('free account under the cap sees no banner', (tester) async {
    await _pump(tester, script: _script(words: 10), isUnlimited: false);
    expect(find.text('Upgrade'), findsNothing);
  });

  testWidgets('unlimited account never sees the banner', (tester) async {
    await _pump(tester, script: _script(words: 501), isUnlimited: true);
    expect(find.text('Upgrade'), findsNothing);
  });

  testWidgets(
      'a script already over the cap before the gate shipped is '
      'grandfathered: no banner even on a free account', (tester) async {
    await _pump(
      tester,
      script: _script(words: 501),
      isUnlimited: false,
      runMigrationBeforeEditing: true,
    );
    expect(find.text('Upgrade'), findsNothing);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/editor_gate_test.dart`
Expected: FAIL — no "Upgrade" text exists anywhere yet.

- [ ] **Step 3: Implement the banner**

In `lib/screens/editor_screen.dart`:

Add imports:

```dart
import '../services/entitlements.dart';
import 'paywall_screen.dart';
```

Add a new private widget right after the existing `_TimingBar` class (after its closing `}`, before `class _MarkupToolbar`):

```dart
/// Nudges a free account past the word cap to upgrade. Never blocks typing
/// itself — see the spec's "never blocks typing" rule — this is purely an
/// informational banner with a CTA.
class _WordCapBanner extends StatelessWidget {
  const _WordCapBanner();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      color: theme.colorScheme.secondaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l.wordCapBannerText(maxFreeWords),
              style: TextStyle(color: theme.colorScheme.onSecondaryContainer),
            ),
          ),
          TextButton(
            onPressed: () => showUpgradeFlow(context),
            child: Text(l.upgrade),
          ),
        ],
      ),
    );
  }
}
```

Then, inside `_EditorScreenState.build`, insert the banner right after the `_TimingBar` `ValueListenableBuilder` block and before `const Divider(height: 1),`:

```dart
            ValueListenableBuilder(
              valueListenable: _analysed,
              builder: (context, body, _) {
                final entitlements = EntitlementsScope.of(context);
                final grandfathered = AppScope.of(
                  context,
                ).isGrandfatheredWordCap(widget.script.id);
                final overCap = countWords(spokenText(body)) > maxFreeWords;
                final showBanner =
                    overCap &&
                    !canExceedWordCap(
                      entitlements.isUnlimited,
                      isGrandfathered: grandfathered,
                    );
                return Column(
                  children: [
                    if (showBanner) const _WordCapBanner(),
                    _TimingBar(
                      body: body,
                      targetSeconds: _target,
                      wpm: AppScope.of(context).settings.wpm,
                    ),
                  ],
                );
              },
            ),
            const Divider(height: 1),
```

(This replaces the existing bare `_TimingBar(...)` `ValueListenableBuilder` — same `valueListenable`, its `builder` now returns a `Column` wrapping the optional banner plus the unchanged `_TimingBar`.)

- [ ] **Step 4: Add the two new localized strings**

Add `wordCapBannerText` (with an `{count}`-style int placeholder, following this file's existing placeholder convention such as `l.words(script.wordCount)`) and `upgrade` to `lib/l10n/app_en.arb`, same as Task 7 Step 2.

- [ ] **Step 5: Run the test to verify it passes**

Run: `flutter test test/editor_gate_test.dart`
Expected: PASS (4 tests).

- [ ] **Step 6: Run the full suite**

Run: `flutter test`
Expected: all tests PASS.

- [ ] **Step 7: Commit**

```bash
git add lib/screens/editor_screen.dart lib/l10n/app_en.arb test/editor_gate_test.dart
git commit -m "Show an upgrade banner past the free word cap in the editor"
```

---

## Task 10: README docs + final verification

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Document the paywall setup**

Add a new section to `README.md`, right after the existing "### Store notes" section (before "Release checklist, Play declarations..."):

```markdown
### Paywall setup

Free accounts get 1 active script capped at 500 words; unlocking is a
RevenueCat-brokered purchase (monthly, yearly, or lifetime) gated behind
Sign in with Apple / Google — the login exists only so a purchase is
recognized across devices and across the App Store / Play Store boundary,
not for script sync.

1. Create a RevenueCat project, add your Apple App Store and Google Play
   apps to it, and create one entitlement (default id `unlimited`) backed
   by three products: a monthly subscription, a yearly subscription, and a
   non-consumable lifetime purchase. Put all three in one Offering's
   `monthly` / `annual` / `lifetime` package slots.
2. In Apple Developer → Certificates, IDs & Profiles, enable the "Sign in
   with Apple" capability for the app id, and add the same capability in
   Xcode (`Runner` → Signing & Capabilities).
3. In Google Cloud Console → Credentials, create an OAuth 2.0 **Web**
   client id (used as `googleServerClientId` even on Android/iOS — this is
   how `google_sign_in` is configured per its own README).
4. Copy `lib/config/entitlements_config.dart.example` to
   `lib/config/entitlements_config.dart` (git-ignored, like
   `android/key.properties` below) and fill in the RevenueCat API keys,
   the entitlement id, and the Google web client id.

Without a real `entitlements_config.dart`, the app builds and runs fine —
sign-in and purchases will simply fail, the same way a release build falls
back to the debug signing key without `android/key.properties`.
```

- [ ] **Step 2: Run the complete verification suite**

Run: `flutter analyze && flutter test`
Expected: `No issues found!` and every test PASSES (the full suite, including every test added in Tasks 2, 3, 8 and 9).

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "Document paywall/SSO setup in README"
```
