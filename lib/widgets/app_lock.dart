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

  /// The phone's fingerprint / face / PIN check; tests put a fake here.
  @visibleForTesting
  static LocalAuthentication auth = LocalAuthentication();

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
    final reason = context.l10n.unlockReason;
    try {
      // Without a screen lock nothing could ever unlock the app: the lock
      // was removed from the phone since, or app lock came back with the
      // app's data on a phone that has none. The lock goes off instead of
      // locking the creator out of their scripts.
      if (!await _phoneHasLock()) {
        await _turnOff();
        return;
      }
      final ok = await AppLockGate.auth.authenticate(
        localizedReason: reason,
        persistAcrossBackgrounding: true,
      );
      if (ok && mounted) setState(() => _locked = false);
    } on LocalAuthException catch (e) {
      if (e.code == LocalAuthExceptionCode.noCredentialsSet ||
          e.code == LocalAuthExceptionCode.noBiometricHardware) {
        await _turnOff();
      }
      // Otherwise (cancelled, too many tries…) stay locked; the button
      // tries again.
    } catch (_) {
      // The prompt failed: stay locked; the button tries again.
    } finally {
      _asking = false;
    }
  }

  /// False only when the phone says it has no screen lock: an error is no
  /// reason to open the app.
  Future<bool> _phoneHasLock() async {
    try {
      return await AppLockGate.auth.isDeviceSupported();
    } catch (_) {
      return true;
    }
  }

  /// Turns app lock off, opens the app and says why.
  Future<void> _turnOff() async {
    if (!mounted) return;
    final state = AppScope.read(context);
    final messenger = ScaffoldMessenger.maybeOf(context);
    final message = context.l10n.appLockTurnedOff;
    await state.setAppLock(false);
    if (mounted) setState(() => _locked = false);
    messenger?.showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 8)),
    );
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

/// Whether app lock can be turned on: the phone has a screen lock.
Future<bool> canUseAppLock() async {
  try {
    return await AppLockGate.auth.isDeviceSupported();
  } catch (_) {
    return false;
  }
}
