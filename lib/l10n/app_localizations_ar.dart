// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'إغلاق';

  @override
  String get settings => 'الإعدادات';

  @override
  String get prompterSettings => 'إعدادات الملقّن';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get undo => 'تراجع';

  @override
  String get duplicate => 'تكرار';

  @override
  String get share => 'مشاركة';

  @override
  String get copyAsCaption => 'نسخ كتعليق';

  @override
  String get captionCopied => 'تم نسخ النص المنطوق — الصقه كتعليق للمنشور';

  @override
  String get copySuffix => '(نسخة)';

  @override
  String deletedScript(String title) {
    return 'تم حذف \"$title\"';
  }

  @override
  String duplicatedScript(String title) {
    return 'تم التكرار باسم \"$title\"';
  }

  @override
  String get untitled => 'بلا عنوان';

  @override
  String get newScript => 'نص جديد';

  @override
  String get searchScripts => 'ابحث في النصوص';

  @override
  String get filterAll => 'الكل';

  @override
  String get statusDraft => 'مسودة';

  @override
  String get statusReady => 'جاهز';

  @override
  String get statusRecorded => 'مُسجَّل';

  @override
  String markAs(String status) {
    return 'وضع علامة: $status';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'تمرين';

  @override
  String get float => 'عائم';

  @override
  String get record => 'تسجيل';

  @override
  String words(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count كلمة',
      many: '$count كلمة',
      few: '$count كلمات',
      two: 'كلمتان',
      one: 'كلمة واحدة',
      zero: 'لا كلمات',
    );
    return '$_temp0';
  }

  @override
  String takes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count لقطة',
      many: '$count لقطة',
      few: '$count لقطات',
      two: 'لقطتان',
      one: 'لقطة واحدة',
      zero: 'لا لقطات',
    );
    return '$_temp0';
  }

  @override
  String get noScriptsYet => 'لا توجد نصوص بعد';

  @override
  String get noScriptsHint => 'اضغط على \"نص جديد\" واختر قالبًا للبدء.';

  @override
  String get nothingHere => 'لا شيء هنا';

  @override
  String get nothingHereHint => 'جرّب فلترًا أو بحثًا آخر.';

  @override
  String get startFromTemplate => 'ابدأ من قالب';

  @override
  String get overlayPermissionNeeded =>
      'اسمح بـ \"الظهور فوق التطبيقات الأخرى\" لاستخدام الملقّن العائم.';

  @override
  String get floatingStarted =>
      'الملقّن عائم الآن. افتح تطبيق الكاميرا واضغط على النص للبدء.';

  @override
  String get floatingNotificationTitle => 'APrompter يعمل فوق الشاشة';

  @override
  String get openScriptInApp => 'افتح نصًا في APrompter';

  @override
  String get script => 'النص';

  @override
  String get title => 'العنوان';

  @override
  String get status => 'الحالة';

  @override
  String get noTarget => 'بلا هدف';

  @override
  String get editorHint =>
      'اكتب أو الصق ما تريد قوله…\n\nنصيحة: ابدأ السطر بـ # لقسم، وبـ // لملاحظة لنفسك.';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $spoken بسرعة $wpm ك/د';
  }

  @override
  String get onTarget => 'ضمن الهدف';

  @override
  String overTarget(int seconds, int words) {
    return 'زيادة $seconds ث · احذف ~$words كلمة';
  }

  @override
  String underTarget(int seconds, int words) {
    return 'متبقٍ $seconds ث · ~$words كلمة أخرى';
  }

  @override
  String longSentences(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count جمل طويلة (25+ كلمة) — قسّمها لتتمكن من التنفس',
      two: 'جملتان طويلتان (25+ كلمة) — قسّمهما لتتمكن من التنفس',
      one: 'جملة طويلة واحدة (25+ كلمة) — قسّمها لتتمكن من التنفس',
    );
    return '$_temp0';
  }

  @override
  String get toolSection => 'قسم';

  @override
  String get toolEmphasis => 'تأكيد';

  @override
  String get toolPause => 'وقفة';

  @override
  String get toolNote => 'ملاحظة';

  @override
  String get toolPaste => 'لصق';

  @override
  String get restart => 'من البداية';

  @override
  String get sections => 'الأقسام';

  @override
  String get slower => 'أبطأ';

  @override
  String get faster => 'أسرع';

  @override
  String get play => 'تشغيل';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get wpmUnit => 'ك/د';

  @override
  String get startOfScript => 'بداية النص';

  @override
  String sectionN(int n) {
    return 'القسم $n';
  }

  @override
  String get noSectionsHint =>
      'لا توجد أقسام بعد. أضف في المحرر أسطرًا تبدأ بـ \"#\" (مثل \"# الخطّاف\") للتنقل بين الأجزاء وإعادة تصوير جزء واحد فقط.';

  @override
  String get emptyScript => '(نص فارغ)';

  @override
  String get preview => 'معاينة';

  @override
  String get setup => 'الإعداد';

  @override
  String get pace => 'الإيقاع';

  @override
  String get text => 'النص';

  @override
  String get layout => 'التخطيط';

  @override
  String get recording => 'التسجيل';

  @override
  String get wordsPerMinute => 'كلمة / دقيقة';

  @override
  String fitTo(String time) {
    return 'اضبط على $time';
  }

  @override
  String get paceCalm => 'هادئ';

  @override
  String get paceNatural => 'طبيعي';

  @override
  String get paceEnergetic => 'حيوي';

  @override
  String get countdown => 'عدّ تنازلي قبل البدء';

  @override
  String get off => 'إيقاف';

  @override
  String get size => 'الحجم';

  @override
  String get lineSpacing => 'تباعد الأسطر';

  @override
  String get textColor => 'لون النص';

  @override
  String get prompterHeight => 'ارتفاع الملقّن';

  @override
  String get background => 'الخلفية';

  @override
  String get readingGuide => 'خط القراءة';

  @override
  String get mirrorText => 'عكس النص';

  @override
  String get mirrorTextHint => 'لزجاج الملقّن / مقسّم الضوء';

  @override
  String get videoQuality => 'جودة الفيديو';

  @override
  String get autoStop => 'إيقاف التسجيل عند انتهاء النص';

  @override
  String get autoStopHint => 'ينتظر ثانيتين بعد السطر الأخير';

  @override
  String get presetHandheld => 'سيلفي باليد';

  @override
  String get presetHandheldHint => 'نص متوسط قرب العدسة';

  @override
  String get presetTripod => 'حامل ثلاثي / عن بُعد';

  @override
  String get presetTripodHint => 'نص كبير يُقرأ من 1–2 م';

  @override
  String get presetGlass => 'زجاج الملقّن';

  @override
  String get presetGlassHint => 'معكوس، ملء الشاشة، خلفية مصمتة';

  @override
  String get niceRun => 'أحسنت!';

  @override
  String runSummary(String time, int words, int wpm) {
    return 'استغرقت $time لـ $words كلمة → $wpm كلمة في الدقيقة.';
  }

  @override
  String runOver(int seconds, String target) {
    return 'هذا أكثر من هدفك $target بـ $seconds ث — اختصر النص أو أسرِع.';
  }

  @override
  String runUnder(int seconds) {
    return 'لديك $seconds ث قبل الوصول إلى هدفك.';
  }

  @override
  String get runOnTarget => 'تمامًا ضمن المدة المستهدفة. 🎯';

  @override
  String get keepCurrent => 'إبقاء الحالي';

  @override
  String useWpm(int wpm) {
    return 'استخدم $wpm ك/د';
  }

  @override
  String get switchCamera => 'تبديل الكاميرا';

  @override
  String get startRecording => 'بدء التسجيل';

  @override
  String get stopRecording => 'إيقاف التسجيل';

  @override
  String get noCamera => 'لم يتم العثور على كاميرا في هذا الجهاز.';

  @override
  String get cameraDenied =>
      'تم رفض الوصول إلى الكاميرا. فعّله من إعدادات النظام.';

  @override
  String cameraError(String message) {
    return 'خطأ في الكاميرا: $message';
  }

  @override
  String takeSaved(int n) {
    return 'تم حفظ اللقطة $n في المعرض';
  }

  @override
  String get templateBlank => 'فارغ';

  @override
  String get templateBlankHint => 'ابدأ من صفحة فارغة';

  @override
  String get templateHvc => 'الخطّاف ← القيمة ← CTA';

  @override
  String get templateHvcHint => 'البنية الكلاسيكية للفيديو القصير';

  @override
  String get templateTutorial => 'شرح تعليمي';

  @override
  String get templateTutorialHint => 'علّم شيئًا خطوة بخطوة';

  @override
  String get templateReview => 'مراجعة منتج';

  @override
  String get templateReviewHint => 'UGC وإعلانات ومراجعات صادقة';

  @override
  String get templateStory => 'قصة';

  @override
  String get templateStoryHint => 'قصة شخصية مع درس';

  @override
  String get secHook => 'الخطّاف';

  @override
  String get secValue => 'القيمة';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'الخطوة $n';
  }

  @override
  String get secRecap => 'الخلاصة وCTA';

  @override
  String get secWhatItIs => 'ما هو';

  @override
  String get secLoved => 'ما أحببته';

  @override
  String get secBetter => 'ما يمكن تحسينه';

  @override
  String get secVerdict => 'الحكم وCTA';

  @override
  String get secSetup => 'التمهيد';

  @override
  String get secTurningPoint => 'نقطة التحول';

  @override
  String get secLesson => 'الدرس';

  @override
  String get noteHook => 'اجذب الانتباه في أول 3 ثوانٍ: ادعاء جريء أو سؤال';

  @override
  String get noteValue => 'قدّم الشيء الوحيد الذي وعدت به';

  @override
  String get noteCta =>
      'أخبرهم بما يفعلونه بعد ذلك: تابِع، علّق، الرابط في البايو';

  @override
  String get noteTutorialHook => '\"إليك طريقة … في أقل من دقيقة\"';

  @override
  String get noteRecap => 'لخّص في جملة واحدة ثم اطلب منهم حفظ الفيديو';

  @override
  String get noteReviewHook => 'اعرض المنتج والمشكلة التي يحلها';

  @override
  String get noteVerdict => 'لمن يناسب — اذكر الكود أو الرابط';

  @override
  String get noteStoryHook => 'ابدأ من منتصف الحدث';

  @override
  String get welcomeTitle => 'مرحبًا بك في APrompter';

  @override
  String get welcomeBody =>
      '# الخطّاف\nهل تريد التصوير دون أن تنسى كلامك؟ [pause]\n// انظر مباشرة إلى العدسة\n\n# كيف يعمل\nاكتب نصك، واختر *مدة مستهدفة*، ودع المؤقت يخبرك إن كان مناسبًا.\nتمرّن لتجد إيقاعك بعدد الكلمات في الدقيقة.\nثم اضغط تسجيل. يمر النص أسفل الكاميرا مباشرة، فتحافظ على *التواصل البصري* مع جمهورك.\n\n# CTA\nاضغط على هذه البطاقة لتعديل النص، أو أنشئ نصك بزر الإضافة. [pause] استمتع بالإبداع!\n';

  @override
  String get expand => 'توسيع';

  @override
  String get minimize => 'تصغير';

  @override
  String get nothingToSay =>
      'أضف أولًا ما ستقوله — الأقسام (#) والملاحظات (//) لا تُقرأ.';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get tryAgain => 'إعادة المحاولة';

  @override
  String get noMicBanner => 'لا يوجد وصول إلى الميكروفون — التسجيل بلا صوت';

  @override
  String get saveFailedTitle => 'تعذّر الحفظ في المعرض';

  @override
  String saveFailedBody(String reason) {
    return 'لقطتك آمنة حاليًا. أعد المحاولة، أو شاركها إلى الملفات أو Drive أو محادثة حتى لا تضيع. ($reason)';
  }

  @override
  String get shareVideo => 'مشاركة الفيديو';

  @override
  String get discardTake => 'تجاهل هذه اللقطة';

  @override
  String takeShared(int n) {
    return 'تمت مشاركة اللقطة $n';
  }

  @override
  String get movePrompter => 'اسحب لتحريك الملقّن';

  @override
  String get resizePrompter => 'اسحب لتغيير حجم الملقّن';

  @override
  String get prompterWidth => 'عرض الملقّن';

  @override
  String get resetPosition => 'إعادة ضبط الموضع (أعلى، بعرض كامل)';

  @override
  String get positionHint =>
      'اسحب الشريط أعلى الملقّن لنقله إلى أي مكان، واسحب الزاوية لتغيير حجمه. على أندرويد يمكن سحب النافذة العائمة إلى أي مكان وتتذكر موضعها.';

  @override
  String get app => 'التطبيق';

  @override
  String get appLanguage => 'لغة التطبيق';

  @override
  String get systemDefault => 'لغة الهاتف';

  @override
  String secondsShort(int n) {
    return '$n ث';
  }

  @override
  String minutesShort(int n) {
    return '$n د';
  }
}
