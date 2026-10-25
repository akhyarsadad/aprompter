import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '../l10n/l10n.dart';
import '../services/app_state.dart';

/// Y1: with app lock on, scripts are hidden behind the phone's fingerprint,
/// face or PIN when the app opens and after 30 s in the background.
class AppLockGate extends StatefulWidget {
  const AppLockGate({super.key, required this.child});

  final Widget child;

  /// Whether the lock screen currently hides the app; [context] rebuilds
  /// (and gets `didChangeDependencies`) when that changes. False without a
  /// gate above [context].
  static bool lockedOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_LockState>()?.locked ?? false;

  /// [lockedOf] without subscribing, for callbacks.
  static bool isLocked(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_LockState>()?.locked ?? false;

  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _LockState extends InheritedWidget {
  const _LockState({required this.locked, required super.child});

  final bool locked;

  @override
  bool updateShouldNotify(_LockState old) => old.locked != locked;
}

class _AppLockGateState extends State<AppLockGate> {
  static const _grace = Duration(seconds: 30);

  late bool _locked = AppScope.read(context).appLock;
  DateTime? _leftAt;
  bool _asking = false;

  late final _lifecycle = AppLifecycleListener(
    onHide: () => _leftAt ??= DateTime.now(),
    onShow: () {
      final left = _leftAt;
      _leftAt = null;
      if (AppScope.read(context).appLock &&
          left != null &&
          DateTime.now().difference(left) >= _grace) {
        setState(() => _locked = true);
        _unlock();
      }
    },
  );

  @override
  void initState() {
    super.initState();
    _lifecycle;
    if (_locked) WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _unlock() async {
    if (_asking || !mounted) return;
    _asking = true;
    try {
      final ok = await LocalAuthentication().authenticate(
        localizedReason: context.l10n.unlockReason,
        persistAcrossBackgrounding: true,
      );
      if (ok && mounted) setState(() => _locked = false);
    } catch (_) {
      // No screen lock any more, or the prompt failed: stay locked; the
      // button tries again.
    } finally {
      _asking = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locked = _locked && AppScope.of(context).appLock;
    // Things shared to APrompter wait for this to turn false (see HomeScreen),
    // so nothing opens or asks for anything behind the lock screen.
    return _LockState(
      locked: locked,
      // Expand: while locked the app underneath is offstage and has no size,
      // and the lock screen would otherwise be zero pixels wide.
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Kept alive underneath so nothing in progress is lost.
          Offstage(offstage: locked, child: widget.child),
          if (locked)
            Positioned.fill(
              child: Material(
                color: Theme.of(context).colorScheme.surface,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 56,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: _unlock,
                        icon: const Icon(Icons.fingerprint),
                        label: Text(context.l10n.unlock),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Turns app lock on after checking the phone can do it.
Future<bool> canUseAppLock() async {
  try {
    final auth = LocalAuthentication();
    return await auth.isDeviceSupported();
  } catch (_) {
    return false;
  }
}
