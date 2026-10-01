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
}
