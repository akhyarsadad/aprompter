// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'Tutup';

  @override
  String get settings => 'Tetapan';

  @override
  String get prompterSettings => 'Tetapan prompter';

  @override
  String get edit => 'Sunting';

  @override
  String get delete => 'Padam';

  @override
  String get undo => 'Buat asal';

  @override
  String get duplicate => 'Pendua';

  @override
  String get share => 'Kongsi';

  @override
  String get copyAsCaption => 'Salin sebagai kapsyen';

  @override
  String get captionCopied =>
      'Teks pertuturan disalin — tampal sebagai kapsyen';

  @override
  String get copySuffix => '(salinan)';

  @override
  String deletedScript(String title) {
    return '\"$title\" dipadam';
  }

  @override
  String duplicatedScript(String title) {
    return 'Diduakan sebagai \"$title\"';
  }

  @override
  String get untitled => 'Tanpa tajuk';

  @override
  String get newScript => 'Skrip baharu';

  @override
  String get searchScripts => 'Cari skrip';

  @override
  String get filterAll => 'Semua';

  @override
  String get statusDraft => 'Draf';

  @override
  String get statusReady => 'Sedia';

  @override
  String get statusRecorded => 'Dirakam';

  @override
  String markAs(String status) {
    return 'Tandakan sebagai $status';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'Latihan';

  @override
  String get float => 'Terapung';

  @override
  String get record => 'Rakam';

  @override
  String words(int count) {
    return '$count perkataan';
  }

  @override
  String takes(int count) {
    return '$count rakaman';
  }

  @override
  String get noScriptsYet => 'Belum ada skrip';

  @override
  String get noScriptsHint =>
      'Ketik \"Skrip baharu\" dan pilih templat untuk bermula.';

  @override
  String get nothingHere => 'Tiada apa-apa di sini';

  @override
  String get nothingHereHint => 'Cuba penapis atau carian lain.';

  @override
  String get startFromTemplate => 'Mula dengan templat';

  @override
  String get overlayPermissionNeeded =>
      'Benarkan \"Papar di atas apl lain\" untuk menggunakan prompter terapung.';

  @override
  String get floatingStarted =>
      'Prompter sedang terapung. Buka apl kamera dan ketik teks untuk bermula.';

  @override
  String get floatingNotificationTitle => 'APrompter sedang terapung';

  @override
  String get openScriptInApp => 'Buka skrip dalam APrompter';

  @override
  String get script => 'Skrip';

  @override
  String get title => 'Tajuk';

  @override
  String get status => 'Status';

  @override
  String get noTarget => 'Tiada sasaran';

  @override
  String get editorHint =>
      'Tulis atau tampal apa yang anda mahu katakan…\n\nPetua: mulakan baris dengan # untuk bahagian, // untuk nota kepada diri sendiri.';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $spoken pada $wpm ppm';
  }

  @override
  String get onTarget => 'Tepat sasaran';

  @override
  String overTarget(int seconds, int words) {
    return 'Lebih $seconds saat · potong ~$words perkataan';
  }

  @override
  String underTarget(int seconds, int words) {
    return 'Baki $seconds saat · ~$words perkataan lagi';
  }

  @override
  String longSentences(int count) {
    return '$count ayat panjang (25+ perkataan) — pecahkan supaya sempat bernafas';
  }

  @override
  String get toolSection => 'Bahagian';

  @override
  String get toolEmphasis => 'Penekanan';

  @override
  String get toolPause => 'Jeda';

  @override
  String get toolNote => 'Nota';

  @override
  String get toolPaste => 'Tampal';

  @override
  String get restart => 'Mula semula';

  @override
  String get sections => 'Bahagian';

  @override
  String get slower => 'Lebih perlahan';

  @override
  String get faster => 'Lebih laju';

  @override
  String get play => 'Main';

  @override
  String get pause => 'Jeda';

  @override
  String get wpmUnit => 'ppm';

  @override
  String get startOfScript => 'Permulaan skrip';

  @override
  String sectionN(int n) {
    return 'Bahagian $n';
  }

  @override
  String get noSectionsHint =>
      'Belum ada bahagian. Tambah baris bermula dengan \"#\" dalam editor (cth. \"# Cangkuk\") untuk melompat antara bahagian dan merakam semula satu sahaja.';

  @override
  String get emptyScript => '(skrip kosong)';

  @override
  String get preview => 'Pratonton';

  @override
  String get setup => 'Persediaan';

  @override
  String get pace => 'Rentak';

  @override
  String get text => 'Teks';

  @override
  String get layout => 'Susun atur';

  @override
  String get recording => 'Rakaman';

  @override
  String get wordsPerMinute => 'perkataan / min';

  @override
  String fitTo(String time) {
    return 'Muatkan ke $time';
  }

  @override
  String get paceCalm => 'Tenang';

  @override
  String get paceNatural => 'Semula jadi';

  @override
  String get paceEnergetic => 'Bertenaga';

  @override
  String get countdown => 'Kiraan detik sebelum mula';

  @override
  String get off => 'Mati';

  @override
  String get size => 'Saiz';

  @override
  String get lineSpacing => 'Jarak baris';

  @override
  String get textColor => 'Warna teks';

  @override
  String get prompterHeight => 'Ketinggian prompter';

  @override
  String get background => 'Latar';

  @override
  String get readingGuide => 'Garis panduan bacaan';

  @override
  String get mirrorText => 'Cerminkan teks';

  @override
  String get mirrorTextHint => 'Untuk kaca teleprompter / pemisah alur';

  @override
  String get videoQuality => 'Kualiti video';

  @override
  String get autoStop => 'Henti rakaman apabila skrip tamat';

  @override
  String get autoStopHint => 'Tunggu 2 saat selepas baris terakhir';

  @override
  String get presetHandheld => 'Swafoto pegang tangan';

  @override
  String get presetHandheldHint => 'Teks sederhana dekat kanta';

  @override
  String get presetTripod => 'Tripod / jarak jauh';

  @override
  String get presetTripodHint => 'Teks besar boleh dibaca dari 1–2 m';

  @override
  String get presetGlass => 'Kaca teleprompter';

  @override
  String get presetGlassHint => 'Dicerminkan, skrin penuh, latar padu';

  @override
  String get niceRun => 'Hebat!';

  @override
  String runSummary(String time, int words, int wpm) {
    return 'Anda ambil $time untuk $words perkataan → $wpm perkataan seminit.';
  }

  @override
  String runOver(int seconds, String target) {
    return 'Itu $seconds saat melebihi sasaran $target — ringkaskan skrip atau cakap lebih laju.';
  }

  @override
  String runUnder(int seconds) {
    return 'Anda masih ada $seconds saat sebelum sasaran.';
  }

  @override
  String get runOnTarget => 'Tepat pada panjang sasaran. 🎯';

  @override
  String get keepCurrent => 'Kekalkan';

  @override
  String useWpm(int wpm) {
    return 'Guna $wpm ppm';
  }

  @override
  String get switchCamera => 'Tukar kamera';

  @override
  String get startRecording => 'Mula merakam';

  @override
  String get stopRecording => 'Henti merakam';

  @override
  String get noCamera => 'Tiada kamera ditemui pada peranti ini.';

  @override
  String get cameraDenied =>
      'Akses kamera ditolak. Dayakan dalam tetapan sistem.';

  @override
  String cameraError(String message) {
    return 'Ralat kamera: $message';
  }

  @override
  String takeSaved(int n) {
    return 'Rakaman $n disimpan ke galeri';
  }

  @override
  String get templateBlank => 'Kosong';

  @override
  String get templateBlankHint => 'Mula dengan halaman kosong';

  @override
  String get templateHvc => 'Cangkuk → Nilai → CTA';

  @override
  String get templateHvcHint => 'Struktur klasik video pendek';

  @override
  String get templateTutorial => 'Tutorial';

  @override
  String get templateTutorialHint => 'Ajar sesuatu langkah demi langkah';

  @override
  String get templateReview => 'Ulasan produk';

  @override
  String get templateReviewHint => 'UGC, iklan dan ulasan jujur';

  @override
  String get templateStory => 'Cerita';

  @override
  String get templateStoryHint => 'Cerita peribadi dengan pengajaran';

  @override
  String get secHook => 'Cangkuk';

  @override
  String get secValue => 'Nilai';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'Langkah $n';
  }

  @override
  String get secRecap => 'Ringkasan & CTA';

  @override
  String get secWhatItIs => 'Apa ini';

  @override
  String get secLoved => 'Apa yang saya suka';

  @override
  String get secBetter => 'Apa yang boleh diperbaiki';

  @override
  String get secVerdict => 'Keputusan & CTA';

  @override
  String get secSetup => 'Latar';

  @override
  String get secTurningPoint => 'Titik perubahan';

  @override
  String get secLesson => 'Pengajaran';

  @override
  String get noteHook =>
      'Tarik perhatian dalam 3 saat pertama: kenyataan berani atau soalan';

  @override
  String get noteValue => 'Berikan satu perkara yang anda janjikan';

  @override
  String get noteCta =>
      'Beritahu langkah seterusnya: ikuti, komen, pautan di bio';

  @override
  String get noteTutorialHook => '\"Begini cara … dalam masa kurang seminit\"';

  @override
  String get noteRecap =>
      'Ringkaskan dalam satu ayat, kemudian minta mereka simpan video';

  @override
  String get noteReviewHook =>
      'Tunjukkan produk dan masalah yang diselesaikannya';

  @override
  String get noteVerdict => 'Sesuai untuk siapa — sebut kod atau pautan';

  @override
  String get noteStoryHook => 'Mulakan di tengah-tengah aksi';

  @override
  String get welcomeTitle => 'Selamat datang ke APrompter';

  @override
  String get welcomeBody =>
      '# Cangkuk\nMahu merakam tanpa lupa skrip? [pause]\n// pandang terus ke kanta\n\n# Cara ia berfungsi\nTulis skrip anda, pilih *panjang sasaran*, dan pemasa akan beritahu sama ada ia muat.\nBuat latihan untuk cari rentak anda dalam perkataan seminit.\nKemudian tekan Rakam. Teks menatal betul-betul di bawah kamera, jadi anda kekal *bertentang mata* dengan penonton.\n\n# CTA\nKetik kad ini untuk menyunting skrip, atau cipta skrip anda sendiri dengan butang tambah. [pause] Selamat berkarya!\n';

  @override
  String get expand => 'Kembangkan';

  @override
  String get minimize => 'Kecilkan';

  @override
  String get nothingToSay =>
      'Tambah ayat untuk diucapkan dahulu — bahagian (#) dan nota (//) tidak dibaca.';

  @override
  String get openSettings => 'Buka tetapan';

  @override
  String get tryAgain => 'Cuba lagi';

  @override
  String get noMicBanner => 'Tiada akses mikrofon — merakam tanpa bunyi';

  @override
  String get saveFailedTitle => 'Gagal menyimpan ke galeri';

  @override
  String saveFailedBody(String reason) {
    return 'Rakaman anda selamat buat masa ini. Cuba lagi, atau kongsi ke Fail, Drive atau sembang supaya tidak hilang. ($reason)';
  }

  @override
  String get shareVideo => 'Kongsi video';

  @override
  String get discardTake => 'Buang rakaman ini';

  @override
  String takeShared(int n) {
    return 'Rakaman $n dikongsi';
  }

  @override
  String get movePrompter => 'Seret untuk mengalih prompter';

  @override
  String get resizePrompter => 'Seret untuk mengubah saiz prompter';

  @override
  String get prompterWidth => 'Lebar prompter';

  @override
  String get resetPosition => 'Set semula kedudukan (atas, lebar penuh)';

  @override
  String get positionHint =>
      'Seret bar di atas prompter untuk mengalihkannya ke mana-mana, dan sudutnya untuk mengubah saiz. Di Android, tetingkap terapung boleh diseret ke mana-mana dan mengingati kedudukannya.';

  @override
  String get app => 'Apl';

  @override
  String get appLanguage => 'Bahasa apl';

  @override
  String get systemDefault => 'Bahasa telefon';

  @override
  String secondsShort(int n) {
    return '$n saat';
  }

  @override
  String minutesShort(int n) {
    return '$n min';
  }

  @override
  String get storageSaveFailed =>
      'Gagal menyimpan — storan telefon mungkin penuh. Kerja anda kekal selagi apl dibuka.';

  @override
  String get versionHistory => 'Sejarah versi';

  @override
  String get noVersions =>
      'Belum ada versi terdahulu. Ia disimpan secara automatik semasa anda menulis.';

  @override
  String get restore => 'Pulihkan';

  @override
  String get versionRestored => 'Versi terdahulu dipulihkan';

  @override
  String get recentlyDeleted => 'Dipadam baru-baru ini';

  @override
  String trashHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Skrip yang dipadam kekal di sini selama $days hari.',
      one: 'Skrip yang dipadam kekal di sini selama 1 hari.',
    );
    return '$_temp0';
  }

  @override
  String get deleteForever => 'Padam selama-lamanya';

  @override
  String deletedOn(String date) {
    return 'Dipadam $date';
  }

  @override
  String restoredScript(String title) {
    return '\"$title\" dipulihkan';
  }

  @override
  String get backUpScripts => 'Sandarkan semua skrip';

  @override
  String get restoreBackup => 'Pulihkan daripada sandaran';

  @override
  String get backupShareTitle => 'Sandaran APrompter';

  @override
  String importedScripts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count skrip dipulihkan',
      one: '1 skrip dipulihkan',
      zero: 'Semua dalam sandaran ini sudah ada',
    );
    return '$_temp0';
  }

  @override
  String get notABackup => 'Fail itu bukan sandaran APrompter.';

  @override
  String fitImpossible(int wpm, String target, int words) {
    return 'Walaupun pada $wpm ppm, ini tidak muat dalam $target — potong kira-kira $words perkataan.';
  }

  @override
  String get cameraNotReady =>
      'Kamera belum sedia, jadi rakaman tidak bermula. Cuba lagi.';

  @override
  String get previousSection => 'Bahagian sebelumnya';

  @override
  String get nextSection => 'Bahagian seterusnya';

  @override
  String get floatingNotificationBody => 'Ketik untuk membuka APrompter';

  @override
  String get customTarget => 'Tersuai…';

  @override
  String get customTargetTitle => 'Panjang sasaran';

  @override
  String get customTargetHint => 'Minit dan saat, cth. 5:00';

  @override
  String get saved => 'Disimpan';

  @override
  String get floatNotOnIos =>
      'iPhone tidak membenarkan apl terapung di atas apl lain. Gunakan Rakam untuk merakam dengan skrip di bawah kamera.';

  @override
  String get hashtagHint =>
      'Baris hashtag (#fyp #ad) dipaparkan malap dan tidak dikira masa. Gunakan \"# \" dengan ruang untuk bahagian.';

  @override
  String get appLock => 'Kunci apl';

  @override
  String get appLockHint =>
      'Minta cap jari, wajah atau PIN telefon untuk membuka APrompter';

  @override
  String get appLockUnavailable =>
      'Sediakan kunci skrin pada telefon ini dahulu.';

  @override
  String get unlock => 'Buka kunci';

  @override
  String get unlockReason => 'Buka kunci APrompter untuk melihat skrip anda';

  @override
  String get autoStopWait => 'Tunggu selepas baris terakhir';

  @override
  String get beforeYouRecord => 'Sebelum anda merakam';

  @override
  String get recordAnyway => 'Rakam juga';

  @override
  String lowStorageWarning(int minutes) {
    return 'Ruang kosong anda hanya muat kira-kira $minutes min video. Kosongkan ruang atau turunkan kualiti video.';
  }

  @override
  String lowBatteryWarning(int level) {
    return 'Bateri pada $level% — rakaman panjang mungkin terputus. Cas jika boleh.';
  }

  @override
  String get brightScreen => 'Kecerahan penuh semasa prompter';

  @override
  String get brightScreenHint => 'Lebih mudah dibaca di luar';

  @override
  String get cameraBusy =>
      'Apl lain sedang menggunakan kamera. Tutup apl itu dan cuba lagi.';

  @override
  String get cameraIntroTitle => 'Kamera dan mikrofon';

  @override
  String get cameraIntroBody =>
      'Untuk merakam anda dengan skrip di skrin, APrompter memerlukan kamera dan mikrofon. Telefon anda akan bertanya selepas ini. Video kekal dalam telefon anda.';

  @override
  String get continueLabel => 'Teruskan';

  @override
  String get notNow => 'Bukan sekarang';

  @override
  String get colorWhite => 'Putih';

  @override
  String get colorYellow => 'Kuning';

  @override
  String get colorGreen => 'Hijau';

  @override
  String get colorBlue => 'Biru';

  @override
  String get colorPink => 'Merah jambu';

  @override
  String get colorBlack => 'Hitam';

  @override
  String get damagedData => 'Data tidak boleh dibaca';

  @override
  String damagedDataHint(String date, int size) {
    return 'Diasingkan pada $date · $size aksara';
  }

  @override
  String get tryToRecover => 'Cuba pulihkan';

  @override
  String get nothingRecovered => 'Tiada skrip yang dapat dibaca daripadanya.';

  @override
  String get floatLowRam =>
      'Telefon ini tidak dapat memaparkan apl di atas apl lain (memori rendah atau Android Go). Gunakan Rakam.';

  @override
  String get oemTipsTitle => 'Kekalkan prompter terapung aktif';

  @override
  String oemTipsBody(String brand) {
    return 'Telefon $brand mungkin menutup tetingkap terapung untuk menjimatkan bateri. Dalam Tetapan → Apl → APrompter: benarkan paparan di atas apl lain (dan tetingkap timbul), tetapkan bateri kepada \"Tiada sekatan\" dan benarkan pemberitahuan.';
  }

  @override
  String get focusLine => 'Fokus pada baris semasa';

  @override
  String get focusLineHint => 'Malapkan baris lain';

  @override
  String get stepByLine => 'Baris demi baris';

  @override
  String get stepByLineHint =>
      'Setiap ketikan atau tekanan alat kawalan jauh maju satu baris — tiada tatal automatik';

  @override
  String get reduceEffects => 'Kurangkan kesan';

  @override
  String get reduceEffectsHint =>
      'Tiada pudar atau bayang: lebih lancar pada telefon lama, jimat bateri';

  @override
  String get letterSpacing => 'Jarak huruf';

  @override
  String get importTextFile => 'Import fail teks';

  @override
  String get importTextFileHint =>
      'Skrip .txt atau .md daripada Fail, Drive atau e-mel';

  @override
  String get importTextFailed =>
      'Fail itu tidak dapat dibaca. Pilih fail teks biasa (.txt).';

  @override
  String get mySetup => 'Persediaan saya';

  @override
  String get mySetupHint => 'Persediaan yang anda simpan';

  @override
  String get saveMySetup => 'Simpan sebagai persediaan saya';

  @override
  String get resetAllSettings => 'Tetapkan semula semua tetapan';

  @override
  String get runHadJumps =>
      'Anda melompat-lompat semasa larian ini, jadi rentak tidak dapat dicadangkan.';

  @override
  String get keepTake => 'Simpan';

  @override
  String get retake => 'Rakam semula';

  @override
  String get reviewTakes => 'Semak setiap rakaman';

  @override
  String get reviewTakesHint => 'Tonton, kemudian simpan atau rakam semula';

  @override
  String get takesToGallery => 'Simpan rakaman ke galeri';

  @override
  String get takesToGalleryHint =>
      'Mati: rakaman kekal dalam apl, di luar Google Photos dan iCloud';

  @override
  String get takesTitle => 'Rakaman';

  @override
  String get takesEmpty =>
      'Rakaman yang disimpan dalam apl dipaparkan di sini. Matikan \"Simpan rakaman ke galeri\" dalam tetapan untuk menyimpannya di sini.';

  @override
  String get saveToGallery => 'Simpan ke galeri';

  @override
  String get savedToGallery => 'Disimpan ke galeri anda';

  @override
  String get deleteTake => 'Padam rakaman';

  @override
  String takeKeptInApp(int n) {
    return 'Rakaman $n disimpan dalam apl';
  }
}
