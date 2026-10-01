import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'l10n/l10n.dart';
import 'overlay/overlay_app.dart';
import 'screens/home_screen.dart';
import 'services/app_state.dart';
import 'services/storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Content is filmed vertically (Reels, TikTok, Shorts).
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final storage = await Storage.open();
  runApp(AprompterApp(state: AppState(storage)));
}

/// Entry point for the Android floating prompter window.
@pragma('vm:entry-point')
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OverlayApp());
}

class AprompterApp extends StatelessWidget {
  const AprompterApp({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF7C4DFF);
    return AppScope(
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
                  child: child!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shown on every screen while writes to the phone fail, so a full phone
/// never loses work silently.
class _SaveFailedBanner extends StatelessWidget {
  const _SaveFailedBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    return Material(
      color: theme.colorScheme.errorContainer,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8),
          child: Row(
            children: [
              Icon(Icons.sd_card_alert, color: theme.colorScheme.error),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l.storageSaveFailed,
                  style: TextStyle(color: theme.colorScheme.onErrorContainer),
                ),
              ),
              TextButton(
                onPressed: AppScope.read(context).retrySave,
                child: Text(l.tryAgain),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
