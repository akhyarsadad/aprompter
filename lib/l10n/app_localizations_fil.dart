// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class AppLocalizationsFil extends AppLocalizations {
  AppLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'Isara';

  @override
  String get settings => 'Mga Setting';

  @override
  String get prompterSettings => 'Mga setting ng prompter';

  @override
  String get edit => 'I-edit';

  @override
  String get delete => 'Burahin';

  @override
  String get undo => 'I-undo';

  @override
  String get duplicate => 'I-duplicate';

  @override
  String get share => 'Ibahagi';

  @override
  String get copyAsCaption => 'Kopyahin bilang caption';

  @override
  String get captionCopied =>
      'Nakopya ang sasabihing teksto — i-paste bilang caption';

  @override
  String get copySuffix => '(kopya)';

  @override
  String deletedScript(String title) {
    return 'Binura ang \"$title\"';
  }

  @override
  String duplicatedScript(String title) {
    return 'Na-duplicate bilang \"$title\"';
  }

  @override
  String get untitled => 'Walang pamagat';

  @override
  String get newScript => 'Bagong script';

  @override
  String get searchScripts => 'Maghanap ng script';

  @override
  String get filterAll => 'Lahat';

  @override
  String get statusDraft => 'Draft';

  @override
  String get statusReady => 'Handa na';

  @override
  String get statusRecorded => 'Na-record na';

  @override
  String markAs(String status) {
    return 'Markahan bilang $status';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'Mag-ensayo';

  @override
  String get float => 'Lumulutang';

  @override
  String get record => 'I-record';

  @override
  String words(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count salita',
      one: '1 salita',
    );
    return '$_temp0';
  }

  @override
  String takes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count take',
      one: '1 take',
    );
    return '$_temp0';
  }

  @override
  String get noScriptsYet => 'Wala pang script';

  @override
  String get noScriptsHint =>
      'I-tap ang \"Bagong script\" at pumili ng template para magsimula.';

  @override
  String get nothingHere => 'Walang laman dito';

  @override
  String get nothingHereHint => 'Sumubok ng ibang filter o paghahanap.';

  @override
  String get startFromTemplate => 'Magsimula sa template';

  @override
  String get overlayPermissionNeeded =>
      'Payagan ang \"Ipakita sa ibabaw ng ibang app\" para magamit ang lumulutang na prompter.';

  @override
  String get floatingStarted =>
      'Lumulutang na ang prompter. Buksan ang camera app at i-tap ang teksto para magsimula.';

  @override
  String get floatingNotificationTitle => 'Lumulutang ang APrompter';

  @override
  String get openScriptInApp => 'Magbukas ng script sa APrompter';

  @override
  String get script => 'Script';

  @override
  String get title => 'Pamagat';

  @override
  String get status => 'Status';

  @override
  String get noTarget => 'Walang target';

  @override
  String get editorHint =>
      'Isulat o i-paste ang gusto mong sabihin…\n\nTip: simulan ang linya sa # para sa section, sa // para sa note sa sarili.';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $spoken sa $wpm spm';
  }

  @override
  String get onTarget => 'Pasok sa target';

  @override
  String overTarget(int seconds, int words) {
    return 'Sobra nang $seconds seg · bawasan ng ~$words salita';
  }

  @override
  String underTarget(int seconds, int words) {
    return '$seconds seg pa · ~$words salita pa';
  }

  @override
  String longSentences(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count mahahabang pangungusap (25+ salita) — hatiin para makahinga',
      one: '1 mahabang pangungusap (25+ salita) — hatiin para makahinga',
    );
    return '$_temp0';
  }

  @override
  String get toolSection => 'Section';

  @override
  String get toolEmphasis => 'Diin';

  @override
  String get toolPause => 'Hinto';

  @override
  String get toolNote => 'Note';

  @override
  String get toolPaste => 'I-paste';

  @override
  String get restart => 'Ulitin';

  @override
  String get sections => 'Mga section';

  @override
  String get slower => 'Mas mabagal';

  @override
  String get faster => 'Mas mabilis';

  @override
  String get play => 'I-play';

  @override
  String get pause => 'I-pause';

  @override
  String get wpmUnit => 'spm';

  @override
  String get startOfScript => 'Simula ng script';

  @override
  String sectionN(int n) {
    return 'Section $n';
  }

  @override
  String get noSectionsHint =>
      'Wala pang section. Magdagdag ng mga linyang nagsisimula sa \"#\" sa editor (hal. \"# Hook\") para tumalon sa pagitan ng mga bahagi at ulitin lang ang isa.';

  @override
  String get emptyScript => '(walang laman na script)';

  @override
  String get preview => 'Preview';

  @override
  String get setup => 'Setup';

  @override
  String get pace => 'Bilis';

  @override
  String get text => 'Teksto';

  @override
  String get layout => 'Layout';

  @override
  String get recording => 'Pag-record';

  @override
  String get wordsPerMinute => 'salita / min';

  @override
  String fitTo(String time) {
    return 'Ipagkasya sa $time';
  }

  @override
  String get paceCalm => 'Kalmado';

  @override
  String get paceNatural => 'Natural';

  @override
  String get paceEnergetic => 'Masigla';

  @override
  String get countdown => 'Countdown bago magsimula';

  @override
  String get off => 'Off';

  @override
  String get size => 'Laki';

  @override
  String get lineSpacing => 'Agwat ng linya';

  @override
  String get textColor => 'Kulay ng teksto';

  @override
  String get prompterHeight => 'Taas ng prompter';

  @override
  String get background => 'Background';

  @override
  String get readingGuide => 'Linya ng pagbasa';

  @override
  String get mirrorText => 'I-mirror ang teksto';

  @override
  String get mirrorTextHint => 'Para sa teleprompter glass / beam splitter';

  @override
  String get videoQuality => 'Kalidad ng video';

  @override
  String get autoStop => 'Ihinto ang pag-record kapag tapos na ang script';

  @override
  String get autoStopHint =>
      'Maghihintay ng 2 segundo pagkatapos ng huling linya';

  @override
  String get presetHandheld => 'Selfie na hawak';

  @override
  String get presetHandheldHint => 'Katamtamang teksto malapit sa lens';

  @override
  String get presetTripod => 'Tripod / malayo';

  @override
  String get presetTripodHint => 'Malaking tekstong nababasa mula 1–2 m';

  @override
  String get presetGlass => 'Teleprompter glass';

  @override
  String get presetGlassHint => 'Naka-mirror, full screen, solid na background';

  @override
  String get niceRun => 'Galing!';

  @override
  String runSummary(String time, int words, int wpm) {
    return 'Inabot ka ng $time para sa $words salita → $wpm salita kada minuto.';
  }

  @override
  String runOver(int seconds, String target) {
    return 'Lampas ito nang $seconds seg sa target mong $target — paikliin ang script o bilisan.';
  }

  @override
  String runUnder(int seconds) {
    return 'May $seconds seg ka pa bago ang target.';
  }

  @override
  String get runOnTarget => 'Saktong-sakto sa target na haba. 🎯';

  @override
  String get keepCurrent => 'Panatilihin';

  @override
  String useWpm(int wpm) {
    return 'Gamitin ang $wpm spm';
  }

  @override
  String get switchCamera => 'Palitan ang camera';

  @override
  String get startRecording => 'Simulan ang pag-record';

  @override
  String get stopRecording => 'Ihinto ang pag-record';

  @override
  String get noCamera => 'Walang nakitang camera sa device na ito.';

  @override
  String get cameraDenied =>
      'Tinanggihan ang access sa camera. I-enable ito sa system settings.';

  @override
  String cameraError(String message) {
    return 'Error sa camera: $message';
  }

  @override
  String takeSaved(int n) {
    return 'Na-save sa gallery ang take $n';
  }

  @override
  String get templateBlank => 'Blangko';

  @override
  String get templateBlankHint => 'Magsimula sa blangkong pahina';

  @override
  String get templateHvc => 'Hook → Value → CTA';

  @override
  String get templateHvcHint => 'Ang klasikong istruktura ng short video';

  @override
  String get templateTutorial => 'Tutorial';

  @override
  String get templateTutorialHint => 'Magturo ng isang bagay hakbang-hakbang';

  @override
  String get templateReview => 'Review ng produkto';

  @override
  String get templateReviewHint => 'UGC, ad at tapat na review';

  @override
  String get templateStory => 'Storytime';

  @override
  String get templateStoryHint => 'Personal na kuwento na may aral';

  @override
  String get secHook => 'Hook';

  @override
  String get secValue => 'Value';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'Hakbang $n';
  }

  @override
  String get secRecap => 'Buod at CTA';

  @override
  String get secWhatItIs => 'Ano ito';

  @override
  String get secLoved => 'Ang nagustuhan ko';

  @override
  String get secBetter => 'Ang puwede pang gumanda';

  @override
  String get secVerdict => 'Hatol at CTA';

  @override
  String get secSetup => 'Simula';

  @override
  String get secTurningPoint => 'Pagbabago';

  @override
  String get secLesson => 'Aral';

  @override
  String get noteHook =>
      'Kunin ang atensyon sa unang 3 segundo: matapang na pahayag o tanong';

  @override
  String get noteValue => 'Ibigay ang isang bagay na ipinangako mo';

  @override
  String get noteCta =>
      'Sabihin kung ano ang susunod: i-follow, mag-comment, link sa bio';

  @override
  String get noteTutorialHook =>
      '\"Ganito ang … sa loob ng wala pang isang minuto\"';

  @override
  String get noteRecap =>
      'Ibuod sa isang pangungusap, tapos hilinging i-save ang video';

  @override
  String get noteReviewHook =>
      'Ipakita ang produkto at ang problemang nilulutas nito';

  @override
  String get noteVerdict => 'Para kanino ito — banggitin ang code o link';

  @override
  String get noteStoryHook => 'Magsimula sa gitna ng aksyon';

  @override
  String get welcomeTitle => 'Maligayang pagdating sa APrompter';

  @override
  String get welcomeBody =>
      '# Hook\nGusto mo bang mag-film nang hindi nakakalimot ng linya? [pause]\n// tumingin nang diretso sa lens\n\n# Paano ito gumagana\nIsulat ang script, pumili ng *target na haba*, at sasabihin ng timer kung pasok ito.\nMag-ensayo para malaman ang bilis mo sa salita kada minuto.\nPagkatapos, pindutin ang I-record. Gumagalaw ang teksto sa ilalim mismo ng camera kaya nananatili ang *eye contact* mo sa audience.\n\n# CTA\nI-tap ang card na ito para i-edit ang script, o gumawa ng sarili mo gamit ang plus button. [pause] Mag-enjoy sa paggawa!\n';

  @override
  String get expand => 'Palakihin';

  @override
  String get minimize => 'Paliitin';

  @override
  String get nothingToSay =>
      'Magdagdag muna ng sasabihin — hindi binabasa ang mga section (#) at note (//).';

  @override
  String get openSettings => 'Buksan ang settings';

  @override
  String get tryAgain => 'Subukan ulit';

  @override
  String get noMicBanner =>
      'Walang access sa mikropono — nagre-record nang walang tunog';

  @override
  String get saveFailedTitle => 'Hindi ma-save sa gallery';

  @override
  String saveFailedBody(String reason) {
    return 'Ligtas pa ang take mo sa ngayon. Subukan ulit, o i-share sa Files, Drive o isang chat para hindi mawala. ($reason)';
  }

  @override
  String get shareVideo => 'I-share ang video';

  @override
  String get discardTake => 'Itapon ang take na ito';

  @override
  String takeShared(int n) {
    return 'Na-share ang take $n';
  }

  @override
  String get movePrompter => 'I-drag para ilipat ang prompter';

  @override
  String get resizePrompter => 'I-drag para baguhin ang laki ng prompter';

  @override
  String get prompterWidth => 'Lapad ng prompter';

  @override
  String get resetPosition => 'I-reset ang posisyon (itaas, buong lapad)';

  @override
  String get positionHint =>
      'I-drag ang bar sa itaas ng prompter para ilipat ito kahit saan, at ang sulok para baguhin ang laki. Sa Android, puwedeng i-drag kahit saan ang lumulutang na window at tinatandaan nito ang puwesto.';

  @override
  String get app => 'App';

  @override
  String get appLanguage => 'Wika ng app';

  @override
  String get systemDefault => 'Wika ng telepono';

  @override
  String secondsShort(int n) {
    return '$n seg';
  }

  @override
  String minutesShort(int n) {
    return '$n min';
  }

  @override
  String get storageSaveFailed =>
      'Hindi ma-save — baka puno na ang storage ng phone mo. Naka-keep ang gawa mo habang bukas ang app.';

  @override
  String get versionHistory => 'History ng bersyon';

  @override
  String get noVersions =>
      'Wala pang naunang bersyon. Awtomatiko itong sine-save habang nagsusulat ka.';

  @override
  String get restore => 'I-restore';

  @override
  String get versionRestored => 'Na-restore ang naunang bersyon';

  @override
  String get recentlyDeleted => 'Kamakailang binura';

  @override
  String trashHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Nananatili rito ang mga binurang script nang $days araw.',
      one: 'Nananatili rito ang mga binurang script nang 1 araw.',
    );
    return '$_temp0';
  }

  @override
  String get deleteForever => 'Burahin nang tuluyan';

  @override
  String deletedOn(String date) {
    return 'Binura noong $date';
  }

  @override
  String restoredScript(String title) {
    return 'Na-restore ang \"$title\"';
  }

  @override
  String get backUpScripts => 'I-back up ang lahat ng script';

  @override
  String get restoreBackup => 'I-restore mula sa backup';

  @override
  String get backupShareTitle => 'Backup ng APrompter';

  @override
  String importedScripts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Na-restore ang $count script',
      one: 'Na-restore ang 1 script',
      zero: 'Nandito na ang lahat ng nasa backup na ito',
    );
    return '$_temp0';
  }

  @override
  String get notABackup => 'Hindi APrompter backup ang file na iyan.';

  @override
  String fitImpossible(int wpm, String target, int words) {
    return 'Kahit sa $wpm spm, hindi kakasya ito sa $target — magbawas ng mga $words salita.';
  }

  @override
  String get cameraNotReady =>
      'Hindi pa handa ang camera kaya hindi nagsimula ang pag-record. Subukan ulit.';

  @override
  String get previousSection => 'Nakaraang section';

  @override
  String get nextSection => 'Susunod na section';

  @override
  String get floatingNotificationBody => 'I-tap para buksan ang APrompter';

  @override
  String get customTarget => 'Custom…';

  @override
  String get customTargetTitle => 'Target na haba';

  @override
  String get customTargetHint => 'Minuto at segundo, hal. 5:00';

  @override
  String get saved => 'Na-save';

  @override
  String get floatNotOnIos =>
      'Hindi pinapayagan ng iPhone na lumutang ang app sa ibabaw ng ibang app. Gamitin ang I-record para mag-film na nasa ilalim ng camera ang script.';

  @override
  String get hashtagHint =>
      'Malabo ang mga linyang hashtag (#fyp #ad) at hindi tinitiyempo. Gumamit ng \"# \" na may space para sa section.';

  @override
  String get appLock => 'Lock ng app';

  @override
  String get appLockHint =>
      'Humingi ng fingerprint, mukha o PIN ng phone para buksan ang APrompter';

  @override
  String get appLockUnavailable =>
      'Mag-set up muna ng screen lock sa phone na ito.';

  @override
  String get unlock => 'I-unlock';

  @override
  String get unlockReason =>
      'I-unlock ang APrompter para makita ang mga script mo';

  @override
  String get autoStopWait => 'Hintay pagkatapos ng huling linya';

  @override
  String get beforeYouRecord => 'Bago ka mag-record';

  @override
  String get recordAnyway => 'I-record pa rin';

  @override
  String lowStorageWarning(int minutes) {
    return 'Mga $minutes min lang ng video ang kasya sa libreng space mo. Magbakante ng space o ibaba ang kalidad ng video.';
  }

  @override
  String lowBatteryWarning(int level) {
    return 'Nasa $level% ang baterya — baka maputol ang mahabang take. Mag-charge kung kaya.';
  }

  @override
  String get brightScreen => 'Full brightness habang nagpo-prompt';

  @override
  String get brightScreenHint => 'Mas madaling basahin sa labas';

  @override
  String get cameraBusy =>
      'May ibang app na gumagamit ng camera. Isara ito at subukan ulit.';

  @override
  String get cameraIntroTitle => 'Camera at mikropono';

  @override
  String get cameraIntroBody =>
      'Para ma-film ka habang nasa screen ang script, kailangan ng APrompter ang camera at mikropono mo. Magtatanong ang phone mo sa susunod. Nananatili sa phone mo ang mga video.';

  @override
  String get continueLabel => 'Magpatuloy';

  @override
  String get notNow => 'Hindi muna';

  @override
  String get colorWhite => 'Puti';

  @override
  String get colorYellow => 'Dilaw';

  @override
  String get colorGreen => 'Berde';

  @override
  String get colorBlue => 'Asul';

  @override
  String get colorPink => 'Pink';

  @override
  String get colorBlack => 'Itim';

  @override
  String get damagedData => 'Hindi mabasang data';

  @override
  String damagedDataHint(String date, int size) {
    return 'Itinabi noong $date · $size character';
  }

  @override
  String get tryToRecover => 'Subukang i-recover';

  @override
  String get nothingRecovered => 'Walang script na nabasa mula rito.';

  @override
  String get floatLowRam =>
      'Hindi kayang magpakita ng phone na ito ng app sa ibabaw ng ibang app (low-memory o Android Go). Gamitin na lang ang I-record.';

  @override
  String get oemTipsTitle => 'Panatilihing gumagana ang lumulutang na prompter';

  @override
  String oemTipsBody(String brand) {
    return 'Puwedeng isara ng mga $brand phone ang mga lumulutang na window para makatipid sa baterya. Sa Settings → Apps → APrompter: payagan ang pagpapakita sa ibabaw ng ibang app (at mga pop-up window), itakda ang baterya sa \"Hindi pinaghihigpitan\", at payagan ang mga notification.';
  }

  @override
  String get focusLine => 'Mag-focus sa kasalukuyang linya';

  @override
  String get focusLineHint => 'Pinalalabo ang ibang linya';

  @override
  String get stepByLine => 'Linya-linya';

  @override
  String get stepByLineHint =>
      'Bawat tap o pindot sa remote ay isang linya — walang auto-scroll';

  @override
  String get reduceEffects => 'Bawasan ang effects';

  @override
  String get reduceEffectsHint =>
      'Walang fade o anino: mas smooth sa lumang phone, tipid sa baterya';

  @override
  String get letterSpacing => 'Pagitan ng letra';

  @override
  String get importTextFile => 'Mag-import ng text file';

  @override
  String get importTextFileHint =>
      'Script na .txt o .md mula sa Files, Drive o email';

  @override
  String get importTextFailed =>
      'Hindi mabasa ang file na iyon. Pumili ng plain text (.txt) file.';

  @override
  String get mySetup => 'Setup ko';

  @override
  String get mySetupHint => 'Ang setup na na-save mo';

  @override
  String get saveMySetup => 'I-save bilang setup ko';

  @override
  String get resetAllSettings => 'I-reset lahat ng settings';

  @override
  String get runHadJumps =>
      'Tumalon-talon ka sa run na ito, kaya hindi ito makapagmungkahi ng pace.';

  @override
  String get keepTake => 'Itago';

  @override
  String get retake => 'Ulitin';

  @override
  String get reviewTakes => 'I-review ang bawat take';

  @override
  String get reviewTakesHint => 'Panoorin, tapos itago o ulitin';

  @override
  String get takesToGallery => 'I-save ang mga take sa gallery';

  @override
  String get takesToGalleryHint =>
      'Naka-off: nasa loob ng app ang mga take, wala sa Google Photos at iCloud';

  @override
  String get takesTitle => 'Mga take';

  @override
  String get takesEmpty =>
      'Dito lalabas ang mga take na itinago sa app. I-off ang \"I-save ang mga take sa gallery\" sa settings para dito sila itago.';

  @override
  String get saveToGallery => 'I-save sa gallery';

  @override
  String get savedToGallery => 'Na-save sa gallery mo';

  @override
  String get deleteTake => 'Burahin ang take';

  @override
  String takeKeptInApp(int n) {
    return 'Itinago sa app ang take $n';
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

  @override
  String wordCapBannerText(int count) {
    return 'Free scripts are capped at $count words.';
  }

  @override
  String get upgrade => 'Upgrade';
}
