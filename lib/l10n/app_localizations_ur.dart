// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'بند کریں';

  @override
  String get settings => 'ترتیبات';

  @override
  String get prompterSettings => 'پرامپٹر کی ترتیبات';

  @override
  String get edit => 'ترمیم';

  @override
  String get delete => 'حذف کریں';

  @override
  String get undo => 'واپس کریں';

  @override
  String get duplicate => 'نقل بنائیں';

  @override
  String get share => 'شیئر کریں';

  @override
  String get copyAsCaption => 'کیپشن کے طور پر کاپی کریں';

  @override
  String get captionCopied =>
      'بولا جانے والا متن کاپی ہو گیا — اسے کیپشن میں پیسٹ کریں';

  @override
  String get copySuffix => '(نقل)';

  @override
  String deletedScript(String title) {
    return '\"$title\" حذف ہو گیا';
  }

  @override
  String duplicatedScript(String title) {
    return '\"$title\" کے نام سے نقل بن گئی';
  }

  @override
  String get untitled => 'بلا عنوان';

  @override
  String get newScript => 'نیا اسکرپٹ';

  @override
  String get searchScripts => 'اسکرپٹ تلاش کریں';

  @override
  String get filterAll => 'سب';

  @override
  String get statusDraft => 'مسودہ';

  @override
  String get statusReady => 'تیار';

  @override
  String get statusRecorded => 'ریکارڈ شدہ';

  @override
  String markAs(String status) {
    return '$status کے طور پر نشان لگائیں';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'مشق';

  @override
  String get float => 'تیرتا ہوا';

  @override
  String get record => 'ریکارڈ';

  @override
  String words(int count) {
    return '$count الفاظ';
  }

  @override
  String takes(int count) {
    return '$count ٹیک';
  }

  @override
  String get noScriptsYet => 'ابھی کوئی اسکرپٹ نہیں';

  @override
  String get noScriptsHint =>
      'شروع کرنے کے لیے \"نیا اسکرپٹ\" پر ٹیپ کریں اور ایک ٹیمپلیٹ چنیں۔';

  @override
  String get nothingHere => 'یہاں کچھ نہیں';

  @override
  String get nothingHereHint => 'کوئی اور فلٹر یا تلاش آزمائیں۔';

  @override
  String get startFromTemplate => 'ٹیمپلیٹ سے شروع کریں';

  @override
  String get overlayPermissionNeeded =>
      'تیرتا پرامپٹر استعمال کرنے کے لیے \"دوسری ایپس کے اوپر دکھائیں\" کی اجازت دیں۔';

  @override
  String get floatingStarted =>
      'پرامپٹر اسکرین پر تیر رہا ہے۔ کیمرہ ایپ کھولیں اور شروع کرنے کے لیے متن پر ٹیپ کریں۔';

  @override
  String get floatingNotificationTitle => 'APrompter اسکرین پر ہے';

  @override
  String get openScriptInApp => 'APrompter میں ایک اسکرپٹ کھولیں';

  @override
  String get script => 'اسکرپٹ';

  @override
  String get title => 'عنوان';

  @override
  String get status => 'حالت';

  @override
  String get noTarget => 'کوئی ہدف نہیں';

  @override
  String get editorHint =>
      'جو کہنا چاہتے ہیں لکھیں یا پیسٹ کریں…\n\nمشورہ: حصے کے لیے لائن # سے، اور اپنے لیے نوٹ کے لیے // سے شروع کریں۔';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $spoken بہ رفتار $wpm ل/م';
  }

  @override
  String get onTarget => 'ہدف پر';

  @override
  String overTarget(int seconds, int words) {
    return '$seconds سیکنڈ زیادہ · ~$words الفاظ کم کریں';
  }

  @override
  String underTarget(int seconds, int words) {
    return '$seconds سیکنڈ باقی · ~$words الفاظ اور';
  }

  @override
  String longSentences(int count) {
    return '$count لمبے جملے (25+ الفاظ) — سانس لینے کے لیے انہیں توڑیں';
  }

  @override
  String get toolSection => 'حصہ';

  @override
  String get toolEmphasis => 'زور';

  @override
  String get toolPause => 'وقفہ';

  @override
  String get toolNote => 'نوٹ';

  @override
  String get toolPaste => 'پیسٹ';

  @override
  String get restart => 'شروع سے';

  @override
  String get sections => 'حصے';

  @override
  String get slower => 'آہستہ';

  @override
  String get faster => 'تیز';

  @override
  String get play => 'چلائیں';

  @override
  String get pause => 'روکیں';

  @override
  String get wpmUnit => 'ل/م';

  @override
  String get startOfScript => 'اسکرپٹ کا آغاز';

  @override
  String sectionN(int n) {
    return 'حصہ $n';
  }

  @override
  String get noSectionsHint =>
      'ابھی کوئی حصہ نہیں۔ ایڈیٹر میں \"#\" سے شروع ہونے والی لائنیں شامل کریں (مثلاً \"# ہُک\") تاکہ حصوں کے درمیان جا سکیں اور صرف ایک دوبارہ ریکارڈ کریں۔';

  @override
  String get emptyScript => '(خالی اسکرپٹ)';

  @override
  String get preview => 'پیش منظر';

  @override
  String get setup => 'سیٹ اپ';

  @override
  String get pace => 'رفتار';

  @override
  String get text => 'متن';

  @override
  String get layout => 'ترتیب';

  @override
  String get recording => 'ریکارڈنگ';

  @override
  String get wordsPerMinute => 'الفاظ / منٹ';

  @override
  String fitTo(String time) {
    return '$time کے مطابق کریں';
  }

  @override
  String get paceCalm => 'پرسکون';

  @override
  String get paceNatural => 'قدرتی';

  @override
  String get paceEnergetic => 'پرجوش';

  @override
  String get countdown => 'شروع سے پہلے الٹی گنتی';

  @override
  String get off => 'بند';

  @override
  String get size => 'سائز';

  @override
  String get lineSpacing => 'سطروں کا فاصلہ';

  @override
  String get textColor => 'متن کا رنگ';

  @override
  String get prompterHeight => 'پرامپٹر کی اونچائی';

  @override
  String get background => 'پس منظر';

  @override
  String get readingGuide => 'پڑھنے کی لکیر';

  @override
  String get mirrorText => 'متن کو آئینہ کریں';

  @override
  String get mirrorTextHint => 'ٹیلی پرامپٹر شیشے / بیم اسپلٹر کے لیے';

  @override
  String get videoQuality => 'ویڈیو کا معیار';

  @override
  String get autoStop => 'اسکرپٹ ختم ہونے پر ریکارڈنگ روکیں';

  @override
  String get autoStopHint => 'آخری لائن کے بعد 2 سیکنڈ انتظار کرتا ہے';

  @override
  String get presetHandheld => 'ہاتھ میں سیلفی';

  @override
  String get presetHandheldHint => 'لینس کے قریب درمیانہ متن';

  @override
  String get presetTripod => 'ٹرائی پوڈ / فاصلے سے';

  @override
  String get presetTripodHint => '1–2 میٹر سے پڑھا جانے والا بڑا متن';

  @override
  String get presetGlass => 'ٹیلی پرامپٹر شیشہ';

  @override
  String get presetGlassHint => 'آئینہ دار، پوری اسکرین، ٹھوس پس منظر';

  @override
  String get niceRun => 'زبردست!';

  @override
  String runSummary(String time, int words, int wpm) {
    return 'آپ نے $words الفاظ کے لیے $time لیا → $wpm الفاظ فی منٹ۔';
  }

  @override
  String runOver(int seconds, String target) {
    return 'یہ آپ کے $target کے ہدف سے $seconds سیکنڈ زیادہ ہے — اسکرپٹ مختصر کریں یا تیز بولیں۔';
  }

  @override
  String runUnder(int seconds) {
    return 'ہدف تک آپ کے پاس $seconds سیکنڈ ہیں۔';
  }

  @override
  String get runOnTarget => 'بالکل ہدف کی مدت پر۔ 🎯';

  @override
  String get keepCurrent => 'یہی رکھیں';

  @override
  String useWpm(int wpm) {
    return '$wpm ل/م استعمال کریں';
  }

  @override
  String get switchCamera => 'کیمرہ بدلیں';

  @override
  String get startRecording => 'ریکارڈنگ شروع کریں';

  @override
  String get stopRecording => 'ریکارڈنگ روکیں';

  @override
  String get noCamera => 'اس ڈیوائس پر کوئی کیمرہ نہیں ملا۔';

  @override
  String get cameraDenied =>
      'کیمرے تک رسائی سے انکار ہوا۔ سسٹم کی ترتیبات میں اسے فعال کریں۔';

  @override
  String cameraError(String message) {
    return 'کیمرے کی خرابی: $message';
  }

  @override
  String takeSaved(int n) {
    return 'ٹیک $n گیلری میں محفوظ ہو گیا';
  }

  @override
  String get templateBlank => 'خالی';

  @override
  String get templateBlankHint => 'خالی صفحے سے شروع کریں';

  @override
  String get templateHvc => 'ہُک ← ویلیو ← CTA';

  @override
  String get templateHvcHint => 'مختصر ویڈیو کا کلاسک ڈھانچہ';

  @override
  String get templateTutorial => 'ٹیوٹوریل';

  @override
  String get templateTutorialHint => 'کچھ قدم بہ قدم سکھائیں';

  @override
  String get templateReview => 'پروڈکٹ ریویو';

  @override
  String get templateReviewHint => 'UGC، اشتہارات اور دیانت دار ریویوز';

  @override
  String get templateStory => 'کہانی';

  @override
  String get templateStoryHint => 'سبق کے ساتھ ذاتی کہانی';

  @override
  String get secHook => 'ہُک';

  @override
  String get secValue => 'ویلیو';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'مرحلہ $n';
  }

  @override
  String get secRecap => 'خلاصہ اور CTA';

  @override
  String get secWhatItIs => 'یہ کیا ہے';

  @override
  String get secLoved => 'مجھے کیا پسند آیا';

  @override
  String get secBetter => 'کیا بہتر ہو سکتا ہے';

  @override
  String get secVerdict => 'فیصلہ اور CTA';

  @override
  String get secSetup => 'پس منظر';

  @override
  String get secTurningPoint => 'موڑ';

  @override
  String get secLesson => 'سبق';

  @override
  String get noteHook =>
      'پہلے 3 سیکنڈ میں توجہ کھینچیں: کوئی جرات مندانہ دعویٰ یا سوال';

  @override
  String get noteValue => 'وہ ایک چیز دیں جس کا وعدہ کیا تھا';

  @override
  String get noteCta => 'بتائیں آگے کیا کرنا ہے: فالو، کمنٹ، بایو میں لنک';

  @override
  String get noteTutorialHook => '\"ایک منٹ سے کم میں … کرنے کا طریقہ\"';

  @override
  String get noteRecap =>
      'ایک جملے میں خلاصہ کریں، پھر ویڈیو محفوظ کرنے کو کہیں';

  @override
  String get noteReviewHook => 'پروڈکٹ اور وہ مسئلہ دکھائیں جو یہ حل کرتا ہے';

  @override
  String get noteVerdict => 'یہ کس کے لیے ہے — کوڈ یا لنک بتائیں';

  @override
  String get noteStoryHook => 'کہانی کے بیچ سے شروع کریں';

  @override
  String get welcomeTitle => 'APrompter میں خوش آمدید';

  @override
  String get welcomeBody =>
      '# ہُک\nکیا آپ اپنی لائنیں بھولے بغیر ویڈیو بنانا چاہتے ہیں؟ [pause]\n// سیدھا لینس میں دیکھیں\n\n# یہ کیسے کام کرتا ہے\nاپنا اسکرپٹ لکھیں، *ہدف کی مدت* چنیں، اور ٹائمر بتائے گا کہ یہ پورا آتا ہے یا نہیں۔\nالفاظ فی منٹ میں اپنی رفتار جاننے کے لیے مشق کریں۔\nپھر ریکارڈ دبائیں۔ متن کیمرے کے بالکل نیچے چلتا ہے، اس لیے ناظرین سے *آنکھوں کا رابطہ* قائم رہتا ہے۔\n\n# CTA\nاسکرپٹ میں ترمیم کے لیے اس کارڈ پر ٹیپ کریں، یا پلس بٹن سے اپنا اسکرپٹ بنائیں۔ [pause] تخلیق کا لطف اٹھائیں!\n';

  @override
  String get expand => 'بڑا کریں';

  @override
  String get minimize => 'چھوٹا کریں';

  @override
  String get nothingToSay =>
      'پہلے بولنے کے لیے کچھ شامل کریں — حصے (#) اور نوٹس (//) پڑھے نہیں جاتے۔';

  @override
  String get openSettings => 'ترتیبات کھولیں';

  @override
  String get tryAgain => 'دوبارہ کوشش کریں';

  @override
  String get noMicBanner =>
      'مائیکروفون تک رسائی نہیں — بغیر آواز ریکارڈ ہو رہا ہے';

  @override
  String get saveFailedTitle => 'گیلری میں محفوظ نہیں ہو سکا';

  @override
  String saveFailedBody(String reason) {
    return 'آپ کا ٹیک فی الحال محفوظ ہے۔ دوبارہ کوشش کریں، یا اسے Files، Drive یا کسی چیٹ میں شیئر کریں تاکہ ضائع نہ ہو۔ ($reason)';
  }

  @override
  String get shareVideo => 'ویڈیو شیئر کریں';

  @override
  String get discardTake => 'یہ ٹیک ضائع کریں';

  @override
  String takeShared(int n) {
    return 'ٹیک $n شیئر ہو گیا';
  }

  @override
  String get movePrompter => 'پرامپٹر کو ہلانے کے لیے گھسیٹیں';

  @override
  String get resizePrompter => 'پرامپٹر کا سائز بدلنے کے لیے گھسیٹیں';

  @override
  String get prompterWidth => 'پرامپٹر کی چوڑائی';

  @override
  String get resetPosition => 'جگہ دوبارہ ترتیب دیں (اوپر، پوری چوڑائی)';

  @override
  String get positionHint =>
      'پرامپٹر کو کہیں بھی لے جانے کے لیے اوپر والی پٹی، اور سائز بدلنے کے لیے کونا گھسیٹیں۔ اینڈرائیڈ پر تیرتی ونڈو کہیں بھی گھسیٹی جا سکتی ہے اور اپنی جگہ یاد رکھتی ہے۔';

  @override
  String get app => 'ایپ';

  @override
  String get appLanguage => 'ایپ کی زبان';

  @override
  String get systemDefault => 'فون کی زبان';

  @override
  String secondsShort(int n) {
    return '$n سیکنڈ';
  }

  @override
  String minutesShort(int n) {
    return '$n منٹ';
  }

  @override
  String get storageSaveFailed =>
      'محفوظ نہیں ہو سکا — شاید فون کی اسٹوریج بھر گئی ہے۔ ایپ کھلی رہنے تک آپ کا کام محفوظ ہے۔';

  @override
  String get versionHistory => 'ورژن کی تاریخ';

  @override
  String get noVersions =>
      'ابھی کوئی پرانا ورژن نہیں۔ لکھتے وقت یہ خود بخود محفوظ ہوتے ہیں۔';

  @override
  String get restore => 'بحال کریں';

  @override
  String get versionRestored => 'پرانا ورژن بحال ہو گیا';

  @override
  String get recentlyDeleted => 'حال ہی میں حذف شدہ';

  @override
  String trashHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'حذف شدہ اسکرپٹ یہاں $days دن رہتے ہیں۔',
      one: 'حذف شدہ اسکرپٹ یہاں 1 دن رہتے ہیں۔',
    );
    return '$_temp0';
  }

  @override
  String get deleteForever => 'ہمیشہ کے لیے حذف کریں';

  @override
  String deletedOn(String date) {
    return '$date کو حذف ہوا';
  }

  @override
  String restoredScript(String title) {
    return '\"$title\" بحال ہو گیا';
  }

  @override
  String get backUpScripts => 'تمام اسکرپٹس کا بیک اپ لیں';

  @override
  String get restoreBackup => 'بیک اپ سے بحال کریں';

  @override
  String get backupShareTitle => 'APrompter بیک اپ';

  @override
  String importedScripts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count اسکرپٹس بحال ہوئے',
      one: '1 اسکرپٹ بحال ہوا',
      zero: 'اس بیک اپ کی ہر چیز پہلے سے موجود ہے',
    );
    return '$_temp0';
  }

  @override
  String get notABackup => 'یہ فائل APrompter بیک اپ نہیں ہے۔';

  @override
  String fitImpossible(int wpm, String target, int words) {
    return '$wpm ل/م پر بھی یہ $target میں نہیں آئے گا — تقریباً $words الفاظ کم کریں۔';
  }

  @override
  String get cameraNotReady =>
      'کیمرا تیار نہیں تھا، اس لیے ریکارڈنگ شروع نہیں ہوئی۔ دوبارہ کوشش کریں۔';

  @override
  String get previousSection => 'پچھلا حصہ';

  @override
  String get nextSection => 'اگلا حصہ';

  @override
  String get floatingNotificationBody => 'APrompter کھولنے کے لیے ٹیپ کریں';

  @override
  String get customTarget => 'حسبِ ضرورت…';

  @override
  String get customTargetTitle => 'ہدف دورانیہ';

  @override
  String get customTargetHint => 'منٹ اور سیکنڈ، مثلاً 5:00';

  @override
  String get saved => 'محفوظ ہو گیا';

  @override
  String get floatNotOnIos =>
      'iPhone ایپس کو دوسری ایپس کے اوپر تیرنے نہیں دیتا۔ کیمرے کے نیچے اسکرپٹ کے ساتھ فلم بنانے کے لیے ریکارڈ استعمال کریں۔';

  @override
  String get hashtagHint =>
      'ہیش ٹیگ والی لائنیں (#fyp #ad) مدھم دکھتی ہیں اور ان کا وقت نہیں گنا جاتا۔ حصے کے لیے اسپیس کے ساتھ \"# \" استعمال کریں۔';

  @override
  String get appLock => 'ایپ لاک';

  @override
  String get appLockHint =>
      'APrompter کھولنے کے لیے فنگر پرنٹ، چہرہ یا فون کا PIN مانگیں';

  @override
  String get appLockUnavailable => 'پہلے اس فون پر اسکرین لاک سیٹ کریں۔';

  @override
  String get unlock => 'ان لاک کریں';

  @override
  String get unlockReason => 'اپنے اسکرپٹ دیکھنے کے لیے APrompter ان لاک کریں';

  @override
  String get autoStopWait => 'آخری لائن کے بعد انتظار';

  @override
  String get beforeYouRecord => 'ریکارڈ کرنے سے پہلے';

  @override
  String get recordAnyway => 'پھر بھی ریکارڈ کریں';

  @override
  String lowStorageWarning(int minutes) {
    return 'خالی جگہ میں صرف تقریباً $minutes منٹ کی ویڈیو آئے گی۔ جگہ خالی کریں یا ویڈیو کا معیار کم کریں۔';
  }

  @override
  String lowBatteryWarning(int level) {
    return 'بیٹری $level% پر ہے — لمبا ٹیک بیچ میں کٹ سکتا ہے۔ ہو سکے تو چارجر لگائیں۔';
  }

  @override
  String get brightScreen => 'پرامپٹنگ کے دوران پوری چمک';

  @override
  String get brightScreenHint => 'باہر پڑھنا آسان';

  @override
  String get cameraBusy =>
      'کوئی اور ایپ کیمرہ استعمال کر رہی ہے۔ اسے بند کر کے دوبارہ کوشش کریں۔';

  @override
  String get cameraIntroTitle => 'کیمرہ اور مائیکروفون';

  @override
  String get cameraIntroBody =>
      'اسکرین پر اسکرپٹ کے ساتھ آپ کو فلمانے کے لیے APrompter کو کیمرہ اور مائیکروفون چاہیے۔ آپ کا فون اب اجازت مانگے گا۔ ویڈیوز آپ کے فون پر ہی رہتی ہیں۔';

  @override
  String get continueLabel => 'جاری رکھیں';

  @override
  String get notNow => 'ابھی نہیں';

  @override
  String get colorWhite => 'سفید';

  @override
  String get colorYellow => 'پیلا';

  @override
  String get colorGreen => 'سبز';

  @override
  String get colorBlue => 'نیلا';

  @override
  String get colorPink => 'گلابی';

  @override
  String get colorBlack => 'سیاہ';

  @override
  String get damagedData => 'ناقابلِ پڑھائی ڈیٹا';

  @override
  String damagedDataHint(String date, int size) {
    return '$date کو الگ رکھا گیا · $size حروف';
  }

  @override
  String get tryToRecover => 'بحال کرنے کی کوشش کریں';

  @override
  String get nothingRecovered => 'اس میں سے کوئی اسکرپٹ نہیں پڑھا جا سکا۔';

  @override
  String get floatLowRam =>
      'یہ فون ایپس کو دوسری ایپس کے اوپر نہیں دکھا سکتا (کم میموری یا Android Go فون)۔ اس کی بجائے ریکارڈ استعمال کریں۔';

  @override
  String get oemTipsTitle => 'تیرتا پرامپٹر چلتا رکھیں';

  @override
  String oemTipsBody(String brand) {
    return '$brand فون بیٹری بچانے کے لیے تیرتی ونڈوز بند کر سکتے ہیں۔ ترتیبات → ایپس → APrompter میں: دوسری ایپس کے اوپر دکھانے (اور پاپ اپ ونڈوز) کی اجازت دیں، بیٹری کو \"غیر محدود\" پر رکھیں اور اطلاعات کی اجازت دیں۔';
  }

  @override
  String get focusLine => 'موجودہ لائن پر فوکس';

  @override
  String get focusLineHint => 'باقی لائنیں مدھم کرتا ہے';

  @override
  String get stepByLine => 'لائن بہ لائن';

  @override
  String get stepByLineHint =>
      'ہر ٹیپ یا ریموٹ دبانے پر ایک لائن آگے — خودکار اسکرول نہیں';

  @override
  String get reduceEffects => 'ایفیکٹس کم کریں';

  @override
  String get reduceEffectsHint =>
      'فیڈ یا سائے نہیں: پرانے فونز پر ہموار، بیٹری کی بچت';

  @override
  String get letterSpacing => 'حروف کا فاصلہ';

  @override
  String get importTextFile => 'ٹیکسٹ فائل درآمد کریں';

  @override
  String get importTextFileHint =>
      'فائلز، Drive یا ای میل سے .txt یا .md اسکرپٹ';

  @override
  String get importTextFailed =>
      'یہ فائل نہیں پڑھی جا سکی۔ سادہ ٹیکسٹ (.txt) فائل چنیں۔';

  @override
  String get mySetup => 'میرا سیٹ اپ';

  @override
  String get mySetupHint => 'آپ کا محفوظ کیا ہوا سیٹ اپ';

  @override
  String get saveMySetup => 'میرے سیٹ اپ کے طور پر محفوظ کریں';

  @override
  String get resetAllSettings => 'تمام ترتیبات ری سیٹ کریں';

  @override
  String get runHadJumps =>
      'اس رن میں آپ آگے پیچھے گئے، اس لیے رفتار تجویز نہیں کی جا سکتی۔';

  @override
  String get keepTake => 'رکھیں';

  @override
  String get retake => 'دوبارہ لیں';

  @override
  String get reviewTakes => 'ہر ٹیک کا جائزہ لیں';

  @override
  String get reviewTakesHint => 'دیکھیں، پھر رکھیں یا دوبارہ لیں';

  @override
  String get takesToGallery => 'ٹیکس گیلری میں محفوظ کریں';

  @override
  String get takesToGalleryHint =>
      'بند: ٹیکس ایپ میں رہتے ہیں، Google Photos اور iCloud سے باہر';

  @override
  String get takesTitle => 'ٹیکس';

  @override
  String get takesEmpty =>
      'ایپ میں رکھے گئے ٹیکس یہاں دکھتے ہیں۔ انہیں یہاں رکھنے کے لیے ترتیبات میں \"ٹیکس گیلری میں محفوظ کریں\" بند کریں۔';

  @override
  String get saveToGallery => 'گیلری میں محفوظ کریں';

  @override
  String get savedToGallery => 'گیلری میں محفوظ ہو گیا';

  @override
  String get deleteTake => 'ٹیک حذف کریں';

  @override
  String takeKeptInApp(int n) {
    return 'ٹیک $n ایپ میں رکھ لیا گیا';
  }
}
