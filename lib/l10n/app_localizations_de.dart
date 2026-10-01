// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'Schließen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get prompterSettings => 'Prompter-Einstellungen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get delete => 'Löschen';

  @override
  String get undo => 'Rückgängig';

  @override
  String get duplicate => 'Duplizieren';

  @override
  String get share => 'Teilen';

  @override
  String get copyAsCaption => 'Als Bildunterschrift kopieren';

  @override
  String get captionCopied =>
      'Gesprochener Text kopiert – als Caption einfügen';

  @override
  String get copySuffix => '(Kopie)';

  @override
  String deletedScript(String title) {
    return '„$title“ gelöscht';
  }

  @override
  String duplicatedScript(String title) {
    return 'Dupliziert als „$title“';
  }

  @override
  String get untitled => 'Ohne Titel';

  @override
  String get newScript => 'Neues Skript';

  @override
  String get searchScripts => 'Skripte suchen';

  @override
  String get filterAll => 'Alle';

  @override
  String get statusDraft => 'Entwurf';

  @override
  String get statusReady => 'Bereit';

  @override
  String get statusRecorded => 'Aufgenommen';

  @override
  String markAs(String status) {
    return 'Als $status markieren';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'Proben';

  @override
  String get float => 'Schweben';

  @override
  String get record => 'Aufnehmen';

  @override
  String words(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Wörter',
      one: '1 Wort',
    );
    return '$_temp0';
  }

  @override
  String takes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Takes',
      one: '1 Take',
    );
    return '$_temp0';
  }

  @override
  String get noScriptsYet => 'Noch keine Skripte';

  @override
  String get noScriptsHint =>
      'Tippe auf „Neues Skript“ und wähle eine Vorlage.';

  @override
  String get nothingHere => 'Nichts gefunden';

  @override
  String get nothingHereHint =>
      'Versuch einen anderen Filter oder Suchbegriff.';

  @override
  String get startFromTemplate => 'Mit einer Vorlage starten';

  @override
  String get overlayPermissionNeeded =>
      'Erlaube „Über anderen Apps einblenden“, um den schwebenden Prompter zu nutzen.';

  @override
  String get floatingStarted =>
      'Der Prompter schwebt. Öffne deine Kamera-App und tippe auf den Text, um zu starten.';

  @override
  String get floatingNotificationTitle => 'APrompter schwebt';

  @override
  String get openScriptInApp => 'Öffne ein Skript in APrompter';

  @override
  String get script => 'Skript';

  @override
  String get title => 'Titel';

  @override
  String get status => 'Status';

  @override
  String get noTarget => 'Kein Ziel';

  @override
  String get editorHint =>
      'Schreib oder füge ein, was du sagen willst …\n\nTipp: Beginne eine Zeile mit # für einen Abschnitt, mit // für eine Notiz an dich.';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $spoken bei $wpm WpM';
  }

  @override
  String get onTarget => 'Im Ziel';

  @override
  String overTarget(int seconds, int words) {
    return '$seconds s zu lang · ~$words Wörter kürzen';
  }

  @override
  String underTarget(int seconds, int words) {
    return 'Noch $seconds s · ~$words Wörter Luft';
  }

  @override
  String longSentences(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count lange Sätze (25+ Wörter) – teile sie, damit du atmen kannst',
      one: '1 langer Satz (25+ Wörter) – teile ihn, damit du atmen kannst',
    );
    return '$_temp0';
  }

  @override
  String get toolSection => 'Abschnitt';

  @override
  String get toolEmphasis => 'Betonung';

  @override
  String get toolPause => 'Pause';

  @override
  String get toolNote => 'Notiz';

  @override
  String get toolPaste => 'Einfügen';

  @override
  String get restart => 'Neustart';

  @override
  String get sections => 'Abschnitte';

  @override
  String get slower => 'Langsamer';

  @override
  String get faster => 'Schneller';

  @override
  String get play => 'Abspielen';

  @override
  String get pause => 'Pause';

  @override
  String get wpmUnit => 'WpM';

  @override
  String get startOfScript => 'Anfang des Skripts';

  @override
  String sectionN(int n) {
    return 'Abschnitt $n';
  }

  @override
  String get noSectionsHint =>
      'Noch keine Abschnitte. Füge im Editor Zeilen mit „#“ am Anfang hinzu (z. B. „# Hook“), um zwischen Teilen zu springen und nur einen neu aufzunehmen.';

  @override
  String get emptyScript => '(leeres Skript)';

  @override
  String get preview => 'Vorschau';

  @override
  String get setup => 'Setup';

  @override
  String get pace => 'Tempo';

  @override
  String get text => 'Text';

  @override
  String get layout => 'Layout';

  @override
  String get recording => 'Aufnahme';

  @override
  String get wordsPerMinute => 'Wörter / Min.';

  @override
  String fitTo(String time) {
    return 'An $time anpassen';
  }

  @override
  String get paceCalm => 'Ruhig';

  @override
  String get paceNatural => 'Natürlich';

  @override
  String get paceEnergetic => 'Energisch';

  @override
  String get countdown => 'Countdown vor dem Start';

  @override
  String get off => 'Aus';

  @override
  String get size => 'Größe';

  @override
  String get lineSpacing => 'Zeilenabstand';

  @override
  String get textColor => 'Textfarbe';

  @override
  String get prompterHeight => 'Prompter-Höhe';

  @override
  String get background => 'Hintergrund';

  @override
  String get readingGuide => 'Leselinie';

  @override
  String get mirrorText => 'Text spiegeln';

  @override
  String get mirrorTextHint => 'Für Teleprompter-Glas / Strahlteiler';

  @override
  String get videoQuality => 'Videoqualität';

  @override
  String get autoStop => 'Aufnahme am Skriptende stoppen';

  @override
  String get autoStopHint => 'Wartet 2 Sekunden nach der letzten Zeile';

  @override
  String get presetHandheld => 'Selfie aus der Hand';

  @override
  String get presetHandheldHint => 'Mittelgroßer Text nah an der Linse';

  @override
  String get presetTripod => 'Stativ / Abstand';

  @override
  String get presetTripodHint => 'Großer Text, lesbar aus 1–2 m';

  @override
  String get presetGlass => 'Teleprompter-Glas';

  @override
  String get presetGlassHint => 'Gespiegelt, Vollbild, deckender Hintergrund';

  @override
  String get niceRun => 'Stark!';

  @override
  String runSummary(String time, int words, int wpm) {
    return 'Du hast $time für $words Wörter gebraucht → $wpm Wörter pro Minute.';
  }

  @override
  String runOver(int seconds, String target) {
    return 'Das sind $seconds s über deinem Ziel von $target – kürze das Skript oder sprich schneller.';
  }

  @override
  String runUnder(int seconds) {
    return 'Du hast noch $seconds s Luft bis zu deinem Ziel.';
  }

  @override
  String get runOnTarget => 'Genau in deiner Ziellänge. 🎯';

  @override
  String get keepCurrent => 'Beibehalten';

  @override
  String useWpm(int wpm) {
    return '$wpm WpM verwenden';
  }

  @override
  String get switchCamera => 'Kamera wechseln';

  @override
  String get startRecording => 'Aufnahme starten';

  @override
  String get stopRecording => 'Aufnahme stoppen';

  @override
  String get noCamera => 'Auf diesem Gerät wurde keine Kamera gefunden.';

  @override
  String get cameraDenied =>
      'Der Kamerazugriff wurde verweigert. Aktiviere ihn in den Systemeinstellungen.';

  @override
  String cameraError(String message) {
    return 'Kamerafehler: $message';
  }

  @override
  String takeSaved(int n) {
    return 'Take $n in der Galerie gespeichert';
  }

  @override
  String get templateBlank => 'Leer';

  @override
  String get templateBlankHint => 'Mit einer leeren Seite starten';

  @override
  String get templateHvc => 'Hook → Mehrwert → CTA';

  @override
  String get templateHvcHint => 'Die klassische Kurzvideo-Struktur';

  @override
  String get templateTutorial => 'Tutorial';

  @override
  String get templateTutorialHint => 'Etwas Schritt für Schritt erklären';

  @override
  String get templateReview => 'Produkttest';

  @override
  String get templateReviewHint => 'UGC, Werbung und ehrliche Reviews';

  @override
  String get templateStory => 'Storytime';

  @override
  String get templateStoryHint => 'Persönliche Geschichte mit Lektion';

  @override
  String get secHook => 'Hook';

  @override
  String get secValue => 'Mehrwert';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'Schritt $n';
  }

  @override
  String get secRecap => 'Zusammenfassung & CTA';

  @override
  String get secWhatItIs => 'Was es ist';

  @override
  String get secLoved => 'Was ich geliebt habe';

  @override
  String get secBetter => 'Was besser sein könnte';

  @override
  String get secVerdict => 'Fazit & CTA';

  @override
  String get secSetup => 'Ausgangslage';

  @override
  String get secTurningPoint => 'Wendepunkt';

  @override
  String get secLesson => 'Lektion';

  @override
  String get noteHook =>
      'Hol dir die Aufmerksamkeit in den ersten 3 Sekunden: eine kühne Aussage oder Frage';

  @override
  String get noteValue => 'Liefere genau das, was du versprochen hast';

  @override
  String get noteCta =>
      'Sag, was als Nächstes kommt: folgen, kommentieren, Link in der Bio';

  @override
  String get noteTutorialHook => '„So geht … in unter einer Minute“';

  @override
  String get noteRecap =>
      'In einem Satz zusammenfassen, dann bitten, das Video zu speichern';

  @override
  String get noteReviewHook => 'Zeig das Produkt und das Problem, das es löst';

  @override
  String get noteVerdict => 'Für wen es sich lohnt – nenn den Code oder Link';

  @override
  String get noteStoryHook => 'Steig mitten in der Handlung ein';

  @override
  String get welcomeTitle => 'Willkommen bei APrompter';

  @override
  String get welcomeBody =>
      '# Hook\nDu willst filmen, ohne deinen Text zu vergessen? [pause]\n// schau direkt in die Linse\n\n# So funktioniert\'s\nSchreib dein Skript, wähle eine *Ziellänge* und der Timer zeigt dir, ob es passt.\nProbe, um dein Tempo in Wörtern pro Minute zu finden.\nDann tippe auf Aufnehmen. Der Text läuft direkt unter der Kamera, so hältst du *Blickkontakt* mit deinem Publikum.\n\n# CTA\nTippe auf diese Karte, um das Skript zu bearbeiten, oder erstelle dein eigenes mit dem Plus. [pause] Viel Spaß beim Erstellen!\n';

  @override
  String get expand => 'Vergrößern';

  @override
  String get minimize => 'Minimieren';

  @override
  String get nothingToSay =>
      'Füge zuerst Sätze zum Sprechen hinzu – Abschnitte (#) und Notizen (//) werden nicht vorgelesen.';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get noMicBanner => 'Kein Mikrofonzugriff – Aufnahme ohne Ton';

  @override
  String get saveFailedTitle => 'Speichern in der Galerie fehlgeschlagen';

  @override
  String saveFailedBody(String reason) {
    return 'Dein Take ist vorerst sicher. Versuch es erneut oder teile ihn in Dateien, Drive oder einen Chat, damit er nicht verloren geht. ($reason)';
  }

  @override
  String get shareVideo => 'Video teilen';

  @override
  String get discardTake => 'Diesen Take verwerfen';

  @override
  String takeShared(int n) {
    return 'Take $n geteilt';
  }

  @override
  String get movePrompter => 'Ziehen, um den Prompter zu verschieben';

  @override
  String get resizePrompter => 'Ziehen, um die Größe zu ändern';

  @override
  String get prompterWidth => 'Prompter-Breite';

  @override
  String get resetPosition => 'Position zurücksetzen (oben, volle Breite)';

  @override
  String get positionHint =>
      'Zieh die Leiste oben am Prompter, um ihn beliebig zu platzieren, und die Ecke, um die Größe zu ändern. Unter Android lässt sich das schwebende Fenster überallhin ziehen und merkt sich seinen Platz.';

  @override
  String get app => 'App';

  @override
  String get appLanguage => 'App-Sprache';

  @override
  String get systemDefault => 'Sprache des Telefons';

  @override
  String secondsShort(int n) {
    return '$n s';
  }

  @override
  String minutesShort(int n) {
    return '$n Min.';
  }
}
