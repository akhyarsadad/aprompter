// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'Đóng';

  @override
  String get settings => 'Cài đặt';

  @override
  String get prompterSettings => 'Cài đặt máy nhắc chữ';

  @override
  String get edit => 'Sửa';

  @override
  String get delete => 'Xóa';

  @override
  String get undo => 'Hoàn tác';

  @override
  String get duplicate => 'Nhân bản';

  @override
  String get share => 'Chia sẻ';

  @override
  String get copyAsCaption => 'Sao chép làm chú thích';

  @override
  String get captionCopied =>
      'Đã sao chép lời nói — dán làm chú thích bài đăng';

  @override
  String get copySuffix => '(bản sao)';

  @override
  String deletedScript(String title) {
    return 'Đã xóa \"$title\"';
  }

  @override
  String duplicatedScript(String title) {
    return 'Đã nhân bản thành \"$title\"';
  }

  @override
  String get untitled => 'Không tiêu đề';

  @override
  String get newScript => 'Kịch bản mới';

  @override
  String get searchScripts => 'Tìm kịch bản';

  @override
  String get filterAll => 'Tất cả';

  @override
  String get statusDraft => 'Bản nháp';

  @override
  String get statusReady => 'Sẵn sàng';

  @override
  String get statusRecorded => 'Đã quay';

  @override
  String markAs(String status) {
    return 'Đánh dấu là $status';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'Tập dượt';

  @override
  String get float => 'Nổi';

  @override
  String get record => 'Quay';

  @override
  String words(int count) {
    return '$count từ';
  }

  @override
  String takes(int count) {
    return '$count lần quay';
  }

  @override
  String get noScriptsYet => 'Chưa có kịch bản nào';

  @override
  String get noScriptsHint =>
      'Nhấn \"Kịch bản mới\" và chọn một mẫu để bắt đầu.';

  @override
  String get nothingHere => 'Không có gì ở đây';

  @override
  String get nothingHereHint => 'Thử bộ lọc hoặc từ khóa khác.';

  @override
  String get startFromTemplate => 'Bắt đầu từ mẫu';

  @override
  String get overlayPermissionNeeded =>
      'Cho phép \"Hiển thị trên ứng dụng khác\" để dùng máy nhắc chữ nổi.';

  @override
  String get floatingStarted =>
      'Máy nhắc chữ đang nổi. Mở ứng dụng camera và nhấn vào chữ để bắt đầu.';

  @override
  String get floatingNotificationTitle => 'APrompter đang nổi trên màn hình';

  @override
  String get openScriptInApp => 'Mở một kịch bản trong APrompter';

  @override
  String get script => 'Kịch bản';

  @override
  String get title => 'Tiêu đề';

  @override
  String get status => 'Trạng thái';

  @override
  String get noTarget => 'Không mục tiêu';

  @override
  String get editorHint =>
      'Viết hoặc dán điều bạn muốn nói…\n\nMẹo: bắt đầu dòng bằng # cho một phần, // cho ghi chú riêng.';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $spoken ở $wpm từ/phút';
  }

  @override
  String get onTarget => 'Đúng mục tiêu';

  @override
  String overTarget(int seconds, int words) {
    return 'Dư $seconds giây · cắt ~$words từ';
  }

  @override
  String underTarget(int seconds, int words) {
    return 'Còn $seconds giây · thêm ~$words từ';
  }

  @override
  String longSentences(int count) {
    return '$count câu dài (25+ từ) — tách ra để kịp lấy hơi';
  }

  @override
  String get toolSection => 'Phần';

  @override
  String get toolEmphasis => 'Nhấn mạnh';

  @override
  String get toolPause => 'Ngắt nghỉ';

  @override
  String get toolNote => 'Ghi chú';

  @override
  String get toolPaste => 'Dán';

  @override
  String get restart => 'Từ đầu';

  @override
  String get sections => 'Các phần';

  @override
  String get slower => 'Chậm hơn';

  @override
  String get faster => 'Nhanh hơn';

  @override
  String get play => 'Phát';

  @override
  String get pause => 'Tạm dừng';

  @override
  String get wpmUnit => 'từ/phút';

  @override
  String get startOfScript => 'Đầu kịch bản';

  @override
  String sectionN(int n) {
    return 'Phần $n';
  }

  @override
  String get noSectionsHint =>
      'Chưa có phần nào. Thêm dòng bắt đầu bằng \"#\" trong trình soạn thảo (ví dụ \"# Mở đầu\") để nhảy giữa các phần và chỉ quay lại một phần.';

  @override
  String get emptyScript => '(kịch bản trống)';

  @override
  String get preview => 'Xem trước';

  @override
  String get setup => 'Bối cảnh';

  @override
  String get pace => 'Tốc độ';

  @override
  String get text => 'Chữ';

  @override
  String get layout => 'Bố cục';

  @override
  String get recording => 'Quay';

  @override
  String get wordsPerMinute => 'từ / phút';

  @override
  String fitTo(String time) {
    return 'Vừa $time';
  }

  @override
  String get paceCalm => 'Thong thả';

  @override
  String get paceNatural => 'Tự nhiên';

  @override
  String get paceEnergetic => 'Năng động';

  @override
  String get countdown => 'Đếm ngược trước khi bắt đầu';

  @override
  String get off => 'Tắt';

  @override
  String get size => 'Cỡ chữ';

  @override
  String get lineSpacing => 'Giãn dòng';

  @override
  String get textColor => 'Màu chữ';

  @override
  String get prompterHeight => 'Chiều cao máy nhắc';

  @override
  String get background => 'Nền';

  @override
  String get readingGuide => 'Đường dẫn đọc';

  @override
  String get mirrorText => 'Lật chữ';

  @override
  String get mirrorTextHint => 'Cho kính teleprompter / bộ chia tia';

  @override
  String get videoQuality => 'Chất lượng video';

  @override
  String get autoStop => 'Dừng quay khi hết kịch bản';

  @override
  String get autoStopHint => 'Chờ 2 giây sau dòng cuối';

  @override
  String get presetHandheld => 'Selfie cầm tay';

  @override
  String get presetHandheldHint => 'Chữ vừa, gần ống kính';

  @override
  String get presetTripod => 'Chân máy / quay xa';

  @override
  String get presetTripodHint => 'Chữ lớn đọc được từ 1–2 m';

  @override
  String get presetGlass => 'Kính teleprompter';

  @override
  String get presetGlassHint => 'Lật, toàn màn hình, nền đặc';

  @override
  String get niceRun => 'Tuyệt vời!';

  @override
  String runSummary(String time, int words, int wpm) {
    return 'Bạn mất $time cho $words từ → $wpm từ mỗi phút.';
  }

  @override
  String runOver(int seconds, String target) {
    return 'Vượt mục tiêu $target $seconds giây — rút gọn kịch bản hoặc nói nhanh hơn.';
  }

  @override
  String runUnder(int seconds) {
    return 'Bạn còn $seconds giây trước mục tiêu.';
  }

  @override
  String get runOnTarget => 'Đúng độ dài mục tiêu. 🎯';

  @override
  String get keepCurrent => 'Giữ nguyên';

  @override
  String useWpm(int wpm) {
    return 'Dùng $wpm từ/phút';
  }

  @override
  String get switchCamera => 'Đổi camera';

  @override
  String get startRecording => 'Bắt đầu quay';

  @override
  String get stopRecording => 'Dừng quay';

  @override
  String get noCamera => 'Không tìm thấy camera trên thiết bị này.';

  @override
  String get cameraDenied =>
      'Quyền camera bị từ chối. Hãy bật trong cài đặt hệ thống.';

  @override
  String cameraError(String message) {
    return 'Lỗi camera: $message';
  }

  @override
  String takeSaved(int n) {
    return 'Đã lưu lần quay $n vào thư viện';
  }

  @override
  String get templateBlank => 'Trống';

  @override
  String get templateBlankHint => 'Bắt đầu từ trang trống';

  @override
  String get templateHvc => 'Mở đầu → Giá trị → CTA';

  @override
  String get templateHvcHint => 'Cấu trúc kinh điển của video ngắn';

  @override
  String get templateTutorial => 'Hướng dẫn';

  @override
  String get templateTutorialHint => 'Dạy một điều gì đó từng bước';

  @override
  String get templateReview => 'Đánh giá sản phẩm';

  @override
  String get templateReviewHint => 'UGC, quảng cáo và review thật lòng';

  @override
  String get templateStory => 'Kể chuyện';

  @override
  String get templateStoryHint => 'Câu chuyện cá nhân kèm bài học';

  @override
  String get secHook => 'Mở đầu';

  @override
  String get secValue => 'Giá trị';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'Bước $n';
  }

  @override
  String get secRecap => 'Tóm tắt & CTA';

  @override
  String get secWhatItIs => 'Đây là gì';

  @override
  String get secLoved => 'Điều tôi thích';

  @override
  String get secBetter => 'Điều có thể tốt hơn';

  @override
  String get secVerdict => 'Kết luận & CTA';

  @override
  String get secSetup => 'Bối cảnh';

  @override
  String get secTurningPoint => 'Bước ngoặt';

  @override
  String get secLesson => 'Bài học';

  @override
  String get noteHook =>
      'Thu hút sự chú ý trong 3 giây đầu: một tuyên bố táo bạo hoặc câu hỏi';

  @override
  String get noteValue => 'Mang lại đúng một điều bạn đã hứa';

  @override
  String get noteCta =>
      'Nói người xem làm gì tiếp: theo dõi, bình luận, link ở bio';

  @override
  String get noteTutorialHook => '\"Đây là cách … trong chưa đầy một phút\"';

  @override
  String get noteRecap => 'Tóm gọn trong một câu, rồi nhờ họ lưu video';

  @override
  String get noteReviewHook => 'Cho thấy sản phẩm và vấn đề nó giải quyết';

  @override
  String get noteVerdict => 'Ai nên mua — nhắc mã giảm giá hoặc link';

  @override
  String get noteStoryHook => 'Bắt đầu ngay giữa diễn biến';

  @override
  String get welcomeTitle => 'Chào mừng đến với APrompter';

  @override
  String get welcomeBody =>
      '# Mở đầu\nMuốn quay video mà không quên lời? [pause]\n// nhìn thẳng vào ống kính\n\n# Cách hoạt động\nViết kịch bản, chọn *độ dài mục tiêu*, và đồng hồ sẽ cho biết có vừa không.\nTập dượt để tìm tốc độ nói của bạn theo số từ mỗi phút.\nRồi nhấn Quay. Chữ cuộn ngay dưới camera nên bạn luôn *giao tiếp bằng mắt* với khán giả.\n\n# CTA\nNhấn vào thẻ này để sửa kịch bản, hoặc tạo kịch bản của riêng bạn bằng nút cộng. [pause] Chúc bạn sáng tạo vui vẻ!\n';

  @override
  String get expand => 'Mở rộng';

  @override
  String get minimize => 'Thu nhỏ';

  @override
  String get nothingToSay =>
      'Hãy thêm điều cần nói trước — phần (#) và ghi chú (//) không được đọc.';

  @override
  String get openSettings => 'Mở cài đặt';

  @override
  String get tryAgain => 'Thử lại';

  @override
  String get noMicBanner => 'Không có quyền micro — đang quay không tiếng';

  @override
  String get saveFailedTitle => 'Không lưu được vào thư viện';

  @override
  String saveFailedBody(String reason) {
    return 'Lần quay của bạn tạm thời vẫn an toàn. Thử lại, hoặc chia sẻ sang Files, Drive hay một cuộc trò chuyện để không bị mất. ($reason)';
  }

  @override
  String get shareVideo => 'Chia sẻ video';

  @override
  String get discardTake => 'Bỏ lần quay này';

  @override
  String takeShared(int n) {
    return 'Đã chia sẻ lần quay $n';
  }

  @override
  String get movePrompter => 'Kéo để di chuyển máy nhắc chữ';

  @override
  String get resizePrompter => 'Kéo để đổi kích thước máy nhắc chữ';

  @override
  String get prompterWidth => 'Chiều rộng máy nhắc';

  @override
  String get resetPosition => 'Đặt lại vị trí (trên cùng, toàn chiều rộng)';

  @override
  String get positionHint =>
      'Kéo thanh trên cùng của máy nhắc chữ để đặt ở bất kỳ đâu, và kéo góc để đổi kích thước. Trên Android, cửa sổ nổi kéo được khắp nơi và nhớ vị trí của nó.';

  @override
  String get app => 'Ứng dụng';

  @override
  String get appLanguage => 'Ngôn ngữ ứng dụng';

  @override
  String get systemDefault => 'Ngôn ngữ của điện thoại';

  @override
  String secondsShort(int n) {
    return '$n giây';
  }

  @override
  String minutesShort(int n) {
    return '$n phút';
  }

  @override
  String get storageSaveFailed =>
      'Không lưu được — có thể điện thoại đã hết dung lượng. Nội dung vẫn được giữ khi ứng dụng còn mở.';

  @override
  String get versionHistory => 'Lịch sử phiên bản';

  @override
  String get noVersions =>
      'Chưa có phiên bản cũ. Chúng được tự động lưu khi bạn viết.';

  @override
  String get restore => 'Khôi phục';

  @override
  String get versionRestored => 'Đã khôi phục phiên bản cũ';

  @override
  String get recentlyDeleted => 'Đã xóa gần đây';

  @override
  String trashHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Kịch bản đã xóa được giữ ở đây $days ngày.',
      one: 'Kịch bản đã xóa được giữ ở đây 1 ngày.',
    );
    return '$_temp0';
  }

  @override
  String get deleteForever => 'Xóa vĩnh viễn';

  @override
  String deletedOn(String date) {
    return 'Đã xóa $date';
  }

  @override
  String restoredScript(String title) {
    return 'Đã khôi phục \"$title\"';
  }

  @override
  String get backUpScripts => 'Sao lưu tất cả kịch bản';

  @override
  String get restoreBackup => 'Khôi phục từ bản sao lưu';

  @override
  String get backupShareTitle => 'Bản sao lưu APrompter';

  @override
  String importedScripts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã khôi phục $count kịch bản',
      one: 'Đã khôi phục 1 kịch bản',
      zero: 'Mọi thứ trong bản sao lưu này đã có sẵn',
    );
    return '$_temp0';
  }

  @override
  String get notABackup => 'Tệp này không phải bản sao lưu APrompter.';

  @override
  String fitImpossible(int wpm, String target, int words) {
    return 'Dù ở $wpm từ/phút vẫn không vừa $target — hãy cắt khoảng $words từ.';
  }

  @override
  String get cameraNotReady =>
      'Camera chưa sẵn sàng nên chưa bắt đầu quay. Hãy thử lại.';

  @override
  String get previousSection => 'Phần trước';

  @override
  String get nextSection => 'Phần tiếp theo';

  @override
  String get floatingNotificationBody => 'Chạm để mở APrompter';

  @override
  String get customTarget => 'Tùy chỉnh…';

  @override
  String get customTargetTitle => 'Thời lượng mục tiêu';

  @override
  String get customTargetHint => 'Phút và giây, vd: 5:00';

  @override
  String get saved => 'Đã lưu';

  @override
  String get floatNotOnIos =>
      'iPhone không cho ứng dụng nổi trên ứng dụng khác. Dùng Quay để quay với kịch bản ngay dưới camera.';

  @override
  String get hashtagHint =>
      'Dòng hashtag (#fyp #ad) được làm mờ và không tính giờ. Dùng \"# \" có dấu cách để tạo phần.';

  @override
  String get appLock => 'Khóa ứng dụng';

  @override
  String get appLockHint =>
      'Yêu cầu vân tay, khuôn mặt hoặc mã PIN điện thoại để mở APrompter';

  @override
  String get appLockUnavailable =>
      'Hãy thiết lập khóa màn hình trên điện thoại này trước.';

  @override
  String get unlock => 'Mở khóa';

  @override
  String get unlockReason => 'Mở khóa APrompter để xem kịch bản của bạn';

  @override
  String get autoStopWait => 'Chờ sau dòng cuối';

  @override
  String get beforeYouRecord => 'Trước khi quay';

  @override
  String get recordAnyway => 'Vẫn quay';

  @override
  String lowStorageWarning(int minutes) {
    return 'Dung lượng trống chỉ đủ cho khoảng $minutes phút video. Hãy giải phóng dung lượng hoặc giảm chất lượng video.';
  }

  @override
  String lowBatteryWarning(int level) {
    return 'Pin còn $level% — lần quay dài có thể bị ngắt. Hãy cắm sạc nếu được.';
  }

  @override
  String get brightScreen => 'Độ sáng tối đa khi nhắc chữ';

  @override
  String get brightScreenHint => 'Dễ đọc hơn ngoài trời';

  @override
  String get cameraBusy =>
      'Ứng dụng khác đang dùng camera. Hãy đóng ứng dụng đó và thử lại.';

  @override
  String get cameraIntroTitle => 'Camera và micrô';

  @override
  String get cameraIntroBody =>
      'Để quay bạn khi kịch bản hiện trên màn hình, APrompter cần camera và micrô. Điện thoại sẽ hỏi bạn ngay sau đây. Video được giữ trên điện thoại của bạn.';

  @override
  String get continueLabel => 'Tiếp tục';

  @override
  String get notNow => 'Để sau';

  @override
  String get colorWhite => 'Trắng';

  @override
  String get colorYellow => 'Vàng';

  @override
  String get colorGreen => 'Xanh lá';

  @override
  String get colorBlue => 'Xanh dương';

  @override
  String get colorPink => 'Hồng';

  @override
  String get colorBlack => 'Đen';

  @override
  String get damagedData => 'Dữ liệu không đọc được';

  @override
  String damagedDataHint(String date, int size) {
    return 'Để riêng ngày $date · $size ký tự';
  }

  @override
  String get tryToRecover => 'Thử khôi phục';

  @override
  String get nothingRecovered => 'Không đọc được kịch bản nào từ dữ liệu này.';

  @override
  String get floatLowRam =>
      'Điện thoại này không thể hiển thị ứng dụng trên ứng dụng khác (ít bộ nhớ hoặc Android Go). Hãy dùng Quay.';

  @override
  String get oemTipsTitle => 'Giữ máy nhắc chữ nổi luôn chạy';

  @override
  String oemTipsBody(String brand) {
    return 'Điện thoại $brand có thể đóng cửa sổ nổi để tiết kiệm pin. Trong Cài đặt → Ứng dụng → APrompter: cho phép hiển thị trên ứng dụng khác (và cửa sổ bật lên), đặt pin thành \"Không hạn chế\" và cho phép thông báo.';
  }

  @override
  String get focusLine => 'Làm nổi dòng hiện tại';

  @override
  String get focusLineHint => 'Làm mờ các dòng khác';

  @override
  String get stepByLine => 'Từng dòng';

  @override
  String get stepByLineHint =>
      'Mỗi lần nhấn hoặc bấm điều khiển chuyển một dòng — không tự cuộn';

  @override
  String get reduceEffects => 'Giảm hiệu ứng';

  @override
  String get reduceEffectsHint =>
      'Không mờ dần hay đổ bóng: mượt hơn trên máy cũ, tiết kiệm pin';

  @override
  String get letterSpacing => 'Khoảng cách chữ';

  @override
  String get importTextFile => 'Nhập tệp văn bản';

  @override
  String get importTextFileHint =>
      'Kịch bản .txt hoặc .md từ Tệp, Drive hoặc email';

  @override
  String get importTextFailed =>
      'Không đọc được tệp này. Hãy chọn tệp văn bản thuần (.txt).';

  @override
  String get mySetup => 'Thiết lập của tôi';

  @override
  String get mySetupHint => 'Thiết lập bạn đã lưu';

  @override
  String get saveMySetup => 'Lưu làm thiết lập của tôi';

  @override
  String get resetAllSettings => 'Đặt lại mọi cài đặt';

  @override
  String get runHadJumps =>
      'Bạn đã nhảy qua lại trong lần chạy này nên không thể gợi ý tốc độ.';

  @override
  String get keepTake => 'Giữ';

  @override
  String get retake => 'Quay lại';

  @override
  String get reviewTakes => 'Xem lại từng lần quay';

  @override
  String get reviewTakesHint => 'Xem rồi giữ lại hoặc quay lần nữa';

  @override
  String get takesToGallery => 'Lưu lần quay vào thư viện';

  @override
  String get takesToGalleryHint =>
      'Tắt: lần quay nằm trong ứng dụng, không vào Google Photos và iCloud';

  @override
  String get takesTitle => 'Các lần quay';

  @override
  String get takesEmpty =>
      'Lần quay giữ trong ứng dụng sẽ hiện ở đây. Tắt \"Lưu lần quay vào thư viện\" trong cài đặt để giữ chúng ở đây.';

  @override
  String get saveToGallery => 'Lưu vào thư viện';

  @override
  String get savedToGallery => 'Đã lưu vào thư viện';

  @override
  String get deleteTake => 'Xóa lần quay';

  @override
  String takeKeptInApp(int n) {
    return 'Đã giữ lần quay $n trong ứng dụng';
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
