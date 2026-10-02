// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'ปิด';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get prompterSettings => 'การตั้งค่าพรอมป์เตอร์';

  @override
  String get edit => 'แก้ไข';

  @override
  String get delete => 'ลบ';

  @override
  String get undo => 'เลิกทำ';

  @override
  String get duplicate => 'ทำซ้ำ';

  @override
  String get share => 'แชร์';

  @override
  String get copyAsCaption => 'คัดลอกเป็นแคปชัน';

  @override
  String get captionCopied => 'คัดลอกข้อความที่จะพูดแล้ว — วางเป็นแคปชันได้เลย';

  @override
  String get copySuffix => '(สำเนา)';

  @override
  String deletedScript(String title) {
    return 'ลบ \"$title\" แล้ว';
  }

  @override
  String duplicatedScript(String title) {
    return 'ทำซ้ำเป็น \"$title\" แล้ว';
  }

  @override
  String get untitled => 'ไม่มีชื่อ';

  @override
  String get newScript => 'สคริปต์ใหม่';

  @override
  String get searchScripts => 'ค้นหาสคริปต์';

  @override
  String get filterAll => 'ทั้งหมด';

  @override
  String get statusDraft => 'ฉบับร่าง';

  @override
  String get statusReady => 'พร้อม';

  @override
  String get statusRecorded => 'ถ่ายแล้ว';

  @override
  String markAs(String status) {
    return 'ทำเครื่องหมายเป็น$status';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'ซ้อม';

  @override
  String get float => 'ลอย';

  @override
  String get record => 'ถ่าย';

  @override
  String words(int count) {
    return '$count คำ';
  }

  @override
  String takes(int count) {
    return '$count เทค';
  }

  @override
  String get noScriptsYet => 'ยังไม่มีสคริปต์';

  @override
  String get noScriptsHint =>
      'แตะ \"สคริปต์ใหม่\" แล้วเลือกเทมเพลตเพื่อเริ่มต้น';

  @override
  String get nothingHere => 'ไม่มีรายการ';

  @override
  String get nothingHereHint => 'ลองใช้ตัวกรองหรือคำค้นหาอื่น';

  @override
  String get startFromTemplate => 'เริ่มจากเทมเพลต';

  @override
  String get overlayPermissionNeeded =>
      'อนุญาต \"แสดงทับแอปอื่น\" เพื่อใช้พรอมป์เตอร์แบบลอย';

  @override
  String get floatingStarted =>
      'พรอมป์เตอร์ลอยอยู่บนจอแล้ว เปิดแอปกล้องแล้วแตะข้อความเพื่อเริ่ม';

  @override
  String get floatingNotificationTitle => 'APrompter กำลังลอยอยู่บนจอ';

  @override
  String get openScriptInApp => 'เปิดสคริปต์ใน APrompter';

  @override
  String get script => 'สคริปต์';

  @override
  String get title => 'ชื่อ';

  @override
  String get status => 'สถานะ';

  @override
  String get noTarget => 'ไม่มีเป้าหมาย';

  @override
  String get editorHint =>
      'เขียนหรือวางสิ่งที่คุณอยากพูด…\n\nเคล็ดลับ: ขึ้นต้นบรรทัดด้วย # สำหรับส่วน และ // สำหรับโน้ตถึงตัวเอง';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $spoken ที่ $wpm คำ/นาที';
  }

  @override
  String get onTarget => 'ตรงเป้า';

  @override
  String overTarget(int seconds, int words) {
    return 'เกิน $seconds วิ · ตัดออก ~$words คำ';
  }

  @override
  String underTarget(int seconds, int words) {
    return 'เหลือ $seconds วิ · อีก ~$words คำ';
  }

  @override
  String longSentences(int count) {
    return '$count ประโยคยาว (25+ คำ) — แบ่งให้สั้นลงเพื่อให้หายใจทัน';
  }

  @override
  String get toolSection => 'ส่วน';

  @override
  String get toolEmphasis => 'เน้น';

  @override
  String get toolPause => 'เว้นจังหวะ';

  @override
  String get toolNote => 'โน้ต';

  @override
  String get toolPaste => 'วาง';

  @override
  String get restart => 'เริ่มใหม่';

  @override
  String get sections => 'ส่วนต่างๆ';

  @override
  String get slower => 'ช้าลง';

  @override
  String get faster => 'เร็วขึ้น';

  @override
  String get play => 'เล่น';

  @override
  String get pause => 'หยุดชั่วคราว';

  @override
  String get wpmUnit => 'คำ/นาที';

  @override
  String get startOfScript => 'ต้นสคริปต์';

  @override
  String sectionN(int n) {
    return 'ส่วนที่ $n';
  }

  @override
  String get noSectionsHint =>
      'ยังไม่มีส่วน เพิ่มบรรทัดที่ขึ้นต้นด้วย \"#\" ในตัวแก้ไข (เช่น \"# ฮุก\") เพื่อข้ามไปมาระหว่างส่วนและถ่ายใหม่เฉพาะส่วนเดียว';

  @override
  String get emptyScript => '(สคริปต์ว่าง)';

  @override
  String get preview => 'ตัวอย่าง';

  @override
  String get setup => 'การจัดวาง';

  @override
  String get pace => 'จังหวะ';

  @override
  String get text => 'ข้อความ';

  @override
  String get layout => 'เลย์เอาต์';

  @override
  String get recording => 'การถ่าย';

  @override
  String get wordsPerMinute => 'คำ / นาที';

  @override
  String fitTo(String time) {
    return 'ปรับให้พอดี $time';
  }

  @override
  String get paceCalm => 'สบายๆ';

  @override
  String get paceNatural => 'เป็นธรรมชาติ';

  @override
  String get paceEnergetic => 'กระฉับกระเฉง';

  @override
  String get countdown => 'นับถอยหลังก่อนเริ่ม';

  @override
  String get off => 'ปิด';

  @override
  String get size => 'ขนาด';

  @override
  String get lineSpacing => 'ระยะห่างบรรทัด';

  @override
  String get textColor => 'สีข้อความ';

  @override
  String get prompterHeight => 'ความสูงพรอมป์เตอร์';

  @override
  String get background => 'พื้นหลัง';

  @override
  String get readingGuide => 'เส้นนำสายตา';

  @override
  String get mirrorText => 'กลับด้านข้อความ';

  @override
  String get mirrorTextHint => 'สำหรับกระจกเทเลพรอมป์เตอร์ / บีมสปลิตเตอร์';

  @override
  String get videoQuality => 'คุณภาพวิดีโอ';

  @override
  String get autoStop => 'หยุดถ่ายเมื่อสคริปต์จบ';

  @override
  String get autoStopHint => 'รอ 2 วินาทีหลังบรรทัดสุดท้าย';

  @override
  String get presetHandheld => 'เซลฟีถือมือ';

  @override
  String get presetHandheldHint => 'ข้อความขนาดกลางใกล้เลนส์';

  @override
  String get presetTripod => 'ขาตั้ง / ระยะไกล';

  @override
  String get presetTripodHint => 'ข้อความใหญ่ อ่านได้จาก 1–2 ม.';

  @override
  String get presetGlass => 'กระจกเทเลพรอมป์เตอร์';

  @override
  String get presetGlassHint => 'กลับด้าน เต็มจอ พื้นหลังทึบ';

  @override
  String get niceRun => 'เยี่ยมมาก!';

  @override
  String runSummary(String time, int words, int wpm) {
    return 'คุณใช้เวลา $time สำหรับ $words คำ → $wpm คำต่อนาที';
  }

  @override
  String runOver(int seconds, String target) {
    return 'เกินเป้าหมาย $target ไป $seconds วิ — ตัดสคริปต์หรือพูดเร็วขึ้น';
  }

  @override
  String runUnder(int seconds) {
    return 'ยังเหลืออีก $seconds วิ ก่อนถึงเป้าหมาย';
  }

  @override
  String get runOnTarget => 'ตรงความยาวเป้าหมายพอดี 🎯';

  @override
  String get keepCurrent => 'ใช้แบบเดิม';

  @override
  String useWpm(int wpm) {
    return 'ใช้ $wpm คำ/นาที';
  }

  @override
  String get switchCamera => 'สลับกล้อง';

  @override
  String get startRecording => 'เริ่มถ่าย';

  @override
  String get stopRecording => 'หยุดถ่าย';

  @override
  String get noCamera => 'ไม่พบกล้องในอุปกรณ์นี้';

  @override
  String get cameraDenied => 'ไม่ได้รับสิทธิ์ใช้กล้อง เปิดได้ในการตั้งค่าระบบ';

  @override
  String cameraError(String message) {
    return 'กล้องขัดข้อง: $message';
  }

  @override
  String takeSaved(int n) {
    return 'บันทึกเทค $n ลงคลังภาพแล้ว';
  }

  @override
  String get templateBlank => 'ว่างเปล่า';

  @override
  String get templateBlankHint => 'เริ่มจากหน้าว่าง';

  @override
  String get templateHvc => 'ฮุก → คุณค่า → CTA';

  @override
  String get templateHvcHint => 'โครงสร้างคลาสสิกของวิดีโอสั้น';

  @override
  String get templateTutorial => 'สอนทำ';

  @override
  String get templateTutorialHint => 'สอนอะไรสักอย่างทีละขั้น';

  @override
  String get templateReview => 'รีวิวสินค้า';

  @override
  String get templateReviewHint => 'UGC โฆษณา และรีวิวแบบจริงใจ';

  @override
  String get templateStory => 'เล่าเรื่อง';

  @override
  String get templateStoryHint => 'เรื่องส่วนตัวพร้อมบทเรียน';

  @override
  String get secHook => 'ฮุก';

  @override
  String get secValue => 'คุณค่า';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'ขั้นที่ $n';
  }

  @override
  String get secRecap => 'สรุปและ CTA';

  @override
  String get secWhatItIs => 'มันคืออะไร';

  @override
  String get secLoved => 'สิ่งที่ชอบ';

  @override
  String get secBetter => 'สิ่งที่ควรปรับปรุง';

  @override
  String get secVerdict => 'สรุปผลและ CTA';

  @override
  String get secSetup => 'ปูเรื่อง';

  @override
  String get secTurningPoint => 'จุดเปลี่ยน';

  @override
  String get secLesson => 'บทเรียน';

  @override
  String get noteHook => 'ดึงความสนใจใน 3 วินาทีแรก: คำกล่าวที่กล้าหรือคำถาม';

  @override
  String get noteValue => 'มอบสิ่งเดียวที่คุณสัญญาไว้';

  @override
  String get noteCta => 'บอกว่าต้องทำอะไรต่อ: ติดตาม คอมเมนต์ ลิงก์ในไบโอ';

  @override
  String get noteTutorialHook => '\"วิธี … ในเวลาไม่ถึงนาที\"';

  @override
  String get noteRecap => 'สรุปในประโยคเดียว แล้วชวนให้กดบันทึกวิดีโอ';

  @override
  String get noteReviewHook => 'โชว์สินค้าและปัญหาที่มันแก้ได้';

  @override
  String get noteVerdict => 'เหมาะกับใคร — บอกโค้ดหรือลิงก์';

  @override
  String get noteStoryHook => 'เริ่มจากกลางเหตุการณ์';

  @override
  String get welcomeTitle => 'ยินดีต้อนรับสู่ APrompter';

  @override
  String get welcomeBody =>
      '# ฮุก\nอยากถ่ายวิดีโอโดยไม่ลืมบทใช่ไหม [pause]\n// มองตรงเข้าเลนส์\n\n# ใช้งานอย่างไร\nเขียนสคริปต์ เลือก *ความยาวเป้าหมาย* แล้วตัวจับเวลาจะบอกว่าพอดีหรือไม่\nซ้อมเพื่อหาจังหวะพูดของคุณเป็นคำต่อนาที\nจากนั้นกดถ่าย ข้อความจะเลื่อนอยู่ใต้กล้องพอดี คุณจึง *สบตา* ผู้ชมได้ตลอด\n\n# CTA\nแตะการ์ดนี้เพื่อแก้ไขสคริปต์ หรือสร้างของคุณเองด้วยปุ่มบวก [pause] สนุกกับการสร้างสรรค์นะ!\n';

  @override
  String get expand => 'ขยาย';

  @override
  String get minimize => 'ย่อ';

  @override
  String get nothingToSay =>
      'เพิ่มประโยคที่จะพูดก่อน — ส่วน (#) และโน้ต (//) จะไม่ถูกอ่าน';

  @override
  String get openSettings => 'เปิดการตั้งค่า';

  @override
  String get tryAgain => 'ลองอีกครั้ง';

  @override
  String get noMicBanner => 'ไม่มีสิทธิ์ใช้ไมโครโฟน — กำลังถ่ายแบบไม่มีเสียง';

  @override
  String get saveFailedTitle => 'บันทึกลงคลังภาพไม่สำเร็จ';

  @override
  String saveFailedBody(String reason) {
    return 'เทคของคุณยังปลอดภัยอยู่ ลองอีกครั้ง หรือแชร์ไปที่ Files, Drive หรือแชทเพื่อไม่ให้หาย ($reason)';
  }

  @override
  String get shareVideo => 'แชร์วิดีโอ';

  @override
  String get discardTake => 'ทิ้งเทคนี้';

  @override
  String takeShared(int n) {
    return 'แชร์เทค $n แล้ว';
  }

  @override
  String get movePrompter => 'ลากเพื่อย้ายพรอมป์เตอร์';

  @override
  String get resizePrompter => 'ลากเพื่อปรับขนาดพรอมป์เตอร์';

  @override
  String get prompterWidth => 'ความกว้างพรอมป์เตอร์';

  @override
  String get resetPosition => 'รีเซ็ตตำแหน่ง (ด้านบน เต็มความกว้าง)';

  @override
  String get positionHint =>
      'ลากแถบด้านบนของพรอมป์เตอร์เพื่อย้ายไปที่ไหนก็ได้ และลากมุมเพื่อปรับขนาด บน Android หน้าต่างลอยลากไปได้ทุกที่และจำตำแหน่งไว้';

  @override
  String get app => 'แอป';

  @override
  String get appLanguage => 'ภาษาของแอป';

  @override
  String get systemDefault => 'ภาษาของโทรศัพท์';

  @override
  String secondsShort(int n) {
    return '$n วิ';
  }

  @override
  String minutesShort(int n) {
    return '$n นาที';
  }

  @override
  String get storageSaveFailed =>
      'บันทึกไม่ได้ — พื้นที่ในโทรศัพท์อาจเต็ม งานของคุณยังอยู่ตราบที่แอปยังเปิดอยู่';

  @override
  String get versionHistory => 'ประวัติเวอร์ชัน';

  @override
  String get noVersions =>
      'ยังไม่มีเวอร์ชันก่อนหน้า ระบบจะเก็บไว้อัตโนมัติขณะที่คุณเขียน';

  @override
  String get restore => 'กู้คืน';

  @override
  String get versionRestored => 'กู้คืนเวอร์ชันก่อนหน้าแล้ว';

  @override
  String get recentlyDeleted => 'ที่ลบล่าสุด';

  @override
  String trashHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'สคริปต์ที่ลบจะอยู่ที่นี่ $days วัน',
      one: 'สคริปต์ที่ลบจะอยู่ที่นี่ 1 วัน',
    );
    return '$_temp0';
  }

  @override
  String get deleteForever => 'ลบถาวร';

  @override
  String deletedOn(String date) {
    return 'ลบเมื่อ $date';
  }

  @override
  String restoredScript(String title) {
    return 'กู้คืน \"$title\" แล้ว';
  }

  @override
  String get backUpScripts => 'สำรองสคริปต์ทั้งหมด';

  @override
  String get restoreBackup => 'กู้คืนจากข้อมูลสำรอง';

  @override
  String get backupShareTitle => 'ข้อมูลสำรอง APrompter';

  @override
  String importedScripts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'กู้คืน $count สคริปต์แล้ว',
      one: 'กู้คืน 1 สคริปต์แล้ว',
      zero: 'ทุกอย่างในข้อมูลสำรองนี้มีอยู่แล้ว',
    );
    return '$_temp0';
  }

  @override
  String get notABackup => 'ไฟล์นี้ไม่ใช่ข้อมูลสำรองของ APrompter';

  @override
  String fitImpossible(int wpm, String target, int words) {
    return 'แม้ที่ $wpm คำ/นาที ก็ยังไม่พอดี $target — ตัดออกราว $words คำ';
  }

  @override
  String get cameraNotReady =>
      'กล้องยังไม่พร้อม จึงไม่ได้เริ่มถ่าย ลองอีกครั้ง';

  @override
  String get previousSection => 'ส่วนก่อนหน้า';

  @override
  String get nextSection => 'ส่วนถัดไป';

  @override
  String get floatingNotificationBody => 'แตะเพื่อเปิด APrompter';

  @override
  String get customTarget => 'กำหนดเอง…';

  @override
  String get customTargetTitle => 'ความยาวเป้าหมาย';

  @override
  String get customTargetHint => 'นาทีและวินาที เช่น 5:00';

  @override
  String get saved => 'บันทึกแล้ว';

  @override
  String get floatNotOnIos =>
      'iPhone ไม่อนุญาตให้แอปลอยเหนือแอปอื่น ใช้ \"ถ่าย\" เพื่อถ่ายโดยมีสคริปต์อยู่ใต้กล้อง';

  @override
  String get hashtagHint =>
      'บรรทัดแฮชแท็ก (#fyp #ad) จะแสดงจางและไม่นับเวลา ใช้ \"# \" ตามด้วยเว้นวรรคเพื่อสร้างส่วน';

  @override
  String get appLock => 'ล็อกแอป';

  @override
  String get appLockHint =>
      'ขอลายนิ้วมือ ใบหน้า หรือ PIN ของโทรศัพท์ก่อนเปิด APrompter';

  @override
  String get appLockUnavailable => 'ตั้งค่าล็อกหน้าจอในโทรศัพท์เครื่องนี้ก่อน';

  @override
  String get unlock => 'ปลดล็อก';

  @override
  String get unlockReason => 'ปลดล็อก APrompter เพื่อดูสคริปต์ของคุณ';

  @override
  String get autoStopWait => 'รอหลังบรรทัดสุดท้าย';

  @override
  String get beforeYouRecord => 'ก่อนเริ่มถ่าย';

  @override
  String get recordAnyway => 'ถ่ายต่อเลย';

  @override
  String lowStorageWarning(int minutes) {
    return 'พื้นที่ว่างพอสำหรับวิดีโอประมาณ $minutes นาทีเท่านั้น ลองล้างพื้นที่หรือลดคุณภาพวิดีโอ';
  }

  @override
  String lowBatteryWarning(int level) {
    return 'แบตเตอรี่เหลือ $level% — เทคยาวอาจถูกตัด เสียบชาร์จถ้าทำได้';
  }

  @override
  String get brightScreen => 'ความสว่างเต็มที่ขณะใช้พรอมป์เตอร์';

  @override
  String get brightScreenHint => 'อ่านง่ายขึ้นเมื่ออยู่กลางแจ้ง';

  @override
  String get cameraBusy => 'แอปอื่นกำลังใช้กล้องอยู่ ปิดแอปนั้นแล้วลองอีกครั้ง';

  @override
  String get cameraIntroTitle => 'กล้องและไมโครโฟน';

  @override
  String get cameraIntroBody =>
      'APrompter ต้องใช้กล้องและไมโครโฟนเพื่อถ่ายคุณพร้อมสคริปต์บนจอ โทรศัพท์จะถามสิทธิ์ถัดไป วิดีโอจะอยู่ในโทรศัพท์ของคุณ';

  @override
  String get continueLabel => 'ต่อไป';

  @override
  String get notNow => 'ไว้ทีหลัง';

  @override
  String get colorWhite => 'ขาว';

  @override
  String get colorYellow => 'เหลือง';

  @override
  String get colorGreen => 'เขียว';

  @override
  String get colorBlue => 'น้ำเงิน';

  @override
  String get colorPink => 'ชมพู';

  @override
  String get colorBlack => 'ดำ';

  @override
  String get damagedData => 'ข้อมูลที่อ่านไม่ได้';

  @override
  String damagedDataHint(String date, int size) {
    return 'แยกเก็บไว้เมื่อ $date · $size ตัวอักษร';
  }

  @override
  String get tryToRecover => 'ลองกู้คืน';

  @override
  String get nothingRecovered => 'อ่านสคริปต์จากข้อมูลนี้ไม่ได้เลย';

  @override
  String get floatLowRam =>
      'โทรศัพท์นี้แสดงแอปทับแอปอื่นไม่ได้ (หน่วยความจำต่ำหรือ Android Go) ใช้ปุ่มถ่ายแทน';

  @override
  String get oemTipsTitle => 'ให้พรอมป์เตอร์แบบลอยทำงานต่อเนื่อง';

  @override
  String oemTipsBody(String brand) {
    return 'โทรศัพท์ $brand อาจปิดหน้าต่างลอยเพื่อประหยัดแบตเตอรี่ ไปที่ การตั้งค่า → แอป → APrompter: อนุญาตให้แสดงทับแอปอื่น (และหน้าต่างป๊อปอัป) ตั้งแบตเตอรี่เป็น \"ไม่จำกัด\" และอนุญาตการแจ้งเตือน';
  }

  @override
  String get focusLine => 'เน้นบรรทัดปัจจุบัน';

  @override
  String get focusLineHint => 'หรี่บรรทัดอื่น';

  @override
  String get stepByLine => 'ทีละบรรทัด';

  @override
  String get stepByLineHint =>
      'แตะหรือกดรีโมตแต่ละครั้งเลื่อนหนึ่งบรรทัด — ไม่เลื่อนอัตโนมัติ';

  @override
  String get reduceEffects => 'ลดเอฟเฟกต์';

  @override
  String get reduceEffectsHint =>
      'ไม่มีการเฟดหรือเงา: ลื่นขึ้นบนเครื่องรุ่นเก่า ประหยัดแบต';

  @override
  String get letterSpacing => 'ระยะห่างตัวอักษร';

  @override
  String get importTextFile => 'นำเข้าไฟล์ข้อความ';

  @override
  String get importTextFileHint =>
      'สคริปต์ .txt หรือ .md จากไฟล์ ไดรฟ์ หรืออีเมล';

  @override
  String get importTextFailed =>
      'อ่านไฟล์นั้นไม่ได้ เลือกไฟล์ข้อความธรรมดา (.txt)';

  @override
  String get mySetup => 'ค่าของฉัน';

  @override
  String get mySetupHint => 'ค่าที่คุณบันทึกไว้';

  @override
  String get saveMySetup => 'บันทึกเป็นค่าของฉัน';

  @override
  String get resetAllSettings => 'รีเซ็ตการตั้งค่าทั้งหมด';

  @override
  String get runHadJumps => 'รอบนี้มีการข้ามไปมา จึงแนะนำความเร็วไม่ได้';

  @override
  String get keepTake => 'เก็บไว้';

  @override
  String get retake => 'ถ่ายใหม่';

  @override
  String get reviewTakes => 'ตรวจดูทุกเทค';

  @override
  String get reviewTakesHint => 'ดูแล้วเลือกเก็บไว้หรือถ่ายใหม่';

  @override
  String get takesToGallery => 'บันทึกเทคลงคลังภาพ';

  @override
  String get takesToGalleryHint =>
      'ปิด: เทคจะอยู่ในแอป ไม่เข้า Google Photos และ iCloud';

  @override
  String get takesTitle => 'เทค';

  @override
  String get takesEmpty =>
      'เทคที่เก็บไว้ในแอปจะแสดงที่นี่ ปิด \"บันทึกเทคลงคลังภาพ\" ในการตั้งค่าเพื่อเก็บไว้ที่นี่';

  @override
  String get saveToGallery => 'บันทึกลงคลังภาพ';

  @override
  String get savedToGallery => 'บันทึกลงคลังภาพแล้ว';

  @override
  String get deleteTake => 'ลบเทค';

  @override
  String takeKeptInApp(int n) {
    return 'เก็บเทค $n ไว้ในแอปแล้ว';
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
