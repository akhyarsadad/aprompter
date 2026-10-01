/// Starting points for common short-form video formats.
class ScriptTemplate {
  const ScriptTemplate(this.name, this.description, this.body);
  final String name;
  final String description;
  final String body;
}

const scriptTemplates = <ScriptTemplate>[
  ScriptTemplate('Blank', 'Start from an empty page', ''),
  ScriptTemplate(
    'Hook → Value → CTA',
    'The classic short-form structure',
    '# Hook\n'
        '// Grab attention in the first 3 seconds: a bold claim or question\n'
        '\n\n'
        '# Value\n'
        '// Deliver the one thing you promised\n'
        '\n\n'
        '# CTA\n'
        '// Tell them what to do next: follow, comment, link in bio\n',
  ),
  ScriptTemplate(
    'Tutorial',
    'Teach something step by step',
    '# Hook\n'
        '// "Here\'s how to … in under a minute"\n'
        '\n\n'
        '# Step 1\n\n\n'
        '# Step 2\n\n\n'
        '# Step 3\n\n\n'
        '# Recap & CTA\n'
        '// Summarise in one line, then ask them to save the video\n',
  ),
  ScriptTemplate(
    'Product review',
    'UGC, ad reads and honest reviews',
    '# Hook\n'
        '// Show the product and the problem it solves\n'
        '\n\n'
        '# What it is\n\n\n'
        '# What I loved\n\n\n'
        '# What could be better\n\n\n'
        '# Verdict & CTA\n'
        '// Who should buy it — mention the code or link\n',
  ),
  ScriptTemplate(
    'Storytime',
    'Personal story with a lesson',
    '# Hook\n'
        '// Start in the middle of the action\n'
        '\n\n'
        '# Setup\n\n\n'
        '# Turning point\n\n\n'
        '# Lesson\n\n\n'
        '# CTA\n',
  ),
];

/// Target video lengths offered when writing a script, in seconds.
const targetLengths = <int>[15, 30, 60, 90, 180];

String targetLabel(int seconds) => seconds < 60
    ? '${seconds}s'
    : (seconds % 60 == 0 ? '${seconds ~/ 60} min' : '${seconds}s');
