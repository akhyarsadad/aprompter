// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => '닫기';

  @override
  String get settings => '설정';

  @override
  String get prompterSettings => '프롬프터 설정';

  @override
  String get edit => '편집';

  @override
  String get delete => '삭제';

  @override
  String get undo => '실행취소';

  @override
  String get duplicate => '복제';

  @override
  String get share => '공유';

  @override
  String get copyAsCaption => '캡션으로 복사';

  @override
  String get captionCopied => '말할 텍스트를 복사했어요. 게시물 캡션에 붙여 넣으세요';

  @override
  String get copySuffix => '(사본)';

  @override
  String deletedScript(String title) {
    return '\'$title\' 삭제됨';
  }

  @override
  String duplicatedScript(String title) {
    return '\'$title\'(으)로 복제됨';
  }

  @override
  String get untitled => '제목 없음';

  @override
  String get newScript => '새 대본';

  @override
  String get searchScripts => '대본 검색';

  @override
  String get filterAll => '전체';

  @override
  String get statusDraft => '초안';

  @override
  String get statusReady => '촬영 준비';

  @override
  String get statusRecorded => '촬영 완료';

  @override
  String markAs(String status) {
    return '$status(으)로 표시';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => '리허설';

  @override
  String get float => '띄우기';

  @override
  String get record => '촬영';

  @override
  String words(int count) {
    return '$count단어';
  }

  @override
  String takes(int count) {
    return '$count테이크';
  }

  @override
  String get noScriptsYet => '아직 대본이 없어요';

  @override
  String get noScriptsHint => '\'새 대본\'을 탭하고 템플릿을 골라 시작하세요.';

  @override
  String get nothingHere => '항목이 없어요';

  @override
  String get nothingHereHint => '다른 필터나 검색어를 사용해 보세요.';

  @override
  String get startFromTemplate => '템플릿으로 시작';

  @override
  String get overlayPermissionNeeded => '떠 있는 프롬프터를 쓰려면 \'다른 앱 위에 표시\'를 허용하세요.';

  @override
  String get floatingStarted => '프롬프터가 화면에 떠 있어요. 카메라 앱을 열고 텍스트를 탭하면 시작돼요.';

  @override
  String get floatingNotificationTitle => 'APrompter가 화면에 떠 있음';

  @override
  String get openScriptInApp => 'APrompter에서 대본을 여세요';

  @override
  String get script => '대본';

  @override
  String get title => '제목';

  @override
  String get status => '상태';

  @override
  String get noTarget => '목표 없음';

  @override
  String get editorHint =>
      '하고 싶은 말을 쓰거나 붙여 넣으세요…\n\n팁: 줄을 #으로 시작하면 섹션, //로 시작하면 나만 보는 메모가 돼요.';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $wpm 단어/분 기준 $spoken';
  }

  @override
  String get onTarget => '목표에 딱 맞음';

  @override
  String overTarget(int seconds, int words) {
    return '$seconds초 초과 · 약 $words단어 줄이기';
  }

  @override
  String underTarget(int seconds, int words) {
    return '$seconds초 남음 · 약 $words단어 더';
  }

  @override
  String longSentences(int count) {
    return '긴 문장 $count개(25단어 이상) — 숨 쉴 수 있게 나눠 보세요';
  }

  @override
  String get toolSection => '섹션';

  @override
  String get toolEmphasis => '강조';

  @override
  String get toolPause => '쉼';

  @override
  String get toolNote => '메모';

  @override
  String get toolPaste => '붙여넣기';

  @override
  String get restart => '처음부터';

  @override
  String get sections => '섹션';

  @override
  String get slower => '느리게';

  @override
  String get faster => '빠르게';

  @override
  String get play => '재생';

  @override
  String get pause => '일시정지';

  @override
  String get wpmUnit => '단어/분';

  @override
  String get startOfScript => '대본 처음';

  @override
  String sectionN(int n) {
    return '섹션 $n';
  }

  @override
  String get noSectionsHint =>
      '아직 섹션이 없어요. 편집기에서 \'#\'으로 시작하는 줄(예: \'# 훅\')을 추가하면 부분을 오가며 한 부분만 다시 찍을 수 있어요.';

  @override
  String get emptyScript => '(빈 대본)';

  @override
  String get preview => '미리보기';

  @override
  String get setup => '촬영 방식';

  @override
  String get pace => '속도';

  @override
  String get text => '텍스트';

  @override
  String get layout => '레이아웃';

  @override
  String get recording => '촬영';

  @override
  String get wordsPerMinute => '단어 / 분';

  @override
  String fitTo(String time) {
    return '$time에 맞추기';
  }

  @override
  String get paceCalm => '차분하게';

  @override
  String get paceNatural => '자연스럽게';

  @override
  String get paceEnergetic => '활기차게';

  @override
  String get countdown => '시작 전 카운트다운';

  @override
  String get off => '끔';

  @override
  String get size => '크기';

  @override
  String get lineSpacing => '줄 간격';

  @override
  String get textColor => '글자 색';

  @override
  String get prompterHeight => '프롬프터 높이';

  @override
  String get background => '배경';

  @override
  String get readingGuide => '읽기 가이드선';

  @override
  String get mirrorText => '텍스트 좌우 반전';

  @override
  String get mirrorTextHint => '프롬프터 유리 / 빔 스플리터용';

  @override
  String get videoQuality => '동영상 화질';

  @override
  String get autoStop => '대본이 끝나면 촬영 중지';

  @override
  String get autoStopHint => '마지막 줄 후 2초 기다려요';

  @override
  String get presetHandheld => '손에 들고 셀카';

  @override
  String get presetHandheldHint => '렌즈 가까이 중간 크기 글자';

  @override
  String get presetTripod => '삼각대 / 원거리';

  @override
  String get presetTripodHint => '1–2m 거리에서 읽히는 큰 글자';

  @override
  String get presetGlass => '프롬프터 유리';

  @override
  String get presetGlassHint => '좌우 반전, 전체 화면, 불투명 배경';

  @override
  String get niceRun => '멋져요!';

  @override
  String runSummary(String time, int words, int wpm) {
    return '$words단어에 $time 걸렸어요 → 분당 $wpm단어.';
  }

  @override
  String runOver(int seconds, String target) {
    return '목표 $target보다 $seconds초 길어요. 대본을 줄이거나 조금 빠르게 말해 보세요.';
  }

  @override
  String runUnder(int seconds) {
    return '목표까지 $seconds초 여유가 있어요.';
  }

  @override
  String get runOnTarget => '목표 길이에 딱 맞아요. 🎯';

  @override
  String get keepCurrent => '그대로 두기';

  @override
  String useWpm(int wpm) {
    return '$wpm 단어/분 사용';
  }

  @override
  String get switchCamera => '카메라 전환';

  @override
  String get startRecording => '촬영 시작';

  @override
  String get stopRecording => '촬영 중지';

  @override
  String get noCamera => '이 기기에서 카메라를 찾을 수 없어요.';

  @override
  String get cameraDenied => '카메라 접근이 거부되었어요. 시스템 설정에서 허용해 주세요.';

  @override
  String cameraError(String message) {
    return '카메라 오류: $message';
  }

  @override
  String takeSaved(int n) {
    return '테이크 $n을(를) 갤러리에 저장했어요';
  }

  @override
  String get templateBlank => '빈 페이지';

  @override
  String get templateBlankHint => '빈 페이지에서 시작';

  @override
  String get templateHvc => '훅 → 핵심 → CTA';

  @override
  String get templateHvcHint => '숏폼의 기본 구조';

  @override
  String get templateTutorial => '튜토리얼';

  @override
  String get templateTutorialHint => '단계별로 알려주기';

  @override
  String get templateReview => '제품 리뷰';

  @override
  String get templateReviewHint => 'UGC, 광고, 솔직한 리뷰';

  @override
  String get templateStory => '스토리타임';

  @override
  String get templateStoryHint => '교훈이 있는 개인 이야기';

  @override
  String get secHook => '훅';

  @override
  String get secValue => '핵심';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return '$n단계';
  }

  @override
  String get secRecap => '요약 & CTA';

  @override
  String get secWhatItIs => '이게 뭐냐면';

  @override
  String get secLoved => '좋았던 점';

  @override
  String get secBetter => '아쉬운 점';

  @override
  String get secVerdict => '총평 & CTA';

  @override
  String get secSetup => '배경';

  @override
  String get secTurningPoint => '전환점';

  @override
  String get secLesson => '교훈';

  @override
  String get noteHook => '처음 3초 안에 시선 끌기: 과감한 주장이나 질문';

  @override
  String get noteValue => '약속한 한 가지를 확실히 전달하기';

  @override
  String get noteCta => '다음 행동 알려주기: 팔로우, 댓글, 프로필 링크';

  @override
  String get noteTutorialHook => '\"1분 안에 … 하는 법\"';

  @override
  String get noteRecap => '한 문장으로 정리하고 저장해 달라고 하기';

  @override
  String get noteReviewHook => '제품과 그것이 해결하는 문제 보여주기';

  @override
  String get noteVerdict => '누구에게 추천하는지 — 할인 코드나 링크 언급';

  @override
  String get noteStoryHook => '사건 한가운데서 시작하기';

  @override
  String get welcomeTitle => 'APrompter에 오신 걸 환영해요';

  @override
  String get welcomeBody =>
      '# 훅\n대사를 잊지 않고 촬영하고 싶나요? [pause]\n// 렌즈를 똑바로 보기\n\n# 사용 방법\n대본을 쓰고 *목표 길이*를 고르면 타이머가 맞는지 알려줘요.\n리허설로 분당 단어 수로 내 속도를 찾아보세요.\n그다음 촬영을 누르세요. 글자가 카메라 바로 아래로 흘러서 시청자와 *눈을 맞춘* 채 말할 수 있어요.\n\n# CTA\n이 카드를 탭해 대본을 편집하거나 플러스 버튼으로 나만의 대본을 만들어 보세요. [pause] 즐겁게 만들어요!\n';

  @override
  String get expand => '펼치기';

  @override
  String get minimize => '최소화';

  @override
  String get nothingToSay => '먼저 말할 내용을 추가하세요. 섹션(#)과 메모(//)는 읽지 않아요.';

  @override
  String get openSettings => '설정 열기';

  @override
  String get tryAgain => '다시 시도';

  @override
  String get noMicBanner => '마이크 권한 없음 — 소리 없이 촬영 중';

  @override
  String get saveFailedTitle => '갤러리에 저장하지 못했어요';

  @override
  String saveFailedBody(String reason) {
    return '테이크는 아직 안전해요. 다시 시도하거나, 잃어버리지 않도록 파일, 드라이브 또는 채팅으로 공유하세요. ($reason)';
  }

  @override
  String get shareVideo => '동영상 공유';

  @override
  String get discardTake => '이 테이크 버리기';

  @override
  String takeShared(int n) {
    return '테이크 $n을(를) 공유했어요';
  }

  @override
  String get movePrompter => '끌어서 프롬프터 이동';

  @override
  String get resizePrompter => '끌어서 프롬프터 크기 조절';

  @override
  String get prompterWidth => '프롬프터 너비';

  @override
  String get resetPosition => '위치 초기화(맨 위, 전체 너비)';

  @override
  String get positionHint =>
      '프롬프터 위쪽 막대를 끌면 원하는 곳으로 옮기고, 모서리를 끌면 크기를 바꿀 수 있어요. Android에서는 떠 있는 창을 어디로든 옮길 수 있고 위치도 기억해요.';

  @override
  String get app => '앱';

  @override
  String get appLanguage => '앱 언어';

  @override
  String get systemDefault => '휴대전화 언어';

  @override
  String secondsShort(int n) {
    return '$n초';
  }

  @override
  String minutesShort(int n) {
    return '$n분';
  }

  @override
  String get storageSaveFailed =>
      '저장하지 못했어요. 휴대폰 저장 공간이 부족할 수 있어요. 앱이 열려 있는 동안 작업 내용은 유지돼요.';

  @override
  String get versionHistory => '버전 기록';

  @override
  String get noVersions => '아직 이전 버전이 없어요. 작성하는 동안 자동으로 저장돼요.';

  @override
  String get restore => '복원';

  @override
  String get versionRestored => '이전 버전을 복원했어요';

  @override
  String get recentlyDeleted => '최근 삭제됨';

  @override
  String trashHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '삭제한 대본은 $days일 동안 여기에 보관돼요.',
      one: '삭제한 대본은 1일 동안 여기에 보관돼요.',
    );
    return '$_temp0';
  }

  @override
  String get deleteForever => '영구 삭제';

  @override
  String deletedOn(String date) {
    return '$date 삭제됨';
  }

  @override
  String restoredScript(String title) {
    return '\'$title\' 복원됨';
  }

  @override
  String get backUpScripts => '모든 대본 백업';

  @override
  String get restoreBackup => '백업에서 복원';

  @override
  String get backupShareTitle => 'APrompter 백업';

  @override
  String importedScripts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '대본 $count개 복원됨',
      one: '대본 1개 복원됨',
      zero: '이 백업의 내용은 이미 모두 있어요',
    );
    return '$_temp0';
  }

  @override
  String get notABackup => 'APrompter 백업 파일이 아니에요.';

  @override
  String fitImpossible(int wpm, String target, int words) {
    return '$wpm 단어/분으로도 $target에 맞출 수 없어요. 약 $words단어를 줄이세요.';
  }

  @override
  String get cameraNotReady => '카메라가 준비되지 않아 촬영이 시작되지 않았어요. 다시 시도해 주세요.';

  @override
  String get previousSection => '이전 섹션';

  @override
  String get nextSection => '다음 섹션';

  @override
  String get floatingNotificationBody => '탭하여 APrompter 열기';

  @override
  String get customTarget => '직접 설정…';

  @override
  String get customTargetTitle => '목표 길이';

  @override
  String get customTargetHint => '분과 초, 예: 5:00';

  @override
  String get saved => '저장됨';

  @override
  String get floatNotOnIos =>
      'iPhone에서는 앱을 다른 앱 위에 띄울 수 없어요. \'촬영\'을 사용하면 카메라 아래에 대본을 두고 찍을 수 있어요.';

  @override
  String get hashtagHint =>
      '해시태그 줄(#fyp #ad)은 흐리게 표시되고 시간에 포함되지 않아요. 섹션은 \'# \'처럼 공백을 넣어 쓰세요.';

  @override
  String get appLock => '앱 잠금';

  @override
  String get appLockHint => 'APrompter를 열 때 지문, 얼굴 또는 휴대폰 PIN을 요구해요';

  @override
  String get appLockUnavailable => '먼저 이 휴대폰에 화면 잠금을 설정하세요.';

  @override
  String get unlock => '잠금 해제';

  @override
  String get unlockReason => '대본을 보려면 APrompter 잠금을 해제하세요';

  @override
  String get autoStopWait => '마지막 줄 후 대기 시간';

  @override
  String get beforeYouRecord => '촬영 전에';

  @override
  String get recordAnyway => '그래도 촬영';

  @override
  String lowStorageWarning(int minutes) {
    return '남은 공간에 약 $minutes분 분량의 동영상만 들어가요. 공간을 비우거나 화질을 낮추세요.';
  }

  @override
  String lowBatteryWarning(int level) {
    return '배터리 $level% — 긴 테이크는 중간에 끊길 수 있어요. 가능하면 충전기를 연결하세요.';
  }

  @override
  String get brightScreen => '프롬프터 중 최대 밝기';

  @override
  String get brightScreenHint => '야외에서 더 잘 보여요';

  @override
  String get cameraBusy => '다른 앱이 카메라를 사용 중이에요. 그 앱을 닫고 다시 시도하세요.';

  @override
  String get cameraIntroTitle => '카메라 및 마이크';

  @override
  String get cameraIntroBody =>
      '화면에 대본을 띄운 채 촬영하려면 APrompter에 카메라와 마이크가 필요해요. 곧 휴대폰에서 권한을 물어봐요. 동영상은 휴대폰에만 저장돼요.';

  @override
  String get continueLabel => '계속';

  @override
  String get notNow => '나중에';

  @override
  String get colorWhite => '흰색';

  @override
  String get colorYellow => '노란색';

  @override
  String get colorGreen => '초록색';

  @override
  String get colorBlue => '파란색';

  @override
  String get colorPink => '분홍색';

  @override
  String get colorBlack => '검은색';

  @override
  String get damagedData => '읽을 수 없는 데이터';

  @override
  String damagedDataHint(String date, int size) {
    return '$date에 따로 보관함 · $size자';
  }

  @override
  String get tryToRecover => '복구 시도';

  @override
  String get nothingRecovered => '대본을 하나도 읽지 못했어요.';

  @override
  String get floatLowRam =>
      '이 휴대폰은 다른 앱 위에 앱을 표시할 수 없어요(저메모리 또는 Android Go 기기). 대신 촬영을 사용하세요.';

  @override
  String get oemTipsTitle => '떠 있는 프롬프터 유지하기';

  @override
  String oemTipsBody(String brand) {
    return '$brand 휴대폰은 배터리를 아끼려고 떠 있는 창을 닫을 수 있어요. 설정 → 애플리케이션 → APrompter에서 다른 앱 위에 표시(및 팝업 창)를 허용하고, 배터리를 \'제한 없음\'으로 설정하고, 알림을 허용하세요.';
  }

  @override
  String get focusLine => '현재 줄에 집중';

  @override
  String get focusLineHint => '다른 줄을 어둡게 해요';

  @override
  String get stepByLine => '한 줄씩';

  @override
  String get stepByLineHint => '탭하거나 리모컨을 누를 때마다 한 줄씩 이동 — 자동 스크롤 없음';

  @override
  String get reduceEffects => '효과 줄이기';

  @override
  String get reduceEffectsHint => '페이드와 그림자 없음: 오래된 휴대폰에서 더 부드럽고 배터리 절약';

  @override
  String get letterSpacing => '자간';

  @override
  String get importTextFile => '텍스트 파일 가져오기';

  @override
  String get importTextFileHint => '파일, 드라이브, 이메일의 .txt 또는 .md 대본';

  @override
  String get importTextFailed => '파일을 읽지 못했어요. 일반 텍스트(.txt) 파일을 선택하세요.';

  @override
  String get mySetup => '내 설정';

  @override
  String get mySetupHint => '저장한 설정';

  @override
  String get saveMySetup => '내 설정으로 저장';

  @override
  String get resetAllSettings => '모든 설정 초기화';

  @override
  String get runHadJumps => '이번 진행 중에 건너뛴 부분이 있어 속도를 제안할 수 없어요.';

  @override
  String get keepTake => '남기기';

  @override
  String get retake => '다시 찍기';

  @override
  String get reviewTakes => '테이크마다 확인';

  @override
  String get reviewTakesHint => '보고 나서 남기거나 다시 찍어요';

  @override
  String get takesToGallery => '테이크를 갤러리에 저장';

  @override
  String get takesToGalleryHint =>
      '끄면: 테이크가 앱 안에만 남고 Google Photos와 iCloud에 올라가지 않아요';

  @override
  String get takesTitle => '테이크';

  @override
  String get takesEmpty =>
      '앱 안에 남긴 테이크가 여기에 표시돼요. 여기에 남기려면 설정에서 \'테이크를 갤러리에 저장\'을 끄세요.';

  @override
  String get saveToGallery => '갤러리에 저장';

  @override
  String get savedToGallery => '갤러리에 저장했어요';

  @override
  String get deleteTake => '테이크 삭제';

  @override
  String takeKeptInApp(int n) {
    return '테이크 $n을(를) 앱에 남겼어요';
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
