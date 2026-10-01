// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'বন্ধ করুন';

  @override
  String get settings => 'সেটিংস';

  @override
  String get prompterSettings => 'প্রম্পটার সেটিংস';

  @override
  String get edit => 'সম্পাদনা';

  @override
  String get delete => 'মুছুন';

  @override
  String get undo => 'আগের মতো করুন';

  @override
  String get duplicate => 'ডুপ্লিকেট';

  @override
  String get share => 'শেয়ার';

  @override
  String get copyAsCaption => 'ক্যাপশন হিসেবে কপি';

  @override
  String get captionCopied =>
      'বলার টেক্সট কপি হয়েছে — এটি ক্যাপশনে পেস্ট করুন';

  @override
  String get copySuffix => '(কপি)';

  @override
  String deletedScript(String title) {
    return '\"$title\" মুছে ফেলা হয়েছে';
  }

  @override
  String duplicatedScript(String title) {
    return '\"$title\" নামে ডুপ্লিকেট হয়েছে';
  }

  @override
  String get untitled => 'শিরোনামহীন';

  @override
  String get newScript => 'নতুন স্ক্রিপ্ট';

  @override
  String get searchScripts => 'স্ক্রিপ্ট খুঁজুন';

  @override
  String get filterAll => 'সব';

  @override
  String get statusDraft => 'খসড়া';

  @override
  String get statusReady => 'প্রস্তুত';

  @override
  String get statusRecorded => 'রেকর্ড করা';

  @override
  String markAs(String status) {
    return '$status হিসেবে চিহ্নিত করুন';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'অনুশীলন';

  @override
  String get float => 'ভাসমান';

  @override
  String get record => 'রেকর্ড';

  @override
  String words(int count) {
    return '$countটি শব্দ';
  }

  @override
  String takes(int count) {
    return '$countটি টেক';
  }

  @override
  String get noScriptsYet => 'এখনও কোনো স্ক্রিপ্ট নেই';

  @override
  String get noScriptsHint =>
      'শুরু করতে \"নতুন স্ক্রিপ্ট\"-এ ট্যাপ করে একটি টেমপ্লেট বেছে নিন।';

  @override
  String get nothingHere => 'এখানে কিছু নেই';

  @override
  String get nothingHereHint => 'অন্য ফিল্টার বা অনুসন্ধান চেষ্টা করুন।';

  @override
  String get startFromTemplate => 'টেমপ্লেট দিয়ে শুরু করুন';

  @override
  String get overlayPermissionNeeded =>
      'ভাসমান প্রম্পটার ব্যবহার করতে \"অন্য অ্যাপের উপরে দেখান\" অনুমতি দিন।';

  @override
  String get floatingStarted =>
      'প্রম্পটার ভাসছে। ক্যামেরা অ্যাপ খুলুন এবং শুরু করতে টেক্সটে ট্যাপ করুন।';

  @override
  String get floatingNotificationTitle => 'APrompter স্ক্রিনে ভাসছে';

  @override
  String get openScriptInApp => 'APrompter-এ একটি স্ক্রিপ্ট খুলুন';

  @override
  String get script => 'স্ক্রিপ্ট';

  @override
  String get title => 'শিরোনাম';

  @override
  String get status => 'অবস্থা';

  @override
  String get noTarget => 'কোনো লক্ষ্য নেই';

  @override
  String get editorHint =>
      'যা বলতে চান তা লিখুন বা পেস্ট করুন…\n\nটিপ: অংশের জন্য লাইন # দিয়ে, নিজের নোটের জন্য // দিয়ে শুরু করুন।';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $wpm শ/মি-তে $spoken';
  }

  @override
  String get onTarget => 'লক্ষ্যে আছে';

  @override
  String overTarget(int seconds, int words) {
    return '$seconds সে. বেশি · ~$wordsটি শব্দ বাদ দিন';
  }

  @override
  String underTarget(int seconds, int words) {
    return '$seconds সে. বাকি · আরও ~$wordsটি শব্দ';
  }

  @override
  String longSentences(int count) {
    return '$countটি দীর্ঘ বাক্য (২৫+ শব্দ) — শ্বাস নিতে ভেঙে নিন';
  }

  @override
  String get toolSection => 'অংশ';

  @override
  String get toolEmphasis => 'জোর';

  @override
  String get toolPause => 'বিরতি';

  @override
  String get toolNote => 'নোট';

  @override
  String get toolPaste => 'পেস্ট';

  @override
  String get restart => 'আবার শুরু';

  @override
  String get sections => 'অংশগুলো';

  @override
  String get slower => 'ধীরে';

  @override
  String get faster => 'দ্রুত';

  @override
  String get play => 'চালান';

  @override
  String get pause => 'থামান';

  @override
  String get wpmUnit => 'শ/মি';

  @override
  String get startOfScript => 'স্ক্রিপ্টের শুরু';

  @override
  String sectionN(int n) {
    return 'অংশ $n';
  }

  @override
  String get noSectionsHint =>
      'এখনও কোনো অংশ নেই। এডিটরে \"#\" দিয়ে শুরু হওয়া লাইন যোগ করুন (যেমন \"# হুক\") যাতে অংশগুলোর মধ্যে যেতে পারেন এবং শুধু একটি আবার রেকর্ড করতে পারেন।';

  @override
  String get emptyScript => '(খালি স্ক্রিপ্ট)';

  @override
  String get preview => 'প্রিভিউ';

  @override
  String get setup => 'সেটআপ';

  @override
  String get pace => 'গতি';

  @override
  String get text => 'টেক্সট';

  @override
  String get layout => 'লেআউট';

  @override
  String get recording => 'রেকর্ডিং';

  @override
  String get wordsPerMinute => 'শব্দ / মিনিট';

  @override
  String fitTo(String time) {
    return '$time-এ মিলিয়ে নিন';
  }

  @override
  String get paceCalm => 'শান্ত';

  @override
  String get paceNatural => 'স্বাভাবিক';

  @override
  String get paceEnergetic => 'উদ্যমী';

  @override
  String get countdown => 'শুরুর আগে কাউন্টডাউন';

  @override
  String get off => 'বন্ধ';

  @override
  String get size => 'আকার';

  @override
  String get lineSpacing => 'লাইনের ব্যবধান';

  @override
  String get textColor => 'টেক্সটের রং';

  @override
  String get prompterHeight => 'প্রম্পটারের উচ্চতা';

  @override
  String get background => 'পটভূমি';

  @override
  String get readingGuide => 'পড়ার গাইড লাইন';

  @override
  String get mirrorText => 'টেক্সট মিরর করুন';

  @override
  String get mirrorTextHint => 'টেলিপ্রম্পটার কাচ / বিম স্প্লিটারের জন্য';

  @override
  String get videoQuality => 'ভিডিওর মান';

  @override
  String get autoStop => 'স্ক্রিপ্ট শেষ হলে রেকর্ডিং থামান';

  @override
  String get autoStopHint => 'শেষ লাইনের পর ২ সেকেন্ড অপেক্ষা করে';

  @override
  String get presetHandheld => 'হাতে সেলফি';

  @override
  String get presetHandheldHint => 'লেন্সের কাছে মাঝারি টেক্সট';

  @override
  String get presetTripod => 'ট্রাইপড / দূর থেকে';

  @override
  String get presetTripodHint => '১–২ মিটার থেকে পড়া যায় এমন বড় টেক্সট';

  @override
  String get presetGlass => 'টেলিপ্রম্পটার কাচ';

  @override
  String get presetGlassHint => 'মিরর করা, ফুল স্ক্রিন, নিরেট পটভূমি';

  @override
  String get niceRun => 'দারুণ!';

  @override
  String runSummary(String time, int words, int wpm) {
    return '$wordsটি শব্দে আপনার $time লেগেছে → মিনিটে $wpmটি শব্দ।';
  }

  @override
  String runOver(int seconds, String target) {
    return 'এটি আপনার $target লক্ষ্যের চেয়ে $seconds সে. বেশি — স্ক্রিপ্ট ছোট করুন বা দ্রুত বলুন।';
  }

  @override
  String runUnder(int seconds) {
    return 'লক্ষ্যে পৌঁছাতে আপনার হাতে $seconds সে. আছে।';
  }

  @override
  String get runOnTarget => 'একদম লক্ষ্যের সময়ে। 🎯';

  @override
  String get keepCurrent => 'এটাই রাখুন';

  @override
  String useWpm(int wpm) {
    return '$wpm শ/মি ব্যবহার করুন';
  }

  @override
  String get switchCamera => 'ক্যামেরা বদলান';

  @override
  String get startRecording => 'রেকর্ডিং শুরু';

  @override
  String get stopRecording => 'রেকর্ডিং বন্ধ';

  @override
  String get noCamera => 'এই ডিভাইসে কোনো ক্যামেরা পাওয়া যায়নি।';

  @override
  String get cameraDenied =>
      'ক্যামেরা অ্যাক্সেস প্রত্যাখ্যাত হয়েছে। সিস্টেম সেটিংসে চালু করুন।';

  @override
  String cameraError(String message) {
    return 'ক্যামেরা ত্রুটি: $message';
  }

  @override
  String takeSaved(int n) {
    return 'টেক $n গ্যালারিতে সেভ হয়েছে';
  }

  @override
  String get templateBlank => 'খালি';

  @override
  String get templateBlankHint => 'খালি পাতা দিয়ে শুরু করুন';

  @override
  String get templateHvc => 'হুক → ভ্যালু → CTA';

  @override
  String get templateHvcHint => 'ছোট ভিডিওর ক্লাসিক কাঠামো';

  @override
  String get templateTutorial => 'টিউটোরিয়াল';

  @override
  String get templateTutorialHint => 'ধাপে ধাপে কিছু শেখান';

  @override
  String get templateReview => 'পণ্য রিভিউ';

  @override
  String get templateReviewHint => 'UGC, বিজ্ঞাপন ও সৎ রিভিউ';

  @override
  String get templateStory => 'গল্প';

  @override
  String get templateStoryHint => 'শিক্ষাসহ ব্যক্তিগত গল্প';

  @override
  String get secHook => 'হুক';

  @override
  String get secValue => 'ভ্যালু';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'ধাপ $n';
  }

  @override
  String get secRecap => 'সারসংক্ষেপ ও CTA';

  @override
  String get secWhatItIs => 'এটা কী';

  @override
  String get secLoved => 'যা ভালো লেগেছে';

  @override
  String get secBetter => 'যা আরও ভালো হতে পারত';

  @override
  String get secVerdict => 'রায় ও CTA';

  @override
  String get secSetup => 'প্রেক্ষাপট';

  @override
  String get secTurningPoint => 'মোড়';

  @override
  String get secLesson => 'শিক্ষা';

  @override
  String get noteHook => 'প্রথম ৩ সেকেন্ডে মনোযোগ কাড়ুন: সাহসী দাবি বা প্রশ্ন';

  @override
  String get noteValue => 'যে একটি জিনিসের প্রতিশ্রুতি দিয়েছেন সেটি দিন';

  @override
  String get noteCta => 'পরে কী করতে হবে বলুন: ফলো, কমেন্ট, বায়োতে লিংক';

  @override
  String get noteTutorialHook => '\"এক মিনিটের কম সময়ে … করার উপায়\"';

  @override
  String get noteRecap => 'এক বাক্যে সারাংশ বলুন, তারপর ভিডিও সেভ করতে বলুন';

  @override
  String get noteReviewHook => 'পণ্য এবং এটি যে সমস্যা সমাধান করে তা দেখান';

  @override
  String get noteVerdict => 'কার জন্য উপযুক্ত — কোড বা লিংক উল্লেখ করুন';

  @override
  String get noteStoryHook => 'ঘটনার মাঝখান থেকে শুরু করুন';

  @override
  String get welcomeTitle => 'APrompter-এ স্বাগতম';

  @override
  String get welcomeBody =>
      '# হুক\nলাইন না ভুলে ভিডিও করতে চান? [pause]\n// সরাসরি লেন্সের দিকে তাকান\n\n# কীভাবে কাজ করে\nআপনার স্ক্রিপ্ট লিখুন, একটি *লক্ষ্য দৈর্ঘ্য* বেছে নিন, আর টাইমার বলে দেবে এটি মিলছে কি না।\nমিনিটে কত শব্দ বলেন তা জানতে অনুশীলন করুন।\nতারপর রেকর্ড চাপুন। টেক্সট ক্যামেরার ঠিক নিচে চলে, তাই দর্শকের সঙ্গে *চোখের যোগাযোগ* বজায় থাকে।\n\n# CTA\nস্ক্রিপ্ট সম্পাদনা করতে এই কার্ডে ট্যাপ করুন, বা প্লাস বোতাম দিয়ে নিজের স্ক্রিপ্ট তৈরি করুন। [pause] তৈরি করতে মজা নিন!\n';

  @override
  String get expand => 'বড় করুন';

  @override
  String get minimize => 'ছোট করুন';

  @override
  String get nothingToSay =>
      'আগে বলার মতো কিছু যোগ করুন — অংশ (#) ও নোট (//) পড়া হয় না।';

  @override
  String get openSettings => 'সেটিংস খুলুন';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন';

  @override
  String get noMicBanner =>
      'মাইক্রোফোন অ্যাক্সেস নেই — শব্দ ছাড়া রেকর্ড হচ্ছে';

  @override
  String get saveFailedTitle => 'গ্যালারিতে সেভ করা যায়নি';

  @override
  String saveFailedBody(String reason) {
    return 'আপনার টেক আপাতত নিরাপদ। আবার চেষ্টা করুন, অথবা হারিয়ে না যেতে Files, Drive বা কোনো চ্যাটে শেয়ার করুন। ($reason)';
  }

  @override
  String get shareVideo => 'ভিডিও শেয়ার';

  @override
  String get discardTake => 'এই টেক বাদ দিন';

  @override
  String takeShared(int n) {
    return 'টেক $n শেয়ার হয়েছে';
  }

  @override
  String get movePrompter => 'প্রম্পটার সরাতে টানুন';

  @override
  String get resizePrompter => 'প্রম্পটারের আকার বদলাতে টানুন';

  @override
  String get prompterWidth => 'প্রম্পটারের প্রস্থ';

  @override
  String get resetPosition => 'অবস্থান রিসেট (উপরে, পূর্ণ প্রস্থ)';

  @override
  String get positionHint =>
      'প্রম্পটারকে যেকোনো জায়গায় নিতে উপরের বারটি এবং আকার বদলাতে কোণটি টানুন। Android-এ ভাসমান উইন্ডো যেকোনো জায়গায় টানা যায় এবং নিজের জায়গা মনে রাখে।';

  @override
  String get app => 'অ্যাপ';

  @override
  String get appLanguage => 'অ্যাপের ভাষা';

  @override
  String get systemDefault => 'ফোনের ভাষা';

  @override
  String secondsShort(int n) {
    return '$n সে.';
  }

  @override
  String minutesShort(int n) {
    return '$n মি.';
  }
}
