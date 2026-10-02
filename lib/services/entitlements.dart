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
