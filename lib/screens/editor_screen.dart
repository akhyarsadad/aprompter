import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';
import '../models/script.dart';
import '../models/script_markup.dart';
import '../models/templates.dart';
import '../services/app_state.dart';
import 'camera_prompter_screen.dart';
import 'read_screen.dart';

/// Write and polish a script (journeys J1 & J2). Saves automatically.
class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key, required this.script});

  final Script script;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late final _title = TextEditingController(text: widget.script.title);
  late final _body = TextEditingController(text: widget.script.body);
  final _bodyFocus = FocusNode();
  late int? _target = widget.script.targetSeconds;
  late ScriptStatus _status = widget.script.status;

  // Based on the stored copy so takes recorded meanwhile are kept.
  Script get _current =>
      (AppScope.read(context).byId(widget.script.id) ?? widget.script).copyWith(
        title: _title.text.trim(),
        body: _body.text,
        targetSeconds: () => _target,
        status: _status,
      );

  /// Saves and returns the stored script, or null if it is empty.
  Future<Script?> _save() async {
    var script = _current;
    if (script.title.isEmpty && script.body.trim().isEmpty) return null;
    if (script.title.isEmpty) {
      script = script.copyWith(title: context.l10n.untitled);
    }
    final state = AppScope.read(context);
    final stored = state.byId(script.id);
    final changed =
        stored == null ||
        stored.title != script.title ||
        stored.body != script.body ||
        stored.targetSeconds != script.targetSeconds ||
        stored.status != script.status;
    if (changed) await state.upsert(script);
    return state.byId(script.id);
  }

  Future<void> _open(Widget Function(Script) builder) async {
    final script = await _save();
    if (script == null || !mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => builder(script)),
    );
    // Recording may have changed status/takes.
    if (mounted) {
      final fresh = AppScope.read(context).byId(script.id);
      if (fresh != null) setState(() => _status = fresh.status);
    }
  }

  /// Wraps the selection (or inserts at the cursor).
  void _wrap(String before, [String after = '']) {
    final v = _body.value;
    final sel = v.selection.isValid
        ? v.selection
        : TextSelection.collapsed(offset: v.text.length);
    final selected = sel.textInside(v.text);
    final text = v.text.replaceRange(
      sel.start,
      sel.end,
      '$before$selected$after',
    );
    _body.value = TextEditingValue(
      text: text,
      selection: selected.isEmpty
          ? TextSelection.collapsed(offset: sel.start + before.length)
          : TextSelection(
              baseOffset: sel.start,
              extentOffset:
                  sel.start + before.length + selected.length + after.length,
            ),
    );
    _bodyFocus.requestFocus();
  }

  /// Inserts [prefix] at the start of a new line.
  void _linePrefix(String prefix) {
    final v = _body.value;
    final at = v.selection.isValid ? v.selection.start : v.text.length;
    final needsNewline = at > 0 && v.text[at - 1] != '\n';
    _wrap('${needsNewline ? '\n' : ''}$prefix');
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text case final String text when text.isNotEmpty) _wrap(text);
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _bodyFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    return PopScope<Object?>(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _save();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.script),
          actions: [
            IconButton(
              tooltip: l.rehearse,
              icon: const Icon(Icons.record_voice_over_outlined),
              onPressed: () => _open((s) => ReadScreen(script: s)),
            ),
            IconButton(
              tooltip: l.record,
              icon: const Icon(Icons.videocam_outlined),
              onPressed: () => _open((s) => CameraPrompterScreen(script: s)),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _title,
                textCapitalization: TextCapitalization.sentences,
                style: theme.textTheme.titleLarge,
                decoration: InputDecoration(
                  hintText: l.title,
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: 44,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    _StatusChip(
                      status: _status,
                      onChanged: (s) => setState(() => _status = s),
                    ),
                    const SizedBox(width: 8),
                    const Center(child: Icon(Icons.timer_outlined, size: 18)),
                    const SizedBox(width: 4),
                    for (final t in [null, ...targetLengths])
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: ChoiceChip(
                          label: Text(t == null ? l.noTarget : targetLabel(t)),
                          selected: _target == t,
                          onSelected: (_) => setState(() => _target = t),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            ListenableBuilder(
              listenable: _body,
              builder: (context, _) => _TimingBar(
                body: _body.text,
                targetSeconds: _target,
                wpm: AppScope.of(context).settings.wpm,
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _body,
                  focusNode: _bodyFocus,
                  autofocus: widget.script.body.isEmpty,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(fontSize: 18, height: 1.5),
                  decoration: InputDecoration(
                    hintText: l.editorHint,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            _MarkupToolbar(
              onSection: () => _linePrefix('# '),
              onEmphasis: () => _wrap('*', '*'),
              onPause: () => _wrap(' [pause] '),
              onNote: () => _linePrefix('// '),
              onPaste: _paste,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, required this.onChanged});

  final ScriptStatus status;
  final ValueChanged<ScriptStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PopupMenuButton<ScriptStatus>(
        tooltip: context.l10n.status,
        onSelected: onChanged,
        itemBuilder: (_) => [
          for (final s in ScriptStatus.values)
            PopupMenuItem(value: s, child: Text(s.label(context.l10n))),
        ],
        child: Chip(
          visualDensity: VisualDensity.compact,
          avatar: Icon(statusIcon(status), size: 16),
          label: Text(status.label(context.l10n)),
        ),
      ),
    );
  }
}

IconData statusIcon(ScriptStatus s) => switch (s) {
  ScriptStatus.draft => Icons.edit_note,
  ScriptStatus.ready => Icons.check_circle_outline,
  ScriptStatus.recorded => Icons.movie_outlined,
};

/// Live words · spoken time · target feedback.
class _TimingBar extends StatelessWidget {
  const _TimingBar({
    required this.body,
    required this.targetSeconds,
    required this.wpm,
  });

  final String body;
  final int? targetSeconds;
  final double wpm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final words = countWords(spokenText(body));
    final seconds = words / wpm * 60;
    final target = targetSeconds;
    final longOnes = longSentenceCount(body);

    String status;
    Color color;
    double? fraction;
    if (target == null) {
      status = '';
      color = theme.colorScheme.primary;
    } else {
      fraction = (seconds / target).clamp(0.0, 1.0);
      final diff = seconds - target;
      final wordsDiff = (diff.abs() / 60 * wpm).round();
      if (diff.abs() <= target * 0.1) {
        status = l.onTarget;
        color = Colors.green;
      } else if (diff > 0) {
        status = l.overTarget(diff.round(), wordsDiff);
        color = theme.colorScheme.error;
      } else {
        status = l.underTarget((-diff).round(), wordsDiff);
        color = Colors.orange;
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.timing(
              l.words(words),
              formatDuration(Duration(seconds: seconds.round())) +
                  (target != null
                      ? ' / ${formatDuration(Duration(seconds: target))}'
                      : ''),
              wpm.round(),
            ),
            style: theme.textTheme.bodySmall,
          ),
          if (fraction != null) ...[
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: fraction,
              color: color,
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
            ),
            const SizedBox(height: 2),
            Text(
              status,
              style: theme.textTheme.bodySmall?.copyWith(color: color),
            ),
          ],
          if (longOnes > 0)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                l.longSentences(longOnes),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.tertiary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MarkupToolbar extends StatelessWidget {
  const _MarkupToolbar({
    required this.onSection,
    required this.onEmphasis,
    required this.onPause,
    required this.onNote,
    required this.onPaste,
  });

  final VoidCallback onSection;
  final VoidCallback onEmphasis;
  final VoidCallback onPause;
  final VoidCallback onNote;
  final VoidCallback onPaste;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              _tool(Icons.title, l.toolSection, onSection),
              _tool(Icons.format_bold, l.toolEmphasis, onEmphasis),
              _tool(Icons.pause, l.toolPause, onPause),
              _tool(Icons.sticky_note_2_outlined, l.toolNote, onNote),
              _tool(Icons.content_paste, l.toolPaste, onPaste),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tool(IconData icon, String label, VoidCallback onTap) => Padding(
    padding: const EdgeInsets.only(right: 4),
    child: TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
    ),
  );
}
