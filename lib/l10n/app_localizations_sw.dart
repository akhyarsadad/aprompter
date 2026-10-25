// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'Funga';

  @override
  String get settings => 'Mipangilio';

  @override
  String get prompterSettings => 'Mipangilio ya prompter';

  @override
  String get edit => 'Hariri';

  @override
  String get delete => 'Futa';

  @override
  String get undo => 'Tendua';

  @override
  String get duplicate => 'Nakili';

  @override
  String get share => 'Shiriki';

  @override
  String get copyAsCaption => 'Nakili kama maelezo';

  @override
  String get captionCopied =>
      'Maandishi ya kusema yamenakiliwa — yabandike kama maelezo ya chapisho';

  @override
  String get copySuffix => '(nakala)';

  @override
  String deletedScript(String title) {
    return '\"$title\" imefutwa';
  }

  @override
  String duplicatedScript(String title) {
    return 'Imenakiliwa kama \"$title\"';
  }

  @override
  String get untitled => 'Bila jina';

  @override
  String get newScript => 'Hati mpya';

  @override
  String get searchScripts => 'Tafuta hati';

  @override
  String get filterAll => 'Zote';

  @override
  String get statusDraft => 'Rasimu';

  @override
  String get statusReady => 'Tayari';

  @override
  String get statusRecorded => 'Imerekodiwa';

  @override
  String markAs(String status) {
    return 'Weka alama: $status';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'Mazoezi';

  @override
  String get float => 'Elea';

  @override
  String get record => 'Rekodi';

  @override
  String words(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'maneno $count',
      one: 'neno 1',
    );
    return '$_temp0';
  }

  @override
  String takes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'picha $count',
      one: 'picha 1',
    );
    return '$_temp0';
  }

  @override
  String get noScriptsYet => 'Bado hakuna hati';

  @override
  String get noScriptsHint =>
      'Gusa \"Hati mpya\" na uchague kiolezo ili kuanza.';

  @override
  String get nothingHere => 'Hakuna kitu hapa';

  @override
  String get nothingHereHint => 'Jaribu kichujio au utafutaji mwingine.';

  @override
  String get startFromTemplate => 'Anza na kiolezo';

  @override
  String get overlayPermissionNeeded =>
      'Ruhusu \"Onyesha juu ya programu nyingine\" ili kutumia prompter inayoelea.';

  @override
  String get floatingStarted =>
      'Prompter inaelea. Fungua programu ya kamera na ugonge maandishi ili kuanza.';

  @override
  String get floatingNotificationTitle => 'APrompter inaelea skrinini';

  @override
  String get openScriptInApp => 'Fungua hati katika APrompter';

  @override
  String get script => 'Hati';

  @override
  String get title => 'Kichwa';

  @override
  String get status => 'Hali';

  @override
  String get noTarget => 'Hakuna lengo';

  @override
  String get editorHint =>
      'Andika au bandika unachotaka kusema…\n\nKidokezo: anza mstari kwa # kwa sehemu, kwa // kwa dokezo lako binafsi.';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $spoken kwa $wpm m/d';
  }

  @override
  String get onTarget => 'Kwenye lengo';

  @override
  String overTarget(int seconds, int words) {
    return 'Zaidi kwa sek $seconds · punguza maneno ~$words';
  }

  @override
  String underTarget(int seconds, int words) {
    return 'Zimebaki sek $seconds · maneno ~$words zaidi';
  }

  @override
  String longSentences(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sentensi $count ndefu (maneno 25+) — zigawe ili upate kupumua',
      one: 'Sentensi 1 ndefu (maneno 25+) — igawe ili upate kupumua',
    );
    return '$_temp0';
  }

  @override
  String get toolSection => 'Sehemu';

  @override
  String get toolEmphasis => 'Msisitizo';

  @override
  String get toolPause => 'Kituo';

  @override
  String get toolNote => 'Dokezo';

  @override
  String get toolPaste => 'Bandika';

  @override
  String get restart => 'Anza upya';

  @override
  String get sections => 'Sehemu';

  @override
  String get slower => 'Polepole';

  @override
  String get faster => 'Haraka';

  @override
  String get play => 'Cheza';

  @override
  String get pause => 'Sitisha';

  @override
  String get wpmUnit => 'm/d';

  @override
  String get startOfScript => 'Mwanzo wa hati';

  @override
  String sectionN(int n) {
    return 'Sehemu $n';
  }

  @override
  String get noSectionsHint =>
      'Bado hakuna sehemu. Ongeza mistari inayoanza na \"#\" kwenye kihariri (k.m. \"# Ndoano\") ili kuruka kati ya sehemu na kurekodi upya moja tu.';

  @override
  String get emptyScript => '(hati tupu)';

  @override
  String get preview => 'Onyesho la awali';

  @override
  String get setup => 'Mpangilio wa upigaji';

  @override
  String get pace => 'Kasi';

  @override
  String get text => 'Maandishi';

  @override
  String get layout => 'Mpangilio';

  @override
  String get recording => 'Kurekodi';

  @override
  String get wordsPerMinute => 'maneno / dakika';

  @override
  String fitTo(String time) {
    return 'Linganisha na $time';
  }

  @override
  String get paceCalm => 'Tulivu';

  @override
  String get paceNatural => 'Asilia';

  @override
  String get paceEnergetic => 'Kwa nguvu';

  @override
  String get countdown => 'Kuhesabu kabla ya kuanza';

  @override
  String get off => 'Zima';

  @override
  String get size => 'Ukubwa';

  @override
  String get lineSpacing => 'Nafasi ya mistari';

  @override
  String get textColor => 'Rangi ya maandishi';

  @override
  String get prompterHeight => 'Urefu wa prompter';

  @override
  String get background => 'Mandharinyuma';

  @override
  String get readingGuide => 'Mstari wa kusoma';

  @override
  String get mirrorText => 'Geuza maandishi kama kioo';

  @override
  String get mirrorTextHint => 'Kwa kioo cha teleprompter / beam splitter';

  @override
  String get videoQuality => 'Ubora wa video';

  @override
  String get autoStop => 'Acha kurekodi hati ikiisha';

  @override
  String get autoStopHint => 'Husubiri sekunde 2 baada ya mstari wa mwisho';

  @override
  String get presetHandheld => 'Selfie mkononi';

  @override
  String get presetHandheldHint => 'Maandishi ya wastani karibu na lenzi';

  @override
  String get presetTripod => 'Tripodi / kwa umbali';

  @override
  String get presetTripodHint => 'Maandishi makubwa yanayosomeka kutoka m 1–2';

  @override
  String get presetGlass => 'Kioo cha teleprompter';

  @override
  String get presetGlassHint => 'Imegeuzwa, skrini nzima, mandharinyuma imara';

  @override
  String get niceRun => 'Hongera!';

  @override
  String runSummary(String time, int words, int wpm) {
    return 'Ulitumia $time kwa maneno $words → maneno $wpm kwa dakika.';
  }

  @override
  String runOver(int seconds, String target) {
    return 'Hiyo ni sek $seconds zaidi ya lengo lako la $target — fupisha hati au ongeza kasi.';
  }

  @override
  String runUnder(int seconds) {
    return 'Una sek $seconds kabla ya lengo lako.';
  }

  @override
  String get runOnTarget => 'Sawasawa na urefu uliolenga. 🎯';

  @override
  String get keepCurrent => 'Acha ilivyo';

  @override
  String useWpm(int wpm) {
    return 'Tumia $wpm m/d';
  }

  @override
  String get switchCamera => 'Badilisha kamera';

  @override
  String get startRecording => 'Anza kurekodi';

  @override
  String get stopRecording => 'Acha kurekodi';

  @override
  String get noCamera => 'Hakuna kamera iliyopatikana kwenye kifaa hiki.';

  @override
  String get cameraDenied =>
      'Ruhusa ya kamera imekataliwa. Iwashe kwenye mipangilio ya mfumo.';

  @override
  String cameraError(String message) {
    return 'Hitilafu ya kamera: $message';
  }

  @override
  String takeSaved(int n) {
    return 'Picha $n imehifadhiwa kwenye matunzio';
  }

  @override
  String get templateBlank => 'Tupu';

  @override
  String get templateBlankHint => 'Anza na ukurasa mtupu';

  @override
  String get templateHvc => 'Ndoano → Thamani → CTA';

  @override
  String get templateHvcHint => 'Muundo wa kawaida wa video fupi';

  @override
  String get templateTutorial => 'Mafunzo';

  @override
  String get templateTutorialHint => 'Fundisha kitu hatua kwa hatua';

  @override
  String get templateReview => 'Tathmini ya bidhaa';

  @override
  String get templateReviewHint => 'UGC, matangazo na tathmini za kweli';

  @override
  String get templateStory => 'Hadithi';

  @override
  String get templateStoryHint => 'Hadithi binafsi yenye funzo';

  @override
  String get secHook => 'Ndoano';

  @override
  String get secValue => 'Thamani';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'Hatua $n';
  }

  @override
  String get secRecap => 'Muhtasari na CTA';

  @override
  String get secWhatItIs => 'Ni nini';

  @override
  String get secLoved => 'Nilichopenda';

  @override
  String get secBetter => 'Kinachoweza kuboreshwa';

  @override
  String get secVerdict => 'Uamuzi na CTA';

  @override
  String get secSetup => 'Utangulizi';

  @override
  String get secTurningPoint => 'Mabadiliko';

  @override
  String get secLesson => 'Funzo';

  @override
  String get noteHook =>
      'Vuta umakini ndani ya sekunde 3 za kwanza: dai la kijasiri au swali';

  @override
  String get noteValue => 'Toa kile kitu kimoja ulichoahidi';

  @override
  String get noteCta =>
      'Waambie wafanye nini baadaye: fuata, toa maoni, kiungo kwenye wasifu';

  @override
  String get noteTutorialHook => '\"Hivi ndivyo … chini ya dakika moja\"';

  @override
  String get noteRecap =>
      'Fupisha kwa sentensi moja, kisha waombe wahifadhi video';

  @override
  String get noteReviewHook => 'Onyesha bidhaa na tatizo inalotatua';

  @override
  String get noteVerdict => 'Inamfaa nani — taja msimbo au kiungo';

  @override
  String get noteStoryHook => 'Anza katikati ya tukio';

  @override
  String get welcomeTitle => 'Karibu APrompter';

  @override
  String get welcomeBody =>
      '# Ndoano\nUnataka kurekodi bila kusahau maneno yako? [pause]\n// tazama moja kwa moja kwenye lenzi\n\n# Jinsi inavyofanya kazi\nAndika hati yako, chagua *urefu unaolenga*, na kipima muda kitakuambia kama inatosha.\nFanya mazoezi kupata kasi yako kwa maneno kwa dakika.\nKisha gusa Rekodi. Maandishi yanasogea chini kabisa ya kamera, hivyo unadumisha *kutazamana macho* na hadhira yako.\n\n# CTA\nGusa kadi hii kuhariri hati, au unda yako mwenyewe kwa kitufe cha kuongeza. [pause] Furahia kuunda!\n';

  @override
  String get expand => 'Panua';

  @override
  String get minimize => 'Punguza';

  @override
  String get nothingToSay =>
      'Ongeza kwanza kitu cha kusema — sehemu (#) na madokezo (//) hayasomwi.';

  @override
  String get openSettings => 'Fungua mipangilio';

  @override
  String get tryAgain => 'Jaribu tena';

  @override
  String get noMicBanner =>
      'Hakuna ruhusa ya maikrofoni — inarekodi bila sauti';

  @override
  String get saveFailedTitle => 'Imeshindwa kuhifadhi kwenye matunzio';

  @override
  String saveFailedBody(String reason) {
    return 'Picha yako iko salama kwa sasa. Jaribu tena, au ishiriki kwenye Faili, Drive au gumzo ili isipotee. ($reason)';
  }

  @override
  String get shareVideo => 'Shiriki video';

  @override
  String get discardTake => 'Tupa picha hii';

  @override
  String takeShared(int n) {
    return 'Picha $n imeshirikiwa';
  }

  @override
  String get movePrompter => 'Buruta kusogeza prompter';

  @override
  String get resizePrompter => 'Buruta kubadilisha ukubwa wa prompter';

  @override
  String get prompterWidth => 'Upana wa prompter';

  @override
  String get resetPosition => 'Rejesha mahali (juu, upana kamili)';

  @override
  String get positionHint =>
      'Buruta upau ulio juu ya prompter kuisogeza popote, na kona kubadilisha ukubwa.';

  @override
  String get app => 'Programu';

  @override
  String get appLanguage => 'Lugha ya programu';

  @override
  String get systemDefault => 'Lugha ya simu';

  @override
  String secondsShort(int n) {
    return 'sek $n';
  }

  @override
  String minutesShort(int n) {
    return 'dak $n';
  }

  @override
  String get storageSaveFailed =>
      'Imeshindwa kuhifadhi — huenda nafasi ya simu imejaa. Kazi yako inabaki wakati programu iko wazi.';

  @override
  String get versionHistory => 'Historia ya matoleo';

  @override
  String get noVersions =>
      'Bado hakuna matoleo ya awali. Huhifadhiwa kiotomatiki unapoandika.';

  @override
  String get restore => 'Rejesha';

  @override
  String get versionRestored => 'Toleo la awali limerejeshwa';

  @override
  String get recentlyDeleted => 'Zilizofutwa hivi karibuni';

  @override
  String trashHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Hati zilizofutwa hukaa hapa kwa siku $days.',
      one: 'Hati zilizofutwa hukaa hapa kwa siku 1.',
    );
    return '$_temp0';
  }

  @override
  String get deleteForever => 'Futa kabisa';

  @override
  String deletedOn(String date) {
    return 'Imefutwa $date';
  }

  @override
  String restoredScript(String title) {
    return '\"$title\" imerejeshwa';
  }

  @override
  String get backUpScripts => 'Hifadhi nakala ya hati zote';

  @override
  String get restoreBackup => 'Rejesha kutoka nakala rudufu';

  @override
  String get backupShareTitle => 'Nakala rudufu ya APrompter';

  @override
  String importedScripts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hati $count zimerejeshwa',
      one: 'Hati 1 imerejeshwa',
      zero: 'Kila kitu katika nakala hii tayari kipo',
    );
    return '$_temp0';
  }

  @override
  String get notABackup => 'Faili hiyo si nakala rudufu ya APrompter.';

  @override
  String fitImpossible(int wpm, String target, int words) {
    return 'Hata kwa $wpm m/d haitatosha $target — punguza takriban maneno $words.';
  }

  @override
  String get cameraNotReady =>
      'Kamera haikuwa tayari, kwa hiyo kurekodi hakukuanza. Jaribu tena.';

  @override
  String get previousSection => 'Sehemu iliyotangulia';

  @override
  String get nextSection => 'Sehemu inayofuata';

  @override
  String get floatingNotificationBody => 'Gusa ili kufungua APrompter';

  @override
  String get customTarget => 'Maalum…';

  @override
  String get customTargetTitle => 'Urefu lengwa';

  @override
  String get customTargetHint => 'Dakika na sekunde, k.m. 5:00';

  @override
  String get saved => 'Imehifadhiwa';

  @override
  String get floatNotOnIos =>
      'iPhone na iPad haziruhusu programu kuelea juu ya programu nyingine. Tumia Rekodi kurekodi huku hati ikiwa chini ya kamera.';

  @override
  String get hashtagHint =>
      'Mistari ya hashtag (#fyp #ad) huonyeshwa hafifu na haipimwi muda. Tumia \"# \" yenye nafasi kwa sehemu.';

  @override
  String get appLock => 'Kufunga programu';

  @override
  String get appLockHint =>
      'Omba alama ya kidole, uso au PIN ya simu ili kufungua APrompter';

  @override
  String get appLockUnavailable =>
      'Weka kwanza kifunga skrini kwenye simu hii.';

  @override
  String get unlock => 'Fungua';

  @override
  String get unlockReason => 'Fungua APrompter ili kuona hati zako';

  @override
  String get autoStopWait => 'Subiri baada ya mstari wa mwisho';

  @override
  String get beforeYouRecord => 'Kabla ya kurekodi';

  @override
  String get recordAnyway => 'Rekodi hata hivyo';

  @override
  String lowStorageWarning(int minutes) {
    return 'Nafasi iliyo wazi inatosha video ya takriban dak $minutes tu. Futa vitu au punguza ubora wa video.';
  }

  @override
  String lowBatteryWarning(int level) {
    return 'Betri iko $level% — picha ndefu inaweza kukatika. Chomeka chaja ukiweza.';
  }

  @override
  String get brightScreen => 'Mwangaza kamili wakati wa prompter';

  @override
  String get brightScreenHint => 'Rahisi kusoma ukiwa nje';

  @override
  String get cameraBusy =>
      'Programu nyingine inatumia kamera. Ifunge kisha ujaribu tena.';

  @override
  String get cameraIntroTitle => 'Kamera na maikrofoni';

  @override
  String get cameraIntroBody =>
      'Ili kukurekodi ukiwa na hati kwenye skrini, APrompter inahitaji kamera na maikrofoni. Simu yako itauliza sasa. Video hubaki kwenye simu yako.';

  @override
  String get continueLabel => 'Endelea';

  @override
  String get notNow => 'Si sasa';

  @override
  String get colorWhite => 'Nyeupe';

  @override
  String get colorYellow => 'Njano';

  @override
  String get colorGreen => 'Kijani';

  @override
  String get colorBlue => 'Bluu';

  @override
  String get colorPink => 'Waridi';

  @override
  String get colorBlack => 'Nyeusi';

  @override
  String get damagedData => 'Data isiyosomeka';

  @override
  String damagedDataHint(String date, int size) {
    return 'Ilitengwa $date · herufi $size';
  }

  @override
  String get tryToRecover => 'Jaribu kurejesha';

  @override
  String get nothingRecovered => 'Hakuna hati iliyoweza kusomwa kutoka humo.';

  @override
  String get floatLowRam =>
      'Simu hii haiwezi kuonyesha programu juu ya programu nyingine (kumbukumbu ndogo au simu ya Android Go). Tumia Rekodi badala yake.';

  @override
  String get oemTipsTitle => 'Weka prompter inayoelea ikifanya kazi';

  @override
  String oemTipsBody(String brand) {
    return 'Simu za $brand zinaweza kufunga madirisha yanayoelea ili kuokoa betri. Katika Mipangilio → Programu → APrompter: ruhusu kuonyesha juu ya programu nyingine (na madirisha ibukizi), weka betri kuwa \"Bila vikwazo\", na uruhusu arifa.';
  }

  @override
  String get focusLine => 'Lenga mstari wa sasa';

  @override
  String get focusLineHint => 'Hufifisha mistari mingine';

  @override
  String get stepByLine => 'Mstari kwa mstari';

  @override
  String get stepByLineHint =>
      'Kila mguso au bonyezo la rimoti husogeza mstari mmoja — bila kusogeza kiotomatiki';

  @override
  String get reduceEffects => 'Punguza madoido';

  @override
  String get reduceEffectsHint =>
      'Bila kufifia wala vivuli: laini zaidi kwenye simu za zamani, huokoa betri';

  @override
  String get letterSpacing => 'Nafasi kati ya herufi';

  @override
  String get pasteAsNewScript => 'Bandika kama hati mpya';

  @override
  String get pasteAsNewScriptHint =>
      'Maandishi uliyonakili kutoka Notes, Keep, Notion, Docs au programu yoyote';

  @override
  String get importFiles => 'Leta faili';

  @override
  String get importFilesHint =>
      'Word, maandishi, Markdown, RTF, HTML, Evernote, manukuu au nakala rudufu';

  @override
  String get clipboardEmpty =>
      'Hakuna cha kubandika. Nakili hati yako kwenye programu nyingine kwanza.';

  @override
  String importedNewScripts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hati $count zimeletwa',
      one: 'Hati 1 imeletwa',
    );
    return '$_temp0';
  }

  @override
  String importFreeLimit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Mpango wa bure unabeba hati $count. Hakuna kilichopotea: dokezo au faili lako bado liko pale pale. Pandisha daraja ili kuleta zaidi.',
      one: 'Mpango wa bure unabeba hati 1. Hakuna kilichopotea: dokezo au faili lako bado liko pale pale. Pandisha daraja ili kuleta zaidi.',
    );
    return '$_temp0';
  }

  @override
  String get importPdf =>
      'PDF haziwezi kuletwa. Fungua PDF, nakili maandishi, kisha tumia \"Bandika kama hati mpya\".';

  @override
  String get importOldFormat =>
      'Faili za zamani za Word (.doc) na Pages haziwezi kusomwa. Lihifadhi kama .docx au maandishi, au nakili maandishi na utumie \"Bandika kama hati mpya\".';

  @override
  String get importUnsupported =>
      'APrompter haiwezi kusoma aina hiyo ya faili. Nakili maandishi na utumie \"Bandika kama hati mpya\".';

  @override
  String get importEmpty => 'Hakuna maandishi ndani yake ya kuleta.';

  @override
  String get importTooLarge =>
      'Ni ndefu mno kwa hati moja. Nakili sehemu unayohitaji na utumie \"Bandika kama hati mpya\".';

  @override
  String get importLinkOnly =>
      'Kiungo pekee ndicho kimefika, si maandishi. Kifungue, nakili maandishi na utumie \"Bandika kama hati mpya\".';

  @override
  String get importUnreadable =>
      'Imeshindwa kusoma. Nakili maandishi na utumie \"Bandika kama hati mpya\".';

  @override
  String get saveAsTextFile => 'Hifadhi kama faili la maandishi';

  @override
  String get saveTextFileFailed =>
      'Imeshindwa kuunda faili la maandishi. Jaribu tena.';

  @override
  String get mySetup => 'Mpangilio wangu';

  @override
  String get mySetupHint => 'Mpangilio uliouhifadhi';

  @override
  String get saveMySetup => 'Hifadhi kama mpangilio wangu';

  @override
  String get resetAllSettings => 'Weka upya mipangilio yote';

  @override
  String get runHadJumps =>
      'Uliruka sehemu katika jaribio hili, kwa hivyo haiwezi kupendekeza kasi.';

  @override
  String get keepTake => 'Hifadhi';

  @override
  String get retake => 'Piga tena';

  @override
  String get reviewTakes => 'Kagua kila picha';

  @override
  String get reviewTakesHint => 'Itazame, kisha ihifadhi au upige tena';

  @override
  String get takesToGallery => 'Hifadhi picha kwenye matunzio';

  @override
  String get takesToGalleryHint =>
      'Imezimwa: picha hubaki ndani ya programu, nje ya Google Photos na iCloud';

  @override
  String get takesTitle => 'Picha';

  @override
  String get takesEmpty =>
      'Picha zilizohifadhiwa ndani ya programu huonekana hapa. Zima \"Hifadhi picha kwenye matunzio\" kwenye mipangilio ili kuzihifadhi hapa.';

  @override
  String get saveToGallery => 'Hifadhi kwenye matunzio';

  @override
  String get savedToGallery => 'Imehifadhiwa kwenye matunzio';

  @override
  String get deleteTake => 'Futa picha';

  @override
  String takeKeptInApp(int n) {
    return 'Picha $n imehifadhiwa ndani ya programu';
  }

  @override
  String get upgradeTitle => 'APrompter Unlimited';

  @override
  String get upgradeBody =>
      'Hati bila kikomo, kwa usajili au ununuzi wa mara moja.';

  @override
  String get offeringsLoadFailed =>
      'Imeshindwa kupakia mipango. Angalia muunganisho wako kisha ujaribu tena.';

  @override
  String get purchaseFailed => 'Ununuzi umeshindwa. Jaribu tena.';

  @override
  String get restoreFailed => 'Imeshindwa kurejesha ununuzi. Jaribu tena.';

  @override
  String get restorePurchases => 'Rejesha ununuzi';

  @override
  String wordCapBannerText(int count) {
    return 'Hati hii ina zaidi ya maneno $count. Hati ndefu ni sehemu ya APrompter Unlimited.';
  }

  @override
  String get upgrade => 'Pandisha daraja';

  @override
  String planMonthly(String price) {
    return 'Kila mwezi · $price / mwezi';
  }

  @override
  String planYearly(String price) {
    return 'Kila mwaka · $price / mwaka';
  }

  @override
  String planLifetime(String price) {
    return 'Maisha yote · $price mara moja';
  }

  @override
  String planSave(int percent) {
    return 'Okoa $percent%';
  }

  @override
  String subscriptionTerms(String store) {
    return 'Mipango ya kila mwezi na kila mwaka hujisasisha kiotomatiki kwa muda uleule hadi utakapoighairi. Ili kuepuka malipo yanayofuata, ghairi angalau saa 24 kabla ya kipindi kuisha kwenye mipangilio ya akaunti yako ya $store. Maisha yote ni ununuzi wa mara moja.';
  }

  @override
  String get termsOfUse => 'Masharti ya Matumizi';

  @override
  String get privacyPolicy => 'Sera ya Faragha';

  @override
  String nothingToRestore(String store) {
    return 'Hakuna ununuzi wa awali uliopatikana kwenye akaunti hii ya $store.';
  }

  @override
  String get appLockTurnedOff =>
      'Simu yako haina kifunga skrini, kwa hiyo kufunga programu kumezimwa.';

  @override
  String get deleteTakeConfirm =>
      'Ufute picha hii? Video haitaweza kurejeshwa.';

  @override
  String deleteForeverConfirm(String title) {
    return 'Ufute \"$title\" kabisa? Haitaweza kurejeshwa.';
  }

  @override
  String get deleteForeverTakes =>
      'Picha zake zilizohifadhiwa ndani ya programu zitafutwa pia.';

  @override
  String get purchasePending =>
      'Malipo yanasubiri. APrompter Unlimited itafunguka kiotomatiki mara tu yatakapoidhinishwa.';

  @override
  String get positionHintFloat =>
      'Dirisha linaloelea linaweza kuburutwa popote na hukumbuka mahali pake.';

  @override
  String get readingLine => 'Mahali pa mstari wa kusoma';

  @override
  String get readingLineHint =>
      'Kamera ya simu iko juu ya skrini: mstari ulio juu huweka macho yako karibu na lenzi.';

  @override
  String get readingLineNearCamera => 'Karibu na kamera';

  @override
  String get readingLineMiddle => 'Katikati';

  @override
  String get readingLineDragHint =>
      'Katika Mazoezi, na katika Rekodi kabla ya kuanza, unaweza pia kuburuta mshale wa kushoto wa mstari juu au chini.';
}
