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
  String get cancel => 'Cancel';

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
  String get deleteScriptTitle => 'Delete script?';

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
  String get pinchToResize => 'Pinch to resize text';

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
  String get micDenied =>
      'Microphone access was denied. Enable it in system settings.';

  @override
  String cameraError(String message) {
    return 'Camera error: $message';
  }

  @override
  String takeSaved(int n) {
    return 'Take $n saved to your gallery';
  }

  @override
  String saveFailed(String message) {
    return 'Could not save video: $message';
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
}
