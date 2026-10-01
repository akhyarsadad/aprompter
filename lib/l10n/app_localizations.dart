import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'APrompter'**
  String get appTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @prompterSettings.
  ///
  /// In en, this message translates to:
  /// **'Prompter settings'**
  String get prompterSettings;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @duplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @copyAsCaption.
  ///
  /// In en, this message translates to:
  /// **'Copy as caption'**
  String get copyAsCaption;

  /// No description provided for @captionCopied.
  ///
  /// In en, this message translates to:
  /// **'Spoken text copied — paste it as your caption'**
  String get captionCopied;

  /// No description provided for @copySuffix.
  ///
  /// In en, this message translates to:
  /// **'(copy)'**
  String get copySuffix;

  /// No description provided for @deletedScript.
  ///
  /// In en, this message translates to:
  /// **'Deleted \"{title}\"'**
  String deletedScript(String title);

  /// No description provided for @duplicatedScript.
  ///
  /// In en, this message translates to:
  /// **'Duplicated as \"{title}\"'**
  String duplicatedScript(String title);

  /// No description provided for @untitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get untitled;

  /// No description provided for @newScript.
  ///
  /// In en, this message translates to:
  /// **'New script'**
  String get newScript;

  /// No description provided for @searchScripts.
  ///
  /// In en, this message translates to:
  /// **'Search scripts'**
  String get searchScripts;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @statusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get statusDraft;

  /// No description provided for @statusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get statusReady;

  /// No description provided for @statusRecorded.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get statusRecorded;

  /// No description provided for @markAs.
  ///
  /// In en, this message translates to:
  /// **'Mark as {status}'**
  String markAs(String status);

  /// No description provided for @filterCount.
  ///
  /// In en, this message translates to:
  /// **'{label} ({count})'**
  String filterCount(String label, int count);

  /// No description provided for @rehearse.
  ///
  /// In en, this message translates to:
  /// **'Rehearse'**
  String get rehearse;

  /// No description provided for @float.
  ///
  /// In en, this message translates to:
  /// **'Float'**
  String get float;

  /// No description provided for @record.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get record;

  /// No description provided for @words.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 word} other{{count} words}}'**
  String words(int count);

  /// No description provided for @takes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 take} other{{count} takes}}'**
  String takes(int count);

  /// No description provided for @noScriptsYet.
  ///
  /// In en, this message translates to:
  /// **'No scripts yet'**
  String get noScriptsYet;

  /// No description provided for @noScriptsHint.
  ///
  /// In en, this message translates to:
  /// **'Tap \"New script\" and pick a template to get started.'**
  String get noScriptsHint;

  /// No description provided for @nothingHere.
  ///
  /// In en, this message translates to:
  /// **'Nothing here'**
  String get nothingHere;

  /// No description provided for @nothingHereHint.
  ///
  /// In en, this message translates to:
  /// **'Try another filter or search.'**
  String get nothingHereHint;

  /// No description provided for @startFromTemplate.
  ///
  /// In en, this message translates to:
  /// **'Start from a template'**
  String get startFromTemplate;

  /// No description provided for @overlayPermissionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Allow \"Display over other apps\" to use the floating prompter.'**
  String get overlayPermissionNeeded;

  /// No description provided for @floatingStarted.
  ///
  /// In en, this message translates to:
  /// **'Prompter is floating. Open your camera app and tap the text to start.'**
  String get floatingStarted;

  /// No description provided for @floatingNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'APrompter is floating'**
  String get floatingNotificationTitle;

  /// No description provided for @openScriptInApp.
  ///
  /// In en, this message translates to:
  /// **'Open a script in APrompter'**
  String get openScriptInApp;

  /// No description provided for @deleteScriptTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete script?'**
  String get deleteScriptTitle;

  /// No description provided for @script.
  ///
  /// In en, this message translates to:
  /// **'Script'**
  String get script;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @noTarget.
  ///
  /// In en, this message translates to:
  /// **'No target'**
  String get noTarget;

  /// No description provided for @editorHint.
  ///
  /// In en, this message translates to:
  /// **'Write or paste what you want to say…\n\nTip: start a line with # for a section, // for a note to yourself.'**
  String get editorHint;

  /// No description provided for @timing.
  ///
  /// In en, this message translates to:
  /// **'{words} · {spoken} at {wpm} wpm'**
  String timing(String words, String spoken, int wpm);

  /// No description provided for @onTarget.
  ///
  /// In en, this message translates to:
  /// **'On target'**
  String get onTarget;

  /// No description provided for @overTarget.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s over · cut ~{words} words'**
  String overTarget(int seconds, int words);

  /// No description provided for @underTarget.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s left · ~{words} words to go'**
  String underTarget(int seconds, int words);

  /// No description provided for @longSentences.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 long sentence (25+ words) — split it so you can breathe} other{{count} long sentences (25+ words) — split them so you can breathe}}'**
  String longSentences(int count);

  /// No description provided for @toolSection.
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get toolSection;

  /// No description provided for @toolEmphasis.
  ///
  /// In en, this message translates to:
  /// **'Emphasis'**
  String get toolEmphasis;

  /// No description provided for @toolPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get toolPause;

  /// No description provided for @toolNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get toolNote;

  /// No description provided for @toolPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get toolPaste;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @sections.
  ///
  /// In en, this message translates to:
  /// **'Sections'**
  String get sections;

  /// No description provided for @slower.
  ///
  /// In en, this message translates to:
  /// **'Slower'**
  String get slower;

  /// No description provided for @faster.
  ///
  /// In en, this message translates to:
  /// **'Faster'**
  String get faster;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @wpmUnit.
  ///
  /// In en, this message translates to:
  /// **'wpm'**
  String get wpmUnit;

  /// No description provided for @startOfScript.
  ///
  /// In en, this message translates to:
  /// **'Start of script'**
  String get startOfScript;

  /// No description provided for @sectionN.
  ///
  /// In en, this message translates to:
  /// **'Section {n}'**
  String sectionN(int n);

  /// No description provided for @noSectionsHint.
  ///
  /// In en, this message translates to:
  /// **'No sections yet. Add lines starting with \"#\" in the editor (e.g. \"# Hook\") to jump between parts and retake just one.'**
  String get noSectionsHint;

  /// No description provided for @emptyScript.
  ///
  /// In en, this message translates to:
  /// **'(empty script)'**
  String get emptyScript;

  /// No description provided for @pinchToResize.
  ///
  /// In en, this message translates to:
  /// **'Pinch to resize text'**
  String get pinchToResize;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @setup.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get setup;

  /// No description provided for @pace.
  ///
  /// In en, this message translates to:
  /// **'Pace'**
  String get pace;

  /// No description provided for @text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get text;

  /// No description provided for @layout.
  ///
  /// In en, this message translates to:
  /// **'Layout'**
  String get layout;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording'**
  String get recording;

  /// No description provided for @wordsPerMinute.
  ///
  /// In en, this message translates to:
  /// **'words / min'**
  String get wordsPerMinute;

  /// No description provided for @fitTo.
  ///
  /// In en, this message translates to:
  /// **'Fit to {time}'**
  String fitTo(String time);

  /// No description provided for @paceCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get paceCalm;

  /// No description provided for @paceNatural.
  ///
  /// In en, this message translates to:
  /// **'Natural'**
  String get paceNatural;

  /// No description provided for @paceEnergetic.
  ///
  /// In en, this message translates to:
  /// **'Energetic'**
  String get paceEnergetic;

  /// No description provided for @countdown.
  ///
  /// In en, this message translates to:
  /// **'Countdown before start'**
  String get countdown;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @lineSpacing.
  ///
  /// In en, this message translates to:
  /// **'Line spacing'**
  String get lineSpacing;

  /// No description provided for @textColor.
  ///
  /// In en, this message translates to:
  /// **'Text color'**
  String get textColor;

  /// No description provided for @prompterHeight.
  ///
  /// In en, this message translates to:
  /// **'Prompter height'**
  String get prompterHeight;

  /// No description provided for @background.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get background;

  /// No description provided for @readingGuide.
  ///
  /// In en, this message translates to:
  /// **'Reading guide line'**
  String get readingGuide;

  /// No description provided for @mirrorText.
  ///
  /// In en, this message translates to:
  /// **'Mirror text'**
  String get mirrorText;

  /// No description provided for @mirrorTextHint.
  ///
  /// In en, this message translates to:
  /// **'For teleprompter glass / beam splitter'**
  String get mirrorTextHint;

  /// No description provided for @videoQuality.
  ///
  /// In en, this message translates to:
  /// **'Video quality'**
  String get videoQuality;

  /// No description provided for @autoStop.
  ///
  /// In en, this message translates to:
  /// **'Stop recording when the script ends'**
  String get autoStop;

  /// No description provided for @autoStopHint.
  ///
  /// In en, this message translates to:
  /// **'Waits 2 seconds after the last line'**
  String get autoStopHint;

  /// No description provided for @presetHandheld.
  ///
  /// In en, this message translates to:
  /// **'Handheld selfie'**
  String get presetHandheld;

  /// No description provided for @presetHandheldHint.
  ///
  /// In en, this message translates to:
  /// **'Medium text close to the lens'**
  String get presetHandheldHint;

  /// No description provided for @presetTripod.
  ///
  /// In en, this message translates to:
  /// **'Tripod / distance'**
  String get presetTripod;

  /// No description provided for @presetTripodHint.
  ///
  /// In en, this message translates to:
  /// **'Big text you can read from 1–2 m'**
  String get presetTripodHint;

  /// No description provided for @presetGlass.
  ///
  /// In en, this message translates to:
  /// **'Teleprompter glass'**
  String get presetGlass;

  /// No description provided for @presetGlassHint.
  ///
  /// In en, this message translates to:
  /// **'Mirrored, full screen, solid background'**
  String get presetGlassHint;

  /// No description provided for @niceRun.
  ///
  /// In en, this message translates to:
  /// **'Nice run!'**
  String get niceRun;

  /// No description provided for @runSummary.
  ///
  /// In en, this message translates to:
  /// **'You took {time} for {words} words → {wpm} words per minute.'**
  String runSummary(String time, int words, int wpm);

  /// No description provided for @runOver.
  ///
  /// In en, this message translates to:
  /// **'That is {seconds}s over your {target} target — trim the script or speed up.'**
  String runOver(int seconds, String target);

  /// No description provided for @runUnder.
  ///
  /// In en, this message translates to:
  /// **'You have {seconds}s of room before your target.'**
  String runUnder(int seconds);

  /// No description provided for @runOnTarget.
  ///
  /// In en, this message translates to:
  /// **'Right on your target length. 🎯'**
  String get runOnTarget;

  /// No description provided for @keepCurrent.
  ///
  /// In en, this message translates to:
  /// **'Keep current'**
  String get keepCurrent;

  /// No description provided for @useWpm.
  ///
  /// In en, this message translates to:
  /// **'Use {wpm} wpm'**
  String useWpm(int wpm);

  /// No description provided for @switchCamera.
  ///
  /// In en, this message translates to:
  /// **'Switch camera'**
  String get switchCamera;

  /// No description provided for @startRecording.
  ///
  /// In en, this message translates to:
  /// **'Start recording'**
  String get startRecording;

  /// No description provided for @stopRecording.
  ///
  /// In en, this message translates to:
  /// **'Stop recording'**
  String get stopRecording;

  /// No description provided for @noCamera.
  ///
  /// In en, this message translates to:
  /// **'No camera found on this device.'**
  String get noCamera;

  /// No description provided for @cameraDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera access was denied. Enable it in system settings.'**
  String get cameraDenied;

  /// No description provided for @micDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone access was denied. Enable it in system settings.'**
  String get micDenied;

  /// No description provided for @cameraError.
  ///
  /// In en, this message translates to:
  /// **'Camera error: {message}'**
  String cameraError(String message);

  /// No description provided for @takeSaved.
  ///
  /// In en, this message translates to:
  /// **'Take {n} saved to your gallery'**
  String takeSaved(int n);

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save video: {message}'**
  String saveFailed(String message);

  /// No description provided for @templateBlank.
  ///
  /// In en, this message translates to:
  /// **'Blank'**
  String get templateBlank;

  /// No description provided for @templateBlankHint.
  ///
  /// In en, this message translates to:
  /// **'Start from an empty page'**
  String get templateBlankHint;

  /// No description provided for @templateHvc.
  ///
  /// In en, this message translates to:
  /// **'Hook → Value → CTA'**
  String get templateHvc;

  /// No description provided for @templateHvcHint.
  ///
  /// In en, this message translates to:
  /// **'The classic short-form structure'**
  String get templateHvcHint;

  /// No description provided for @templateTutorial.
  ///
  /// In en, this message translates to:
  /// **'Tutorial'**
  String get templateTutorial;

  /// No description provided for @templateTutorialHint.
  ///
  /// In en, this message translates to:
  /// **'Teach something step by step'**
  String get templateTutorialHint;

  /// No description provided for @templateReview.
  ///
  /// In en, this message translates to:
  /// **'Product review'**
  String get templateReview;

  /// No description provided for @templateReviewHint.
  ///
  /// In en, this message translates to:
  /// **'UGC, ad reads and honest reviews'**
  String get templateReviewHint;

  /// No description provided for @templateStory.
  ///
  /// In en, this message translates to:
  /// **'Storytime'**
  String get templateStory;

  /// No description provided for @templateStoryHint.
  ///
  /// In en, this message translates to:
  /// **'Personal story with a lesson'**
  String get templateStoryHint;

  /// No description provided for @secHook.
  ///
  /// In en, this message translates to:
  /// **'Hook'**
  String get secHook;

  /// No description provided for @secValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get secValue;

  /// No description provided for @secCta.
  ///
  /// In en, this message translates to:
  /// **'CTA'**
  String get secCta;

  /// No description provided for @secStep.
  ///
  /// In en, this message translates to:
  /// **'Step {n}'**
  String secStep(int n);

  /// No description provided for @secRecap.
  ///
  /// In en, this message translates to:
  /// **'Recap & CTA'**
  String get secRecap;

  /// No description provided for @secWhatItIs.
  ///
  /// In en, this message translates to:
  /// **'What it is'**
  String get secWhatItIs;

  /// No description provided for @secLoved.
  ///
  /// In en, this message translates to:
  /// **'What I loved'**
  String get secLoved;

  /// No description provided for @secBetter.
  ///
  /// In en, this message translates to:
  /// **'What could be better'**
  String get secBetter;

  /// No description provided for @secVerdict.
  ///
  /// In en, this message translates to:
  /// **'Verdict & CTA'**
  String get secVerdict;

  /// No description provided for @secSetup.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get secSetup;

  /// No description provided for @secTurningPoint.
  ///
  /// In en, this message translates to:
  /// **'Turning point'**
  String get secTurningPoint;

  /// No description provided for @secLesson.
  ///
  /// In en, this message translates to:
  /// **'Lesson'**
  String get secLesson;

  /// No description provided for @noteHook.
  ///
  /// In en, this message translates to:
  /// **'Grab attention in the first 3 seconds: a bold claim or question'**
  String get noteHook;

  /// No description provided for @noteValue.
  ///
  /// In en, this message translates to:
  /// **'Deliver the one thing you promised'**
  String get noteValue;

  /// No description provided for @noteCta.
  ///
  /// In en, this message translates to:
  /// **'Tell them what to do next: follow, comment, link in bio'**
  String get noteCta;

  /// No description provided for @noteTutorialHook.
  ///
  /// In en, this message translates to:
  /// **'\"Here\'s how to … in under a minute\"'**
  String get noteTutorialHook;

  /// No description provided for @noteRecap.
  ///
  /// In en, this message translates to:
  /// **'Summarise in one line, then ask them to save the video'**
  String get noteRecap;

  /// No description provided for @noteReviewHook.
  ///
  /// In en, this message translates to:
  /// **'Show the product and the problem it solves'**
  String get noteReviewHook;

  /// No description provided for @noteVerdict.
  ///
  /// In en, this message translates to:
  /// **'Who should buy it — mention the code or link'**
  String get noteVerdict;

  /// No description provided for @noteStoryHook.
  ///
  /// In en, this message translates to:
  /// **'Start in the middle of the action'**
  String get noteStoryHook;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to APrompter'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'# Hook\nWant to film without forgetting your lines? [pause]\n// look straight into the lens\n\n# How it works\nWrite your script, pick a *target length*, and watch the timer tell you if it fits.\nRehearse to find your pace in words per minute.\nThen hit Record. The text scrolls right under the camera, so you keep *eye contact* with your audience.\n\n# CTA\nTap this card to edit the script, or create your own with the plus button. [pause] Have fun creating!\n'**
  String get welcomeBody;

  /// No description provided for @expand.
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get expand;

  /// No description provided for @minimize.
  ///
  /// In en, this message translates to:
  /// **'Minimize'**
  String get minimize;

  /// No description provided for @nothingToSay.
  ///
  /// In en, this message translates to:
  /// **'Add some lines to say first — sections (#) and notes (//) aren\'t read out.'**
  String get nothingToSay;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @noMicBanner.
  ///
  /// In en, this message translates to:
  /// **'No microphone access — recording without sound'**
  String get noMicBanner;

  /// No description provided for @saveFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save to your gallery'**
  String get saveFailedTitle;

  /// No description provided for @saveFailedBody.
  ///
  /// In en, this message translates to:
  /// **'Your take is safe for now. Try again, or share it to Files, Drive or a chat so you don\'t lose it. ({reason})'**
  String saveFailedBody(String reason);

  /// No description provided for @shareVideo.
  ///
  /// In en, this message translates to:
  /// **'Share video'**
  String get shareVideo;

  /// No description provided for @discardTake.
  ///
  /// In en, this message translates to:
  /// **'Discard this take'**
  String get discardTake;

  /// No description provided for @takeShared.
  ///
  /// In en, this message translates to:
  /// **'Take {n} shared'**
  String takeShared(int n);

  /// No description provided for @movePrompter.
  ///
  /// In en, this message translates to:
  /// **'Drag to move the prompter'**
  String get movePrompter;

  /// No description provided for @resizePrompter.
  ///
  /// In en, this message translates to:
  /// **'Drag to resize the prompter'**
  String get resizePrompter;

  /// No description provided for @prompterWidth.
  ///
  /// In en, this message translates to:
  /// **'Prompter width'**
  String get prompterWidth;

  /// No description provided for @resetPosition.
  ///
  /// In en, this message translates to:
  /// **'Reset position (top, full width)'**
  String get resetPosition;

  /// No description provided for @positionHint.
  ///
  /// In en, this message translates to:
  /// **'Drag the bar on top of the prompter to move it anywhere, and the corner to resize. On Android the floating window can be dragged anywhere and remembers its spot.'**
  String get positionHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
