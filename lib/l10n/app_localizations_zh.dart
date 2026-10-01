// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => '关闭';

  @override
  String get settings => '设置';

  @override
  String get prompterSettings => '提词器设置';

  @override
  String get edit => '编辑';

  @override
  String get delete => '删除';

  @override
  String get undo => '撤销';

  @override
  String get duplicate => '复制';

  @override
  String get share => '分享';

  @override
  String get copyAsCaption => '复制为文案';

  @override
  String get captionCopied => '已复制口播文字，可直接粘贴为发布文案';

  @override
  String get copySuffix => '(副本)';

  @override
  String deletedScript(String title) {
    return '已删除“$title”';
  }

  @override
  String duplicatedScript(String title) {
    return '已复制为“$title”';
  }

  @override
  String get untitled => '未命名';

  @override
  String get newScript => '新建脚本';

  @override
  String get searchScripts => '搜索脚本';

  @override
  String get filterAll => '全部';

  @override
  String get statusDraft => '草稿';

  @override
  String get statusReady => '待拍摄';

  @override
  String get statusRecorded => '已拍摄';

  @override
  String markAs(String status) {
    return '标记为$status';
  }

  @override
  String filterCount(String label, int count) {
    return '$label（$count）';
  }

  @override
  String get rehearse => '排练';

  @override
  String get float => '悬浮';

  @override
  String get record => '拍摄';

  @override
  String words(int count) {
    return '$count 词';
  }

  @override
  String takes(int count) {
    return '$count 条';
  }

  @override
  String get noScriptsYet => '还没有脚本';

  @override
  String get noScriptsHint => '点按“新建脚本”并选择一个模板即可开始。';

  @override
  String get nothingHere => '这里什么都没有';

  @override
  String get nothingHereHint => '试试其他筛选条件或关键词。';

  @override
  String get startFromTemplate => '从模板开始';

  @override
  String get overlayPermissionNeeded => '请允许“在其他应用上层显示”，才能使用悬浮提词器。';

  @override
  String get floatingStarted => '提词器已悬浮。打开相机应用，点按文字即可开始。';

  @override
  String get floatingNotificationTitle => 'APrompter 正在悬浮显示';

  @override
  String get openScriptInApp => '在 APrompter 中打开一个脚本';

  @override
  String get script => '脚本';

  @override
  String get title => '标题';

  @override
  String get status => '状态';

  @override
  String get noTarget => '无目标';

  @override
  String get editorHint => '写下或粘贴你想说的话…\n\n提示：以 # 开头表示一个段落，以 // 开头表示给自己的备注。';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $wpm 词/分时 $spoken';
  }

  @override
  String get onTarget => '时长刚好';

  @override
  String overTarget(int seconds, int words) {
    return '超出 $seconds 秒 · 删减约 $words 词';
  }

  @override
  String underTarget(int seconds, int words) {
    return '还剩 $seconds 秒 · 可再加约 $words 词';
  }

  @override
  String longSentences(int count) {
    return '$count 个长句（25+ 词）— 拆开说，方便换气';
  }

  @override
  String get toolSection => '段落';

  @override
  String get toolEmphasis => '强调';

  @override
  String get toolPause => '停顿';

  @override
  String get toolNote => '备注';

  @override
  String get toolPaste => '粘贴';

  @override
  String get restart => '从头开始';

  @override
  String get sections => '段落';

  @override
  String get slower => '放慢';

  @override
  String get faster => '加快';

  @override
  String get play => '播放';

  @override
  String get pause => '暂停';

  @override
  String get wpmUnit => '词/分';

  @override
  String get startOfScript => '脚本开头';

  @override
  String sectionN(int n) {
    return '段落 $n';
  }

  @override
  String get noSectionsHint =>
      '还没有段落。在编辑器中添加以“#”开头的行（如“# 开头钩子”），就能在各部分之间跳转，只重拍其中一段。';

  @override
  String get emptyScript => '（空脚本）';

  @override
  String get preview => '预览';

  @override
  String get setup => '拍摄场景';

  @override
  String get pace => '语速';

  @override
  String get text => '文字';

  @override
  String get layout => '布局';

  @override
  String get recording => '拍摄';

  @override
  String get wordsPerMinute => '词 / 分钟';

  @override
  String fitTo(String time) {
    return '适配 $time';
  }

  @override
  String get paceCalm => '平缓';

  @override
  String get paceNatural => '自然';

  @override
  String get paceEnergetic => '活力';

  @override
  String get countdown => '开始前倒计时';

  @override
  String get off => '关';

  @override
  String get size => '字号';

  @override
  String get lineSpacing => '行距';

  @override
  String get textColor => '文字颜色';

  @override
  String get prompterHeight => '提词器高度';

  @override
  String get background => '背景';

  @override
  String get readingGuide => '阅读引导线';

  @override
  String get mirrorText => '镜像文字';

  @override
  String get mirrorTextHint => '用于提词器玻璃 / 分光镜';

  @override
  String get videoQuality => '视频画质';

  @override
  String get autoStop => '脚本结束时停止拍摄';

  @override
  String get autoStopHint => '最后一行后等待 2 秒';

  @override
  String get presetHandheld => '手持自拍';

  @override
  String get presetHandheldHint => '中号文字，靠近镜头';

  @override
  String get presetTripod => '三脚架 / 远距离';

  @override
  String get presetTripodHint => '大号文字，1–2 米外可读';

  @override
  String get presetGlass => '提词器玻璃';

  @override
  String get presetGlassHint => '镜像、全屏、纯色背景';

  @override
  String get niceRun => '太棒了！';

  @override
  String runSummary(String time, int words, int wpm) {
    return '你用 $time 读完 $words 词 → 每分钟 $wpm 词。';
  }

  @override
  String runOver(int seconds, String target) {
    return '比 $target 的目标多了 $seconds 秒 — 精简脚本或加快语速。';
  }

  @override
  String runUnder(int seconds) {
    return '距离目标还有 $seconds 秒。';
  }

  @override
  String get runOnTarget => '正好卡在目标时长。🎯';

  @override
  String get keepCurrent => '保持不变';

  @override
  String useWpm(int wpm) {
    return '使用 $wpm 词/分';
  }

  @override
  String get switchCamera => '切换摄像头';

  @override
  String get startRecording => '开始拍摄';

  @override
  String get stopRecording => '停止拍摄';

  @override
  String get noCamera => '此设备上未找到摄像头。';

  @override
  String get cameraDenied => '相机权限被拒绝。请在系统设置中开启。';

  @override
  String cameraError(String message) {
    return '相机出错：$message';
  }

  @override
  String takeSaved(int n) {
    return '第 $n 条已保存到相册';
  }

  @override
  String get templateBlank => '空白';

  @override
  String get templateBlankHint => '从空白页开始';

  @override
  String get templateHvc => '钩子 → 干货 → 行动号召';

  @override
  String get templateHvcHint => '经典短视频结构';

  @override
  String get templateTutorial => '教程';

  @override
  String get templateTutorialHint => '一步一步教会别人';

  @override
  String get templateReview => '产品测评';

  @override
  String get templateReviewHint => 'UGC、广告口播和真实测评';

  @override
  String get templateStory => '讲故事';

  @override
  String get templateStoryHint => '带启发的个人故事';

  @override
  String get secHook => '开头钩子';

  @override
  String get secValue => '干货';

  @override
  String get secCta => '行动号召';

  @override
  String secStep(int n) {
    return '第 $n 步';
  }

  @override
  String get secRecap => '总结与行动号召';

  @override
  String get secWhatItIs => '它是什么';

  @override
  String get secLoved => '我喜欢的地方';

  @override
  String get secBetter => '可以更好的地方';

  @override
  String get secVerdict => '结论与行动号召';

  @override
  String get secSetup => '铺垫';

  @override
  String get secTurningPoint => '转折';

  @override
  String get secLesson => '启发';

  @override
  String get noteHook => '前 3 秒抓住注意力：一个大胆的观点或问题';

  @override
  String get noteValue => '兑现你承诺的那一点';

  @override
  String get noteCta => '告诉观众下一步：关注、评论、主页链接';

  @override
  String get noteTutorialHook => '“一分钟教你……”';

  @override
  String get noteRecap => '一句话总结，然后提醒大家收藏视频';

  @override
  String get noteReviewHook => '展示产品和它解决的问题';

  @override
  String get noteVerdict => '适合谁买 — 提一下优惠码或链接';

  @override
  String get noteStoryHook => '从最精彩的地方讲起';

  @override
  String get welcomeTitle => '欢迎使用 APrompter';

  @override
  String get welcomeBody =>
      '# 开头钩子\n想拍视频又怕忘词？[pause]\n// 直视镜头\n\n# 使用方法\n写好脚本，选择*目标时长*，计时器会告诉你是否合适。\n先排练，找到你每分钟的语速。\n然后点按拍摄。文字就在摄像头下方滚动，让你和观众保持*眼神交流*。\n\n# 行动号召\n点按这张卡片编辑脚本，或用加号按钮新建你自己的脚本。[pause] 祝你创作愉快！\n';

  @override
  String get expand => '展开';

  @override
  String get minimize => '收起';

  @override
  String get nothingToSay => '请先添加要说的内容 — 段落（#）和备注（//）不会被念出。';

  @override
  String get openSettings => '打开设置';

  @override
  String get tryAgain => '重试';

  @override
  String get noMicBanner => '没有麦克风权限 — 正在无声拍摄';

  @override
  String get saveFailedTitle => '无法保存到相册';

  @override
  String saveFailedBody(String reason) {
    return '这条视频暂时是安全的。请重试，或分享到文件、云盘或聊天中，以免丢失。（$reason）';
  }

  @override
  String get shareVideo => '分享视频';

  @override
  String get discardTake => '丢弃这一条';

  @override
  String takeShared(int n) {
    return '第 $n 条已分享';
  }

  @override
  String get movePrompter => '拖动以移动提词器';

  @override
  String get resizePrompter => '拖动以调整提词器大小';

  @override
  String get prompterWidth => '提词器宽度';

  @override
  String get resetPosition => '重置位置（顶部、全宽）';

  @override
  String get positionHint =>
      '拖动提词器顶部的横条可移到任意位置，拖动角落可调整大小。在 Android 上，悬浮窗可拖到任意位置并会记住位置。';

  @override
  String get app => '应用';

  @override
  String get appLanguage => '应用语言';

  @override
  String get systemDefault => '手机语言';

  @override
  String secondsShort(int n) {
    return '$n 秒';
  }

  @override
  String minutesShort(int n) {
    return '$n 分钟';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => '關閉';

  @override
  String get settings => '設定';

  @override
  String get prompterSettings => '提詞機設定';

  @override
  String get edit => '編輯';

  @override
  String get delete => '刪除';

  @override
  String get undo => '復原';

  @override
  String get duplicate => '複製';

  @override
  String get share => '分享';

  @override
  String get copyAsCaption => '複製為貼文文字';

  @override
  String get captionCopied => '已複製口播文字，可直接貼上為貼文文字';

  @override
  String get copySuffix => '(副本)';

  @override
  String deletedScript(String title) {
    return '已刪除「$title」';
  }

  @override
  String duplicatedScript(String title) {
    return '已複製為「$title」';
  }

  @override
  String get untitled => '未命名';

  @override
  String get newScript => '新增腳本';

  @override
  String get searchScripts => '搜尋腳本';

  @override
  String get filterAll => '全部';

  @override
  String get statusDraft => '草稿';

  @override
  String get statusReady => '待拍攝';

  @override
  String get statusRecorded => '已拍攝';

  @override
  String markAs(String status) {
    return '標示為$status';
  }

  @override
  String filterCount(String label, int count) {
    return '$label（$count）';
  }

  @override
  String get rehearse => '排練';

  @override
  String get float => '懸浮';

  @override
  String get record => '拍攝';

  @override
  String words(int count) {
    return '$count 詞';
  }

  @override
  String takes(int count) {
    return '$count 條';
  }

  @override
  String get noScriptsYet => '還沒有腳本';

  @override
  String get noScriptsHint => '點一下「新增腳本」並選擇範本即可開始。';

  @override
  String get nothingHere => '這裡什麼都沒有';

  @override
  String get nothingHereHint => '試試其他篩選條件或關鍵字。';

  @override
  String get startFromTemplate => '從範本開始';

  @override
  String get overlayPermissionNeeded => '請允許「顯示在其他應用程式上層」，才能使用懸浮提詞機。';

  @override
  String get floatingStarted => '提詞機已懸浮。打開相機 App，點一下文字即可開始。';

  @override
  String get floatingNotificationTitle => 'APrompter 正在懸浮顯示';

  @override
  String get openScriptInApp => '在 APrompter 中開啟一個腳本';

  @override
  String get script => '腳本';

  @override
  String get title => '標題';

  @override
  String get status => '狀態';

  @override
  String get noTarget => '無目標';

  @override
  String get editorHint => '寫下或貼上你想說的話…\n\n提示：以 # 開頭表示一個段落，以 // 開頭表示給自己的備註。';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $wpm 詞/分時 $spoken';
  }

  @override
  String get onTarget => '時長剛好';

  @override
  String overTarget(int seconds, int words) {
    return '超出 $seconds 秒 · 刪減約 $words 詞';
  }

  @override
  String underTarget(int seconds, int words) {
    return '還剩 $seconds 秒 · 可再加約 $words 詞';
  }

  @override
  String longSentences(int count) {
    return '$count 個長句（25+ 詞）— 拆開說，方便換氣';
  }

  @override
  String get toolSection => '段落';

  @override
  String get toolEmphasis => '強調';

  @override
  String get toolPause => '停頓';

  @override
  String get toolNote => '備註';

  @override
  String get toolPaste => '貼上';

  @override
  String get restart => '從頭開始';

  @override
  String get sections => '段落';

  @override
  String get slower => '放慢';

  @override
  String get faster => '加快';

  @override
  String get play => '播放';

  @override
  String get pause => '暫停';

  @override
  String get wpmUnit => '詞/分';

  @override
  String get startOfScript => '腳本開頭';

  @override
  String sectionN(int n) {
    return '段落 $n';
  }

  @override
  String get noSectionsHint =>
      '還沒有段落。在編輯器中加入以「#」開頭的行（例如「# 開場鉤子」），就能在各部分之間跳轉，只重拍其中一段。';

  @override
  String get emptyScript => '（空白腳本）';

  @override
  String get preview => '預覽';

  @override
  String get setup => '拍攝情境';

  @override
  String get pace => '語速';

  @override
  String get text => '文字';

  @override
  String get layout => '版面';

  @override
  String get recording => '拍攝';

  @override
  String get wordsPerMinute => '詞 / 分鐘';

  @override
  String fitTo(String time) {
    return '配合 $time';
  }

  @override
  String get paceCalm => '平穩';

  @override
  String get paceNatural => '自然';

  @override
  String get paceEnergetic => '活力';

  @override
  String get countdown => '開始前倒數';

  @override
  String get off => '關';

  @override
  String get size => '字級';

  @override
  String get lineSpacing => '行距';

  @override
  String get textColor => '文字顏色';

  @override
  String get prompterHeight => '提詞機高度';

  @override
  String get background => '背景';

  @override
  String get readingGuide => '閱讀導引線';

  @override
  String get mirrorText => '鏡像文字';

  @override
  String get mirrorTextHint => '用於提詞機玻璃 / 分光鏡';

  @override
  String get videoQuality => '影片畫質';

  @override
  String get autoStop => '腳本結束時停止拍攝';

  @override
  String get autoStopHint => '最後一行後等待 2 秒';

  @override
  String get presetHandheld => '手持自拍';

  @override
  String get presetHandheldHint => '中等字級，靠近鏡頭';

  @override
  String get presetTripod => '三腳架 / 遠距離';

  @override
  String get presetTripodHint => '大字級，1–2 公尺外可讀';

  @override
  String get presetGlass => '提詞機玻璃';

  @override
  String get presetGlassHint => '鏡像、全螢幕、純色背景';

  @override
  String get niceRun => '太棒了！';

  @override
  String runSummary(String time, int words, int wpm) {
    return '你用 $time 讀完 $words 詞 → 每分鐘 $wpm 詞。';
  }

  @override
  String runOver(int seconds, String target) {
    return '比 $target 的目標多了 $seconds 秒 — 精簡腳本或加快語速。';
  }

  @override
  String runUnder(int seconds) {
    return '距離目標還有 $seconds 秒。';
  }

  @override
  String get runOnTarget => '剛好卡在目標時長。🎯';

  @override
  String get keepCurrent => '維持不變';

  @override
  String useWpm(int wpm) {
    return '使用 $wpm 詞/分';
  }

  @override
  String get switchCamera => '切換鏡頭';

  @override
  String get startRecording => '開始拍攝';

  @override
  String get stopRecording => '停止拍攝';

  @override
  String get noCamera => '這部裝置上找不到相機。';

  @override
  String get cameraDenied => '相機權限遭拒。請在系統設定中開啟。';

  @override
  String cameraError(String message) {
    return '相機發生錯誤：$message';
  }

  @override
  String takeSaved(int n) {
    return '第 $n 條已儲存到相簿';
  }

  @override
  String get templateBlank => '空白';

  @override
  String get templateBlankHint => '從空白頁開始';

  @override
  String get templateHvc => '鉤子 → 乾貨 → 行動呼籲';

  @override
  String get templateHvcHint => '經典短影音結構';

  @override
  String get templateTutorial => '教學';

  @override
  String get templateTutorialHint => '一步一步教會別人';

  @override
  String get templateReview => '產品開箱評測';

  @override
  String get templateReviewHint => 'UGC、業配口播與真實評價';

  @override
  String get templateStory => '說故事';

  @override
  String get templateStoryHint => '帶有啟發的個人故事';

  @override
  String get secHook => '開場鉤子';

  @override
  String get secValue => '乾貨';

  @override
  String get secCta => '行動呼籲';

  @override
  String secStep(int n) {
    return '第 $n 步';
  }

  @override
  String get secRecap => '總結與行動呼籲';

  @override
  String get secWhatItIs => '它是什麼';

  @override
  String get secLoved => '我喜歡的地方';

  @override
  String get secBetter => '可以更好的地方';

  @override
  String get secVerdict => '結論與行動呼籲';

  @override
  String get secSetup => '鋪陳';

  @override
  String get secTurningPoint => '轉折';

  @override
  String get secLesson => '啟發';

  @override
  String get noteHook => '前 3 秒抓住注意力：一個大膽的觀點或問題';

  @override
  String get noteValue => '兌現你承諾的那一點';

  @override
  String get noteCta => '告訴觀眾下一步：追蹤、留言、個人簡介連結';

  @override
  String get noteTutorialHook => '「一分鐘教你……」';

  @override
  String get noteRecap => '一句話總結，然後提醒大家收藏影片';

  @override
  String get noteReviewHook => '展示產品和它解決的問題';

  @override
  String get noteVerdict => '適合誰買 — 提一下折扣碼或連結';

  @override
  String get noteStoryHook => '從最精彩的地方說起';

  @override
  String get welcomeTitle => '歡迎使用 APrompter';

  @override
  String get welcomeBody =>
      '# 開場鉤子\n想拍影片又怕忘詞？[pause]\n// 直視鏡頭\n\n# 使用方式\n寫好腳本，選擇*目標時長*，計時器會告訴你是否剛好。\n先排練，找出你每分鐘的語速。\n然後點一下拍攝。文字就在鏡頭下方捲動，讓你和觀眾保持*眼神交流*。\n\n# 行動呼籲\n點一下這張卡片編輯腳本，或用加號按鈕新增你自己的腳本。[pause] 祝你創作愉快！\n';

  @override
  String get expand => '展開';

  @override
  String get minimize => '收合';

  @override
  String get nothingToSay => '請先加入要說的內容 — 段落（#）和備註（//）不會被念出。';

  @override
  String get openSettings => '開啟設定';

  @override
  String get tryAgain => '再試一次';

  @override
  String get noMicBanner => '沒有麥克風權限 — 正在無聲拍攝';

  @override
  String get saveFailedTitle => '無法儲存到相簿';

  @override
  String saveFailedBody(String reason) {
    return '這條影片暫時是安全的。請再試一次，或分享到檔案、雲端硬碟或聊天中，以免遺失。（$reason）';
  }

  @override
  String get shareVideo => '分享影片';

  @override
  String get discardTake => '捨棄這一條';

  @override
  String takeShared(int n) {
    return '第 $n 條已分享';
  }

  @override
  String get movePrompter => '拖曳以移動提詞機';

  @override
  String get resizePrompter => '拖曳以調整提詞機大小';

  @override
  String get prompterWidth => '提詞機寬度';

  @override
  String get resetPosition => '重設位置（頂端、全寬）';

  @override
  String get positionHint =>
      '拖曳提詞機頂端的橫條可移到任何位置，拖曳角落可調整大小。在 Android 上，懸浮視窗可拖到任何位置並會記住位置。';

  @override
  String get app => 'App';

  @override
  String get appLanguage => 'App 語言';

  @override
  String get systemDefault => '手機語言';

  @override
  String secondsShort(int n) {
    return '$n 秒';
  }

  @override
  String minutesShort(int n) {
    return '$n 分鐘';
  }
}
