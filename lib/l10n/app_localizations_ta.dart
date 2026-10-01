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
}
