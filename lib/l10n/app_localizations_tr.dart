// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'Kapat';

  @override
  String get settings => 'Ayarlar';

  @override
  String get prompterSettings => 'Prompter ayarları';

  @override
  String get edit => 'Düzenle';

  @override
  String get delete => 'Sil';

  @override
  String get undo => 'Geri al';

  @override
  String get duplicate => 'Çoğalt';

  @override
  String get share => 'Paylaş';

  @override
  String get copyAsCaption => 'Açıklama olarak kopyala';

  @override
  String get captionCopied =>
      'Konuşma metni kopyalandı — gönderi açıklamasına yapıştır';

  @override
  String get copySuffix => '(kopya)';

  @override
  String deletedScript(String title) {
    return '\"$title\" silindi';
  }

  @override
  String duplicatedScript(String title) {
    return '\"$title\" olarak çoğaltıldı';
  }

  @override
  String get untitled => 'Adsız';

  @override
  String get newScript => 'Yeni senaryo';

  @override
  String get searchScripts => 'Senaryo ara';

  @override
  String get filterAll => 'Tümü';

  @override
  String get statusDraft => 'Taslak';

  @override
  String get statusReady => 'Hazır';

  @override
  String get statusRecorded => 'Kaydedildi';

  @override
  String markAs(String status) {
    return '$status olarak işaretle';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'Prova';

  @override
  String get float => 'Yüzen';

  @override
  String get record => 'Kaydet';

  @override
  String words(int count) {
    return '$count kelime';
  }

  @override
  String takes(int count) {
    return '$count çekim';
  }

  @override
  String get noScriptsYet => 'Henüz senaryo yok';

  @override
  String get noScriptsHint =>
      'Başlamak için \"Yeni senaryo\"ya dokun ve bir şablon seç.';

  @override
  String get nothingHere => 'Burada bir şey yok';

  @override
  String get nothingHereHint => 'Başka bir filtre ya da arama dene.';

  @override
  String get startFromTemplate => 'Bir şablonla başla';

  @override
  String get overlayPermissionNeeded =>
      'Yüzen prompter için \"Diğer uygulamaların üzerinde göster\" iznini ver.';

  @override
  String get floatingStarted =>
      'Prompter ekranda yüzüyor. Kamera uygulamanı aç ve başlamak için metne dokun.';

  @override
  String get floatingNotificationTitle => 'APrompter ekranda';

  @override
  String get openScriptInApp => 'APrompter\'da bir senaryo aç';

  @override
  String get script => 'Senaryo';

  @override
  String get title => 'Başlık';

  @override
  String get status => 'Durum';

  @override
  String get noTarget => 'Hedef yok';

  @override
  String get editorHint =>
      'Söylemek istediğini yaz ya da yapıştır…\n\nİpucu: bölüm için satıra # ile, kendine not için // ile başla.';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $wpm kdk ile $spoken';
  }

  @override
  String get onTarget => 'Hedefte';

  @override
  String overTarget(int seconds, int words) {
    return '$seconds sn fazla · ~$words kelime kısalt';
  }

  @override
  String underTarget(int seconds, int words) {
    return '$seconds sn kaldı · ~$words kelime daha';
  }

  @override
  String longSentences(int count) {
    return '$count uzun cümle (25+ kelime) — nefes alabilmek için böl';
  }

  @override
  String get toolSection => 'Bölüm';

  @override
  String get toolEmphasis => 'Vurgu';

  @override
  String get toolPause => 'Duraklama';

  @override
  String get toolNote => 'Not';

  @override
  String get toolPaste => 'Yapıştır';

  @override
  String get restart => 'Baştan';

  @override
  String get sections => 'Bölümler';

  @override
  String get slower => 'Daha yavaş';

  @override
  String get faster => 'Daha hızlı';

  @override
  String get play => 'Oynat';

  @override
  String get pause => 'Duraklat';

  @override
  String get wpmUnit => 'kdk';

  @override
  String get startOfScript => 'Senaryonun başı';

  @override
  String sectionN(int n) {
    return 'Bölüm $n';
  }

  @override
  String get noSectionsHint =>
      'Henüz bölüm yok. Parçalar arasında atlamak ve yalnızca birini yeniden çekmek için düzenleyicide \"#\" ile başlayan satırlar ekle (ör. \"# Kanca\").';

  @override
  String get emptyScript => '(boş senaryo)';

  @override
  String get preview => 'Önizleme';

  @override
  String get setup => 'Kurulum';

  @override
  String get pace => 'Tempo';

  @override
  String get text => 'Metin';

  @override
  String get layout => 'Yerleşim';

  @override
  String get recording => 'Kayıt';

  @override
  String get wordsPerMinute => 'kelime / dk';

  @override
  String fitTo(String time) {
    return '$time süresine sığdır';
  }

  @override
  String get paceCalm => 'Sakin';

  @override
  String get paceNatural => 'Doğal';

  @override
  String get paceEnergetic => 'Enerjik';

  @override
  String get countdown => 'Başlamadan önce geri sayım';

  @override
  String get off => 'Kapalı';

  @override
  String get size => 'Boyut';

  @override
  String get lineSpacing => 'Satır aralığı';

  @override
  String get textColor => 'Metin rengi';

  @override
  String get prompterHeight => 'Prompter yüksekliği';

  @override
  String get background => 'Arka plan';

  @override
  String get readingGuide => 'Okuma çizgisi';

  @override
  String get mirrorText => 'Metni aynala';

  @override
  String get mirrorTextHint => 'Teleprompter camı / ışın ayırıcı için';

  @override
  String get videoQuality => 'Video kalitesi';

  @override
  String get autoStop => 'Senaryo bitince kaydı durdur';

  @override
  String get autoStopHint => 'Son satırdan sonra 2 saniye bekler';

  @override
  String get presetHandheld => 'Elde selfie';

  @override
  String get presetHandheldHint => 'Lense yakın orta boy metin';

  @override
  String get presetTripod => 'Tripod / uzaktan';

  @override
  String get presetTripodHint => '1–2 m\'den okunan büyük metin';

  @override
  String get presetGlass => 'Teleprompter camı';

  @override
  String get presetGlassHint => 'Aynalı, tam ekran, düz arka plan';

  @override
  String get niceRun => 'Harika!';

  @override
  String runSummary(String time, int words, int wpm) {
    return '$words kelime için $time sürdü → dakikada $wpm kelime.';
  }

  @override
  String runOver(int seconds, String target) {
    return 'Bu, $target hedefinin $seconds sn üstünde — senaryoyu kısalt ya da hızlan.';
  }

  @override
  String runUnder(int seconds) {
    return 'Hedefine $seconds sn payın var.';
  }

  @override
  String get runOnTarget => 'Tam hedef sürende. 🎯';

  @override
  String get keepCurrent => 'Böyle kalsın';

  @override
  String useWpm(int wpm) {
    return '$wpm kdk kullan';
  }

  @override
  String get switchCamera => 'Kamerayı değiştir';

  @override
  String get startRecording => 'Kaydı başlat';

  @override
  String get stopRecording => 'Kaydı durdur';

  @override
  String get noCamera => 'Bu cihazda kamera bulunamadı.';

  @override
  String get cameraDenied =>
      'Kamera erişimi reddedildi. Sistem ayarlarından aç.';

  @override
  String cameraError(String message) {
    return 'Kamera hatası: $message';
  }

  @override
  String takeSaved(int n) {
    return '$n. çekim galeriye kaydedildi';
  }

  @override
  String get templateBlank => 'Boş';

  @override
  String get templateBlankHint => 'Boş bir sayfayla başla';

  @override
  String get templateHvc => 'Kanca → Değer → CTA';

  @override
  String get templateHvcHint => 'Klasik kısa video yapısı';

  @override
  String get templateTutorial => 'Eğitim';

  @override
  String get templateTutorialHint => 'Bir şeyi adım adım öğret';

  @override
  String get templateReview => 'Ürün incelemesi';

  @override
  String get templateReviewHint => 'UGC, reklam ve dürüst incelemeler';

  @override
  String get templateStory => 'Hikâye';

  @override
  String get templateStoryHint => 'Dersi olan kişisel bir hikâye';

  @override
  String get secHook => 'Kanca';

  @override
  String get secValue => 'Değer';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'Adım $n';
  }

  @override
  String get secRecap => 'Özet ve CTA';

  @override
  String get secWhatItIs => 'Nedir';

  @override
  String get secLoved => 'Sevdiklerim';

  @override
  String get secBetter => 'Daha iyi olabilecekler';

  @override
  String get secVerdict => 'Karar ve CTA';

  @override
  String get secSetup => 'Giriş';

  @override
  String get secTurningPoint => 'Dönüm noktası';

  @override
  String get secLesson => 'Ders';

  @override
  String get noteHook =>
      'İlk 3 saniyede dikkat çek: cesur bir iddia ya da soru';

  @override
  String get noteValue => 'Söz verdiğin o tek şeyi ver';

  @override
  String get noteCta =>
      'Sonra ne yapacaklarını söyle: takip et, yorum yap, biyografideki link';

  @override
  String get noteTutorialHook =>
      '\"Bir dakikadan kısa sürede … şöyle yapılır\"';

  @override
  String get noteRecap =>
      'Tek cümlede özetle, sonra videoyu kaydetmelerini iste';

  @override
  String get noteReviewHook => 'Ürünü ve çözdüğü sorunu göster';

  @override
  String get noteVerdict => 'Kimler almalı — kodu ya da linki söyle';

  @override
  String get noteStoryHook => 'Olayın tam ortasından başla';

  @override
  String get welcomeTitle => 'APrompter\'a hoş geldin';

  @override
  String get welcomeBody =>
      '# Kanca\nMetnini unutmadan çekim yapmak ister misin? [pause]\n// doğrudan lense bak\n\n# Nasıl çalışır\nSenaryonu yaz, bir *hedef süre* seç ve zamanlayıcı sığıp sığmadığını söylesin.\nDakikadaki kelime sayısıyla temponu bulmak için prova yap.\nSonra Kaydet\'e dokun. Metin kameranın hemen altında kayar, böylece izleyicilerinle *göz temasını* korursun.\n\n# CTA\nSenaryoyu düzenlemek için bu karta dokun ya da artı düğmesiyle kendi senaryonu oluştur. [pause] İyi eğlenceler!\n';

  @override
  String get expand => 'Genişlet';

  @override
  String get minimize => 'Küçült';

  @override
  String get nothingToSay =>
      'Önce söylenecek bir şey ekle — bölümler (#) ve notlar (//) okunmaz.';

  @override
  String get openSettings => 'Ayarları aç';

  @override
  String get tryAgain => 'Tekrar dene';

  @override
  String get noMicBanner => 'Mikrofon erişimi yok — sessiz kaydediliyor';

  @override
  String get saveFailedTitle => 'Galeriye kaydedilemedi';

  @override
  String saveFailedBody(String reason) {
    return 'Çekimin şimdilik güvende. Tekrar dene ya da kaybetmemek için Dosyalar\'a, Drive\'a veya bir sohbete paylaş. ($reason)';
  }

  @override
  String get shareVideo => 'Videoyu paylaş';

  @override
  String get discardTake => 'Bu çekimi at';

  @override
  String takeShared(int n) {
    return '$n. çekim paylaşıldı';
  }

  @override
  String get movePrompter => 'Prompter\'ı taşımak için sürükle';

  @override
  String get resizePrompter => 'Prompter\'ı boyutlandırmak için sürükle';

  @override
  String get prompterWidth => 'Prompter genişliği';

  @override
  String get resetPosition => 'Konumu sıfırla (üstte, tam genişlik)';

  @override
  String get positionHint =>
      'Prompter\'ı istediğin yere taşımak için üstteki çubuğu, boyutlandırmak için köşeyi sürükle. Android\'de yüzen pencere her yere sürüklenebilir ve yerini hatırlar.';

  @override
  String get app => 'Uygulama';

  @override
  String get appLanguage => 'Uygulama dili';

  @override
  String get systemDefault => 'Telefon dili';

  @override
  String secondsShort(int n) {
    return '$n sn';
  }

  @override
  String minutesShort(int n) {
    return '$n dk';
  }

  @override
  String get storageSaveFailed =>
      'Kaydedilemedi — telefonunda yer kalmamış olabilir. Uygulama açık kaldıkça çalışman korunur.';

  @override
  String get versionHistory => 'Sürüm geçmişi';

  @override
  String get noVersions =>
      'Henüz önceki sürüm yok. Sen yazarken otomatik olarak saklanır.';

  @override
  String get restore => 'Geri yükle';

  @override
  String get versionRestored => 'Önceki sürüm geri yüklendi';

  @override
  String get recentlyDeleted => 'Son silinenler';

  @override
  String trashHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Silinen senaryolar burada $days gün kalır.',
      one: 'Silinen senaryolar burada 1 gün kalır.',
    );
    return '$_temp0';
  }

  @override
  String get deleteForever => 'Kalıcı olarak sil';

  @override
  String deletedOn(String date) {
    return 'Silinme: $date';
  }

  @override
  String restoredScript(String title) {
    return '\"$title\" geri yüklendi';
  }

  @override
  String get backUpScripts => 'Tüm senaryoları yedekle';

  @override
  String get restoreBackup => 'Yedekten geri yükle';

  @override
  String get backupShareTitle => 'APrompter yedeği';

  @override
  String importedScripts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count senaryo geri yüklendi',
      one: '1 senaryo geri yüklendi',
      zero: 'Bu yedekteki her şey zaten burada',
    );
    return '$_temp0';
  }

  @override
  String get notABackup => 'Bu dosya bir APrompter yedeği değil.';

  @override
  String fitImpossible(int wpm, String target, int words) {
    return '$wpm kdk hızda bile $target süresine sığmaz — yaklaşık $words kelime kısalt.';
  }

  @override
  String get cameraNotReady =>
      'Kamera hazır değildi, bu yüzden kayıt başlamadı. Tekrar dene.';

  @override
  String get previousSection => 'Önceki bölüm';

  @override
  String get nextSection => 'Sonraki bölüm';

  @override
  String get floatingNotificationBody => 'APrompter\'ı açmak için dokun';

  @override
  String get customTarget => 'Özel…';

  @override
  String get customTargetTitle => 'Hedef süre';

  @override
  String get customTargetHint => 'Dakika ve saniye, ör. 5:00';

  @override
  String get saved => 'Kaydedildi';

  @override
  String get floatNotOnIos =>
      'iPhone, uygulamaların diğer uygulamaların üzerinde durmasına izin vermez. Senaryo kameranın altındayken çekmek için Kaydet\'i kullan.';

  @override
  String get hashtagHint =>
      'Hashtag satırları (#fyp #ad) soluk gösterilir ve süreye sayılmaz. Bölüm için boşluklu \"# \" kullan.';

  @override
  String get appLock => 'Uygulama kilidi';

  @override
  String get appLockHint =>
      'APrompter\'ı açmak için parmak izi, yüz veya telefon PIN\'i iste';

  @override
  String get appLockUnavailable => 'Önce bu telefonda bir ekran kilidi ayarla.';

  @override
  String get unlock => 'Kilidi aç';

  @override
  String get unlockReason =>
      'Senaryolarını görmek için APrompter\'ın kilidini aç';

  @override
  String get autoStopWait => 'Son satırdan sonra bekleme';

  @override
  String get beforeYouRecord => 'Çekimden önce';

  @override
  String get recordAnyway => 'Yine de kaydet';

  @override
  String lowStorageWarning(int minutes) {
    return 'Boş alanına yalnızca yaklaşık $minutes dk video sığar. Yer aç veya video kalitesini düşür.';
  }

  @override
  String lowBatteryWarning(int level) {
    return 'Pil %$level — uzun bir çekim yarıda kesilebilir. Mümkünse şarja tak.';
  }

  @override
  String get brightScreen => 'Prompter sırasında tam parlaklık';

  @override
  String get brightScreenHint => 'Dışarıda okuması daha kolay';

  @override
  String get cameraBusy =>
      'Kamerayı başka bir uygulama kullanıyor. Onu kapatıp tekrar dene.';

  @override
  String get cameraIntroTitle => 'Kamera ve mikrofon';

  @override
  String get cameraIntroBody =>
      'Senaryo ekrandayken seni çekmek için APrompter\'ın kameraya ve mikrofona ihtiyacı var. Telefonun birazdan soracak. Videolar telefonunda kalır.';

  @override
  String get continueLabel => 'Devam';

  @override
  String get notNow => 'Şimdi değil';

  @override
  String get colorWhite => 'Beyaz';

  @override
  String get colorYellow => 'Sarı';

  @override
  String get colorGreen => 'Yeşil';

  @override
  String get colorBlue => 'Mavi';

  @override
  String get colorPink => 'Pembe';

  @override
  String get colorBlack => 'Siyah';

  @override
  String get damagedData => 'Okunamayan veri';

  @override
  String damagedDataHint(String date, int size) {
    return '$date tarihinde ayrıldı · $size karakter';
  }

  @override
  String get tryToRecover => 'Kurtarmayı dene';

  @override
  String get nothingRecovered => 'İçinden hiçbir senaryo okunamadı.';

  @override
  String get floatLowRam =>
      'Bu telefon uygulamaları diğerlerinin üzerinde gösteremiyor (düşük bellek veya Android Go). Bunun yerine Kaydet\'i kullan.';

  @override
  String get oemTipsTitle => 'Yüzen prompter\'ı açık tut';

  @override
  String oemTipsBody(String brand) {
    return '$brand telefonlar pil tasarrufu için yüzen pencereleri kapatabilir. Ayarlar → Uygulamalar → APrompter içinde: diğer uygulamaların üzerinde göstermeye (ve açılır pencerelere) izin ver, pili \"Kısıtlanmamış\" yap ve bildirimlere izin ver.';
  }

  @override
  String get focusLine => 'Geçerli satıra odaklan';

  @override
  String get focusLineHint => 'Diğer satırları soluklaştırır';

  @override
  String get stepByLine => 'Satır satır';

  @override
  String get stepByLineHint =>
      'Her dokunuş veya kumanda basışı bir satır ilerler — otomatik kaydırma yok';

  @override
  String get reduceEffects => 'Efektleri azalt';

  @override
  String get reduceEffectsHint =>
      'Geçiş ve gölge yok: eski telefonlarda daha akıcı, pil tasarrufu sağlar';

  @override
  String get letterSpacing => 'Harf aralığı';

  @override
  String get importTextFile => 'Metin dosyası içe aktar';

  @override
  String get importTextFileHint =>
      'Dosyalar, Drive veya e-postadan .txt ya da .md senaryo';

  @override
  String get importTextFailed =>
      'Dosya okunamadı. Düz metin (.txt) dosyası seç.';

  @override
  String get mySetup => 'Kurulumum';

  @override
  String get mySetupHint => 'Kaydettiğin kurulum';

  @override
  String get saveMySetup => 'Kurulumum olarak kaydet';

  @override
  String get resetAllSettings => 'Tüm ayarları sıfırla';

  @override
  String get runHadJumps =>
      'Bu denemede atlamalar yaptın, bu yüzden tempo önerilemiyor.';

  @override
  String get keepTake => 'Sakla';

  @override
  String get retake => 'Yeniden çek';

  @override
  String get reviewTakes => 'Her çekimi gözden geçir';

  @override
  String get reviewTakesHint => 'İzle, sonra sakla ya da yeniden çek';

  @override
  String get takesToGallery => 'Çekimleri galeriye kaydet';

  @override
  String get takesToGalleryHint =>
      'Kapalı: çekimler uygulamada kalır, Google Photos ve iCloud\'a gitmez';

  @override
  String get takesTitle => 'Çekimler';

  @override
  String get takesEmpty =>
      'Uygulamada saklanan çekimler burada görünür. Burada tutmak için ayarlarda \"Çekimleri galeriye kaydet\"i kapat.';

  @override
  String get saveToGallery => 'Galeriye kaydet';

  @override
  String get savedToGallery => 'Galerine kaydedildi';

  @override
  String get deleteTake => 'Çekimi sil';

  @override
  String takeKeptInApp(int n) {
    return '$n. çekim uygulamada saklandı';
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
