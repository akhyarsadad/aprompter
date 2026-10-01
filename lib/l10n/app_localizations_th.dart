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
}
