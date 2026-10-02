// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'APrompter';

  @override
  String get close => 'Close';

  @override
  String get settings => 'Settings';

  @override
  String get prompterSettings => 'Prompter settings';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get undo => 'Undo';

  @override
  String get duplicate => 'Duplicate';

  @override
  String get share => 'Share';

  @override
  String get copyAsCaption => 'Copy as caption';

  @override
  String get captionCopied => 'Spoken text copied — paste it as your caption';

  @override
  String get copySuffix => '(copy)';

  @override
  String deletedScript(String title) {
    return 'Deleted \"$title\"';
  }

  @override
  String duplicatedScript(String title) {
    return 'Duplicated as \"$title\"';
  }

  @override
  String get untitled => 'Untitled';

  @override
  String get newScript => 'New script';

  @override
  String get searchScripts => 'Search scripts';

  @override
  String get filterAll => 'All';

  @override
  String get statusDraft => 'Draft';

  @override
  String get statusReady => 'Ready';

  @override
  String get statusRecorded => 'Recorded';

  @override
  String markAs(String status) {
    return 'Mark as $status';
  }

  @override
  String filterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get rehearse => 'Rehearse';

  @override
  String get float => 'Float';

  @override
  String get record => 'Record';

  @override
  String words(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count words',
      one: '1 word',
    );
    return '$_temp0';
  }

  @override
  String takes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count takes',
      one: '1 take',
    );
    return '$_temp0';
  }

  @override
  String get noScriptsYet => 'No scripts yet';

  @override
  String get noScriptsHint =>
      'Tap \"New script\" and pick a template to get started.';

  @override
  String get nothingHere => 'Nothing here';

  @override
  String get nothingHereHint => 'Try another filter or search.';

  @override
  String get startFromTemplate => 'Start from a template';

  @override
  String get overlayPermissionNeeded =>
      'Allow \"Display over other apps\" to use the floating prompter.';

  @override
  String get floatingStarted =>
      'Prompter is floating. Open your camera app and tap the text to start.';

  @override
  String get floatingNotificationTitle => 'APrompter is floating';

  @override
  String get openScriptInApp => 'Open a script in APrompter';

  @override
  String get script => 'Script';

  @override
  String get title => 'Title';

  @override
  String get status => 'Status';

  @override
  String get noTarget => 'No target';

  @override
  String get editorHint =>
      'Write or paste what you want to say…\n\nTip: start a line with # for a section, // for a note to yourself.';

  @override
  String timing(String words, String spoken, int wpm) {
    return '$words · $spoken at $wpm wpm';
  }

  @override
  String get onTarget => 'On target';

  @override
  String overTarget(int seconds, int words) {
    return '${seconds}s over · cut ~$words words';
  }

  @override
  String underTarget(int seconds, int words) {
    return '${seconds}s left · ~$words words to go';
  }

  @override
  String longSentences(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count long sentences (25+ words) — split them so you can breathe',
      one: '1 long sentence (25+ words) — split it so you can breathe',
    );
    return '$_temp0';
  }

  @override
  String get toolSection => 'Section';

  @override
  String get toolEmphasis => 'Emphasis';

  @override
  String get toolPause => 'Pause';

  @override
  String get toolNote => 'Note';

  @override
  String get toolPaste => 'Paste';

  @override
  String get restart => 'Restart';

  @override
  String get sections => 'Sections';

  @override
  String get slower => 'Slower';

  @override
  String get faster => 'Faster';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get wpmUnit => 'wpm';

  @override
  String get startOfScript => 'Start of script';

  @override
  String sectionN(int n) {
    return 'Section $n';
  }

  @override
  String get noSectionsHint =>
      'No sections yet. Add lines starting with \"#\" in the editor (e.g. \"# Hook\") to jump between parts and retake just one.';

  @override
  String get emptyScript => '(empty script)';

  @override
  String get preview => 'Preview';

  @override
  String get setup => 'Setup';

  @override
  String get pace => 'Pace';

  @override
  String get text => 'Text';

  @override
  String get layout => 'Layout';

  @override
  String get recording => 'Recording';

  @override
  String get wordsPerMinute => 'words / min';

  @override
  String fitTo(String time) {
    return 'Fit to $time';
  }

  @override
  String get paceCalm => 'Calm';

  @override
  String get paceNatural => 'Natural';

  @override
  String get paceEnergetic => 'Energetic';

  @override
  String get countdown => 'Countdown before start';

  @override
  String get off => 'Off';

  @override
  String get size => 'Size';

  @override
  String get lineSpacing => 'Line spacing';

  @override
  String get textColor => 'Text color';

  @override
  String get prompterHeight => 'Prompter height';

  @override
  String get background => 'Background';

  @override
  String get readingGuide => 'Reading guide line';

  @override
  String get mirrorText => 'Mirror text';

  @override
  String get mirrorTextHint => 'For teleprompter glass / beam splitter';

  @override
  String get videoQuality => 'Video quality';

  @override
  String get autoStop => 'Stop recording when the script ends';

  @override
  String get autoStopHint => 'Waits 2 seconds after the last line';

  @override
  String get presetHandheld => 'Handheld selfie';

  @override
  String get presetHandheldHint => 'Medium text close to the lens';

  @override
  String get presetTripod => 'Tripod / distance';

  @override
  String get presetTripodHint => 'Big text you can read from 1–2 m';

  @override
  String get presetGlass => 'Teleprompter glass';

  @override
  String get presetGlassHint => 'Mirrored, full screen, solid background';

  @override
  String get niceRun => 'Nice run!';

  @override
  String runSummary(String time, int words, int wpm) {
    return 'You took $time for $words words → $wpm words per minute.';
  }

  @override
  String runOver(int seconds, String target) {
    return 'That is ${seconds}s over your $target target — trim the script or speed up.';
  }

  @override
  String runUnder(int seconds) {
    return 'You have ${seconds}s of room before your target.';
  }

  @override
  String get runOnTarget => 'Right on your target length. 🎯';

  @override
  String get keepCurrent => 'Keep current';

  @override
  String useWpm(int wpm) {
    return 'Use $wpm wpm';
  }

  @override
  String get switchCamera => 'Switch camera';

  @override
  String get startRecording => 'Start recording';

  @override
  String get stopRecording => 'Stop recording';

  @override
  String get noCamera => 'No camera found on this device.';

  @override
  String get cameraDenied =>
      'Camera access was denied. Enable it in system settings.';

  @override
  String cameraError(String message) {
    return 'Camera error: $message';
  }

  @override
  String takeSaved(int n) {
    return 'Take $n saved to your gallery';
  }

  @override
  String get templateBlank => 'Blank';

  @override
  String get templateBlankHint => 'Start from an empty page';

  @override
  String get templateHvc => 'Hook → Value → CTA';

  @override
  String get templateHvcHint => 'The classic short-form structure';

  @override
  String get templateTutorial => 'Tutorial';

  @override
  String get templateTutorialHint => 'Teach something step by step';

  @override
  String get templateReview => 'Product review';

  @override
  String get templateReviewHint => 'UGC, ad reads and honest reviews';

  @override
  String get templateStory => 'Storytime';

  @override
  String get templateStoryHint => 'Personal story with a lesson';

  @override
  String get secHook => 'Hook';

  @override
  String get secValue => 'Value';

  @override
  String get secCta => 'CTA';

  @override
  String secStep(int n) {
    return 'Step $n';
  }

  @override
  String get secRecap => 'Recap & CTA';

  @override
  String get secWhatItIs => 'What it is';

  @override
  String get secLoved => 'What I loved';

  @override
  String get secBetter => 'What could be better';

  @override
  String get secVerdict => 'Verdict & CTA';

  @override
  String get secSetup => 'Setup';

  @override
  String get secTurningPoint => 'Turning point';

  @override
  String get secLesson => 'Lesson';

  @override
  String get noteHook =>
      'Grab attention in the first 3 seconds: a bold claim or question';

  @override
  String get noteValue => 'Deliver the one thing you promised';

  @override
  String get noteCta =>
      'Tell them what to do next: follow, comment, link in bio';

  @override
  String get noteTutorialHook => '\"Here\'s how to … in under a minute\"';

  @override
  String get noteRecap =>
      'Summarise in one line, then ask them to save the video';

  @override
  String get noteReviewHook => 'Show the product and the problem it solves';

  @override
  String get noteVerdict => 'Who should buy it — mention the code or link';

  @override
  String get noteStoryHook => 'Start in the middle of the action';

  @override
  String get welcomeTitle => 'Welcome to APrompter';

  @override
  String get welcomeBody =>
      '# Hook\nWant to film without forgetting your lines? [pause]\n// look straight into the lens\n\n# How it works\nWrite your script, pick a *target length*, and watch the timer tell you if it fits.\nRehearse to find your pace in words per minute.\nThen hit Record. The text scrolls right under the camera, so you keep *eye contact* with your audience.\n\n# CTA\nTap this card to edit the script, or create your own with the plus button. [pause] Have fun creating!\n';

  @override
  String get expand => 'Expand';

  @override
  String get minimize => 'Minimize';

  @override
  String get nothingToSay =>
      'Add some lines to say first — sections (#) and notes (//) aren\'t read out.';

  @override
  String get openSettings => 'Open settings';

  @override
  String get tryAgain => 'Try again';

  @override
  String get noMicBanner => 'No microphone access — recording without sound';

  @override
  String get saveFailedTitle => 'Couldn\'t save to your gallery';

  @override
  String saveFailedBody(String reason) {
    return 'Your take is safe for now. Try again, or share it to Files, Drive or a chat so you don\'t lose it. ($reason)';
  }

  @override
  String get shareVideo => 'Share video';

  @override
  String get discardTake => 'Discard this take';

  @override
  String takeShared(int n) {
    return 'Take $n shared';
  }

  @override
  String get movePrompter => 'Drag to move the prompter';

  @override
  String get resizePrompter => 'Drag to resize the prompter';

  @override
  String get prompterWidth => 'Prompter width';

  @override
  String get resetPosition => 'Reset position (top, full width)';

  @override
  String get positionHint =>
      'Drag the bar on top of the prompter to move it anywhere, and the corner to resize. On Android the floating window can be dragged anywhere and remembers its spot.';

  @override
  String get app => 'App';

  @override
  String get appLanguage => 'App language';

  @override
  String get systemDefault => 'Phone language';

  @override
  String secondsShort(int n) {
    return '${n}s';
  }

  @override
  String minutesShort(int n) {
    return '$n min';
  }

  @override
  String get storageSaveFailed =>
      'Couldn\'t save — your phone may be out of storage. Your work is kept while the app stays open.';

  @override
  String get versionHistory => 'Version history';

  @override
  String get noVersions =>
      'No earlier versions yet. They are kept automatically while you write.';

  @override
  String get restore => 'Restore';

  @override
  String get versionRestored => 'Earlier version restored';

  @override
  String get recentlyDeleted => 'Recently deleted';

  @override
  String trashHint(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Deleted scripts stay here for $days days.',
      one: 'Deleted scripts stay here for 1 day.',
    );
    return '$_temp0';
  }

  @override
  String get deleteForever => 'Delete forever';

  @override
  String deletedOn(String date) {
    return 'Deleted $date';
  }

  @override
  String restoredScript(String title) {
    return 'Restored \"$title\"';
  }

  @override
  String get backUpScripts => 'Back up all scripts';

  @override
  String get restoreBackup => 'Restore from a backup';

  @override
  String get backupShareTitle => 'APrompter backup';

  @override
  String importedScripts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count scripts restored',
      one: '1 script restored',
      zero: 'Everything in this backup is already here',
    );
    return '$_temp0';
  }

  @override
  String get notABackup => 'That file isn\'t an APrompter backup.';

  @override
  String fitImpossible(int wpm, String target, int words) {
    return 'Even at $wpm wpm this won\'t fit $target — cut about $words words.';
  }

  @override
  String get cameraNotReady =>
      'The camera wasn\'t ready, so recording didn\'t start. Try again.';

  @override
  String get previousSection => 'Previous section';

  @override
  String get nextSection => 'Next section';

  @override
  String get floatingNotificationBody => 'Tap to open APrompter';

  @override
  String get customTarget => 'Custom…';

  @override
  String get customTargetTitle => 'Target length';

  @override
  String get customTargetHint => 'Minutes and seconds, e.g. 5:00';

  @override
  String get saved => 'Saved';

  @override
  String get floatNotOnIos =>
      'iPhone doesn\'t let apps float over other apps. Use Record to film with the script under the camera.';

  @override
  String get hashtagHint =>
      'Hashtag lines (#fyp #ad) are shown dimmed and not timed. Use \"# \" with a space for a section.';

  @override
  String get appLock => 'App lock';

  @override
  String get appLockHint =>
      'Ask for fingerprint, face or phone PIN to open APrompter';

  @override
  String get appLockUnavailable => 'Set up a screen lock on this phone first.';

  @override
  String get unlock => 'Unlock';

  @override
  String get unlockReason => 'Unlock APrompter to see your scripts';

  @override
  String get autoStopWait => 'Wait after the last line';

  @override
  String get beforeYouRecord => 'Before you record';

  @override
  String get recordAnyway => 'Record anyway';

  @override
  String lowStorageWarning(int minutes) {
    return 'Only about $minutes min of video fits in your free space. Free up space or lower the video quality.';
  }

  @override
  String lowBatteryWarning(int level) {
    return 'Battery is at $level% — a long take may get cut off. Plug in if you can.';
  }

  @override
  String get brightScreen => 'Full brightness while prompting';

  @override
  String get brightScreenHint => 'Easier to read outdoors';

  @override
  String get cameraBusy =>
      'Another app is using the camera. Close it and try again.';

  @override
  String get cameraIntroTitle => 'Camera and microphone';

  @override
  String get cameraIntroBody =>
      'To film you with the script on screen, APrompter needs your camera and microphone. Your phone will ask next. Videos stay on your phone.';

  @override
  String get continueLabel => 'Continue';

  @override
  String get notNow => 'Not now';

  @override
  String get colorWhite => 'White';

  @override
  String get colorYellow => 'Yellow';

  @override
  String get colorGreen => 'Green';

  @override
  String get colorBlue => 'Blue';

  @override
  String get colorPink => 'Pink';

  @override
  String get colorBlack => 'Black';

  @override
  String get damagedData => 'Unreadable data';

  @override
  String damagedDataHint(String date, int size) {
    return 'Kept aside on $date · $size characters';
  }

  @override
  String get tryToRecover => 'Try to recover';

  @override
  String get nothingRecovered => 'No scripts could be read from it.';

  @override
  String get floatLowRam =>
      'This phone can\'t show apps over other apps (low-memory or Android Go phone). Use Record instead.';

  @override
  String get oemTipsTitle => 'Keep the floating prompter alive';

  @override
  String oemTipsBody(String brand) {
    return '$brand phones may close floating windows to save battery. In Settings → Apps → APrompter: allow display over other apps (and pop-up windows), set battery to \"No restrictions\", and allow notifications.';
  }

  @override
  String get focusLine => 'Focus on the current line';

  @override
  String get focusLineHint => 'Dims the other lines';

  @override
  String get stepByLine => 'Line by line';

  @override
  String get stepByLineHint =>
      'Each tap or remote press moves one line — no automatic scrolling';

  @override
  String get reduceEffects => 'Reduce effects';

  @override
  String get reduceEffectsHint =>
      'No fades or shadows: smoother on older phones, saves battery';

  @override
  String get letterSpacing => 'Letter spacing';

  @override
  String get importTextFile => 'Import a text file';

  @override
  String get importTextFileHint =>
      'A .txt or .md script from Files, Drive or email';

  @override
  String get importTextFailed =>
      'Couldn\'t read that file. Pick a plain text (.txt) file.';

  @override
  String get mySetup => 'My setup';

  @override
  String get mySetupHint => 'The setup you saved';

  @override
  String get saveMySetup => 'Save as my setup';

  @override
  String get resetAllSettings => 'Reset all settings';

  @override
  String get runHadJumps =>
      'You skipped around during this run, so it can\'t suggest a pace.';

  @override
  String get keepTake => 'Keep';

  @override
  String get retake => 'Retake';

  @override
  String get reviewTakes => 'Review each take';

  @override
  String get reviewTakesHint => 'Watch it, then keep it or go again';

  @override
  String get takesToGallery => 'Save takes to the gallery';

  @override
  String get takesToGalleryHint =>
      'Off: takes stay inside the app, out of Google Photos and iCloud';

  @override
  String get takesTitle => 'Takes';

  @override
  String get takesEmpty =>
      'Takes kept inside the app show up here. Turn off \"Save takes to the gallery\" in settings to keep them here.';

  @override
  String get saveToGallery => 'Save to gallery';

  @override
  String get savedToGallery => 'Saved to your gallery';

  @override
  String get deleteTake => 'Delete take';

  @override
  String takeKeptInApp(int n) {
    return 'Take $n kept in the app';
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
