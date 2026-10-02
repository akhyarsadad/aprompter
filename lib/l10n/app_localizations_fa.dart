// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'بستن';

  @override
  String get settings => 'تنظیمات';

  @override
  String get prompterSettings => 'تنظیمات پرامپتر';

  @override
  String get edit => 'ویرایش';

  @override
  String get delete => 'حذف';

  @override
  String get undo => 'واگرد';

  @override
  String get duplicate => 'تکثیر';

  @override
  String get share => 'اشتراک‌گذاری';

  @override
  String get copyAsCaption => 'کپی به‌عنوان کپشن';

  @override
  String get captionCopied =>
      'متن گفتاری کپی شد — آن را به‌عنوان کپشن بچسبانید';

  @override
  String get copySuffix => '(کپی)';

  @override
  String deletedScript(String title) {
    return '«$title» حذف شد';
  }

  @override
  String duplicatedScript(String title) {
    return 'با نام «$title» تکثیر شد';
  }

  @override
  String get untitled => 'بدون عنوان';

  @override
  String get newScript => 'متن جدید';

  @override
  String get searchScripts => 'جستجوی متن‌ها';

  @override
  String get filterAll => 'همه';

  @override
  String get statusDraft => 'پیش‌نویس';

  @override
  String get statusReady => 'آماده';

  @override
  String get statusRecorded => 'ضبط‌شده';

  @override
  String markAs(String status) {
    return 'علامت‌گذاری به‌عنوان $status';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'تمرین';

  @override
  String get float => 'شناور';

  @override
  String get record => 'ضبط';

  @override
  String words(int count) {
    return '$count کلمه';
  }

  @override
  String takes(int count) {
    return '$count برداشت';
  }

  @override
  String get noScriptsYet => 'هنوز متنی ندارید';

  @override
  String get noScriptsHint => 'روی «متن جدید» بزنید و یک قالب انتخاب کنید.';

  @override
  String get nothingHere => 'چیزی اینجا نیست';

  @override
  String get nothingHereHint => 'فیلتر یا جستجوی دیگری را امتحان کنید.';

  @override
  String get startFromTemplate => 'شروع با یک قالب';

  @override
  String get overlayPermissionNeeded =>
      'برای استفاده از پرامپتر شناور، «نمایش روی برنامه‌های دیگر» را مجاز کنید.';

  @override
  String get floatingStarted =>
      'پرامپتر شناور است. برنامهٔ دوربین را باز کنید و برای شروع روی متن بزنید.';

  @override
  String get floatingNotificationTitle => 'APrompter روی صفحه است';

  @override
  String get openScriptInApp => 'یک متن را در APrompter باز کنید';

  @override
  String get script => 'متن';

  @override
  String get title => 'عنوان';

  @override
  String get status => 'وضعیت';

  @override
  String get noTarget => 'بدون هدف';

  @override
  String get editorHint =>
      'آنچه می‌خواهید بگویید را بنویسید یا بچسبانید…\n\nنکته: خط را برای بخش با # و برای یادداشت شخصی با // شروع کنید.';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $spoken با $wpm ک/د';
  }

  @override
  String get onTarget => 'در هدف';

  @override
  String overTarget(int seconds, int words) {
    return '$seconds ث بیشتر · ~$words کلمه کم کنید';
  }

  @override
  String underTarget(int seconds, int words) {
    return '$seconds ث مانده · ~$words کلمهٔ دیگر';
  }

  @override
  String longSentences(int count) {
    return '$count جملهٔ بلند (۲۵+ کلمه) — تقسیمش کنید تا بتوانید نفس بکشید';
  }

  @override
  String get toolSection => 'بخش';

  @override
  String get toolEmphasis => 'تأکید';

  @override
  String get toolPause => 'مکث';

  @override
  String get toolNote => 'یادداشت';

  @override
  String get toolPaste => 'چسباندن';

  @override
  String get restart => 'از اول';

  @override
  String get sections => 'بخش‌ها';

  @override
  String get slower => 'آهسته‌تر';

  @override
  String get faster => 'سریع‌تر';

  @override
  String get play => 'پخش';

  @override
  String get pause => 'توقف';

  @override
  String get wpmUnit => 'ک/د';

  @override
  String get startOfScript => 'ابتدای متن';

  @override
  String sectionN(int n) {
    return 'بخش $n';
  }

  @override
  String get noSectionsHint =>
      'هنوز بخشی ندارید. در ویرایشگر خط‌هایی که با «#» شروع می‌شوند اضافه کنید (مثلاً «# قلاب») تا بین قسمت‌ها جابه‌جا شوید و فقط یکی را دوباره ضبط کنید.';

  @override
  String get emptyScript => '(متن خالی)';

  @override
  String get preview => 'پیش‌نمایش';

  @override
  String get setup => 'چیدمان';

  @override
  String get pace => 'سرعت';

  @override
  String get text => 'متن';

  @override
  String get layout => 'طرح‌بندی';

  @override
  String get recording => 'ضبط';

  @override
  String get wordsPerMinute => 'کلمه / دقیقه';

  @override
  String fitTo(String time) {
    return 'تنظیم روی $time';
  }

  @override
  String get paceCalm => 'آرام';

  @override
  String get paceNatural => 'طبیعی';

  @override
  String get paceEnergetic => 'پرانرژی';

  @override
  String get countdown => 'شمارش معکوس پیش از شروع';

  @override
  String get off => 'خاموش';

  @override
  String get size => 'اندازه';

  @override
  String get lineSpacing => 'فاصلهٔ خطوط';

  @override
  String get textColor => 'رنگ متن';

  @override
  String get prompterHeight => 'ارتفاع پرامپتر';

  @override
  String get background => 'پس‌زمینه';

  @override
  String get readingGuide => 'خط راهنمای خواندن';

  @override
  String get mirrorText => 'آینه‌ای کردن متن';

  @override
  String get mirrorTextHint => 'برای شیشهٔ تله‌پرامپتر / تقسیم‌کنندهٔ نور';

  @override
  String get videoQuality => 'کیفیت ویدیو';

  @override
  String get autoStop => 'توقف ضبط در پایان متن';

  @override
  String get autoStopHint => '۲ ثانیه پس از آخرین خط صبر می‌کند';

  @override
  String get presetHandheld => 'سلفی با دست';

  @override
  String get presetHandheldHint => 'متن متوسط نزدیک لنز';

  @override
  String get presetTripod => 'سه‌پایه / از فاصله';

  @override
  String get presetTripodHint => 'متن درشت خوانا از ۱–۲ متری';

  @override
  String get presetGlass => 'شیشهٔ تله‌پرامپتر';

  @override
  String get presetGlassHint => 'آینه‌ای، تمام‌صفحه، پس‌زمینهٔ یکدست';

  @override
  String get niceRun => 'عالی بود!';

  @override
  String runSummary(String time, int words, int wpm) {
    return 'برای $words کلمه $time طول کشید → $wpm کلمه در دقیقه.';
  }

  @override
  String runOver(int seconds, String target) {
    return 'این $seconds ث بیشتر از هدف $target است — متن را کوتاه کنید یا تندتر بخوانید.';
  }

  @override
  String runUnder(int seconds) {
    return 'تا هدفتان $seconds ث فرصت دارید.';
  }

  @override
  String get runOnTarget => 'دقیقاً در مدت هدف. 🎯';

  @override
  String get keepCurrent => 'همین بماند';

  @override
  String useWpm(int wpm) {
    return 'استفاده از $wpm ک/د';
  }

  @override
  String get switchCamera => 'تعویض دوربین';

  @override
  String get startRecording => 'شروع ضبط';

  @override
  String get stopRecording => 'توقف ضبط';

  @override
  String get noCamera => 'دوربینی روی این دستگاه پیدا نشد.';

  @override
  String get cameraDenied =>
      'دسترسی به دوربین رد شد. آن را در تنظیمات سیستم فعال کنید.';

  @override
  String cameraError(String message) {
    return 'خطای دوربین: $message';
  }

  @override
  String takeSaved(int n) {
    return 'برداشت $n در گالری ذخیره شد';
  }

  @override
  String get templateBlank => 'خالی';

  @override
  String get templateBlankHint => 'شروع با صفحهٔ خالی';

  @override
  String get templateHvc => 'قلاب ← ارزش ← CTA';

  @override
  String get templateHvcHint => 'ساختار کلاسیک ویدیوی کوتاه';

  @override
  String get templateTutorial => 'آموزشی';

  @override
  String get templateTutorialHint => 'چیزی را قدم‌به‌قدم آموزش دهید';

  @override
  String get templateReview => 'نقد محصول';

  @override
  String get templateReviewHint => 'UGC، تبلیغ و نقدهای صادقانه';

  @override
  String get templateStory => 'داستان';

  @override
  String get templateStoryHint => 'داستان شخصی با یک درس';

  @override
  String get secHook => 'قلاب';

  @override
  String get secValue => 'ارزش';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'قدم $n';
  }

  @override
  String get secRecap => 'جمع‌بندی و CTA';

  @override
  String get secWhatItIs => 'این چیست';

  @override
  String get secLoved => 'چیزهایی که دوست داشتم';

  @override
  String get secBetter => 'چیزهایی که می‌تواند بهتر باشد';

  @override
  String get secVerdict => 'نتیجه و CTA';

  @override
  String get secSetup => 'مقدمه';

  @override
  String get secTurningPoint => 'نقطهٔ عطف';

  @override
  String get secLesson => 'درس';

  @override
  String get noteHook =>
      'در ۳ ثانیهٔ اول توجه را جلب کنید: یک ادعای جسورانه یا یک سؤال';

  @override
  String get noteValue => 'همان یک چیزی را که قول دادید ارائه کنید';

  @override
  String get noteCta => 'بگویید قدم بعد چیست: دنبال کردن، کامنت، لینک در بیو';

  @override
  String get noteTutorialHook =>
      '«این‌طوری … را در کمتر از یک دقیقه انجام بده»';

  @override
  String get noteRecap =>
      'در یک جمله جمع‌بندی کنید و بخواهید ویدیو را ذخیره کنند';

  @override
  String get noteReviewHook => 'محصول و مشکلی را که حل می‌کند نشان دهید';

  @override
  String get noteVerdict => 'به درد چه کسی می‌خورد — کد یا لینک را بگویید';

  @override
  String get noteStoryHook => 'از وسط ماجرا شروع کنید';

  @override
  String get welcomeTitle => 'به APrompter خوش آمدید';

  @override
  String get welcomeBody =>
      '# قلاب\nمی‌خواهید بدون فراموش کردن متن فیلم بگیرید؟ [pause]\n// مستقیم به لنز نگاه کنید\n\n# چطور کار می‌کند\nمتن خود را بنویسید، یک *مدت هدف* انتخاب کنید و زمان‌سنج می‌گوید جا می‌شود یا نه.\nتمرین کنید تا سرعت خود را بر حسب کلمه در دقیقه پیدا کنید.\nسپس ضبط را بزنید. متن درست زیر دوربین حرکت می‌کند تا *ارتباط چشمی* با مخاطب حفظ شود.\n\n# CTA\nبرای ویرایش متن روی این کارت بزنید یا با دکمهٔ به‌علاوه متن خودتان را بسازید. [pause] از ساختن لذت ببرید!\n';

  @override
  String get expand => 'بزرگ کردن';

  @override
  String get minimize => 'کوچک کردن';

  @override
  String get nothingToSay =>
      'اول چیزی برای گفتن اضافه کنید — بخش‌ها (#) و یادداشت‌ها (//) خوانده نمی‌شوند.';

  @override
  String get openSettings => 'باز کردن تنظیمات';

  @override
  String get tryAgain => 'تلاش دوباره';

  @override
  String get noMicBanner => 'بدون دسترسی به میکروفون — ضبط بدون صدا';

  @override
  String get saveFailedTitle => 'ذخیره در گالری ممکن نشد';

  @override
  String saveFailedBody(String reason) {
    return 'برداشت شما فعلاً امن است. دوباره تلاش کنید یا آن را به Files، Drive یا یک گفتگو بفرستید تا از دست نرود. ($reason)';
  }

  @override
  String get shareVideo => 'اشتراک ویدیو';

  @override
  String get discardTake => 'کنار گذاشتن این برداشت';

  @override
  String takeShared(int n) {
    return 'برداشت $n به اشتراک گذاشته شد';
  }

  @override
  String get movePrompter => 'برای جابه‌جایی پرامپتر بکشید';

  @override
  String get resizePrompter => 'برای تغییر اندازهٔ پرامپتر بکشید';

  @override
  String get prompterWidth => 'عرض پرامپتر';

  @override
  String get resetPosition => 'بازنشانی موقعیت (بالا، تمام‌عرض)';

  @override
  String get positionHint =>
      'نوار بالای پرامپتر را بکشید تا هر جا خواستید ببریدش و گوشه را بکشید تا اندازه‌اش عوض شود. در اندروید پنجرهٔ شناور هر جایی کشیده می‌شود و جایش را به خاطر می‌سپارد.';

  @override
  String get app => 'برنامه';

  @override
  String get appLanguage => 'زبان برنامه';

  @override
  String get systemDefault => 'زبان گوشی';

  @override
  String secondsShort(int n) {
    return '$n ث';
  }

  @override
  String minutesShort(int n) {
    return '$n د';
  }

  @override
  String get storageSaveFailed =>
      'ذخیره نشد — شاید حافظهٔ گوشی پر باشد. تا وقتی برنامه باز است، کارتان حفظ می‌شود.';

  @override
  String get versionHistory => 'تاریخچهٔ نسخه‌ها';

  @override
  String get noVersions =>
      'هنوز نسخهٔ قبلی‌ای نیست. هنگام نوشتن خودکار ذخیره می‌شوند.';

  @override
  String get restore => 'بازگردانی';

  @override
  String get versionRestored => 'نسخهٔ قبلی بازگردانده شد';

  @override
  String get recentlyDeleted => 'اخیراً حذف‌شده';

  @override
  String trashHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'متن‌های حذف‌شده $days روز اینجا می‌مانند.',
      one: 'متن‌های حذف‌شده ۱ روز اینجا می‌مانند.',
    );
    return '$_temp0';
  }

  @override
  String get deleteForever => 'حذف برای همیشه';

  @override
  String deletedOn(String date) {
    return 'حذف‌شده در $date';
  }

  @override
  String restoredScript(String title) {
    return '«$title» بازگردانده شد';
  }

  @override
  String get backUpScripts => 'پشتیبان‌گیری از همهٔ متن‌ها';

  @override
  String get restoreBackup => 'بازگردانی از پشتیبان';

  @override
  String get backupShareTitle => 'پشتیبان APrompter';

  @override
  String importedScripts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count متن بازگردانده شد',
      one: '۱ متن بازگردانده شد',
      zero: 'همهٔ محتوای این پشتیبان از قبل اینجاست',
    );
    return '$_temp0';
  }

  @override
  String get notABackup => 'این فایل پشتیبان APrompter نیست.';

  @override
  String fitImpossible(int wpm, String target, int words) {
    return 'حتی با $wpm ک/د هم در $target جا نمی‌شود — حدود $words کلمه کم کنید.';
  }

  @override
  String get cameraNotReady =>
      'دوربین آماده نبود، برای همین ضبط شروع نشد. دوباره امتحان کنید.';

  @override
  String get previousSection => 'بخش قبلی';

  @override
  String get nextSection => 'بخش بعدی';

  @override
  String get floatingNotificationBody => 'برای باز کردن APrompter بزنید';

  @override
  String get customTarget => 'سفارشی…';

  @override
  String get customTargetTitle => 'مدت هدف';

  @override
  String get customTargetHint => 'دقیقه و ثانیه، مثلاً 5:00';

  @override
  String get saved => 'ذخیره شد';

  @override
  String get floatNotOnIos =>
      'آیفون اجازه نمی‌دهد برنامه‌ها روی برنامه‌های دیگر شناور شوند. از «ضبط» استفاده کنید تا با متن زیر دوربین فیلم بگیرید.';

  @override
  String get hashtagHint =>
      'خط‌های هشتگ (#fyp #ad) کم‌رنگ نمایش داده می‌شوند و زمان‌بندی نمی‌شوند. برای بخش از «# » با فاصله استفاده کنید.';

  @override
  String get appLock => 'قفل برنامه';

  @override
  String get appLockHint =>
      'برای باز کردن APrompter اثر انگشت، چهره یا پین گوشی خواسته شود';

  @override
  String get appLockUnavailable => 'ابتدا روی این گوشی قفل صفحه تنظیم کنید.';

  @override
  String get unlock => 'باز کردن قفل';

  @override
  String get unlockReason => 'برای دیدن متن‌هایتان قفل APrompter را باز کنید';

  @override
  String get autoStopWait => 'مکث بعد از خط آخر';

  @override
  String get beforeYouRecord => 'پیش از ضبط';

  @override
  String get recordAnyway => 'ضبط در هر صورت';

  @override
  String lowStorageWarning(int minutes) {
    return 'فضای خالی فقط برای حدود $minutes د ویدیو کافی است. فضا آزاد کنید یا کیفیت ویدیو را پایین بیاورید.';
  }

  @override
  String lowBatteryWarning(int level) {
    return 'باتری $level٪ است — ممکن است برداشت طولانی قطع شود. اگر می‌توانید شارژر را وصل کنید.';
  }

  @override
  String get brightScreen => 'روشنایی کامل هنگام پرامپتر';

  @override
  String get brightScreenHint => 'خواندن در فضای باز آسان‌تر';

  @override
  String get cameraBusy =>
      'برنامهٔ دیگری از دوربین استفاده می‌کند. آن را ببندید و دوباره تلاش کنید.';

  @override
  String get cameraIntroTitle => 'دوربین و میکروفون';

  @override
  String get cameraIntroBody =>
      'برای فیلم‌برداری از شما همراه با متن روی صفحه، APrompter به دوربین و میکروفون نیاز دارد. گوشی در ادامه اجازه می‌خواهد. ویدیوها روی گوشی شما می‌مانند.';

  @override
  String get continueLabel => 'ادامه';

  @override
  String get notNow => 'الان نه';

  @override
  String get colorWhite => 'سفید';

  @override
  String get colorYellow => 'زرد';

  @override
  String get colorGreen => 'سبز';

  @override
  String get colorBlue => 'آبی';

  @override
  String get colorPink => 'صورتی';

  @override
  String get colorBlack => 'مشکی';

  @override
  String get damagedData => 'دادهٔ ناخوانا';

  @override
  String damagedDataHint(String date, int size) {
    return 'کنار گذاشته در $date · $size نویسه';
  }

  @override
  String get tryToRecover => 'تلاش برای بازیابی';

  @override
  String get nothingRecovered => 'هیچ متنی از آن خوانده نشد.';

  @override
  String get floatLowRam =>
      'این گوشی نمی‌تواند برنامه‌ها را روی برنامه‌های دیگر نشان دهد (حافظهٔ کم یا Android Go). به‌جای آن از ضبط استفاده کنید.';

  @override
  String get oemTipsTitle => 'فعال نگه داشتن پرامپتر شناور';

  @override
  String oemTipsBody(String brand) {
    return 'گوشی‌های $brand ممکن است برای صرفه‌جویی در باتری پنجره‌های شناور را ببندند. در تنظیمات → برنامه‌ها → APrompter: نمایش روی برنامه‌های دیگر (و پنجره‌های بازشو) را مجاز کنید، باتری را روی «نامحدود» بگذارید و اعلان‌ها را مجاز کنید.';
  }

  @override
  String get focusLine => 'تمرکز روی خط فعلی';

  @override
  String get focusLineHint => 'خط‌های دیگر را کم‌رنگ می‌کند';

  @override
  String get stepByLine => 'خط به خط';

  @override
  String get stepByLineHint =>
      'هر ضربه یا فشار ریموت یک خط جلو می‌رود — بدون پیمایش خودکار';

  @override
  String get reduceEffects => 'کاهش جلوه‌ها';

  @override
  String get reduceEffectsHint =>
      'بدون محوشدگی و سایه: روان‌تر روی گوشی‌های قدیمی، صرفه‌جویی در باتری';

  @override
  String get letterSpacing => 'فاصلهٔ حروف';

  @override
  String get importTextFile => 'وارد کردن فایل متنی';

  @override
  String get importTextFileHint => 'متن .txt یا .md از فایل‌ها، Drive یا ایمیل';

  @override
  String get importTextFailed =>
      'این فایل خوانده نشد. یک فایل متنی ساده (.txt) انتخاب کنید.';

  @override
  String get mySetup => 'چیدمان من';

  @override
  String get mySetupHint => 'چیدمانی که ذخیره کرده‌اید';

  @override
  String get saveMySetup => 'ذخیره به‌عنوان چیدمان من';

  @override
  String get resetAllSettings => 'بازنشانی همهٔ تنظیمات';

  @override
  String get runHadJumps =>
      'در این اجرا بین بخش‌ها پرش کردید، پس سرعتی پیشنهاد نمی‌شود.';

  @override
  String get keepTake => 'نگه داشتن';

  @override
  String get retake => 'برداشت دوباره';

  @override
  String get reviewTakes => 'بازبینی هر برداشت';

  @override
  String get reviewTakesHint => 'تماشا کنید، بعد نگه دارید یا دوباره بگیرید';

  @override
  String get takesToGallery => 'ذخیرهٔ برداشت‌ها در گالری';

  @override
  String get takesToGalleryHint =>
      'خاموش: برداشت‌ها داخل برنامه می‌مانند، بیرون از Google Photos و iCloud';

  @override
  String get takesTitle => 'برداشت‌ها';

  @override
  String get takesEmpty =>
      'برداشت‌هایی که داخل برنامه نگه داشته شده‌اند اینجا نمایش داده می‌شوند. برای نگه داشتن آن‌ها اینجا، «ذخیرهٔ برداشت‌ها در گالری» را در تنظیمات خاموش کنید.';

  @override
  String get saveToGallery => 'ذخیره در گالری';

  @override
  String get savedToGallery => 'در گالری ذخیره شد';

  @override
  String get deleteTake => 'حذف برداشت';

  @override
  String takeKeptInApp(int n) {
    return 'برداشت $n در برنامه نگه داشته شد';
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
