// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => '閉じる';

  @override
  String get settings => '設定';

  @override
  String get prompterSettings => 'プロンプターの設定';

  @override
  String get edit => '編集';

  @override
  String get delete => '削除';

  @override
  String get undo => '元に戻す';

  @override
  String get duplicate => '複製';

  @override
  String get share => '共有';

  @override
  String get copyAsCaption => 'キャプションとしてコピー';

  @override
  String get captionCopied => '読み上げるテキストをコピーしました。投稿のキャプションに貼り付けてください';

  @override
  String get copySuffix => '(コピー)';

  @override
  String deletedScript(String title) {
    return '「$title」を削除しました';
  }

  @override
  String duplicatedScript(String title) {
    return '「$title」として複製しました';
  }

  @override
  String get untitled => '無題';

  @override
  String get newScript => '新しい台本';

  @override
  String get searchScripts => '台本を検索';

  @override
  String get filterAll => 'すべて';

  @override
  String get statusDraft => '下書き';

  @override
  String get statusReady => '撮影待ち';

  @override
  String get statusRecorded => '撮影済み';

  @override
  String markAs(String status) {
    return '$statusにする';
  }

  @override
  String filterCount(String label, int count) {
    return '$label（$count）';
  }

  @override
  String get rehearse => 'リハーサル';

  @override
  String get float => 'フロート';

  @override
  String get record => '撮影';

  @override
  String words(int count) {
    return '$count語';
  }

  @override
  String takes(int count) {
    return '$countテイク';
  }

  @override
  String get noScriptsYet => '台本はまだありません';

  @override
  String get noScriptsHint => '「新しい台本」をタップしてテンプレートを選びましょう。';

  @override
  String get nothingHere => '何もありません';

  @override
  String get nothingHereHint => '別のフィルタやキーワードを試してください。';

  @override
  String get startFromTemplate => 'テンプレートから始める';

  @override
  String get overlayPermissionNeeded =>
      'フローティングプロンプターを使うには「他のアプリの上に重ねて表示」を許可してください。';

  @override
  String get floatingStarted => 'プロンプターを表示しました。カメラアプリを開き、テキストをタップして開始します。';

  @override
  String get floatingNotificationTitle => 'APrompter を画面に表示中';

  @override
  String get openScriptInApp => 'APrompter で台本を開いてください';

  @override
  String get script => '台本';

  @override
  String get title => 'タイトル';

  @override
  String get status => 'ステータス';

  @override
  String get noTarget => '目標なし';

  @override
  String get editorHint =>
      '話したいことを書くか貼り付けてください…\n\nヒント：行頭に # でセクション、// で自分用のメモになります。';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $wpm 語/分で $spoken';
  }

  @override
  String get onTarget => '目標どおり';

  @override
  String overTarget(int seconds, int words) {
    return '$seconds 秒オーバー · 約 $words 語削りましょう';
  }

  @override
  String underTarget(int seconds, int words) {
    return '残り $seconds 秒 · あと約 $words 語';
  }

  @override
  String longSentences(int count) {
    return '長い文が $count 個（25語以上）— 息継ぎできるよう分けましょう';
  }

  @override
  String get toolSection => 'セクション';

  @override
  String get toolEmphasis => '強調';

  @override
  String get toolPause => '間';

  @override
  String get toolNote => 'メモ';

  @override
  String get toolPaste => '貼り付け';

  @override
  String get restart => '最初から';

  @override
  String get sections => 'セクション';

  @override
  String get slower => '遅く';

  @override
  String get faster => '速く';

  @override
  String get play => '再生';

  @override
  String get pause => '一時停止';

  @override
  String get wpmUnit => '語/分';

  @override
  String get startOfScript => '台本の最初';

  @override
  String sectionN(int n) {
    return 'セクション $n';
  }

  @override
  String get noSectionsHint =>
      'セクションがまだありません。エディタで「#」から始まる行（例：「# つかみ」）を追加すると、パートを行き来して一部だけ撮り直せます。';

  @override
  String get emptyScript => '（空の台本）';

  @override
  String get preview => 'プレビュー';

  @override
  String get setup => '撮影スタイル';

  @override
  String get pace => 'ペース';

  @override
  String get text => 'テキスト';

  @override
  String get layout => 'レイアウト';

  @override
  String get recording => '撮影';

  @override
  String get wordsPerMinute => '語 / 分';

  @override
  String fitTo(String time) {
    return '$time に合わせる';
  }

  @override
  String get paceCalm => 'ゆったり';

  @override
  String get paceNatural => 'ナチュラル';

  @override
  String get paceEnergetic => 'エネルギッシュ';

  @override
  String get countdown => '開始前のカウントダウン';

  @override
  String get off => 'オフ';

  @override
  String get size => 'サイズ';

  @override
  String get lineSpacing => '行間';

  @override
  String get textColor => '文字色';

  @override
  String get prompterHeight => 'プロンプターの高さ';

  @override
  String get background => '背景';

  @override
  String get readingGuide => '読み位置ガイド';

  @override
  String get mirrorText => '文字を反転';

  @override
  String get mirrorTextHint => 'プロンプターガラス／ハーフミラー用';

  @override
  String get videoQuality => '画質';

  @override
  String get autoStop => '台本が終わったら撮影を止める';

  @override
  String get autoStopHint => '最後の行から2秒待ちます';

  @override
  String get presetHandheld => '手持ち自撮り';

  @override
  String get presetHandheldHint => 'レンズの近くに中くらいの文字';

  @override
  String get presetTripod => '三脚／離れて撮影';

  @override
  String get presetTripodHint => '1〜2 m 先から読める大きな文字';

  @override
  String get presetGlass => 'プロンプターガラス';

  @override
  String get presetGlassHint => '反転・全画面・不透明な背景';

  @override
  String get niceRun => 'お見事！';

  @override
  String runSummary(String time, int words, int wpm) {
    return '$words語に $time かかりました → 1分あたり $wpm語。';
  }

  @override
  String runOver(int seconds, String target) {
    return '目標の $target より $seconds 秒長いです。台本を短くするか、少し速く話しましょう。';
  }

  @override
  String runUnder(int seconds) {
    return '目標まであと $seconds 秒あります。';
  }

  @override
  String get runOnTarget => '目標の長さにぴったりです。🎯';

  @override
  String get keepCurrent => 'そのままにする';

  @override
  String useWpm(int wpm) {
    return '$wpm 語/分にする';
  }

  @override
  String get switchCamera => 'カメラを切り替え';

  @override
  String get startRecording => '撮影を開始';

  @override
  String get stopRecording => '撮影を停止';

  @override
  String get noCamera => 'このデバイスにカメラが見つかりません。';

  @override
  String get cameraDenied => 'カメラへのアクセスが拒否されました。システム設定で許可してください。';

  @override
  String cameraError(String message) {
    return 'カメラエラー：$message';
  }

  @override
  String takeSaved(int n) {
    return 'テイク $n を写真に保存しました';
  }

  @override
  String get templateBlank => '白紙';

  @override
  String get templateBlankHint => '空のページから始める';

  @override
  String get templateHvc => 'つかみ → 本題 → CTA';

  @override
  String get templateHvcHint => 'ショート動画の定番構成';

  @override
  String get templateTutorial => 'ハウツー';

  @override
  String get templateTutorialHint => '手順を追って教える';

  @override
  String get templateReview => '商品レビュー';

  @override
  String get templateReviewHint => 'UGC・PR案件・正直なレビュー';

  @override
  String get templateStory => 'ストーリー';

  @override
  String get templateStoryHint => '学びのある自分の体験談';

  @override
  String get secHook => 'つかみ';

  @override
  String get secValue => '本題';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'ステップ $n';
  }

  @override
  String get secRecap => 'まとめと CTA';

  @override
  String get secWhatItIs => 'これは何？';

  @override
  String get secLoved => '気に入ったところ';

  @override
  String get secBetter => '改善してほしいところ';

  @override
  String get secVerdict => '結論と CTA';

  @override
  String get secSetup => '導入';

  @override
  String get secTurningPoint => '転機';

  @override
  String get secLesson => '学び';

  @override
  String get noteHook => '最初の3秒で惹きつける：大胆な主張か問いかけ';

  @override
  String get noteValue => '約束したひとつのことを届ける';

  @override
  String get noteCta => '次の行動を伝える：フォロー、コメント、プロフィールのリンク';

  @override
  String get noteTutorialHook => '「1分以内で…する方法」';

  @override
  String get noteRecap => '一言でまとめて、保存をお願いする';

  @override
  String get noteReviewHook => '商品と、それが解決する悩みを見せる';

  @override
  String get noteVerdict => '誰におすすめか — クーポンコードやリンクに触れる';

  @override
  String get noteStoryHook => 'いちばん盛り上がる場面から始める';

  @override
  String get welcomeTitle => 'APrompter へようこそ';

  @override
  String get welcomeBody =>
      '# つかみ\nセリフを忘れずに撮影したいですか？[pause]\n// レンズをまっすぐ見る\n\n# 使い方\n台本を書いて*目標の長さ*を選ぶと、タイマーが収まるかどうかを教えてくれます。\nリハーサルをして、1分あたりの語数で自分のペースを見つけましょう。\nそれから撮影をタップ。文字がカメラのすぐ下を流れるので、視聴者と*目線を合わせた*まま話せます。\n\n# CTA\nこのカードをタップして台本を編集するか、プラスボタンで自分の台本を作りましょう。[pause] 楽しく作ってください！\n';

  @override
  String get expand => '拡大';

  @override
  String get minimize => '最小化';

  @override
  String get nothingToSay => 'まず話す内容を追加してください。セクション（#）とメモ（//）は読み上げられません。';

  @override
  String get openSettings => '設定を開く';

  @override
  String get tryAgain => 'もう一度試す';

  @override
  String get noMicBanner => 'マイクへのアクセスなし — 音声なしで撮影中';

  @override
  String get saveFailedTitle => '写真に保存できませんでした';

  @override
  String saveFailedBody(String reason) {
    return 'テイクは今のところ無事です。もう一度試すか、失わないように「ファイル」やドライブ、チャットに共有してください。（$reason）';
  }

  @override
  String get shareVideo => '動画を共有';

  @override
  String get discardTake => 'このテイクを破棄';

  @override
  String takeShared(int n) {
    return 'テイク $n を共有しました';
  }

  @override
  String get movePrompter => 'ドラッグしてプロンプターを移動';

  @override
  String get resizePrompter => 'ドラッグしてプロンプターのサイズを変更';

  @override
  String get prompterWidth => 'プロンプターの幅';

  @override
  String get resetPosition => '位置をリセット（上端・全幅）';

  @override
  String get positionHint =>
      'プロンプター上部のバーをドラッグすると好きな場所に移動でき、角をドラッグするとサイズを変えられます。Android ではフローティングウィンドウをどこへでも動かせ、位置も記憶します。';

  @override
  String get app => 'アプリ';

  @override
  String get appLanguage => 'アプリの言語';

  @override
  String get systemDefault => '端末の言語';

  @override
  String secondsShort(int n) {
    return '$n秒';
  }

  @override
  String minutesShort(int n) {
    return '$n分';
  }

  @override
  String get storageSaveFailed =>
      '保存できませんでした。端末の空き容量が不足している可能性があります。アプリを開いている間は内容が保持されます。';

  @override
  String get versionHistory => 'バージョン履歴';

  @override
  String get noVersions => '以前のバージョンはまだありません。書いている間に自動で保存されます。';

  @override
  String get restore => '復元';

  @override
  String get versionRestored => '以前のバージョンを復元しました';

  @override
  String get recentlyDeleted => '最近削除した項目';

  @override
  String trashHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '削除した台本はここに$days日間保管されます。',
      one: '削除した台本はここに1日間保管されます。',
    );
    return '$_temp0';
  }

  @override
  String get deleteForever => '完全に削除';

  @override
  String deletedOn(String date) {
    return '$dateに削除';
  }

  @override
  String restoredScript(String title) {
    return '「$title」を復元しました';
  }

  @override
  String get backUpScripts => 'すべての台本をバックアップ';

  @override
  String get restoreBackup => 'バックアップから復元';

  @override
  String get backupShareTitle => 'APrompter バックアップ';

  @override
  String importedScripts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件の台本を復元しました',
      one: '1件の台本を復元しました',
      zero: 'このバックアップの内容はすべて復元済みです',
    );
    return '$_temp0';
  }

  @override
  String get notABackup => 'このファイルは APrompter のバックアップではありません。';

  @override
  String fitImpossible(int wpm, String target, int words) {
    return '$wpm 語/分でも $target に収まりません。約$words語削ってください。';
  }

  @override
  String get cameraNotReady => 'カメラの準備ができていなかったため、撮影を開始できませんでした。もう一度お試しください。';

  @override
  String get previousSection => '前のセクション';

  @override
  String get nextSection => '次のセクション';

  @override
  String get floatingNotificationBody => 'タップして APrompter を開く';

  @override
  String get customTarget => 'カスタム…';

  @override
  String get customTargetTitle => '目標の長さ';

  @override
  String get customTargetHint => '分と秒（例：5:00）';

  @override
  String get saved => '保存しました';

  @override
  String get floatNotOnIos =>
      'iPhone ではアプリを他のアプリの上に表示できません。「撮影」なら台本をカメラの下に表示して撮影できます。';

  @override
  String get hashtagHint =>
      'ハッシュタグの行（#fyp #ad）は薄く表示され、時間に含まれません。セクションには「# 」（スペース付き）を使います。';
}
