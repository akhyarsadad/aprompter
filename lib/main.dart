import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      child: MaterialApp(
        title: 'APrompter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: seed, useMaterial3: true),
        darkTheme: ThemeData(
          colorSchemeSeed: seed,
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
