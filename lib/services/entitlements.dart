import 'dart:async';

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
/// RevenueCat elsewhere ([lib/services/purchase_service.dart]); this class only
/// holds the resulting bool so the rest of the app never touches RevenueCat
/// types directly.
///
/// At launch `main.dart` starts it from the last answer this device saw and
/// with `known: false`; it becomes known once RevenueCat has answered (or
/// failed to). Anything built directly — tests, previews — is known at once.
class Entitlements extends ChangeNotifier {
  // `isUnlimited` is the stable public constructor param; the
  // initializing-formal lint would rename it to the private field name,
  // breaking callers — suppressed on the initializer below for that reason.
  Entitlements({bool isUnlimited = false, bool known = true})
    // ignore: prefer_initializing_formals
    : _isUnlimited = isUnlimited {
    if (known) _known.complete();
  }

  bool _isUnlimited;
  bool get isUnlimited => _isUnlimited;

  final _known = Completer<void>();

  /// Whether the store has answered since launch, or failed to. Until then
  /// [isUnlimited] is only what this device knew the last time.
  bool get isKnown => _known.isCompleted;

  /// Completes once [markKnown] has run.
  Future<void> get whenKnown => _known.future;

  /// The store has answered at launch, or failed to: from now on
  /// [isUnlimited] is as good as it gets until the next change.
  void markKnown() {
    if (!_known.isCompleted) _known.complete();
  }

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

  static Entitlements of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<EntitlementsScope>()!
      .notifier!;

  static Entitlements read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<EntitlementsScope>()!.notifier!;
}
