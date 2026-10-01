// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'Zamknij';

  @override
  String get settings => 'Ustawienia';

  @override
  String get prompterSettings => 'Ustawienia promptera';

  @override
  String get edit => 'Edytuj';

  @override
  String get delete => 'Usuń';

  @override
  String get undo => 'Cofnij';

  @override
  String get duplicate => 'Duplikuj';

  @override
  String get share => 'Udostępnij';

  @override
  String get copyAsCaption => 'Kopiuj jako opis';

  @override
  String get captionCopied =>
      'Skopiowano tekst do wypowiedzenia — wklej go jako opis';

  @override
  String get copySuffix => '(kopia)';

  @override
  String deletedScript(String title) {
    return 'Usunięto „$title”';
  }

  @override
  String duplicatedScript(String title) {
    return 'Zduplikowano jako „$title”';
  }

  @override
  String get untitled => 'Bez tytułu';

  @override
  String get newScript => 'Nowy scenariusz';

  @override
  String get searchScripts => 'Szukaj scenariuszy';

  @override
  String get filterAll => 'Wszystkie';

  @override
  String get statusDraft => 'Szkic';

  @override
  String get statusReady => 'Gotowy';

  @override
  String get statusRecorded => 'Nagrany';

  @override
  String markAs(String status) {
    return 'Oznacz jako: $status';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'Próba';

  @override
  String get float => 'Pływające';

  @override
  String get record => 'Nagraj';

  @override
  String words(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count słowa',
      many: '$count słów',
      few: '$count słowa',
      one: '1 słowo',
    );
    return '$_temp0';
  }

  @override
  String takes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ujęcia',
      many: '$count ujęć',
      few: '$count ujęcia',
      one: '1 ujęcie',
    );
    return '$_temp0';
  }

  @override
  String get noScriptsYet => 'Nie ma jeszcze scenariuszy';

  @override
  String get noScriptsHint =>
      'Stuknij „Nowy scenariusz” i wybierz szablon, aby zacząć.';

  @override
  String get nothingHere => 'Nic tu nie ma';

  @override
  String get nothingHereHint => 'Spróbuj innego filtra lub wyszukiwania.';

  @override
  String get startFromTemplate => 'Zacznij od szablonu';

  @override
  String get overlayPermissionNeeded =>
      'Zezwól na „Wyświetlanie nad innymi aplikacjami”, aby używać pływającego promptera.';

  @override
  String get floatingStarted =>
      'Prompter jest na wierzchu. Otwórz aplikację aparatu i stuknij tekst, aby zacząć.';

  @override
  String get floatingNotificationTitle => 'APrompter jest na wierzchu';

  @override
  String get openScriptInApp => 'Otwórz scenariusz w APrompter';

  @override
  String get script => 'Scenariusz';

  @override
  String get title => 'Tytuł';

  @override
  String get status => 'Status';

  @override
  String get noTarget => 'Bez celu';

  @override
  String get editorHint =>
      'Napisz lub wklej to, co chcesz powiedzieć…\n\nWskazówka: zacznij wiersz od # dla sekcji, od // dla notatki dla siebie.';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $spoken przy $wpm sł/min';
  }

  @override
  String get onTarget => 'W celu';

  @override
  String overTarget(int seconds, int words) {
    return '$seconds s za długo · wytnij ~$words słów';
  }

  @override
  String underTarget(int seconds, int words) {
    return 'Zostało $seconds s · jeszcze ~$words słów';
  }

  @override
  String longSentences(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count długiego zdania (25+ słów) — podziel je, żeby złapać oddech',
      many: '$count długich zdań (25+ słów) — podziel je, żeby złapać oddech',
      few: '$count długie zdania (25+ słów) — podziel je, żeby złapać oddech',
      one: '1 długie zdanie (25+ słów) — podziel je, żeby złapać oddech',
    );
    return '$_temp0';
  }

  @override
  String get toolSection => 'Sekcja';

  @override
  String get toolEmphasis => 'Akcent';

  @override
  String get toolPause => 'Pauza';

  @override
  String get toolNote => 'Notatka';

  @override
  String get toolPaste => 'Wklej';

  @override
  String get restart => 'Od nowa';

  @override
  String get sections => 'Sekcje';

  @override
  String get slower => 'Wolniej';

  @override
  String get faster => 'Szybciej';

  @override
  String get play => 'Odtwórz';

  @override
  String get pause => 'Pauza';

  @override
  String get wpmUnit => 'sł/min';

  @override
  String get startOfScript => 'Początek scenariusza';

  @override
  String sectionN(int n) {
    return 'Sekcja $n';
  }

  @override
  String get noSectionsHint =>
      'Brak sekcji. Dodaj w edytorze wiersze zaczynające się od „#” (np. „# Haczyk”), by przeskakiwać między częściami i powtórzyć tylko jedną.';

  @override
  String get emptyScript => '(pusty scenariusz)';

  @override
  String get preview => 'Podgląd';

  @override
  String get setup => 'Konfiguracja';

  @override
  String get pace => 'Tempo';

  @override
  String get text => 'Tekst';

  @override
  String get layout => 'Układ';

  @override
  String get recording => 'Nagrywanie';

  @override
  String get wordsPerMinute => 'słów / min';

  @override
  String fitTo(String time) {
    return 'Dopasuj do $time';
  }

  @override
  String get paceCalm => 'Spokojne';

  @override
  String get paceNatural => 'Naturalne';

  @override
  String get paceEnergetic => 'Energiczne';

  @override
  String get countdown => 'Odliczanie przed startem';

  @override
  String get off => 'Wył.';

  @override
  String get size => 'Rozmiar';

  @override
  String get lineSpacing => 'Odstęp między wierszami';

  @override
  String get textColor => 'Kolor tekstu';

  @override
  String get prompterHeight => 'Wysokość promptera';

  @override
  String get background => 'Tło';

  @override
  String get readingGuide => 'Linia czytania';

  @override
  String get mirrorText => 'Odbicie lustrzane';

  @override
  String get mirrorTextHint => 'Do szyby telepromptera / beam splittera';

  @override
  String get videoQuality => 'Jakość wideo';

  @override
  String get autoStop => 'Zatrzymaj nagrywanie na końcu scenariusza';

  @override
  String get autoStopHint => 'Czeka 2 sekundy po ostatnim wierszu';

  @override
  String get presetHandheld => 'Selfie z ręki';

  @override
  String get presetHandheldHint => 'Średni tekst blisko obiektywu';

  @override
  String get presetTripod => 'Statyw / z daleka';

  @override
  String get presetTripodHint => 'Duży tekst czytelny z 1–2 m';

  @override
  String get presetGlass => 'Szyba telepromptera';

  @override
  String get presetGlassHint => 'Lustrzany, pełny ekran, pełne tło';

  @override
  String get niceRun => 'Świetnie!';

  @override
  String runSummary(String time, int words, int wpm) {
    return 'Zajęło ci to $time dla $words słów → $wpm słów na minutę.';
  }

  @override
  String runOver(int seconds, String target) {
    return 'To $seconds s ponad cel $target — skróć scenariusz albo przyspiesz.';
  }

  @override
  String runUnder(int seconds) {
    return 'Masz jeszcze $seconds s zapasu do celu.';
  }

  @override
  String get runOnTarget => 'Idealnie w docelowej długości. 🎯';

  @override
  String get keepCurrent => 'Zostaw';

  @override
  String useWpm(int wpm) {
    return 'Użyj $wpm sł/min';
  }

  @override
  String get switchCamera => 'Przełącz aparat';

  @override
  String get startRecording => 'Zacznij nagrywać';

  @override
  String get stopRecording => 'Zatrzymaj nagrywanie';

  @override
  String get noCamera => 'Nie znaleziono aparatu w tym urządzeniu.';

  @override
  String get cameraDenied =>
      'Odmówiono dostępu do aparatu. Włącz go w ustawieniach systemu.';

  @override
  String cameraError(String message) {
    return 'Błąd aparatu: $message';
  }

  @override
  String takeSaved(int n) {
    return 'Ujęcie $n zapisane w galerii';
  }

  @override
  String get templateBlank => 'Pusty';

  @override
  String get templateBlankHint => 'Zacznij od pustej strony';

  @override
  String get templateHvc => 'Haczyk → Wartość → CTA';

  @override
  String get templateHvcHint => 'Klasyczna struktura krótkiego wideo';

  @override
  String get templateTutorial => 'Poradnik';

  @override
  String get templateTutorialHint => 'Naucz czegoś krok po kroku';

  @override
  String get templateReview => 'Recenzja produktu';

  @override
  String get templateReviewHint => 'UGC, reklamy i szczere recenzje';

  @override
  String get templateStory => 'Storytime';

  @override
  String get templateStoryHint => 'Osobista historia z morałem';

  @override
  String get secHook => 'Haczyk';

  @override
  String get secValue => 'Wartość';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'Krok $n';
  }

  @override
  String get secRecap => 'Podsumowanie i CTA';

  @override
  String get secWhatItIs => 'Co to jest';

  @override
  String get secLoved => 'Co mi się podobało';

  @override
  String get secBetter => 'Co mogłoby być lepsze';

  @override
  String get secVerdict => 'Werdykt i CTA';

  @override
  String get secSetup => 'Wprowadzenie';

  @override
  String get secTurningPoint => 'Punkt zwrotny';

  @override
  String get secLesson => 'Lekcja';

  @override
  String get noteHook =>
      'Przyciągnij uwagę w pierwszych 3 sekundach: śmiałe stwierdzenie lub pytanie';

  @override
  String get noteValue => 'Daj tę jedną rzecz, którą obiecałeś';

  @override
  String get noteCta =>
      'Powiedz, co zrobić dalej: obserwuj, skomentuj, link w bio';

  @override
  String get noteTutorialHook => '„Oto jak … w mniej niż minutę”';

  @override
  String get noteRecap => 'Podsumuj jednym zdaniem i poproś o zapisanie filmu';

  @override
  String get noteReviewHook => 'Pokaż produkt i problem, który rozwiązuje';

  @override
  String get noteVerdict => 'Dla kogo jest — podaj kod lub link';

  @override
  String get noteStoryHook => 'Zacznij w środku akcji';

  @override
  String get welcomeTitle => 'Witaj w APrompter';

  @override
  String get welcomeBody =>
      '# Haczyk\nChcesz nagrywać bez zapominania tekstu? [pause]\n// patrz prosto w obiektyw\n\n# Jak to działa\nNapisz scenariusz, wybierz *docelową długość*, a licznik powie ci, czy się mieścisz.\nZrób próbę, aby znaleźć swoje tempo w słowach na minutę.\nPotem stuknij Nagraj. Tekst przewija się tuż pod aparatem, więc utrzymujesz *kontakt wzrokowy* z widzami.\n\n# CTA\nStuknij tę kartę, aby edytować scenariusz, albo utwórz własny przyciskiem plus. [pause] Miłego tworzenia!\n';

  @override
  String get expand => 'Rozwiń';

  @override
  String get minimize => 'Minimalizuj';

  @override
  String get nothingToSay =>
      'Najpierw dodaj coś do powiedzenia — sekcje (#) i notatki (//) nie są czytane.';

  @override
  String get openSettings => 'Otwórz ustawienia';

  @override
  String get tryAgain => 'Spróbuj ponownie';

  @override
  String get noMicBanner =>
      'Brak dostępu do mikrofonu — nagrywanie bez dźwięku';

  @override
  String get saveFailedTitle => 'Nie udało się zapisać w galerii';

  @override
  String saveFailedBody(String reason) {
    return 'Twoje ujęcie jest na razie bezpieczne. Spróbuj ponownie albo udostępnij je do Plików, na Dysk lub do czatu, żeby go nie stracić. ($reason)';
  }

  @override
  String get shareVideo => 'Udostępnij wideo';

  @override
  String get discardTake => 'Odrzuć to ujęcie';

  @override
  String takeShared(int n) {
    return 'Udostępniono ujęcie $n';
  }

  @override
  String get movePrompter => 'Przeciągnij, aby przesunąć prompter';

  @override
  String get resizePrompter => 'Przeciągnij, aby zmienić rozmiar promptera';

  @override
  String get prompterWidth => 'Szerokość promptera';

  @override
  String get resetPosition => 'Resetuj pozycję (góra, pełna szerokość)';

  @override
  String get positionHint =>
      'Przeciągnij pasek na górze promptera, aby przenieść go w dowolne miejsce, a róg, aby zmienić rozmiar. Na Androidzie pływające okno można przeciągnąć wszędzie i zapamiętuje swoje miejsce.';

  @override
  String get app => 'Aplikacja';

  @override
  String get appLanguage => 'Język aplikacji';

  @override
  String get systemDefault => 'Język telefonu';

  @override
  String secondsShort(int n) {
    return '$n s';
  }

  @override
  String minutesShort(int n) {
    return '$n min';
  }
}
