// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'बंद करें';

  @override
  String get settings => 'सेटिंग';

  @override
  String get prompterSettings => 'प्रॉम्प्टर सेटिंग';

  @override
  String get edit => 'संपादित करें';

  @override
  String get delete => 'हटाएँ';

  @override
  String get undo => 'पहले जैसा करें';

  @override
  String get duplicate => 'डुप्लिकेट करें';

  @override
  String get share => 'शेयर करें';

  @override
  String get copyAsCaption => 'कैप्शन के रूप में कॉपी करें';

  @override
  String get captionCopied =>
      'बोला जाने वाला टेक्स्ट कॉपी हो गया — इसे कैप्शन में पेस्ट करें';

  @override
  String get copySuffix => '(कॉपी)';

  @override
  String deletedScript(String title) {
    return '\"$title\" हटा दी गई';
  }

  @override
  String duplicatedScript(String title) {
    return '\"$title\" नाम से डुप्लिकेट की गई';
  }

  @override
  String get untitled => 'बिना शीर्षक';

  @override
  String get newScript => 'नई स्क्रिप्ट';

  @override
  String get searchScripts => 'स्क्रिप्ट खोजें';

  @override
  String get filterAll => 'सभी';

  @override
  String get statusDraft => 'ड्राफ़्ट';

  @override
  String get statusReady => 'तैयार';

  @override
  String get statusRecorded => 'रिकॉर्ड हुई';

  @override
  String markAs(String status) {
    return '$status के रूप में चिह्नित करें';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'अभ्यास';

  @override
  String get float => 'फ़्लोट';

  @override
  String get record => 'रिकॉर्ड';

  @override
  String words(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count शब्द',
      one: '1 शब्द',
    );
    return '$_temp0';
  }

  @override
  String takes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count टेक',
      one: '1 टेक',
    );
    return '$_temp0';
  }

  @override
  String get noScriptsYet => 'अभी कोई स्क्रिप्ट नहीं';

  @override
  String get noScriptsHint =>
      'शुरू करने के लिए \"नई स्क्रिप्ट\" पर टैप करें और एक टेम्पलेट चुनें।';

  @override
  String get nothingHere => 'यहाँ कुछ नहीं है';

  @override
  String get nothingHereHint => 'कोई दूसरा फ़िल्टर या खोज आज़माएँ।';

  @override
  String get startFromTemplate => 'टेम्पलेट से शुरू करें';

  @override
  String get overlayPermissionNeeded =>
      'फ़्लोटिंग प्रॉम्प्टर के लिए \"दूसरे ऐप्स के ऊपर दिखाएँ\" की अनुमति दें।';

  @override
  String get floatingStarted =>
      'प्रॉम्प्टर स्क्रीन पर तैर रहा है। कैमरा ऐप खोलें और शुरू करने के लिए टेक्स्ट पर टैप करें।';

  @override
  String get floatingNotificationTitle => 'APrompter स्क्रीन पर है';

  @override
  String get openScriptInApp => 'APrompter में कोई स्क्रिप्ट खोलें';

  @override
  String get script => 'स्क्रिप्ट';

  @override
  String get title => 'शीर्षक';

  @override
  String get status => 'स्थिति';

  @override
  String get noTarget => 'कोई लक्ष्य नहीं';

  @override
  String get editorHint =>
      'जो कहना है उसे लिखें या पेस्ट करें…\n\nसुझाव: सेक्शन के लिए लाइन # से, और अपने लिए नोट के लिए // से शुरू करें।';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $wpm श/मि पर $spoken';
  }

  @override
  String get onTarget => 'लक्ष्य पर';

  @override
  String overTarget(int seconds, int words) {
    return '$seconds से. ज़्यादा · ~$words शब्द कम करें';
  }

  @override
  String underTarget(int seconds, int words) {
    return '$seconds से. बाकी · ~$words शब्द और';
  }

  @override
  String longSentences(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लंबे वाक्य (25+ शब्द) — साँस लेने के लिए इन्हें तोड़ें',
      one: '1 लंबा वाक्य (25+ शब्द) — साँस लेने के लिए इसे तोड़ें',
    );
    return '$_temp0';
  }

  @override
  String get toolSection => 'सेक्शन';

  @override
  String get toolEmphasis => 'ज़ोर';

  @override
  String get toolPause => 'विराम';

  @override
  String get toolNote => 'नोट';

  @override
  String get toolPaste => 'पेस्ट';

  @override
  String get restart => 'फिर से';

  @override
  String get sections => 'सेक्शन';

  @override
  String get slower => 'धीमा';

  @override
  String get faster => 'तेज़';

  @override
  String get play => 'चलाएँ';

  @override
  String get pause => 'रोकें';

  @override
  String get wpmUnit => 'श/मि';

  @override
  String get startOfScript => 'स्क्रिप्ट की शुरुआत';

  @override
  String sectionN(int n) {
    return 'सेक्शन $n';
  }

  @override
  String get noSectionsHint =>
      'अभी कोई सेक्शन नहीं। एडिटर में \"#\" से शुरू होने वाली लाइनें जोड़ें (जैसे \"# हुक\") ताकि हिस्सों के बीच जा सकें और सिर्फ़ एक को दोबारा रिकॉर्ड करें।';

  @override
  String get emptyScript => '(खाली स्क्रिप्ट)';

  @override
  String get preview => 'प्रीव्यू';

  @override
  String get setup => 'सेटअप';

  @override
  String get pace => 'गति';

  @override
  String get text => 'टेक्स्ट';

  @override
  String get layout => 'लेआउट';

  @override
  String get recording => 'रिकॉर्डिंग';

  @override
  String get wordsPerMinute => 'शब्द / मिनट';

  @override
  String fitTo(String time) {
    return '$time में फ़िट करें';
  }

  @override
  String get paceCalm => 'शांत';

  @override
  String get paceNatural => 'स्वाभाविक';

  @override
  String get paceEnergetic => 'जोशीला';

  @override
  String get countdown => 'शुरू करने से पहले उलटी गिनती';

  @override
  String get off => 'बंद';

  @override
  String get size => 'आकार';

  @override
  String get lineSpacing => 'लाइन स्पेसिंग';

  @override
  String get textColor => 'टेक्स्ट का रंग';

  @override
  String get prompterHeight => 'प्रॉम्प्टर की ऊँचाई';

  @override
  String get background => 'बैकग्राउंड';

  @override
  String get readingGuide => 'पढ़ने की गाइड लाइन';

  @override
  String get mirrorText => 'टेक्स्ट को मिरर करें';

  @override
  String get mirrorTextHint => 'टेलीप्रॉम्प्टर ग्लास / बीम स्प्लिटर के लिए';

  @override
  String get videoQuality => 'वीडियो क्वालिटी';

  @override
  String get autoStop => 'स्क्रिप्ट ख़त्म होने पर रिकॉर्डिंग रोकें';

  @override
  String get autoStopHint => 'आख़िरी लाइन के बाद 2 सेकंड रुकता है';

  @override
  String get presetHandheld => 'हाथ में सेल्फ़ी';

  @override
  String get presetHandheldHint => 'लेंस के पास मध्यम टेक्स्ट';

  @override
  String get presetTripod => 'ट्राइपॉड / दूरी से';

  @override
  String get presetTripodHint => '1–2 मीटर से पढ़ने लायक बड़ा टेक्स्ट';

  @override
  String get presetGlass => 'टेलीप्रॉम्प्टर ग्लास';

  @override
  String get presetGlassHint => 'मिरर, फ़ुल स्क्रीन, ठोस बैकग्राउंड';

  @override
  String get niceRun => 'बहुत बढ़िया!';

  @override
  String runSummary(String time, int words, int wpm) {
    return '$words शब्दों में आपको $time लगे → $wpm शब्द प्रति मिनट।';
  }

  @override
  String runOver(int seconds, String target) {
    return 'यह आपके $target लक्ष्य से $seconds से. ज़्यादा है — स्क्रिप्ट छोटी करें या तेज़ बोलें।';
  }

  @override
  String runUnder(int seconds) {
    return 'लक्ष्य तक आपके पास $seconds से. बाकी हैं।';
  }

  @override
  String get runOnTarget => 'बिल्कुल लक्ष्य अवधि पर। 🎯';

  @override
  String get keepCurrent => 'यही रखें';

  @override
  String useWpm(int wpm) {
    return '$wpm श/मि इस्तेमाल करें';
  }

  @override
  String get switchCamera => 'कैमरा बदलें';

  @override
  String get startRecording => 'रिकॉर्डिंग शुरू करें';

  @override
  String get stopRecording => 'रिकॉर्डिंग रोकें';

  @override
  String get noCamera => 'इस डिवाइस पर कोई कैमरा नहीं मिला।';

  @override
  String get cameraDenied =>
      'कैमरा एक्सेस नहीं मिला। सिस्टम सेटिंग में इसे चालू करें।';

  @override
  String cameraError(String message) {
    return 'कैमरा त्रुटि: $message';
  }

  @override
  String takeSaved(int n) {
    return 'टेक $n गैलरी में सेव हो गया';
  }

  @override
  String get templateBlank => 'खाली';

  @override
  String get templateBlankHint => 'खाली पेज से शुरू करें';

  @override
  String get templateHvc => 'हुक → वैल्यू → CTA';

  @override
  String get templateHvcHint => 'शॉर्ट वीडियो की क्लासिक संरचना';

  @override
  String get templateTutorial => 'ट्यूटोरियल';

  @override
  String get templateTutorialHint => 'कुछ स्टेप-बाय-स्टेप सिखाएँ';

  @override
  String get templateReview => 'प्रोडक्ट रिव्यू';

  @override
  String get templateReviewHint => 'UGC, विज्ञापन और ईमानदार रिव्यू';

  @override
  String get templateStory => 'स्टोरीटाइम';

  @override
  String get templateStoryHint => 'सीख के साथ निजी कहानी';

  @override
  String get secHook => 'हुक';

  @override
  String get secValue => 'वैल्यू';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'स्टेप $n';
  }

  @override
  String get secRecap => 'सारांश और CTA';

  @override
  String get secWhatItIs => 'यह क्या है';

  @override
  String get secLoved => 'मुझे क्या पसंद आया';

  @override
  String get secBetter => 'क्या बेहतर हो सकता है';

  @override
  String get secVerdict => 'फ़ैसला और CTA';

  @override
  String get secSetup => 'शुरुआत';

  @override
  String get secTurningPoint => 'मोड़';

  @override
  String get secLesson => 'सीख';

  @override
  String get noteHook =>
      'पहले 3 सेकंड में ध्यान खींचें: कोई साहसी दावा या सवाल';

  @override
  String get noteValue => 'वह एक चीज़ दें जिसका वादा किया था';

  @override
  String get noteCta => 'बताएँ आगे क्या करना है: फ़ॉलो, कमेंट, बायो में लिंक';

  @override
  String get noteTutorialHook => '\"एक मिनट से कम में … ऐसे करें\"';

  @override
  String get noteRecap => 'एक वाक्य में सार बताएँ, फिर वीडियो सेव करने को कहें';

  @override
  String get noteReviewHook => 'प्रोडक्ट और उसकी हल की गई समस्या दिखाएँ';

  @override
  String get noteVerdict => 'यह किसके लिए है — कोड या लिंक बताएँ';

  @override
  String get noteStoryHook => 'कहानी बीच से शुरू करें';

  @override
  String get welcomeTitle => 'APrompter में आपका स्वागत है';

  @override
  String get welcomeBody =>
      '# हुक\nक्या आप अपनी लाइनें भूले बिना वीडियो बनाना चाहते हैं? [pause]\n// सीधे लेंस में देखें\n\n# यह कैसे काम करता है\nअपनी स्क्रिप्ट लिखें, *लक्ष्य अवधि* चुनें, और टाइमर बताएगा कि यह फ़िट होती है या नहीं।\nशब्द प्रति मिनट में अपनी गति जानने के लिए अभ्यास करें।\nफिर रिकॉर्ड दबाएँ। टेक्स्ट कैमरे के ठीक नीचे चलता है, ताकि दर्शकों से आपका *आई कॉन्टैक्ट* बना रहे।\n\n# CTA\nस्क्रिप्ट संपादित करने के लिए इस कार्ड पर टैप करें, या प्लस बटन से अपनी स्क्रिप्ट बनाएँ। [pause] बनाने का मज़ा लें!\n';

  @override
  String get expand => 'बड़ा करें';

  @override
  String get minimize => 'छोटा करें';

  @override
  String get nothingToSay =>
      'पहले बोलने के लिए कुछ जोड़ें — सेक्शन (#) और नोट (//) पढ़े नहीं जाते।';

  @override
  String get openSettings => 'सेटिंग खोलें';

  @override
  String get tryAgain => 'फिर कोशिश करें';

  @override
  String get noMicBanner =>
      'माइक्रोफ़ोन एक्सेस नहीं — बिना आवाज़ रिकॉर्ड हो रहा है';

  @override
  String get saveFailedTitle => 'गैलरी में सेव नहीं हो सका';

  @override
  String saveFailedBody(String reason) {
    return 'आपका टेक अभी सुरक्षित है। फिर कोशिश करें, या इसे Files, Drive या किसी चैट में शेयर करें ताकि यह खो न जाए। ($reason)';
  }

  @override
  String get shareVideo => 'वीडियो शेयर करें';

  @override
  String get discardTake => 'यह टेक हटाएँ';

  @override
  String takeShared(int n) {
    return 'टेक $n शेयर हो गया';
  }

  @override
  String get movePrompter => 'प्रॉम्प्टर हिलाने के लिए खींचें';

  @override
  String get resizePrompter => 'प्रॉम्प्टर का आकार बदलने के लिए खींचें';

  @override
  String get prompterWidth => 'प्रॉम्प्टर की चौड़ाई';

  @override
  String get resetPosition => 'स्थिति रीसेट करें (ऊपर, पूरी चौड़ाई)';

  @override
  String get positionHint =>
      'प्रॉम्प्टर को कहीं भी ले जाने के लिए ऊपर की पट्टी और आकार बदलने के लिए कोना खींचें। Android पर फ़्लोटिंग विंडो कहीं भी खींची जा सकती है और अपनी जगह याद रखती है।';

  @override
  String get app => 'ऐप';

  @override
  String get appLanguage => 'ऐप की भाषा';

  @override
  String get systemDefault => 'फ़ोन की भाषा';

  @override
  String secondsShort(int n) {
    return '$n से.';
  }

  @override
  String minutesShort(int n) {
    return '$n मि.';
  }

  @override
  String get storageSaveFailed =>
      'सेव नहीं हो सका — शायद फ़ोन की स्टोरेज भर गई है। ऐप खुला रहने तक आपका काम सुरक्षित है।';

  @override
  String get versionHistory => 'वर्ज़न इतिहास';

  @override
  String get noVersions =>
      'अभी कोई पुराना वर्ज़न नहीं है। लिखते समय ये अपने-आप सेव होते हैं।';

  @override
  String get restore => 'रीस्टोर करें';

  @override
  String get versionRestored => 'पुराना वर्ज़न रीस्टोर हो गया';

  @override
  String get recentlyDeleted => 'हाल ही में हटाई गई';

  @override
  String trashHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'हटाई गई स्क्रिप्ट यहाँ $days दिन तक रहती हैं।',
      one: 'हटाई गई स्क्रिप्ट यहाँ 1 दिन तक रहती हैं।',
    );
    return '$_temp0';
  }

  @override
  String get deleteForever => 'हमेशा के लिए हटाएँ';

  @override
  String deletedOn(String date) {
    return '$date को हटाई गई';
  }

  @override
  String restoredScript(String title) {
    return '\"$title\" रीस्टोर हो गई';
  }

  @override
  String get backUpScripts => 'सभी स्क्रिप्ट का बैकअप लें';

  @override
  String get restoreBackup => 'बैकअप से रीस्टोर करें';

  @override
  String get backupShareTitle => 'APrompter बैकअप';

  @override
  String importedScripts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count स्क्रिप्ट रीस्टोर हुईं',
      one: '1 स्क्रिप्ट रीस्टोर हुई',
      zero: 'इस बैकअप की सारी चीज़ें पहले से मौजूद हैं',
    );
    return '$_temp0';
  }

  @override
  String get notABackup => 'यह फ़ाइल APrompter बैकअप नहीं है।';

  @override
  String fitImpossible(int wpm, String target, int words) {
    return '$wpm श/मि पर भी यह $target में नहीं आएगी — लगभग $words शब्द कम करें।';
  }

  @override
  String get cameraNotReady =>
      'कैमरा तैयार नहीं था, इसलिए रिकॉर्डिंग शुरू नहीं हुई। फिर से कोशिश करें।';

  @override
  String get previousSection => 'पिछला सेक्शन';

  @override
  String get nextSection => 'अगला सेक्शन';

  @override
  String get floatingNotificationBody => 'APrompter खोलने के लिए टैप करें';

  @override
  String get customTarget => 'कस्टम…';

  @override
  String get customTargetTitle => 'लक्ष्य अवधि';

  @override
  String get customTargetHint => 'मिनट और सेकंड, जैसे 5:00';

  @override
  String get saved => 'सेव हो गया';

  @override
  String get floatNotOnIos =>
      'iPhone ऐप्स को दूसरे ऐप्स के ऊपर फ़्लोट नहीं करने देता। कैमरे के नीचे स्क्रिप्ट के साथ शूट करने के लिए रिकॉर्ड इस्तेमाल करें।';

  @override
  String get hashtagHint =>
      'हैशटैग वाली लाइनें (#fyp #ad) धुंधली दिखती हैं और उनका समय नहीं गिना जाता। सेक्शन के लिए स्पेस के साथ \"# \" लिखें।';

  @override
  String get appLock => 'ऐप लॉक';

  @override
  String get appLockHint =>
      'APrompter खोलने के लिए फ़िंगरप्रिंट, चेहरा या फ़ोन का PIN माँगें';

  @override
  String get appLockUnavailable => 'पहले इस फ़ोन पर स्क्रीन लॉक सेट करें।';

  @override
  String get unlock => 'अनलॉक करें';

  @override
  String get unlockReason => 'अपनी स्क्रिप्ट देखने के लिए APrompter अनलॉक करें';

  @override
  String get autoStopWait => 'आख़िरी लाइन के बाद रुकें';

  @override
  String get beforeYouRecord => 'रिकॉर्ड करने से पहले';

  @override
  String get recordAnyway => 'फिर भी रिकॉर्ड करें';

  @override
  String lowStorageWarning(int minutes) {
    return 'खाली जगह में सिर्फ़ लगभग $minutes मि. का वीडियो आएगा। जगह खाली करें या वीडियो क्वालिटी कम करें।';
  }

  @override
  String lowBatteryWarning(int level) {
    return 'बैटरी $level% है — लंबा टेक बीच में कट सकता है। हो सके तो चार्जर लगाएँ।';
  }

  @override
  String get brightScreen => 'प्रॉम्प्टिंग के दौरान पूरी ब्राइटनेस';

  @override
  String get brightScreenHint => 'बाहर पढ़ना आसान';

  @override
  String get cameraBusy =>
      'कोई दूसरा ऐप कैमरा इस्तेमाल कर रहा है। उसे बंद करके फिर कोशिश करें।';

  @override
  String get cameraIntroTitle => 'कैमरा और माइक्रोफ़ोन';

  @override
  String get cameraIntroBody =>
      'स्क्रीन पर स्क्रिप्ट के साथ आपको फ़िल्माने के लिए APrompter को कैमरा और माइक्रोफ़ोन चाहिए। आपका फ़ोन अब अनुमति माँगेगा। वीडियो आपके फ़ोन पर ही रहते हैं।';

  @override
  String get continueLabel => 'जारी रखें';

  @override
  String get notNow => 'अभी नहीं';

  @override
  String get colorWhite => 'सफ़ेद';

  @override
  String get colorYellow => 'पीला';

  @override
  String get colorGreen => 'हरा';

  @override
  String get colorBlue => 'नीला';

  @override
  String get colorPink => 'गुलाबी';

  @override
  String get colorBlack => 'काला';

  @override
  String get damagedData => 'पढ़ने लायक नहीं डेटा';

  @override
  String damagedDataHint(String date, int size) {
    return '$date को अलग रखा गया · $size अक्षर';
  }

  @override
  String get tryToRecover => 'रिकवर करके देखें';

  @override
  String get nothingRecovered => 'इसमें से कोई स्क्रिप्ट नहीं पढ़ी जा सकी।';

  @override
  String get floatLowRam =>
      'यह फ़ोन ऐप्स को दूसरे ऐप्स के ऊपर नहीं दिखा सकता (कम मेमोरी या Android Go फ़ोन)। इसके बजाय रिकॉर्ड इस्तेमाल करें।';

  @override
  String get oemTipsTitle => 'फ़्लोटिंग प्रॉम्प्टर चालू रखें';

  @override
  String oemTipsBody(String brand) {
    return '$brand फ़ोन बैटरी बचाने के लिए फ़्लोटिंग विंडो बंद कर सकते हैं। सेटिंग → ऐप्लिकेशन → APrompter में: दूसरे ऐप्स के ऊपर दिखाने (और पॉप-अप विंडो) की अनुमति दें, बैटरी को \"पाबंदी नहीं है\" पर सेट करें और सूचनाओं की अनुमति दें।';
  }

  @override
  String get focusLine => 'मौजूदा लाइन पर फ़ोकस';

  @override
  String get focusLineHint => 'बाकी लाइनों को धुंधला करता है';

  @override
  String get stepByLine => 'लाइन दर लाइन';

  @override
  String get stepByLineHint =>
      'हर टैप या रिमोट दबाने पर एक लाइन आगे — अपने-आप स्क्रॉल नहीं';

  @override
  String get reduceEffects => 'इफ़ेक्ट कम करें';

  @override
  String get reduceEffectsHint =>
      'फ़ेड या शैडो नहीं: पुराने फ़ोन पर स्मूद, बैटरी बचती है';

  @override
  String get letterSpacing => 'अक्षरों के बीच जगह';

  @override
  String get importTextFile => 'टेक्स्ट फ़ाइल इंपोर्ट करें';

  @override
  String get importTextFileHint =>
      'Files, Drive या ईमेल से .txt या .md स्क्रिप्ट';

  @override
  String get importTextFailed =>
      'यह फ़ाइल नहीं पढ़ी जा सकी। सादी टेक्स्ट (.txt) फ़ाइल चुनें।';

  @override
  String get mySetup => 'मेरा सेटअप';

  @override
  String get mySetupHint => 'आपका सेव किया सेटअप';

  @override
  String get saveMySetup => 'मेरे सेटअप के रूप में सेव करें';

  @override
  String get resetAllSettings => 'सभी सेटिंग रीसेट करें';

  @override
  String get runHadJumps =>
      'इस रन में आप आगे-पीछे गए, इसलिए रफ़्तार नहीं सुझाई जा सकती।';

  @override
  String get keepTake => 'रखें';

  @override
  String get retake => 'फिर से लें';

  @override
  String get reviewTakes => 'हर टेक देखें';

  @override
  String get reviewTakesHint => 'देखें, फिर रखें या दोबारा लें';

  @override
  String get takesToGallery => 'टेक गैलरी में सेव करें';

  @override
  String get takesToGalleryHint =>
      'बंद: टेक ऐप में ही रहते हैं, Google Photos और iCloud से बाहर';

  @override
  String get takesTitle => 'टेक';

  @override
  String get takesEmpty =>
      'ऐप में रखे टेक यहाँ दिखते हैं। उन्हें यहाँ रखने के लिए सेटिंग में \"टेक गैलरी में सेव करें\" बंद करें।';

  @override
  String get saveToGallery => 'गैलरी में सेव करें';

  @override
  String get savedToGallery => 'गैलरी में सेव हो गया';

  @override
  String get deleteTake => 'टेक हटाएँ';

  @override
  String takeKeptInApp(int n) {
    return 'टेक $n ऐप में रखा गया';
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
