// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'סגירה';

  @override
  String get settings => 'הגדרות';

  @override
  String get prompterSettings => 'הגדרות פרומפטר';

  @override
  String get edit => 'עריכה';

  @override
  String get delete => 'מחיקה';

  @override
  String get undo => 'ביטול';

  @override
  String get duplicate => 'שכפול';

  @override
  String get share => 'שיתוף';

  @override
  String get copyAsCaption => 'העתקה ככיתוב';

  @override
  String get captionCopied => 'הטקסט המדובר הועתק — הדביקו אותו ככיתוב';

  @override
  String get copySuffix => '(עותק)';

  @override
  String deletedScript(String title) {
    return '\"$title\" נמחק';
  }

  @override
  String duplicatedScript(String title) {
    return 'שוכפל בשם \"$title\"';
  }

  @override
  String get untitled => 'ללא שם';

  @override
  String get newScript => 'תסריט חדש';

  @override
  String get searchScripts => 'חיפוש תסריטים';

  @override
  String get filterAll => 'הכול';

  @override
  String get statusDraft => 'טיוטה';

  @override
  String get statusReady => 'מוכן';

  @override
  String get statusRecorded => 'צולם';

  @override
  String markAs(String status) {
    return 'סימון כ$status';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'חזרה';

  @override
  String get float => 'צף';

  @override
  String get record => 'צילום';

  @override
  String words(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count מילים',
      one: 'מילה אחת',
    );
    return '$_temp0';
  }

  @override
  String takes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count טייקים',
      one: 'טייק אחד',
    );
    return '$_temp0';
  }

  @override
  String get noScriptsYet => 'עדיין אין תסריטים';

  @override
  String get noScriptsHint => 'הקישו על \"תסריט חדש\" ובחרו תבנית כדי להתחיל.';

  @override
  String get nothingHere => 'אין כאן כלום';

  @override
  String get nothingHereHint => 'נסו מסנן או חיפוש אחר.';

  @override
  String get startFromTemplate => 'התחלה מתבנית';

  @override
  String get overlayPermissionNeeded =>
      'אשרו \"הצגה מעל אפליקציות אחרות\" כדי להשתמש בפרומפטר הצף.';

  @override
  String get floatingStarted =>
      'הפרומפטר צף. פתחו את אפליקציית המצלמה והקישו על הטקסט כדי להתחיל.';

  @override
  String get floatingNotificationTitle => 'APrompter צף על המסך';

  @override
  String get openScriptInApp => 'פתחו תסריט ב-APrompter';

  @override
  String get script => 'תסריט';

  @override
  String get title => 'כותרת';

  @override
  String get status => 'סטטוס';

  @override
  String get noTarget => 'ללא יעד';

  @override
  String get editorHint =>
      'כתבו או הדביקו את מה שתרצו לומר…\n\nטיפ: התחילו שורה ב-# לקטע, וב-// להערה לעצמכם.';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $spoken ב-$wpm מ/ד';
  }

  @override
  String get onTarget => 'ביעד';

  @override
  String overTarget(int seconds, int words) {
    return 'חריגה של $seconds שנ׳ · קצרו ~$words מילים';
  }

  @override
  String underTarget(int seconds, int words) {
    return 'נותרו $seconds שנ׳ · עוד ~$words מילים';
  }

  @override
  String longSentences(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count משפטים ארוכים (25+ מילים) — חלקו אותם כדי שתוכלו לנשום',
      one: 'משפט ארוך אחד (25+ מילים) — חלקו אותו כדי שתוכלו לנשום',
    );
    return '$_temp0';
  }

  @override
  String get toolSection => 'קטע';

  @override
  String get toolEmphasis => 'הדגשה';

  @override
  String get toolPause => 'הפסקה';

  @override
  String get toolNote => 'הערה';

  @override
  String get toolPaste => 'הדבקה';

  @override
  String get restart => 'מההתחלה';

  @override
  String get sections => 'קטעים';

  @override
  String get slower => 'לאט יותר';

  @override
  String get faster => 'מהר יותר';

  @override
  String get play => 'הפעלה';

  @override
  String get pause => 'השהיה';

  @override
  String get wpmUnit => 'מ/ד';

  @override
  String get startOfScript => 'תחילת התסריט';

  @override
  String sectionN(int n) {
    return 'קטע $n';
  }

  @override
  String get noSectionsHint =>
      'אין עדיין קטעים. הוסיפו בעורך שורות שמתחילות ב-\"#\" (למשל \"# הוק\") כדי לקפוץ בין חלקים ולצלם מחדש רק אחד.';

  @override
  String get emptyScript => '(תסריט ריק)';

  @override
  String get preview => 'תצוגה מקדימה';

  @override
  String get setup => 'מערך צילום';

  @override
  String get pace => 'קצב';

  @override
  String get text => 'טקסט';

  @override
  String get layout => 'פריסה';

  @override
  String get recording => 'צילום';

  @override
  String get wordsPerMinute => 'מילים / דקה';

  @override
  String fitTo(String time) {
    return 'התאמה ל-$time';
  }

  @override
  String get paceCalm => 'רגוע';

  @override
  String get paceNatural => 'טבעי';

  @override
  String get paceEnergetic => 'אנרגטי';

  @override
  String get countdown => 'ספירה לאחור לפני ההתחלה';

  @override
  String get off => 'כבוי';

  @override
  String get size => 'גודל';

  @override
  String get lineSpacing => 'מרווח שורות';

  @override
  String get textColor => 'צבע טקסט';

  @override
  String get prompterHeight => 'גובה הפרומפטר';

  @override
  String get background => 'רקע';

  @override
  String get readingGuide => 'קו קריאה';

  @override
  String get mirrorText => 'היפוך טקסט';

  @override
  String get mirrorTextHint => 'לזכוכית טלפרומפטר / מפצל אור';

  @override
  String get videoQuality => 'איכות וידאו';

  @override
  String get autoStop => 'עצירת הצילום בסוף התסריט';

  @override
  String get autoStopHint => 'ממתין 2 שניות אחרי השורה האחרונה';

  @override
  String get presetHandheld => 'סלפי ביד';

  @override
  String get presetHandheldHint => 'טקסט בינוני ליד העדשה';

  @override
  String get presetTripod => 'חצובה / מרחוק';

  @override
  String get presetTripodHint => 'טקסט גדול שנקרא מ-1–2 מ׳';

  @override
  String get presetGlass => 'זכוכית טלפרומפטר';

  @override
  String get presetGlassHint => 'הפוך, מסך מלא, רקע אטום';

  @override
  String get niceRun => 'כל הכבוד!';

  @override
  String runSummary(String time, int words, int wpm) {
    return 'לקח לכם $time ל-$words מילים → $wpm מילים בדקה.';
  }

  @override
  String runOver(int seconds, String target) {
    return 'זה $seconds שנ׳ מעל היעד של $target — קצרו את התסריט או האיצו.';
  }

  @override
  String runUnder(int seconds) {
    return 'נשארו לכם $seconds שנ׳ עד היעד.';
  }

  @override
  String get runOnTarget => 'בדיוק באורך היעד. 🎯';

  @override
  String get keepCurrent => 'להשאיר';

  @override
  String useWpm(int wpm) {
    return 'להשתמש ב-$wpm מ/ד';
  }

  @override
  String get switchCamera => 'החלפת מצלמה';

  @override
  String get startRecording => 'התחלת צילום';

  @override
  String get stopRecording => 'עצירת צילום';

  @override
  String get noCamera => 'לא נמצאה מצלמה במכשיר הזה.';

  @override
  String get cameraDenied => 'הגישה למצלמה נדחתה. אפשרו אותה בהגדרות המערכת.';

  @override
  String cameraError(String message) {
    return 'שגיאת מצלמה: $message';
  }

  @override
  String takeSaved(int n) {
    return 'טייק $n נשמר בגלריה';
  }

  @override
  String get templateBlank => 'ריק';

  @override
  String get templateBlankHint => 'התחלה מדף ריק';

  @override
  String get templateHvc => 'הוק ← ערך ← CTA';

  @override
  String get templateHvcHint => 'המבנה הקלאסי של סרטון קצר';

  @override
  String get templateTutorial => 'מדריך';

  @override
  String get templateTutorialHint => 'ללמד משהו צעד אחר צעד';

  @override
  String get templateReview => 'ביקורת מוצר';

  @override
  String get templateReviewHint => 'UGC, פרסומות וביקורות כנות';

  @override
  String get templateStory => 'סיפור';

  @override
  String get templateStoryHint => 'סיפור אישי עם לקח';

  @override
  String get secHook => 'הוק';

  @override
  String get secValue => 'ערך';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'שלב $n';
  }

  @override
  String get secRecap => 'סיכום ו-CTA';

  @override
  String get secWhatItIs => 'מה זה';

  @override
  String get secLoved => 'מה אהבתי';

  @override
  String get secBetter => 'מה יכול להיות טוב יותר';

  @override
  String get secVerdict => 'השורה התחתונה ו-CTA';

  @override
  String get secSetup => 'רקע';

  @override
  String get secTurningPoint => 'נקודת מפנה';

  @override
  String get secLesson => 'הלקח';

  @override
  String get noteHook =>
      'תפסו תשומת לב ב-3 השניות הראשונות: טענה נועזת או שאלה';

  @override
  String get noteValue => 'תנו את הדבר האחד שהבטחתם';

  @override
  String get noteCta => 'אמרו מה לעשות עכשיו: לעקוב, להגיב, לינק בביו';

  @override
  String get noteTutorialHook => '\"ככה עושים … בפחות מדקה\"';

  @override
  String get noteRecap => 'סכמו במשפט אחד ובקשו לשמור את הסרטון';

  @override
  String get noteReviewHook => 'הראו את המוצר ואת הבעיה שהוא פותר';

  @override
  String get noteVerdict => 'למי זה מתאים — ציינו את הקוד או הלינק';

  @override
  String get noteStoryHook => 'התחילו באמצע האקשן';

  @override
  String get welcomeTitle => 'ברוכים הבאים ל-APrompter';

  @override
  String get welcomeBody =>
      '# הוק\nרוצים לצלם בלי לשכוח את הטקסט? [pause]\n// הסתכלו ישר לעדשה\n\n# איך זה עובד\nכתבו את התסריט, בחרו *אורך יעד*, והטיימר יגיד לכם אם זה נכנס.\nעשו חזרה כדי למצוא את הקצב שלכם במילים לדקה.\nאז הקישו על צילום. הטקסט נגלל ממש מתחת למצלמה, כך שאתם שומרים על *קשר עין* עם הקהל.\n\n# CTA\nהקישו על הכרטיס הזה כדי לערוך את התסריט, או צרו תסריט משלכם בכפתור הפלוס. [pause] תיהנו מהיצירה!\n';

  @override
  String get expand => 'הרחבה';

  @override
  String get minimize => 'מזעור';

  @override
  String get nothingToSay =>
      'הוסיפו קודם משהו לומר — קטעים (#) והערות (//) לא מוקראים.';

  @override
  String get openSettings => 'פתיחת ההגדרות';

  @override
  String get tryAgain => 'ניסיון נוסף';

  @override
  String get noMicBanner => 'אין גישה למיקרופון — מצלמים בלי קול';

  @override
  String get saveFailedTitle => 'לא ניתן היה לשמור בגלריה';

  @override
  String saveFailedBody(String reason) {
    return 'הטייק שלכם בטוח בינתיים. נסו שוב, או שתפו אותו ל-Files, ל-Drive או לצ׳אט כדי שלא ילך לאיבוד. ($reason)';
  }

  @override
  String get shareVideo => 'שיתוף הסרטון';

  @override
  String get discardTake => 'מחיקת הטייק';

  @override
  String takeShared(int n) {
    return 'טייק $n שותף';
  }

  @override
  String get movePrompter => 'גררו כדי להזיז את הפרומפטר';

  @override
  String get resizePrompter => 'גררו כדי לשנות את גודל הפרומפטר';

  @override
  String get prompterWidth => 'רוחב הפרומפטר';

  @override
  String get resetPosition => 'איפוס מיקום (למעלה, רוחב מלא)';

  @override
  String get positionHint =>
      'גררו את הפס שבראש הפרומפטר כדי להזיז אותו לכל מקום, ואת הפינה כדי לשנות גודל. באנדרואיד אפשר לגרור את החלון הצף לכל מקום, והוא זוכר את מיקומו.';

  @override
  String get app => 'אפליקציה';

  @override
  String get appLanguage => 'שפת האפליקציה';

  @override
  String get systemDefault => 'שפת הטלפון';

  @override
  String secondsShort(int n) {
    return '$n שנ׳';
  }

  @override
  String minutesShort(int n) {
    return '$n דק׳';
  }

  @override
  String get storageSaveFailed =>
      'השמירה נכשלה — ייתכן שאין מקום בטלפון. העבודה נשמרת כל עוד האפליקציה פתוחה.';

  @override
  String get versionHistory => 'היסטוריית גרסאות';

  @override
  String get noVersions =>
      'אין עדיין גרסאות קודמות. הן נשמרות אוטומטית בזמן הכתיבה.';

  @override
  String get restore => 'שחזור';

  @override
  String get versionRestored => 'גרסה קודמת שוחזרה';

  @override
  String get recentlyDeleted => 'נמחקו לאחרונה';

  @override
  String trashHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'תסריטים שנמחקו נשמרים כאן $days ימים.',
      two: 'תסריטים שנמחקו נשמרים כאן יומיים.',
      one: 'תסריטים שנמחקו נשמרים כאן יום אחד.',
    );
    return '$_temp0';
  }

  @override
  String get deleteForever => 'מחיקה לצמיתות';

  @override
  String deletedOn(String date) {
    return 'נמחק ב־$date';
  }

  @override
  String restoredScript(String title) {
    return '\"$title\" שוחזר';
  }

  @override
  String get backUpScripts => 'גיבוי כל התסריטים';

  @override
  String get restoreBackup => 'שחזור מגיבוי';

  @override
  String get backupShareTitle => 'גיבוי APrompter';

  @override
  String importedScripts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count תסריטים שוחזרו',
      one: 'תסריט אחד שוחזר',
      zero: 'כל מה שבגיבוי הזה כבר כאן',
    );
    return '$_temp0';
  }

  @override
  String get notABackup => 'הקובץ הזה אינו גיבוי של APrompter.';

  @override
  String fitImpossible(int wpm, String target, int words) {
    return 'גם ב־$wpm מ/ד זה לא ייכנס ב־$target — קצרו בערך $words מילים.';
  }

  @override
  String get cameraNotReady =>
      'המצלמה לא הייתה מוכנה, ולכן הצילום לא התחיל. נסו שוב.';

  @override
  String get previousSection => 'הקטע הקודם';

  @override
  String get nextSection => 'הקטע הבא';

  @override
  String get floatingNotificationBody => 'הקישו כדי לפתוח את APrompter';

  @override
  String get customTarget => 'מותאם אישית…';

  @override
  String get customTargetTitle => 'אורך יעד';

  @override
  String get customTargetHint => 'דקות ושניות, למשל 5:00';

  @override
  String get saved => 'נשמר';

  @override
  String get floatNotOnIos =>
      'ב־iPhone אפליקציות לא יכולות לצוף מעל אפליקציות אחרות. השתמשו ב\"צילום\" כדי לצלם עם התסריט מתחת למצלמה.';

  @override
  String get hashtagHint =>
      'שורות האשטגים (#fyp #ad) מוצגות מעומעמות ולא נכללות בתזמון. לקטע השתמשו ב־\"# \" עם רווח.';

  @override
  String get appLock => 'נעילת האפליקציה';

  @override
  String get appLockHint =>
      'דרישת טביעת אצבע, פנים או קוד PIN של הטלפון לפתיחת APrompter';

  @override
  String get appLockUnavailable => 'קודם צריך להגדיר נעילת מסך בטלפון הזה.';

  @override
  String get unlock => 'ביטול נעילה';

  @override
  String get unlockReason => 'בטלו את נעילת APrompter כדי לראות את התסריטים';

  @override
  String get autoStopWait => 'המתנה אחרי השורה האחרונה';

  @override
  String get beforeYouRecord => 'לפני הצילום';

  @override
  String get recordAnyway => 'לצלם בכל זאת';

  @override
  String lowStorageWarning(int minutes) {
    return 'בשטח הפנוי נכנסים רק כ-$minutes דק׳ וידאו. פנו מקום או הורידו את איכות הווידאו.';
  }

  @override
  String lowBatteryWarning(int level) {
    return 'הסוללה ב-$level% — טייק ארוך עלול להיקטע. חברו למטען אם אפשר.';
  }

  @override
  String get brightScreen => 'בהירות מלאה בזמן הפרומפטר';

  @override
  String get brightScreenHint => 'קל יותר לקרוא בחוץ';

  @override
  String get cameraBusy => 'אפליקציה אחרת משתמשת במצלמה. סגרו אותה ונסו שוב.';

  @override
  String get cameraIntroTitle => 'מצלמה ומיקרופון';

  @override
  String get cameraIntroBody =>
      'כדי לצלם אתכם עם התסריט על המסך, APrompter צריכה גישה למצלמה ולמיקרופון. הטלפון יבקש אישור מיד. הסרטונים נשארים בטלפון שלכם.';

  @override
  String get continueLabel => 'המשך';

  @override
  String get notNow => 'לא עכשיו';

  @override
  String get colorWhite => 'לבן';

  @override
  String get colorYellow => 'צהוב';

  @override
  String get colorGreen => 'ירוק';

  @override
  String get colorBlue => 'כחול';

  @override
  String get colorPink => 'ורוד';

  @override
  String get colorBlack => 'שחור';

  @override
  String get damagedData => 'נתונים שלא ניתן לקרוא';

  @override
  String damagedDataHint(String date, int size) {
    return 'נשמרו בצד ב-$date · $size תווים';
  }

  @override
  String get tryToRecover => 'ניסיון שחזור';

  @override
  String get nothingRecovered => 'לא ניתן היה לקרוא מהם אף תסריט.';

  @override
  String get floatLowRam =>
      'הטלפון הזה לא יכול להציג אפליקציות מעל אפליקציות אחרות (זיכרון נמוך או Android Go). השתמשו בצילום במקום.';

  @override
  String get oemTipsTitle => 'שמירה על הפרומפטר הצף פעיל';

  @override
  String oemTipsBody(String brand) {
    return 'טלפונים של $brand עלולים לסגור חלונות צפים כדי לחסוך בסוללה. בהגדרות → אפליקציות → APrompter: אשרו הצגה מעל אפליקציות אחרות (וחלונות קופצים), הגדירו את הסוללה ל\"ללא הגבלה\" ואשרו התראות.';
  }

  @override
  String get focusLine => 'התמקדות בשורה הנוכחית';

  @override
  String get focusLineHint => 'מעמעם את שאר השורות';

  @override
  String get stepByLine => 'שורה אחרי שורה';

  @override
  String get stepByLineHint =>
      'כל הקשה או לחיצה בשלט מתקדמת שורה אחת — בלי גלילה אוטומטית';

  @override
  String get reduceEffects => 'הפחתת אפקטים';

  @override
  String get reduceEffectsHint =>
      'בלי מעברים או צללים: חלק יותר בטלפונים ישנים וחוסך סוללה';

  @override
  String get letterSpacing => 'ריווח אותיות';

  @override
  String get importTextFile => 'ייבוא קובץ טקסט';

  @override
  String get importTextFileHint =>
      'תסריט ‎.txt או ‎.md מהקבצים, מ-Drive או מהמייל';

  @override
  String get importTextFailed =>
      'לא ניתן לקרוא את הקובץ. בחרו קובץ טקסט פשוט (.txt).';

  @override
  String get mySetup => 'ההגדרה שלי';

  @override
  String get mySetupHint => 'ההגדרה ששמרתם';

  @override
  String get saveMySetup => 'שמירה כהגדרה שלי';

  @override
  String get resetAllSettings => 'איפוס כל ההגדרות';

  @override
  String get runHadJumps => 'היו קפיצות בתסריט במהלך ההרצה, לכן אין הצעת קצב.';

  @override
  String get keepTake => 'לשמור';

  @override
  String get retake => 'טייק חוזר';

  @override
  String get reviewTakes => 'צפייה בכל טייק';

  @override
  String get reviewTakesHint => 'צפו בו, ואז שמרו או צלמו שוב';

  @override
  String get takesToGallery => 'שמירת טייקים בגלריה';

  @override
  String get takesToGalleryHint =>
      'כבוי: הטייקים נשארים באפליקציה, מחוץ ל-Google Photos ול-iCloud';

  @override
  String get takesTitle => 'טייקים';

  @override
  String get takesEmpty =>
      'טייקים שנשמרו באפליקציה יופיעו כאן. כבו את \"שמירת טייקים בגלריה\" בהגדרות כדי לשמור אותם כאן.';

  @override
  String get saveToGallery => 'שמירה בגלריה';

  @override
  String get savedToGallery => 'נשמר בגלריה';

  @override
  String get deleteTake => 'מחיקת הטייק';

  @override
  String takeKeptInApp(int n) {
    return 'טייק $n נשמר באפליקציה';
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
