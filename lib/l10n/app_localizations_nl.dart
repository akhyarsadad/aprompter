// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'Sluiten';

  @override
  String get settings => 'Instellingen';

  @override
  String get prompterSettings => 'Prompterinstellingen';

  @override
  String get edit => 'Bewerken';

  @override
  String get delete => 'Verwijderen';

  @override
  String get undo => 'Ongedaan maken';

  @override
  String get duplicate => 'Dupliceren';

  @override
  String get share => 'Delen';

  @override
  String get copyAsCaption => 'Kopiëren als caption';

  @override
  String get captionCopied =>
      'Gesproken tekst gekopieerd — plak hem als caption';

  @override
  String get copySuffix => '(kopie)';

  @override
  String deletedScript(String title) {
    return '\"$title\" verwijderd';
  }

  @override
  String duplicatedScript(String title) {
    return 'Gedupliceerd als \"$title\"';
  }

  @override
  String get untitled => 'Naamloos';

  @override
  String get newScript => 'Nieuw script';

  @override
  String get searchScripts => 'Scripts zoeken';

  @override
  String get filterAll => 'Alle';

  @override
  String get statusDraft => 'Concept';

  @override
  String get statusReady => 'Klaar';

  @override
  String get statusRecorded => 'Opgenomen';

  @override
  String markAs(String status) {
    return 'Markeren als $status';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'Oefenen';

  @override
  String get float => 'Zwevend';

  @override
  String get record => 'Opnemen';

  @override
  String words(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count woorden',
      one: '1 woord',
    );
    return '$_temp0';
  }

  @override
  String takes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count takes',
      one: '1 take',
    );
    return '$_temp0';
  }

  @override
  String get noScriptsYet => 'Nog geen scripts';

  @override
  String get noScriptsHint =>
      'Tik op \"Nieuw script\" en kies een sjabloon om te beginnen.';

  @override
  String get nothingHere => 'Niets gevonden';

  @override
  String get nothingHereHint =>
      'Probeer een ander filter of een andere zoekterm.';

  @override
  String get startFromTemplate => 'Begin met een sjabloon';

  @override
  String get overlayPermissionNeeded =>
      'Sta \"Weergeven boven andere apps\" toe om de zwevende prompter te gebruiken.';

  @override
  String get floatingStarted =>
      'De prompter zweeft. Open je camera-app en tik op de tekst om te starten.';

  @override
  String get floatingNotificationTitle => 'APrompter zweeft';

  @override
  String get openScriptInApp => 'Open een script in APrompter';

  @override
  String get script => 'Script';

  @override
  String get title => 'Titel';

  @override
  String get status => 'Status';

  @override
  String get noTarget => 'Geen doel';

  @override
  String get editorHint =>
      'Schrijf of plak wat je wilt zeggen…\n\nTip: begin een regel met # voor een sectie, met // voor een notitie voor jezelf.';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $spoken bij $wpm wpm';
  }

  @override
  String get onTarget => 'Op doel';

  @override
  String overTarget(int seconds, int words) {
    return '$seconds s te lang · schrap ~$words woorden';
  }

  @override
  String underTarget(int seconds, int words) {
    return 'Nog $seconds s · ~$words woorden ruimte';
  }

  @override
  String longSentences(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count lange zinnen (25+ woorden) — splits ze zodat je kunt ademen',
      one: '1 lange zin (25+ woorden) — splits hem zodat je kunt ademen',
    );
    return '$_temp0';
  }

  @override
  String get toolSection => 'Sectie';

  @override
  String get toolEmphasis => 'Nadruk';

  @override
  String get toolPause => 'Pauze';

  @override
  String get toolNote => 'Notitie';

  @override
  String get toolPaste => 'Plakken';

  @override
  String get restart => 'Opnieuw';

  @override
  String get sections => 'Secties';

  @override
  String get slower => 'Langzamer';

  @override
  String get faster => 'Sneller';

  @override
  String get play => 'Afspelen';

  @override
  String get pause => 'Pauze';

  @override
  String get wpmUnit => 'wpm';

  @override
  String get startOfScript => 'Begin van het script';

  @override
  String sectionN(int n) {
    return 'Sectie $n';
  }

  @override
  String get noSectionsHint =>
      'Nog geen secties. Voeg in de editor regels toe die met \"#\" beginnen (bijv. \"# Hook\") om tussen delen te springen en er maar één opnieuw te doen.';

  @override
  String get emptyScript => '(leeg script)';

  @override
  String get preview => 'Voorbeeld';

  @override
  String get setup => 'Opstelling';

  @override
  String get pace => 'Tempo';

  @override
  String get text => 'Tekst';

  @override
  String get layout => 'Indeling';

  @override
  String get recording => 'Opname';

  @override
  String get wordsPerMinute => 'woorden / min';

  @override
  String fitTo(String time) {
    return 'Passend maken op $time';
  }

  @override
  String get paceCalm => 'Rustig';

  @override
  String get paceNatural => 'Natuurlijk';

  @override
  String get paceEnergetic => 'Energiek';

  @override
  String get countdown => 'Aftellen voor de start';

  @override
  String get off => 'Uit';

  @override
  String get size => 'Grootte';

  @override
  String get lineSpacing => 'Regelafstand';

  @override
  String get textColor => 'Tekstkleur';

  @override
  String get prompterHeight => 'Prompterhoogte';

  @override
  String get background => 'Achtergrond';

  @override
  String get readingGuide => 'Leeslijn';

  @override
  String get mirrorText => 'Tekst spiegelen';

  @override
  String get mirrorTextHint => 'Voor teleprompterglas / beam splitter';

  @override
  String get videoQuality => 'Videokwaliteit';

  @override
  String get autoStop => 'Opname stoppen als het script klaar is';

  @override
  String get autoStopHint => 'Wacht 2 seconden na de laatste regel';

  @override
  String get presetHandheld => 'Selfie uit de hand';

  @override
  String get presetHandheldHint => 'Middelgrote tekst dicht bij de lens';

  @override
  String get presetTripod => 'Statief / op afstand';

  @override
  String get presetTripodHint => 'Grote tekst, leesbaar op 1–2 m';

  @override
  String get presetGlass => 'Teleprompterglas';

  @override
  String get presetGlassHint =>
      'Gespiegeld, volledig scherm, dichte achtergrond';

  @override
  String get niceRun => 'Goed gedaan!';

  @override
  String runSummary(String time, int words, int wpm) {
    return 'Je deed $time over $words woorden → $wpm woorden per minuut.';
  }

  @override
  String runOver(int seconds, String target) {
    return 'Dat is $seconds s boven je doel van $target — kort het script in of praat sneller.';
  }

  @override
  String runUnder(int seconds) {
    return 'Je hebt nog $seconds s tot je doel.';
  }

  @override
  String get runOnTarget => 'Precies op je doellengte. 🎯';

  @override
  String get keepCurrent => 'Behouden';

  @override
  String useWpm(int wpm) {
    return '$wpm wpm gebruiken';
  }

  @override
  String get switchCamera => 'Camera wisselen';

  @override
  String get startRecording => 'Opname starten';

  @override
  String get stopRecording => 'Opname stoppen';

  @override
  String get noCamera => 'Geen camera gevonden op dit apparaat.';

  @override
  String get cameraDenied =>
      'Cameratoegang is geweigerd. Zet deze aan in de systeeminstellingen.';

  @override
  String cameraError(String message) {
    return 'Camerafout: $message';
  }

  @override
  String takeSaved(int n) {
    return 'Take $n opgeslagen in je galerij';
  }

  @override
  String get templateBlank => 'Leeg';

  @override
  String get templateBlankHint => 'Begin met een lege pagina';

  @override
  String get templateHvc => 'Hook → Waarde → CTA';

  @override
  String get templateHvcHint => 'De klassieke structuur voor korte video\'s';

  @override
  String get templateTutorial => 'Tutorial';

  @override
  String get templateTutorialHint => 'Leg iets stap voor stap uit';

  @override
  String get templateReview => 'Productreview';

  @override
  String get templateReviewHint => 'UGC, advertenties en eerlijke reviews';

  @override
  String get templateStory => 'Storytime';

  @override
  String get templateStoryHint => 'Persoonlijk verhaal met een les';

  @override
  String get secHook => 'Hook';

  @override
  String get secValue => 'Waarde';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'Stap $n';
  }

  @override
  String get secRecap => 'Samenvatting & CTA';

  @override
  String get secWhatItIs => 'Wat het is';

  @override
  String get secLoved => 'Wat ik geweldig vond';

  @override
  String get secBetter => 'Wat beter kan';

  @override
  String get secVerdict => 'Oordeel & CTA';

  @override
  String get secSetup => 'Aanloop';

  @override
  String get secTurningPoint => 'Keerpunt';

  @override
  String get secLesson => 'Les';

  @override
  String get noteHook =>
      'Pak de aandacht in de eerste 3 seconden: een gedurfde claim of vraag';

  @override
  String get noteValue => 'Lever dat ene ding dat je beloofde';

  @override
  String get noteCta =>
      'Zeg wat ze nu moeten doen: volgen, reageren, link in bio';

  @override
  String get noteTutorialHook => '\"Zo doe je … in minder dan een minuut\"';

  @override
  String get noteRecap =>
      'Vat samen in één zin en vraag ze de video op te slaan';

  @override
  String get noteReviewHook =>
      'Laat het product zien en het probleem dat het oplost';

  @override
  String get noteVerdict => 'Voor wie het is — noem de code of link';

  @override
  String get noteStoryHook => 'Begin midden in de actie';

  @override
  String get welcomeTitle => 'Welkom bij APrompter';

  @override
  String get welcomeBody =>
      '# Hook\nWil je filmen zonder je tekst te vergeten? [pause]\n// kijk recht in de lens\n\n# Zo werkt het\nSchrijf je script, kies een *doellengte* en de timer vertelt of het past.\nOefen om je tempo in woorden per minuut te vinden.\nTik dan op Opnemen. De tekst scrolt vlak onder de camera, zodat je *oogcontact* houdt met je publiek.\n\n# CTA\nTik op deze kaart om het script te bewerken, of maak je eigen script met de plusknop. [pause] Veel plezier met maken!\n';

  @override
  String get expand => 'Uitvouwen';

  @override
  String get minimize => 'Minimaliseren';

  @override
  String get nothingToSay =>
      'Voeg eerst iets toe om te zeggen — secties (#) en notities (//) worden niet voorgelezen.';

  @override
  String get openSettings => 'Instellingen openen';

  @override
  String get tryAgain => 'Opnieuw proberen';

  @override
  String get noMicBanner => 'Geen microfoontoegang — opname zonder geluid';

  @override
  String get saveFailedTitle => 'Opslaan in je galerij is mislukt';

  @override
  String saveFailedBody(String reason) {
    return 'Je take is voorlopig veilig. Probeer het opnieuw of deel hem naar Bestanden, Drive of een chat zodat je hem niet kwijtraakt. ($reason)';
  }

  @override
  String get shareVideo => 'Video delen';

  @override
  String get discardTake => 'Deze take weggooien';

  @override
  String takeShared(int n) {
    return 'Take $n gedeeld';
  }

  @override
  String get movePrompter => 'Sleep om de prompter te verplaatsen';

  @override
  String get resizePrompter =>
      'Sleep om het formaat van de prompter te wijzigen';

  @override
  String get prompterWidth => 'Prompterbreedte';

  @override
  String get resetPosition => 'Positie herstellen (boven, volle breedte)';

  @override
  String get positionHint =>
      'Sleep de balk boven aan de prompter om hem overal neer te zetten, en de hoek om het formaat te wijzigen. Op Android kun je het zwevende venster overal heen slepen en onthoudt het zijn plek.';

  @override
  String get app => 'App';

  @override
  String get appLanguage => 'App-taal';

  @override
  String get systemDefault => 'Taal van de telefoon';

  @override
  String secondsShort(int n) {
    return '$n s';
  }

  @override
  String minutesShort(int n) {
    return '$n min';
  }

  @override
  String get storageSaveFailed =>
      'Opslaan mislukt — misschien is je telefoon vol. Je werk blijft bewaard zolang de app open is.';

  @override
  String get versionHistory => 'Versiegeschiedenis';

  @override
  String get noVersions =>
      'Nog geen eerdere versies. Ze worden automatisch bewaard terwijl je schrijft.';

  @override
  String get restore => 'Herstellen';

  @override
  String get versionRestored => 'Eerdere versie hersteld';

  @override
  String get recentlyDeleted => 'Recent verwijderd';

  @override
  String trashHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Verwijderde scripts blijven hier $days dagen.',
      one: 'Verwijderde scripts blijven hier 1 dag.',
    );
    return '$_temp0';
  }

  @override
  String get deleteForever => 'Definitief verwijderen';

  @override
  String deletedOn(String date) {
    return 'Verwijderd op $date';
  }

  @override
  String restoredScript(String title) {
    return '\"$title\" hersteld';
  }

  @override
  String get backUpScripts => 'Back-up van alle scripts';

  @override
  String get restoreBackup => 'Herstellen uit back-up';

  @override
  String get backupShareTitle => 'APrompter-back-up';

  @override
  String importedScripts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count scripts hersteld',
      one: '1 script hersteld',
      zero: 'Alles uit deze back-up staat er al',
    );
    return '$_temp0';
  }

  @override
  String get notABackup => 'Dat bestand is geen APrompter-back-up.';

  @override
  String fitImpossible(int wpm, String target, int words) {
    return 'Zelfs met $wpm wpm past dit niet in $target — schrap ongeveer $words woorden.';
  }

  @override
  String get cameraNotReady =>
      'De camera was niet klaar, dus de opname is niet gestart. Probeer het opnieuw.';

  @override
  String get previousSection => 'Vorige sectie';

  @override
  String get nextSection => 'Volgende sectie';

  @override
  String get floatingNotificationBody => 'Tik om APrompter te openen';

  @override
  String get customTarget => 'Aangepast…';

  @override
  String get customTargetTitle => 'Doellengte';

  @override
  String get customTargetHint => 'Minuten en seconden, bijv. 5:00';

  @override
  String get saved => 'Opgeslagen';

  @override
  String get floatNotOnIos =>
      'Op iPhone kunnen apps niet over andere apps zweven. Gebruik Opnemen om te filmen met het script onder de camera.';

  @override
  String get hashtagHint =>
      'Hashtagregels (#fyp #ad) worden gedimd en niet getimed. Gebruik \"# \" met een spatie voor een sectie.';
}
