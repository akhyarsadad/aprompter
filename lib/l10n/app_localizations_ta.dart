// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'மூடு';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get prompterSettings => 'ப்ராம்ப்டர் அமைப்புகள்';

  @override
  String get edit => 'திருத்து';

  @override
  String get delete => 'நீக்கு';

  @override
  String get undo => 'செயல்தவிர்';

  @override
  String get duplicate => 'நகலெடு';

  @override
  String get share => 'பகிர்';

  @override
  String get copyAsCaption => 'கேப்ஷனாக நகலெடு';

  @override
  String get captionCopied =>
      'பேசும் உரை நகலெடுக்கப்பட்டது — கேப்ஷனில் ஒட்டவும்';

  @override
  String get copySuffix => '(நகல்)';

  @override
  String deletedScript(String title) {
    return '\"$title\" நீக்கப்பட்டது';
  }

  @override
  String duplicatedScript(String title) {
    return '\"$title\" என நகலெடுக்கப்பட்டது';
  }

  @override
  String get untitled => 'தலைப்பில்லை';

  @override
  String get newScript => 'புதிய ஸ்கிரிப்ட்';

  @override
  String get searchScripts => 'ஸ்கிரிப்ட்களைத் தேடு';

  @override
  String get filterAll => 'அனைத்தும்';

  @override
  String get statusDraft => 'வரைவு';

  @override
  String get statusReady => 'தயார்';

  @override
  String get statusRecorded => 'பதிவு செய்தது';

  @override
  String markAs(String status) {
    return '$status எனக் குறி';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'ஒத்திகை';

  @override
  String get float => 'மிதக்கும்';

  @override
  String get record => 'பதிவு';

  @override
  String words(int count) {
    return '$count சொற்கள்';
  }

  @override
  String takes(int count) {
    return '$count டேக்';
  }

  @override
  String get noScriptsYet => 'இன்னும் ஸ்கிரிப்ட் இல்லை';

  @override
  String get noScriptsHint =>
      'தொடங்க \"புதிய ஸ்கிரிப்ட்\" தட்டி ஒரு டெம்ப்ளேட்டைத் தேர்வுசெய்யவும்.';

  @override
  String get nothingHere => 'இங்கே எதுவும் இல்லை';

  @override
  String get nothingHereHint => 'வேறு வடிகட்டி அல்லது தேடலை முயலவும்.';

  @override
  String get startFromTemplate => 'டெம்ப்ளேட்டிலிருந்து தொடங்கு';

  @override
  String get overlayPermissionNeeded =>
      'மிதக்கும் ப்ராம்ப்டருக்கு \"பிற ஆப்களின் மேல் காட்டு\" அனுமதியை வழங்கவும்.';

  @override
  String get floatingStarted =>
      'ப்ராம்ப்டர் மிதக்கிறது. கேமரா ஆப்பைத் திறந்து, தொடங்க உரையைத் தட்டவும்.';

  @override
  String get floatingNotificationTitle => 'APrompter திரையில் மிதக்கிறது';

  @override
  String get openScriptInApp => 'APrompter-இல் ஒரு ஸ்கிரிப்டைத் திறக்கவும்';

  @override
  String get script => 'ஸ்கிரிப்ட்';

  @override
  String get title => 'தலைப்பு';

  @override
  String get status => 'நிலை';

  @override
  String get noTarget => 'இலக்கு இல்லை';

  @override
  String get editorHint =>
      'நீங்கள் சொல்ல விரும்புவதை எழுதவும் அல்லது ஒட்டவும்…\n\nகுறிப்பு: பகுதிக்கு வரியை # கொண்டும், உங்களுக்கான குறிப்புக்கு // கொண்டும் தொடங்கவும்.';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $wpm சொ/நி வேகத்தில் $spoken';
  }

  @override
  String get onTarget => 'இலக்கில்';

  @override
  String overTarget(int seconds, int words) {
    return '$seconds வி. அதிகம் · ~$words சொற்களைக் குறைக்கவும்';
  }

  @override
  String underTarget(int seconds, int words) {
    return '$seconds வி. மீதம் · இன்னும் ~$words சொற்கள்';
  }

  @override
  String longSentences(int count) {
    return '$count நீண்ட வாக்கியங்கள் (25+ சொற்கள்) — மூச்சு விட பிரிக்கவும்';
  }

  @override
  String get toolSection => 'பகுதி';

  @override
  String get toolEmphasis => 'அழுத்தம்';

  @override
  String get toolPause => 'இடைவெளி';

  @override
  String get toolNote => 'குறிப்பு';

  @override
  String get toolPaste => 'ஒட்டு';

  @override
  String get restart => 'மீண்டும்';

  @override
  String get sections => 'பகுதிகள்';

  @override
  String get slower => 'மெதுவாக';

  @override
  String get faster => 'வேகமாக';

  @override
  String get play => 'இயக்கு';

  @override
  String get pause => 'இடைநிறுத்து';

  @override
  String get wpmUnit => 'சொ/நி';

  @override
  String get startOfScript => 'ஸ்கிரிப்ட் தொடக்கம்';

  @override
  String sectionN(int n) {
    return 'பகுதி $n';
  }

  @override
  String get noSectionsHint =>
      'இன்னும் பகுதிகள் இல்லை. பகுதிகளுக்கிடையே தாவி ஒன்றை மட்டும் மீண்டும் பதிவுசெய்ய, எடிட்டரில் \"#\" கொண்டு தொடங்கும் வரிகளைச் சேர்க்கவும் (எ.கா. \"# ஹூக்\").';

  @override
  String get emptyScript => '(காலியான ஸ்கிரிப்ட்)';

  @override
  String get preview => 'முன்னோட்டம்';

  @override
  String get setup => 'அமைப்பு';

  @override
  String get pace => 'வேகம்';

  @override
  String get text => 'உரை';

  @override
  String get layout => 'தளவமைப்பு';

  @override
  String get recording => 'பதிவு';

  @override
  String get wordsPerMinute => 'சொற்கள் / நிமிடம்';

  @override
  String fitTo(String time) {
    return '$time-க்குப் பொருத்து';
  }

  @override
  String get paceCalm => 'அமைதி';

  @override
  String get paceNatural => 'இயல்பு';

  @override
  String get paceEnergetic => 'உற்சாகம்';

  @override
  String get countdown => 'தொடங்கும் முன் கவுண்ட்டவுன்';

  @override
  String get off => 'அணை';

  @override
  String get size => 'அளவு';

  @override
  String get lineSpacing => 'வரி இடைவெளி';

  @override
  String get textColor => 'உரை நிறம்';

  @override
  String get prompterHeight => 'ப்ராம்ப்டர் உயரம்';

  @override
  String get background => 'பின்னணி';

  @override
  String get readingGuide => 'வாசிப்பு வழிகாட்டி வரி';

  @override
  String get mirrorText => 'உரையை கண்ணாடிப் பிம்பமாக்கு';

  @override
  String get mirrorTextHint => 'டெலிப்ராம்ப்டர் கண்ணாடி / பீம் ஸ்ப்ளிட்டருக்கு';

  @override
  String get videoQuality => 'வீடியோ தரம்';

  @override
  String get autoStop => 'ஸ்கிரிப்ட் முடிந்ததும் பதிவை நிறுத்து';

  @override
  String get autoStopHint => 'கடைசி வரிக்குப் பிறகு 2 விநாடிகள் காத்திருக்கும்';

  @override
  String get presetHandheld => 'கையில் செல்ஃபி';

  @override
  String get presetHandheldHint => 'லென்ஸ் அருகே நடுத்தர உரை';

  @override
  String get presetTripod => 'ட்ரைபாட் / தூரத்திலிருந்து';

  @override
  String get presetTripodHint =>
      '1–2 மீ தூரத்திலிருந்து படிக்கக்கூடிய பெரிய உரை';

  @override
  String get presetGlass => 'டெலிப்ராம்ப்டர் கண்ணாடி';

  @override
  String get presetGlassHint => 'பிம்பமாக்கப்பட்டது, முழுத்திரை, திடப் பின்னணி';

  @override
  String get niceRun => 'அருமை!';

  @override
  String runSummary(String time, int words, int wpm) {
    return '$words சொற்களுக்கு $time எடுத்தீர்கள் → நிமிடத்திற்கு $wpm சொற்கள்.';
  }

  @override
  String runOver(int seconds, String target) {
    return 'இது உங்கள் $target இலக்கை விட $seconds வி. அதிகம் — ஸ்கிரிப்டைச் சுருக்கவும் அல்லது வேகமாகப் பேசவும்.';
  }

  @override
  String runUnder(int seconds) {
    return 'இலக்குக்கு இன்னும் $seconds வி. உள்ளது.';
  }

  @override
  String get runOnTarget => 'சரியாக இலக்கு நீளத்தில். 🎯';

  @override
  String get keepCurrent => 'இதையே வை';

  @override
  String useWpm(int wpm) {
    return '$wpm சொ/நி பயன்படுத்து';
  }

  @override
  String get switchCamera => 'கேமராவை மாற்று';

  @override
  String get startRecording => 'பதிவைத் தொடங்கு';

  @override
  String get stopRecording => 'பதிவை நிறுத்து';

  @override
  String get noCamera => 'இந்தச் சாதனத்தில் கேமரா இல்லை.';

  @override
  String get cameraDenied =>
      'கேமரா அணுகல் மறுக்கப்பட்டது. கணினி அமைப்புகளில் இயக்கவும்.';

  @override
  String cameraError(String message) {
    return 'கேமரா பிழை: $message';
  }

  @override
  String takeSaved(int n) {
    return 'டேக் $n கேலரியில் சேமிக்கப்பட்டது';
  }

  @override
  String get templateBlank => 'காலி';

  @override
  String get templateBlankHint => 'காலிப் பக்கத்திலிருந்து தொடங்கு';

  @override
  String get templateHvc => 'ஹூக் → மதிப்பு → CTA';

  @override
  String get templateHvcHint => 'குறும் வீடியோவின் பாரம்பரிய அமைப்பு';

  @override
  String get templateTutorial => 'பயிற்சி';

  @override
  String get templateTutorialHint => 'படிப்படியாக ஒன்றைக் கற்றுக்கொடு';

  @override
  String get templateReview => 'பொருள் மதிப்பாய்வு';

  @override
  String get templateReviewHint =>
      'UGC, விளம்பரங்கள், நேர்மையான மதிப்பாய்வுகள்';

  @override
  String get templateStory => 'கதை நேரம்';

  @override
  String get templateStoryHint => 'பாடத்துடன் தனிப்பட்ட கதை';

  @override
  String get secHook => 'ஹூக்';

  @override
  String get secValue => 'மதிப்பு';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'படி $n';
  }

  @override
  String get secRecap => 'சுருக்கம் & CTA';

  @override
  String get secWhatItIs => 'இது என்ன';

  @override
  String get secLoved => 'எனக்குப் பிடித்தது';

  @override
  String get secBetter => 'மேம்படுத்தக்கூடியது';

  @override
  String get secVerdict => 'தீர்ப்பு & CTA';

  @override
  String get secSetup => 'பின்னணி';

  @override
  String get secTurningPoint => 'திருப்புமுனை';

  @override
  String get secLesson => 'பாடம்';

  @override
  String get noteHook =>
      'முதல் 3 விநாடிகளில் கவனத்தை ஈர்க்கவும்: துணிச்சலான கூற்று அல்லது கேள்வி';

  @override
  String get noteValue => 'வாக்களித்த அந்த ஒரு விஷயத்தைக் கொடுங்கள்';

  @override
  String get noteCta =>
      'அடுத்து என்ன செய்ய வேண்டும் என்று சொல்லுங்கள்: ஃபாலோ, கமெண்ட், பயோவில் இணைப்பு';

  @override
  String get noteTutorialHook => '\"ஒரு நிமிடத்திற்குள் … செய்வது இப்படி\"';

  @override
  String get noteRecap =>
      'ஒரு வாக்கியத்தில் சுருக்கி, வீடியோவைச் சேமிக்கச் சொல்லுங்கள்';

  @override
  String get noteReviewHook =>
      'பொருளையும் அது தீர்க்கும் பிரச்சினையையும் காட்டுங்கள்';

  @override
  String get noteVerdict =>
      'யாருக்கு ஏற்றது — கோடு அல்லது இணைப்பைக் குறிப்பிடுங்கள்';

  @override
  String get noteStoryHook => 'நிகழ்வின் நடுவிலிருந்து தொடங்குங்கள்';

  @override
  String get welcomeTitle => 'APrompter-க்கு வரவேற்கிறோம்';

  @override
  String get welcomeBody =>
      '# ஹூக்\nவரிகளை மறக்காமல் வீடியோ எடுக்க வேண்டுமா? [pause]\n// நேராக லென்ஸைப் பாருங்கள்\n\n# இது எப்படி வேலை செய்கிறது\nஉங்கள் ஸ்கிரிப்டை எழுதி, ஒரு *இலக்கு நீளத்தைத்* தேர்வுசெய்யுங்கள்; பொருந்துகிறதா என டைமர் சொல்லும்.\nநிமிடத்திற்கு எத்தனை சொற்கள் என உங்கள் வேகத்தைக் கண்டறிய ஒத்திகை பாருங்கள்.\nபிறகு பதிவை அழுத்துங்கள். உரை கேமராவுக்குக் கீழே நகர்வதால், பார்வையாளர்களுடன் *கண் தொடர்பு* நிலைக்கும்.\n\n# CTA\nஸ்கிரிப்டைத் திருத்த இந்த அட்டையைத் தட்டுங்கள், அல்லது பிளஸ் பொத்தானால் உங்கள் ஸ்கிரிப்டை உருவாக்குங்கள். [pause] மகிழ்ச்சியாக உருவாக்குங்கள்!\n';

  @override
  String get expand => 'விரிவாக்கு';

  @override
  String get minimize => 'சிறிதாக்கு';

  @override
  String get nothingToSay =>
      'முதலில் சொல்ல ஏதாவது சேர்க்கவும் — பகுதிகள் (#) மற்றும் குறிப்புகள் (//) படிக்கப்படாது.';

  @override
  String get openSettings => 'அமைப்புகளைத் திற';

  @override
  String get tryAgain => 'மீண்டும் முயல்';

  @override
  String get noMicBanner =>
      'மைக்ரோஃபோன் அணுகல் இல்லை — ஒலி இல்லாமல் பதிவாகிறது';

  @override
  String get saveFailedTitle => 'கேலரியில் சேமிக்க முடியவில்லை';

  @override
  String saveFailedBody(String reason) {
    return 'உங்கள் டேக் இப்போதைக்குப் பாதுகாப்பாக உள்ளது. மீண்டும் முயலுங்கள், அல்லது தொலையாமல் இருக்க Files, Drive அல்லது ஒரு அரட்டையில் பகிருங்கள். ($reason)';
  }

  @override
  String get shareVideo => 'வீடியோவைப் பகிர்';

  @override
  String get discardTake => 'இந்த டேக்கை நீக்கு';

  @override
  String takeShared(int n) {
    return 'டேக் $n பகிரப்பட்டது';
  }

  @override
  String get movePrompter => 'ப்ராம்ப்டரை நகர்த்த இழுக்கவும்';

  @override
  String get resizePrompter => 'ப்ராம்ப்டர் அளவை மாற்ற இழுக்கவும்';

  @override
  String get prompterWidth => 'ப்ராம்ப்டர் அகலம்';

  @override
  String get resetPosition => 'நிலையை மீட்டமை (மேலே, முழு அகலம்)';

  @override
  String get positionHint =>
      'ப்ராம்ப்டரை எங்கும் நகர்த்த மேலுள்ள பட்டையையும், அளவை மாற்ற மூலையையும் இழுக்கவும். Android-இல் மிதக்கும் சாளரத்தை எங்கும் இழுக்கலாம், அது தன் இடத்தை நினைவில் வைக்கும்.';

  @override
  String get app => 'ஆப்';

  @override
  String get appLanguage => 'ஆப் மொழி';

  @override
  String get systemDefault => 'ஃபோன் மொழி';

  @override
  String secondsShort(int n) {
    return '$n வி.';
  }

  @override
  String minutesShort(int n) {
    return '$n நி.';
  }

  @override
  String get storageSaveFailed =>
      'சேமிக்க முடியவில்லை — ஃபோன் சேமிப்பகம் நிரம்பியிருக்கலாம். ஆப் திறந்திருக்கும் வரை உங்கள் வேலை பாதுகாப்பாக இருக்கும்.';

  @override
  String get versionHistory => 'பதிப்பு வரலாறு';

  @override
  String get noVersions =>
      'முந்தைய பதிப்புகள் இன்னும் இல்லை. நீங்கள் எழுதும்போது தானாகச் சேமிக்கப்படும்.';

  @override
  String get restore => 'மீட்டமை';

  @override
  String get versionRestored => 'முந்தைய பதிப்பு மீட்டமைக்கப்பட்டது';

  @override
  String get recentlyDeleted => 'சமீபத்தில் நீக்கியவை';

  @override
  String trashHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'நீக்கிய ஸ்கிரிப்ட்கள் இங்கே $days நாட்கள் இருக்கும்.',
      one: 'நீக்கிய ஸ்கிரிப்ட்கள் இங்கே 1 நாள் இருக்கும்.',
    );
    return '$_temp0';
  }

  @override
  String get deleteForever => 'நிரந்தரமாக நீக்கு';

  @override
  String deletedOn(String date) {
    return '$date அன்று நீக்கப்பட்டது';
  }

  @override
  String restoredScript(String title) {
    return '\"$title\" மீட்டமைக்கப்பட்டது';
  }

  @override
  String get backUpScripts => 'எல்லா ஸ்கிரிப்ட்களையும் காப்புப்பிரதி எடு';

  @override
  String get restoreBackup => 'காப்புப்பிரதியிலிருந்து மீட்டமை';

  @override
  String get backupShareTitle => 'APrompter காப்புப்பிரதி';

  @override
  String importedScripts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ஸ்கிரிப்ட்கள் மீட்டமைக்கப்பட்டன',
      one: '1 ஸ்கிரிப்ட் மீட்டமைக்கப்பட்டது',
      zero: 'இந்தக் காப்புப்பிரதியில் உள்ளவை அனைத்தும் ஏற்கனவே உள்ளன',
    );
    return '$_temp0';
  }

  @override
  String get notABackup => 'இந்தக் கோப்பு APrompter காப்புப்பிரதி அல்ல.';

  @override
  String fitImpossible(int wpm, String target, int words) {
    return '$wpm சொ/நி வேகத்திலும் இது $target-க்குள் அடங்காது — சுமார் $words சொற்களைக் குறைக்கவும்.';
  }

  @override
  String get cameraNotReady =>
      'கேமரா தயாராக இல்லை, அதனால் பதிவு தொடங்கவில்லை. மீண்டும் முயலவும்.';

  @override
  String get previousSection => 'முந்தைய பகுதி';

  @override
  String get nextSection => 'அடுத்த பகுதி';

  @override
  String get floatingNotificationBody => 'APrompter-ஐத் திறக்க தட்டவும்';

  @override
  String get customTarget => 'தனிப்பயன்…';

  @override
  String get customTargetTitle => 'இலக்கு நீளம்';

  @override
  String get customTargetHint => 'நிமிடம், வினாடி, எ.கா. 5:00';

  @override
  String get saved => 'சேமிக்கப்பட்டது';

  @override
  String get floatNotOnIos =>
      'iPhone-இல் ஆப்கள் மற்ற ஆப்களின் மேல் மிதக்க முடியாது. கேமராவுக்குக் கீழே ஸ்கிரிப்டுடன் படம்பிடிக்க பதிவு பயன்படுத்தவும்.';

  @override
  String get hashtagHint =>
      'ஹேஷ்டேக் வரிகள் (#fyp #ad) மங்கலாகக் காட்டப்படும், நேரம் கணக்கிடப்படாது. பகுதிக்கு இடைவெளியுடன் \"# \" பயன்படுத்தவும்.';

  @override
  String get appLock => 'ஆப் பூட்டு';

  @override
  String get appLockHint =>
      'APrompter-ஐத் திறக்க கைரேகை, முகம் அல்லது ஃபோன் PIN கேட்கும்';

  @override
  String get appLockUnavailable =>
      'முதலில் இந்த ஃபோனில் திரைப் பூட்டை அமைக்கவும்.';

  @override
  String get unlock => 'திற';

  @override
  String get unlockReason =>
      'உங்கள் ஸ்கிரிப்ட்களைப் பார்க்க APrompter-ஐத் திறக்கவும்';

  @override
  String get autoStopWait => 'கடைசி வரிக்குப் பின் காத்திருப்பு';

  @override
  String get beforeYouRecord => 'பதிவு செய்யும் முன்';

  @override
  String get recordAnyway => 'இருந்தாலும் பதிவுசெய்';

  @override
  String lowStorageWarning(int minutes) {
    return 'காலி இடத்தில் சுமார் $minutes நி. வீடியோ மட்டுமே பொருந்தும். இடத்தைக் காலி செய்யவும் அல்லது வீடியோ தரத்தைக் குறைக்கவும்.';
  }

  @override
  String lowBatteryWarning(int level) {
    return 'பேட்டரி $level% — நீண்ட டேக் இடையில் நின்றுவிடலாம். முடிந்தால் சார்ஜரை இணைக்கவும்.';
  }

  @override
  String get brightScreen => 'ப்ராம்ப்டிங்கின்போது முழு ஒளிர்வு';

  @override
  String get brightScreenHint => 'வெளியே படிக்க எளிது';

  @override
  String get cameraBusy =>
      'வேறொரு ஆப் கேமராவைப் பயன்படுத்துகிறது. அதை மூடிவிட்டு மீண்டும் முயலவும்.';

  @override
  String get cameraIntroTitle => 'கேமரா மற்றும் மைக்ரோஃபோன்';

  @override
  String get cameraIntroBody =>
      'திரையில் ஸ்கிரிப்டுடன் உங்களைப் படம்பிடிக்க APrompter-க்கு கேமராவும் மைக்ரோஃபோனும் தேவை. அடுத்து உங்கள் ஃபோன் அனுமதி கேட்கும். வீடியோக்கள் உங்கள் ஃபோனிலேயே இருக்கும்.';

  @override
  String get continueLabel => 'தொடர்';

  @override
  String get notNow => 'இப்போது வேண்டாம்';

  @override
  String get colorWhite => 'வெள்ளை';

  @override
  String get colorYellow => 'மஞ்சள்';

  @override
  String get colorGreen => 'பச்சை';

  @override
  String get colorBlue => 'நீலம்';

  @override
  String get colorPink => 'இளஞ்சிவப்பு';

  @override
  String get colorBlack => 'கருப்பு';

  @override
  String get damagedData => 'படிக்க முடியாத தரவு';

  @override
  String damagedDataHint(String date, int size) {
    return '$date அன்று தனியாக வைக்கப்பட்டது · $size எழுத்துகள்';
  }

  @override
  String get tryToRecover => 'மீட்க முயல்';

  @override
  String get nothingRecovered =>
      'இதிலிருந்து எந்த ஸ்கிரிப்டையும் படிக்க முடியவில்லை.';

  @override
  String get floatLowRam =>
      'இந்த ஃபோனால் பிற ஆப்களின் மேல் ஆப்களைக் காட்ட முடியாது (குறைந்த நினைவகம் அல்லது Android Go ஃபோன்). பதிலாக பதிவு-ஐப் பயன்படுத்தவும்.';

  @override
  String get oemTipsTitle => 'மிதக்கும் ப்ராம்ப்டரை இயக்கத்தில் வைக்க';

  @override
  String oemTipsBody(String brand) {
    return 'பேட்டரியைச் சேமிக்க $brand ஃபோன்கள் மிதக்கும் சாளரங்களை மூடலாம். அமைப்புகள் → ஆப்ஸ் → APrompter-இல்: பிற ஆப்களின் மேல் காட்ட (மற்றும் பாப்-அப் சாளரங்கள்) அனுமதிக்கவும், பேட்டரியை \"கட்டுப்பாடற்றது\" என அமைக்கவும், அறிவிப்புகளை அனுமதிக்கவும்.';
  }

  @override
  String get focusLine => 'தற்போதைய வரியில் கவனம்';

  @override
  String get focusLineHint => 'மற்ற வரிகளை மங்கச் செய்யும்';

  @override
  String get stepByLine => 'வரி வரியாக';

  @override
  String get stepByLineHint =>
      'ஒவ்வொரு தட்டலும் ரிமோட் அழுத்தமும் ஒரு வரி நகர்த்தும் — தானியங்கு உருட்டல் இல்லை';

  @override
  String get reduceEffects => 'எஃபெக்ட்களைக் குறை';

  @override
  String get reduceEffectsHint =>
      'மங்கல், நிழல் இல்லை: பழைய ஃபோன்களில் சீராக, பேட்டரி மிச்சம்';

  @override
  String get letterSpacing => 'எழுத்து இடைவெளி';

  @override
  String get importTextFile => 'உரைக் கோப்பை இறக்கு';

  @override
  String get importTextFileHint =>
      'Files, Drive அல்லது மின்னஞ்சலிலிருந்து .txt அல்லது .md ஸ்கிரிப்ட்';

  @override
  String get importTextFailed =>
      'அந்தக் கோப்பைப் படிக்க முடியவில்லை. சாதாரண உரை (.txt) கோப்பைத் தேர்வுசெய்யவும்.';

  @override
  String get mySetup => 'என் அமைப்பு';

  @override
  String get mySetupHint => 'நீங்கள் சேமித்த அமைப்பு';

  @override
  String get saveMySetup => 'என் அமைப்பாகச் சேமி';

  @override
  String get resetAllSettings => 'எல்லா அமைப்புகளையும் மீட்டமை';

  @override
  String get runHadJumps =>
      'இந்த ஓட்டத்தில் முன்னும் பின்னும் தாவினீர்கள், அதனால் வேகத்தைப் பரிந்துரைக்க முடியாது.';

  @override
  String get keepTake => 'வைத்திரு';

  @override
  String get retake => 'மீண்டும் எடு';

  @override
  String get reviewTakes => 'ஒவ்வொரு டேக்கையும் பார்';

  @override
  String get reviewTakesHint =>
      'பார்த்துவிட்டு வைத்திருக்கவும் அல்லது மீண்டும் எடுக்கவும்';

  @override
  String get takesToGallery => 'டேக்குகளை கேலரியில் சேமி';

  @override
  String get takesToGalleryHint =>
      'ஆஃப்: டேக்குகள் ஆப்பிலேயே இருக்கும், Google Photos, iCloud-க்குச் செல்லாது';

  @override
  String get takesTitle => 'டேக்குகள்';

  @override
  String get takesEmpty =>
      'ஆப்பில் வைத்த டேக்குகள் இங்கே தெரியும். இங்கே வைக்க அமைப்புகளில் \"டேக்குகளை கேலரியில் சேமி\"-ஐ ஆஃப் செய்யவும்.';

  @override
  String get saveToGallery => 'கேலரியில் சேமி';

  @override
  String get savedToGallery => 'கேலரியில் சேமிக்கப்பட்டது';

  @override
  String get deleteTake => 'டேக்கை நீக்கு';

  @override
  String takeKeptInApp(int n) {
    return 'டேக் $n ஆப்பில் வைக்கப்பட்டது';
  }
}
