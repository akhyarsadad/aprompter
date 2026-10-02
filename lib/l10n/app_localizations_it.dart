// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'Chiudi';

  @override
  String get settings => 'Impostazioni';

  @override
  String get prompterSettings => 'Impostazioni del prompter';

  @override
  String get edit => 'Modifica';

  @override
  String get delete => 'Elimina';

  @override
  String get undo => 'Annulla';

  @override
  String get duplicate => 'Duplica';

  @override
  String get share => 'Condividi';

  @override
  String get copyAsCaption => 'Copia come didascalia';

  @override
  String get captionCopied =>
      'Testo parlato copiato: incollalo come didascalia';

  @override
  String get copySuffix => '(copia)';

  @override
  String deletedScript(String title) {
    return '\"$title\" eliminato';
  }

  @override
  String duplicatedScript(String title) {
    return 'Duplicato come \"$title\"';
  }

  @override
  String get untitled => 'Senza titolo';

  @override
  String get newScript => 'Nuovo copione';

  @override
  String get searchScripts => 'Cerca copioni';

  @override
  String get filterAll => 'Tutti';

  @override
  String get statusDraft => 'Bozza';

  @override
  String get statusReady => 'Pronto';

  @override
  String get statusRecorded => 'Registrato';

  @override
  String markAs(String status) {
    return 'Segna come $status';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'Prova';

  @override
  String get float => 'Fluttuante';

  @override
  String get record => 'Registra';

  @override
  String words(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parole',
      one: '1 parola',
    );
    return '$_temp0';
  }

  @override
  String takes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count riprese',
      one: '1 ripresa',
    );
    return '$_temp0';
  }

  @override
  String get noScriptsYet => 'Ancora nessun copione';

  @override
  String get noScriptsHint =>
      'Tocca \"Nuovo copione\" e scegli un modello per iniziare.';

  @override
  String get nothingHere => 'Niente qui';

  @override
  String get nothingHereHint => 'Prova un altro filtro o un\'altra ricerca.';

  @override
  String get startFromTemplate => 'Parti da un modello';

  @override
  String get overlayPermissionNeeded =>
      'Consenti \"Mostra sopra altre app\" per usare il prompter fluttuante.';

  @override
  String get floatingStarted =>
      'Il prompter è fluttuante. Apri l\'app fotocamera e tocca il testo per iniziare.';

  @override
  String get floatingNotificationTitle => 'APrompter è in sovrimpressione';

  @override
  String get openScriptInApp => 'Apri un copione in APrompter';

  @override
  String get script => 'Copione';

  @override
  String get title => 'Titolo';

  @override
  String get status => 'Stato';

  @override
  String get noTarget => 'Nessun obiettivo';

  @override
  String get editorHint =>
      'Scrivi o incolla quello che vuoi dire…\n\nSuggerimento: inizia una riga con # per una sezione, con // per una nota per te.';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $spoken a $wpm ppm';
  }

  @override
  String get onTarget => 'Nell\'obiettivo';

  @override
  String overTarget(int seconds, int words) {
    return '$seconds s in più · taglia ~$words parole';
  }

  @override
  String underTarget(int seconds, int words) {
    return 'Restano $seconds s · ~$words parole ancora';
  }

  @override
  String longSentences(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count frasi lunghe (25+ parole): dividile per respirare',
      one: '1 frase lunga (25+ parole): dividila per respirare',
    );
    return '$_temp0';
  }

  @override
  String get toolSection => 'Sezione';

  @override
  String get toolEmphasis => 'Enfasi';

  @override
  String get toolPause => 'Pausa';

  @override
  String get toolNote => 'Nota';

  @override
  String get toolPaste => 'Incolla';

  @override
  String get restart => 'Ricomincia';

  @override
  String get sections => 'Sezioni';

  @override
  String get slower => 'Più lento';

  @override
  String get faster => 'Più veloce';

  @override
  String get play => 'Avvia';

  @override
  String get pause => 'Pausa';

  @override
  String get wpmUnit => 'ppm';

  @override
  String get startOfScript => 'Inizio del copione';

  @override
  String sectionN(int n) {
    return 'Sezione $n';
  }

  @override
  String get noSectionsHint =>
      'Ancora nessuna sezione. Aggiungi nell\'editor righe che iniziano con \"#\" (es. \"# Gancio\") per saltare tra le parti e rifarne solo una.';

  @override
  String get emptyScript => '(copione vuoto)';

  @override
  String get preview => 'Anteprima';

  @override
  String get setup => 'Configurazione';

  @override
  String get pace => 'Ritmo';

  @override
  String get text => 'Testo';

  @override
  String get layout => 'Layout';

  @override
  String get recording => 'Registrazione';

  @override
  String get wordsPerMinute => 'parole / min';

  @override
  String fitTo(String time) {
    return 'Adatta a $time';
  }

  @override
  String get paceCalm => 'Calmo';

  @override
  String get paceNatural => 'Naturale';

  @override
  String get paceEnergetic => 'Energico';

  @override
  String get countdown => 'Conto alla rovescia prima di iniziare';

  @override
  String get off => 'Off';

  @override
  String get size => 'Dimensione';

  @override
  String get lineSpacing => 'Interlinea';

  @override
  String get textColor => 'Colore del testo';

  @override
  String get prompterHeight => 'Altezza del prompter';

  @override
  String get background => 'Sfondo';

  @override
  String get readingGuide => 'Linea guida di lettura';

  @override
  String get mirrorText => 'Testo a specchio';

  @override
  String get mirrorTextHint => 'Per vetro da teleprompter / beam splitter';

  @override
  String get videoQuality => 'Qualità video';

  @override
  String get autoStop => 'Interrompi la registrazione a fine copione';

  @override
  String get autoStopHint => 'Attende 2 secondi dopo l\'ultima riga';

  @override
  String get presetHandheld => 'Selfie a mano';

  @override
  String get presetHandheldHint => 'Testo medio vicino all\'obiettivo';

  @override
  String get presetTripod => 'Treppiede / a distanza';

  @override
  String get presetTripodHint => 'Testo grande leggibile da 1–2 m';

  @override
  String get presetGlass => 'Vetro da teleprompter';

  @override
  String get presetGlassHint => 'A specchio, schermo intero, sfondo pieno';

  @override
  String get niceRun => 'Ottimo lavoro!';

  @override
  String runSummary(String time, int words, int wpm) {
    return 'Ci hai messo $time per $words parole → $wpm parole al minuto.';
  }

  @override
  String runOver(int seconds, String target) {
    return 'Sono $seconds s oltre l\'obiettivo di $target: accorcia il copione o accelera.';
  }

  @override
  String runUnder(int seconds) {
    return 'Hai ancora $seconds s prima dell\'obiettivo.';
  }

  @override
  String get runOnTarget => 'Esattamente nella durata obiettivo. 🎯';

  @override
  String get keepCurrent => 'Mantieni';

  @override
  String useWpm(int wpm) {
    return 'Usa $wpm ppm';
  }

  @override
  String get switchCamera => 'Cambia fotocamera';

  @override
  String get startRecording => 'Avvia registrazione';

  @override
  String get stopRecording => 'Interrompi registrazione';

  @override
  String get noCamera => 'Nessuna fotocamera trovata su questo dispositivo.';

  @override
  String get cameraDenied =>
      'Accesso alla fotocamera negato. Attivalo nelle impostazioni di sistema.';

  @override
  String cameraError(String message) {
    return 'Errore fotocamera: $message';
  }

  @override
  String takeSaved(int n) {
    return 'Ripresa $n salvata in galleria';
  }

  @override
  String get templateBlank => 'Vuoto';

  @override
  String get templateBlankHint => 'Parti da una pagina vuota';

  @override
  String get templateHvc => 'Gancio → Valore → CTA';

  @override
  String get templateHvcHint => 'La struttura classica dei video brevi';

  @override
  String get templateTutorial => 'Tutorial';

  @override
  String get templateTutorialHint => 'Insegna qualcosa passo dopo passo';

  @override
  String get templateReview => 'Recensione prodotto';

  @override
  String get templateReviewHint => 'UGC, sponsorizzate e recensioni oneste';

  @override
  String get templateStory => 'Storytime';

  @override
  String get templateStoryHint => 'Storia personale con una lezione';

  @override
  String get secHook => 'Gancio';

  @override
  String get secValue => 'Valore';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'Passo $n';
  }

  @override
  String get secRecap => 'Riepilogo e CTA';

  @override
  String get secWhatItIs => 'Che cos\'è';

  @override
  String get secLoved => 'Cosa mi è piaciuto';

  @override
  String get secBetter => 'Cosa si potrebbe migliorare';

  @override
  String get secVerdict => 'Verdetto e CTA';

  @override
  String get secSetup => 'Premessa';

  @override
  String get secTurningPoint => 'Svolta';

  @override
  String get secLesson => 'Lezione';

  @override
  String get noteHook =>
      'Cattura l\'attenzione nei primi 3 secondi: un\'affermazione audace o una domanda';

  @override
  String get noteValue => 'Dai l\'unica cosa che hai promesso';

  @override
  String get noteCta => 'Di\' cosa fare dopo: seguire, commentare, link in bio';

  @override
  String get noteTutorialHook => '\"Ecco come … in meno di un minuto\"';

  @override
  String get noteRecap =>
      'Riassumi in una frase, poi chiedi di salvare il video';

  @override
  String get noteReviewHook => 'Mostra il prodotto e il problema che risolve';

  @override
  String get noteVerdict => 'Per chi è adatto: cita il codice o il link';

  @override
  String get noteStoryHook => 'Inizia nel pieno dell\'azione';

  @override
  String get welcomeTitle => 'Benvenuto in APrompter';

  @override
  String get welcomeBody =>
      '# Gancio\nVuoi registrare senza dimenticare le battute? [pause]\n// guarda dritto nell\'obiettivo\n\n# Come funziona\nScrivi il copione, scegli una *durata obiettivo* e il timer ti dice se ci stai.\nFai una prova per trovare il tuo ritmo in parole al minuto.\nPoi tocca Registra. Il testo scorre proprio sotto la fotocamera, così mantieni il *contatto visivo* con il pubblico.\n\n# CTA\nTocca questa scheda per modificare il copione o creane uno tuo con il pulsante più. [pause] Buon divertimento!\n';

  @override
  String get expand => 'Espandi';

  @override
  String get minimize => 'Riduci';

  @override
  String get nothingToSay =>
      'Aggiungi prima qualcosa da dire: sezioni (#) e note (//) non vengono lette.';

  @override
  String get openSettings => 'Apri impostazioni';

  @override
  String get tryAgain => 'Riprova';

  @override
  String get noMicBanner =>
      'Nessun accesso al microfono: registrazione senza audio';

  @override
  String get saveFailedTitle => 'Impossibile salvare in galleria';

  @override
  String saveFailedBody(String reason) {
    return 'La tua ripresa per ora è al sicuro. Riprova o condividila su File, Drive o in una chat per non perderla. ($reason)';
  }

  @override
  String get shareVideo => 'Condividi video';

  @override
  String get discardTake => 'Scarta questa ripresa';

  @override
  String takeShared(int n) {
    return 'Ripresa $n condivisa';
  }

  @override
  String get movePrompter => 'Trascina per spostare il prompter';

  @override
  String get resizePrompter => 'Trascina per ridimensionare il prompter';

  @override
  String get prompterWidth => 'Larghezza del prompter';

  @override
  String get resetPosition => 'Ripristina posizione (in alto, larghezza piena)';

  @override
  String get positionHint =>
      'Trascina la barra in cima al prompter per spostarlo ovunque e l\'angolo per ridimensionarlo. Su Android la finestra fluttuante si sposta ovunque e ricorda la posizione.';

  @override
  String get app => 'App';

  @override
  String get appLanguage => 'Lingua dell\'app';

  @override
  String get systemDefault => 'Lingua del telefono';

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
      'Impossibile salvare: forse la memoria del telefono è piena. Il tuo lavoro resta finché l\'app è aperta.';

  @override
  String get versionHistory => 'Cronologia versioni';

  @override
  String get noVersions =>
      'Ancora nessuna versione precedente. Vengono salvate automaticamente mentre scrivi.';

  @override
  String get restore => 'Ripristina';

  @override
  String get versionRestored => 'Versione precedente ripristinata';

  @override
  String get recentlyDeleted => 'Eliminati di recente';

  @override
  String trashHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'I copioni eliminati restano qui per $days giorni.',
      one: 'I copioni eliminati restano qui per 1 giorno.',
    );
    return '$_temp0';
  }

  @override
  String get deleteForever => 'Elimina definitivamente';

  @override
  String deletedOn(String date) {
    return 'Eliminato il $date';
  }

  @override
  String restoredScript(String title) {
    return '\"$title\" ripristinato';
  }

  @override
  String get backUpScripts => 'Backup di tutti i copioni';

  @override
  String get restoreBackup => 'Ripristina da un backup';

  @override
  String get backupShareTitle => 'Backup di APrompter';

  @override
  String importedScripts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count copioni ripristinati',
      one: '1 copione ripristinato',
      zero: 'Tutto il contenuto di questo backup è già qui',
    );
    return '$_temp0';
  }

  @override
  String get notABackup => 'Questo file non è un backup di APrompter.';

  @override
  String fitImpossible(int wpm, String target, int words) {
    return 'Anche a $wpm ppm non entra in $target: taglia circa $words parole.';
  }

  @override
  String get cameraNotReady =>
      'La fotocamera non era pronta, quindi la registrazione non è partita. Riprova.';

  @override
  String get previousSection => 'Sezione precedente';

  @override
  String get nextSection => 'Sezione successiva';

  @override
  String get floatingNotificationBody => 'Tocca per aprire APrompter';

  @override
  String get customTarget => 'Personalizzata…';

  @override
  String get customTargetTitle => 'Durata obiettivo';

  @override
  String get customTargetHint => 'Minuti e secondi, es. 5:00';

  @override
  String get saved => 'Salvato';

  @override
  String get floatNotOnIos =>
      'Su iPhone le app non possono fluttuare sopra altre app. Usa Registra per filmare con il copione sotto la fotocamera.';

  @override
  String get hashtagHint =>
      'Le righe di hashtag (#fyp #ad) sono attenuate e non cronometrate. Usa \"# \" con uno spazio per una sezione.';

  @override
  String get appLock => 'Blocco app';

  @override
  String get appLockHint =>
      'Chiedi impronta, volto o PIN del telefono per aprire APrompter';

  @override
  String get appLockUnavailable =>
      'Prima imposta un blocco schermo su questo telefono.';

  @override
  String get unlock => 'Sblocca';

  @override
  String get unlockReason => 'Sblocca APrompter per vedere i tuoi copioni';

  @override
  String get autoStopWait => 'Attesa dopo l\'ultima riga';

  @override
  String get beforeYouRecord => 'Prima di registrare';

  @override
  String get recordAnyway => 'Registra comunque';

  @override
  String lowStorageWarning(int minutes) {
    return 'Nello spazio libero entrano solo circa $minutes min di video. Libera spazio o abbassa la qualità video.';
  }

  @override
  String lowBatteryWarning(int level) {
    return 'Batteria al $level%: una ripresa lunga potrebbe interrompersi. Collega il caricatore se puoi.';
  }

  @override
  String get brightScreen => 'Luminosità massima durante il prompter';

  @override
  String get brightScreenHint => 'Più leggibile all\'aperto';

  @override
  String get cameraBusy =>
      'Un\'altra app sta usando la fotocamera. Chiudila e riprova.';

  @override
  String get cameraIntroTitle => 'Fotocamera e microfono';

  @override
  String get cameraIntroBody =>
      'Per filmarti con il copione sullo schermo, APrompter ha bisogno di fotocamera e microfono. Il telefono te lo chiederà ora. I video restano sul tuo telefono.';

  @override
  String get continueLabel => 'Continua';

  @override
  String get notNow => 'Non ora';

  @override
  String get colorWhite => 'Bianco';

  @override
  String get colorYellow => 'Giallo';

  @override
  String get colorGreen => 'Verde';

  @override
  String get colorBlue => 'Blu';

  @override
  String get colorPink => 'Rosa';

  @override
  String get colorBlack => 'Nero';

  @override
  String get damagedData => 'Dati illeggibili';

  @override
  String damagedDataHint(String date, int size) {
    return 'Messi da parte il $date · $size caratteri';
  }

  @override
  String get tryToRecover => 'Prova a recuperare';

  @override
  String get nothingRecovered => 'Non è stato possibile leggere alcun copione.';

  @override
  String get floatLowRam =>
      'Questo telefono non può mostrare app sopra altre app (poca memoria o Android Go). Usa invece Registra.';

  @override
  String get oemTipsTitle => 'Mantieni attivo il prompter fluttuante';

  @override
  String oemTipsBody(String brand) {
    return 'I telefoni $brand possono chiudere le finestre fluttuanti per risparmiare batteria. In Impostazioni → App → APrompter: consenti la visualizzazione sopra altre app (e le finestre pop-up), imposta la batteria su \"Senza restrizioni\" e consenti le notifiche.';
  }

  @override
  String get focusLine => 'Evidenzia la riga attuale';

  @override
  String get focusLineHint => 'Attenua le altre righe';

  @override
  String get stepByLine => 'Riga per riga';

  @override
  String get stepByLineHint =>
      'Ogni tocco o pressione del telecomando avanza di una riga, senza scorrimento automatico';

  @override
  String get reduceEffects => 'Riduci effetti';

  @override
  String get reduceEffectsHint =>
      'Niente dissolvenze né ombre: più fluido sui telefoni datati, risparmia batteria';

  @override
  String get letterSpacing => 'Spaziatura lettere';

  @override
  String get importTextFile => 'Importa un file di testo';

  @override
  String get importTextFileHint =>
      'Un copione .txt o .md da File, Drive o email';

  @override
  String get importTextFailed =>
      'Impossibile leggere il file. Scegli un file di testo semplice (.txt).';

  @override
  String get mySetup => 'La mia configurazione';

  @override
  String get mySetupHint => 'La configurazione che hai salvato';

  @override
  String get saveMySetup => 'Salva come mia configurazione';

  @override
  String get resetAllSettings => 'Ripristina tutte le impostazioni';

  @override
  String get runHadJumps =>
      'Hai saltato dei punti in questa prova, quindi non può suggerire un ritmo.';

  @override
  String get keepTake => 'Tieni';

  @override
  String get retake => 'Rifai';

  @override
  String get reviewTakes => 'Rivedi ogni ripresa';

  @override
  String get reviewTakesHint => 'Guardala, poi tienila o rifalla';

  @override
  String get takesToGallery => 'Salva le riprese in galleria';

  @override
  String get takesToGalleryHint =>
      'Disattivato: le riprese restano nell\'app, fuori da Google Photos e iCloud';

  @override
  String get takesTitle => 'Riprese';

  @override
  String get takesEmpty =>
      'Qui compaiono le riprese tenute nell\'app. Disattiva \"Salva le riprese in galleria\" nelle impostazioni per tenerle qui.';

  @override
  String get saveToGallery => 'Salva in galleria';

  @override
  String get savedToGallery => 'Salvato nella tua galleria';

  @override
  String get deleteTake => 'Elimina ripresa';

  @override
  String takeKeptInApp(int n) {
    return 'Ripresa $n tenuta nell\'app';
  }

  @override
  String get signInTitle => 'Sign in to continue';

  @override
  String get signInBody =>
      'This only identifies your purchase across your devices — it does not sync your scripts.';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get signInFailed => 'Sign in failed. Try again.';

  @override
  String get upgradeTitle => 'Go unlimited';

  @override
  String get upgradeBody =>
      'Unlock unlimited scripts and length with a subscription or a one-time purchase.';

  @override
  String get offeringsLoadFailed =>
      'Couldn\'t load plans. Check your connection and try again.';

  @override
  String get purchaseFailed => 'Purchase failed. Try again.';

  @override
  String get restoreFailed => 'Couldn\'t restore purchases. Try again.';

  @override
  String get restorePurchases => 'Restore purchases';
}
