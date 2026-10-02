// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'Tutup';

  @override
  String get settings => 'Pengaturan';

  @override
  String get prompterSettings => 'Pengaturan prompter';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Hapus';

  @override
  String get undo => 'Urungkan';

  @override
  String get duplicate => 'Duplikat';

  @override
  String get share => 'Bagikan';

  @override
  String get copyAsCaption => 'Salin sebagai caption';

  @override
  String get captionCopied => 'Teks ucapan disalin — tempel sebagai caption';

  @override
  String get copySuffix => '(salinan)';

  @override
  String deletedScript(String title) {
    return '\"$title\" dihapus';
  }

  @override
  String duplicatedScript(String title) {
    return 'Diduplikat sebagai \"$title\"';
  }

  @override
  String get untitled => 'Tanpa judul';

  @override
  String get newScript => 'Naskah baru';

  @override
  String get searchScripts => 'Cari naskah';

  @override
  String get filterAll => 'Semua';

  @override
  String get statusDraft => 'Draf';

  @override
  String get statusReady => 'Siap';

  @override
  String get statusRecorded => 'Direkam';

  @override
  String markAs(String status) {
    return 'Tandai $status';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'Latihan';

  @override
  String get float => 'Melayang';

  @override
  String get record => 'Rekam';

  @override
  String words(int count) {
    return '$count kata';
  }

  @override
  String takes(int count) {
    return '$count take';
  }

  @override
  String get noScriptsYet => 'Belum ada naskah';

  @override
  String get noScriptsHint =>
      'Ketuk \"Naskah baru\" dan pilih template untuk mulai.';

  @override
  String get nothingHere => 'Tidak ada apa-apa';

  @override
  String get nothingHereHint => 'Coba filter atau kata kunci lain.';

  @override
  String get startFromTemplate => 'Mulai dari template';

  @override
  String get overlayPermissionNeeded =>
      'Izinkan \"Tampilkan di atas aplikasi lain\" untuk memakai prompter melayang.';

  @override
  String get floatingStarted =>
      'Prompter melayang aktif. Buka aplikasi kamera lalu ketuk teks untuk mulai.';

  @override
  String get floatingNotificationTitle => 'APrompter sedang melayang';

  @override
  String get openScriptInApp => 'Buka naskah di APrompter';

  @override
  String get script => 'Naskah';

  @override
  String get title => 'Judul';

  @override
  String get status => 'Status';

  @override
  String get noTarget => 'Tanpa target';

  @override
  String get editorHint =>
      'Tulis atau tempel apa yang ingin kamu ucapkan…\n\nTips: awali baris dengan # untuk bagian, // untuk catatan pribadi.';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $spoken pada $wpm kpm';
  }

  @override
  String get onTarget => 'Sesuai target';

  @override
  String overTarget(int seconds, int words) {
    return 'Lebih $seconds dtk · potong ~$words kata';
  }

  @override
  String underTarget(int seconds, int words) {
    return 'Sisa $seconds dtk · ~$words kata lagi';
  }

  @override
  String longSentences(int count) {
    return '$count kalimat panjang (25+ kata) — pecah agar bisa bernapas';
  }

  @override
  String get toolSection => 'Bagian';

  @override
  String get toolEmphasis => 'Tekanan';

  @override
  String get toolPause => 'Jeda';

  @override
  String get toolNote => 'Catatan';

  @override
  String get toolPaste => 'Tempel';

  @override
  String get restart => 'Ulang';

  @override
  String get sections => 'Bagian';

  @override
  String get slower => 'Lebih lambat';

  @override
  String get faster => 'Lebih cepat';

  @override
  String get play => 'Putar';

  @override
  String get pause => 'Jeda';

  @override
  String get wpmUnit => 'kpm';

  @override
  String get startOfScript => 'Awal naskah';

  @override
  String sectionN(int n) {
    return 'Bagian $n';
  }

  @override
  String get noSectionsHint =>
      'Belum ada bagian. Tambahkan baris yang diawali \"#\" di editor (mis. \"# Hook\") untuk lompat antar bagian dan mengulang satu bagian saja.';

  @override
  String get emptyScript => '(naskah kosong)';

  @override
  String get preview => 'Pratinjau';

  @override
  String get setup => 'Setelan';

  @override
  String get pace => 'Tempo';

  @override
  String get text => 'Teks';

  @override
  String get layout => 'Tata letak';

  @override
  String get recording => 'Perekaman';

  @override
  String get wordsPerMinute => 'kata / menit';

  @override
  String fitTo(String time) {
    return 'Pas $time';
  }

  @override
  String get paceCalm => 'Tenang';

  @override
  String get paceNatural => 'Natural';

  @override
  String get paceEnergetic => 'Energik';

  @override
  String get countdown => 'Hitung mundur sebelum mulai';

  @override
  String get off => 'Mati';

  @override
  String get size => 'Ukuran';

  @override
  String get lineSpacing => 'Jarak baris';

  @override
  String get textColor => 'Warna teks';

  @override
  String get prompterHeight => 'Tinggi prompter';

  @override
  String get background => 'Latar';

  @override
  String get readingGuide => 'Garis panduan baca';

  @override
  String get mirrorText => 'Cerminkan teks';

  @override
  String get mirrorTextHint => 'Untuk kaca teleprompter / beam splitter';

  @override
  String get videoQuality => 'Kualitas video';

  @override
  String get autoStop => 'Berhenti merekam saat naskah selesai';

  @override
  String get autoStopHint => 'Menunggu 2 detik setelah baris terakhir';

  @override
  String get presetHandheld => 'Selfie genggam';

  @override
  String get presetHandheldHint => 'Teks sedang dekat lensa';

  @override
  String get presetTripod => 'Tripod / jarak jauh';

  @override
  String get presetTripodHint => 'Teks besar terbaca dari 1–2 m';

  @override
  String get presetGlass => 'Kaca teleprompter';

  @override
  String get presetGlassHint => 'Dicerminkan, layar penuh, latar solid';

  @override
  String get niceRun => 'Mantap!';

  @override
  String runSummary(String time, int words, int wpm) {
    return 'Kamu butuh $time untuk $words kata → $wpm kata per menit.';
  }

  @override
  String runOver(int seconds, String target) {
    return 'Itu $seconds dtk melewati target $target — pangkas naskah atau percepat.';
  }

  @override
  String runUnder(int seconds) {
    return 'Masih ada $seconds dtk sebelum target.';
  }

  @override
  String get runOnTarget => 'Pas dengan target durasi. 🎯';

  @override
  String get keepCurrent => 'Tetap';

  @override
  String useWpm(int wpm) {
    return 'Pakai $wpm kpm';
  }

  @override
  String get switchCamera => 'Ganti kamera';

  @override
  String get startRecording => 'Mulai rekam';

  @override
  String get stopRecording => 'Berhenti rekam';

  @override
  String get noCamera => 'Kamera tidak ditemukan di perangkat ini.';

  @override
  String get cameraDenied =>
      'Akses kamera ditolak. Aktifkan di pengaturan sistem.';

  @override
  String cameraError(String message) {
    return 'Kesalahan kamera: $message';
  }

  @override
  String takeSaved(int n) {
    return 'Take $n disimpan ke galeri';
  }

  @override
  String get templateBlank => 'Kosong';

  @override
  String get templateBlankHint => 'Mulai dari halaman kosong';

  @override
  String get templateHvc => 'Hook → Isi → CTA';

  @override
  String get templateHvcHint => 'Struktur klasik video pendek';

  @override
  String get templateTutorial => 'Tutorial';

  @override
  String get templateTutorialHint => 'Ajarkan sesuatu langkah demi langkah';

  @override
  String get templateReview => 'Review produk';

  @override
  String get templateReviewHint => 'UGC, iklan, dan ulasan jujur';

  @override
  String get templateStory => 'Cerita';

  @override
  String get templateStoryHint => 'Cerita pribadi dengan pelajaran';

  @override
  String get secHook => 'Hook';

  @override
  String get secValue => 'Isi';

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
  String get secLoved => 'Yang aku suka';

  @override
  String get secBetter => 'Yang bisa lebih baik';

  @override
  String get secVerdict => 'Kesimpulan & CTA';

  @override
  String get secSetup => 'Pembuka';

  @override
  String get secTurningPoint => 'Titik balik';

  @override
  String get secLesson => 'Pelajaran';

  @override
  String get noteHook =>
      'Tarik perhatian di 3 detik pertama: klaim berani atau pertanyaan';

  @override
  String get noteValue => 'Berikan satu hal yang kamu janjikan';

  @override
  String get noteCta =>
      'Bilang apa langkah berikutnya: follow, komen, link di bio';

  @override
  String get noteTutorialHook => '\"Begini cara … dalam kurang dari semenit\"';

  @override
  String get noteRecap =>
      'Ringkas dalam satu kalimat, lalu minta mereka menyimpan video';

  @override
  String get noteReviewHook => 'Tunjukkan produk dan masalah yang diselesaikan';

  @override
  String get noteVerdict => 'Siapa yang cocok membeli — sebut kode atau link';

  @override
  String get noteStoryHook => 'Mulai dari tengah aksi';

  @override
  String get welcomeTitle => 'Selamat datang di APrompter';

  @override
  String get welcomeBody =>
      '# Hook\nMau rekam video tanpa lupa naskah? [pause]\n// lihat langsung ke lensa\n\n# Cara kerja\nTulis naskahmu, pilih *target durasi*, dan lihat timer memberi tahu apakah pas.\nLatihan untuk menemukan tempo bicaramu dalam kata per menit.\nLalu tekan Rekam. Teks bergulir tepat di bawah kamera, jadi kamu tetap *kontak mata* dengan penonton.\n\n# CTA\nKetuk kartu ini untuk mengedit naskah, atau buat naskahmu sendiri dengan tombol plus. [pause] Selamat berkarya!\n';

  @override
  String get expand => 'Perbesar';

  @override
  String get minimize => 'Perkecil';

  @override
  String get nothingToSay =>
      'Tambahkan kalimat yang akan diucapkan dulu — bagian (#) dan catatan (//) tidak dibacakan.';

  @override
  String get openSettings => 'Buka pengaturan';

  @override
  String get tryAgain => 'Coba lagi';

  @override
  String get noMicBanner => 'Tanpa akses mikrofon — merekam tanpa suara';

  @override
  String get saveFailedTitle => 'Gagal menyimpan ke galeri';

  @override
  String saveFailedBody(String reason) {
    return 'Take-mu masih aman. Coba lagi, atau bagikan ke Files, Drive, atau chat agar tidak hilang. ($reason)';
  }

  @override
  String get shareVideo => 'Bagikan video';

  @override
  String get discardTake => 'Buang take ini';

  @override
  String takeShared(int n) {
    return 'Take $n dibagikan';
  }

  @override
  String get movePrompter => 'Seret untuk memindahkan prompter';

  @override
  String get resizePrompter => 'Seret untuk mengubah ukuran prompter';

  @override
  String get prompterWidth => 'Lebar prompter';

  @override
  String get resetPosition => 'Atur ulang posisi (atas, lebar penuh)';

  @override
  String get positionHint =>
      'Seret bilah di atas prompter untuk memindahkannya ke mana saja, dan sudutnya untuk mengubah ukuran. Di Android, jendela melayang bisa diseret ke mana saja dan mengingat posisinya.';

  @override
  String get app => 'Aplikasi';

  @override
  String get appLanguage => 'Bahasa aplikasi';

  @override
  String get systemDefault => 'Bahasa ponsel';

  @override
  String secondsShort(int n) {
    return '$n dtk';
  }

  @override
  String minutesShort(int n) {
    return '$n mnt';
  }

  @override
  String get storageSaveFailed =>
      'Gagal menyimpan — mungkin penyimpanan ponsel penuh. Pekerjaan tetap aman selama aplikasi masih terbuka.';

  @override
  String get versionHistory => 'Riwayat versi';

  @override
  String get noVersions =>
      'Belum ada versi sebelumnya. Versi disimpan otomatis selama kamu menulis.';

  @override
  String get restore => 'Pulihkan';

  @override
  String get versionRestored => 'Versi sebelumnya dipulihkan';

  @override
  String get recentlyDeleted => 'Baru dihapus';

  @override
  String trashHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Naskah yang dihapus disimpan di sini selama $days hari.',
      one: 'Naskah yang dihapus disimpan di sini selama 1 hari.',
    );
    return '$_temp0';
  }

  @override
  String get deleteForever => 'Hapus permanen';

  @override
  String deletedOn(String date) {
    return 'Dihapus $date';
  }

  @override
  String restoredScript(String title) {
    return '\"$title\" dipulihkan';
  }

  @override
  String get backUpScripts => 'Cadangkan semua naskah';

  @override
  String get restoreBackup => 'Pulihkan dari cadangan';

  @override
  String get backupShareTitle => 'Cadangan APrompter';

  @override
  String importedScripts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count naskah dipulihkan',
      one: '1 naskah dipulihkan',
      zero: 'Semua isi cadangan ini sudah ada',
    );
    return '$_temp0';
  }

  @override
  String get notABackup => 'File itu bukan cadangan APrompter.';

  @override
  String fitImpossible(int wpm, String target, int words) {
    return 'Bahkan pada $wpm kpm, ini tidak muat dalam $target — pangkas sekitar $words kata.';
  }

  @override
  String get cameraNotReady =>
      'Kamera belum siap, jadi rekaman tidak dimulai. Coba lagi.';

  @override
  String get previousSection => 'Bagian sebelumnya';

  @override
  String get nextSection => 'Bagian berikutnya';

  @override
  String get floatingNotificationBody => 'Ketuk untuk membuka APrompter';

  @override
  String get customTarget => 'Kustom…';

  @override
  String get customTargetTitle => 'Durasi target';

  @override
  String get customTargetHint => 'Menit dan detik, mis. 5:00';

  @override
  String get saved => 'Tersimpan';

  @override
  String get floatNotOnIos =>
      'iPhone tidak mengizinkan aplikasi melayang di atas aplikasi lain. Gunakan Rekam untuk merekam dengan naskah di bawah kamera.';

  @override
  String get hashtagHint =>
      'Baris hashtag (#fyp #ad) ditampilkan redup dan tidak dihitung waktunya. Gunakan \"# \" dengan spasi untuk bagian.';

  @override
  String get appLock => 'Kunci aplikasi';

  @override
  String get appLockHint =>
      'Minta sidik jari, wajah, atau PIN HP untuk membuka APrompter';

  @override
  String get appLockUnavailable => 'Atur kunci layar di HP ini dulu.';

  @override
  String get unlock => 'Buka kunci';

  @override
  String get unlockReason => 'Buka kunci APrompter untuk melihat naskahmu';

  @override
  String get autoStopWait => 'Jeda setelah baris terakhir';

  @override
  String get beforeYouRecord => 'Sebelum merekam';

  @override
  String get recordAnyway => 'Tetap rekam';

  @override
  String lowStorageWarning(int minutes) {
    return 'Ruang kosongmu hanya cukup untuk sekitar $minutes mnt video. Kosongkan ruang atau turunkan kualitas video.';
  }

  @override
  String lowBatteryWarning(int level) {
    return 'Baterai $level% — take panjang bisa terpotong. Colokkan charger kalau bisa.';
  }

  @override
  String get brightScreen => 'Kecerahan penuh saat prompter jalan';

  @override
  String get brightScreenHint => 'Lebih mudah dibaca di luar ruangan';

  @override
  String get cameraBusy =>
      'Aplikasi lain sedang memakai kamera. Tutup lalu coba lagi.';

  @override
  String get cameraIntroTitle => 'Kamera dan mikrofon';

  @override
  String get cameraIntroBody =>
      'Untuk merekammu dengan naskah di layar, APrompter butuh kamera dan mikrofon. HP-mu akan meminta izin berikutnya. Video tetap di HP-mu.';

  @override
  String get continueLabel => 'Lanjut';

  @override
  String get notNow => 'Nanti saja';

  @override
  String get colorWhite => 'Putih';

  @override
  String get colorYellow => 'Kuning';

  @override
  String get colorGreen => 'Hijau';

  @override
  String get colorBlue => 'Biru';

  @override
  String get colorPink => 'Merah muda';

  @override
  String get colorBlack => 'Hitam';

  @override
  String get damagedData => 'Data tak terbaca';

  @override
  String damagedDataHint(String date, int size) {
    return 'Disisihkan pada $date · $size karakter';
  }

  @override
  String get tryToRecover => 'Coba pulihkan';

  @override
  String get nothingRecovered => 'Tidak ada naskah yang bisa dibaca.';

  @override
  String get floatLowRam =>
      'HP ini tidak bisa menampilkan aplikasi di atas aplikasi lain (memori rendah atau Android Go). Pakai Rekam saja.';

  @override
  String get oemTipsTitle => 'Jaga prompter melayang tetap aktif';

  @override
  String oemTipsBody(String brand) {
    return 'HP $brand bisa menutup jendela melayang untuk hemat baterai. Di Pengaturan → Aplikasi → APrompter: izinkan tampil di atas aplikasi lain (dan jendela pop-up), atur baterai ke \"Tidak dibatasi\", dan izinkan notifikasi.';
  }

  @override
  String get focusLine => 'Fokus ke baris saat ini';

  @override
  String get focusLineHint => 'Meredupkan baris lainnya';

  @override
  String get stepByLine => 'Baris demi baris';

  @override
  String get stepByLineHint =>
      'Setiap ketukan atau tombol remote maju satu baris — tanpa gulir otomatis';

  @override
  String get reduceEffects => 'Kurangi efek';

  @override
  String get reduceEffectsHint =>
      'Tanpa fade atau bayangan: lebih lancar di HP lama, hemat baterai';

  @override
  String get letterSpacing => 'Jarak huruf';

  @override
  String get importTextFile => 'Impor file teks';

  @override
  String get importTextFileHint =>
      'Naskah .txt atau .md dari Files, Drive, atau email';

  @override
  String get importTextFailed =>
      'File itu tidak bisa dibaca. Pilih file teks biasa (.txt).';

  @override
  String get mySetup => 'Setelanku';

  @override
  String get mySetupHint => 'Setelan yang kamu simpan';

  @override
  String get saveMySetup => 'Simpan sebagai setelanku';

  @override
  String get resetAllSettings => 'Reset semua pengaturan';

  @override
  String get runHadJumps =>
      'Kamu melompat-lompat di sesi ini, jadi tempo tidak bisa disarankan.';

  @override
  String get keepTake => 'Simpan';

  @override
  String get retake => 'Ulangi';

  @override
  String get reviewTakes => 'Tinjau setiap take';

  @override
  String get reviewTakesHint => 'Tonton, lalu simpan atau ulangi';

  @override
  String get takesToGallery => 'Simpan take ke galeri';

  @override
  String get takesToGalleryHint =>
      'Mati: take tetap di aplikasi, tidak masuk Google Photos dan iCloud';

  @override
  String get takesTitle => 'Take';

  @override
  String get takesEmpty =>
      'Take yang disimpan di aplikasi muncul di sini. Matikan \"Simpan take ke galeri\" di pengaturan agar tersimpan di sini.';

  @override
  String get saveToGallery => 'Simpan ke galeri';

  @override
  String get savedToGallery => 'Disimpan ke galerimu';

  @override
  String get deleteTake => 'Hapus take';

  @override
  String takeKeptInApp(int n) {
    return 'Take $n disimpan di aplikasi';
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
}
