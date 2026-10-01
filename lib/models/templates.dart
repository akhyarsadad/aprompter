import '../l10n/l10n.dart';

/// Starting points for common short-form video formats.
class ScriptTemplate {
  const ScriptTemplate(this.name, this.description, this.body);
  final String name;
  final String description;
  final String body;
}

List<ScriptTemplate> scriptTemplates(AppLocalizations l) {
  String section(String title, [String? note]) =>
      '# $title\n${note != null ? '// $note\n' : ''}\n\n';
  return [
    ScriptTemplate(l.templateBlank, l.templateBlankHint, ''),
    ScriptTemplate(
      l.templateHvc,
      l.templateHvcHint,
      section(l.secHook, l.noteHook) +
          section(l.secValue, l.noteValue) +
          section(l.secCta, l.noteCta),
    ),
    ScriptTemplate(
      l.templateTutorial,
      l.templateTutorialHint,
      section(l.secHook, l.noteTutorialHook) +
          section(l.secStep(1)) +
          section(l.secStep(2)) +
          section(l.secStep(3)) +
          section(l.secRecap, l.noteRecap),
    ),
    ScriptTemplate(
      l.templateReview,
      l.templateReviewHint,
      section(l.secHook, l.noteReviewHook) +
          section(l.secWhatItIs) +
          section(l.secLoved) +
          section(l.secBetter) +
          section(l.secVerdict, l.noteVerdict),
    ),
    ScriptTemplate(
      l.templateStory,
      l.templateStoryHint,
      section(l.secHook, l.noteStoryHook) +
          section(l.secSetup) +
          section(l.secTurningPoint) +
          section(l.secLesson) +
          section(l.secCta),
    ),
  ];
}

/// Target video lengths offered when writing a script, in seconds.
const targetLengths = <int>[15, 30, 60, 90, 180];

String targetLabel(AppLocalizations l, int seconds) =>
    seconds < 60 || seconds % 60 != 0
    ? l.secondsShort(seconds)
    : l.minutesShort(seconds ~/ 60);
