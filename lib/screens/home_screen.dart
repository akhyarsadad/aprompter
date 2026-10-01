import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/l10n.dart';
import '../models/script.dart';
import '../models/script_markup.dart';
import '../models/templates.dart';
import '../services/app_state.dart';
import '../services/floating_prompter.dart';
import '../services/storage.dart';
import '../widgets/guards.dart';
import '../widgets/settings_sheet.dart';
import 'camera_prompter_screen.dart';
import 'editor_screen.dart';
import 'read_screen.dart';

/// Script library (journey J7).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScriptStatus? _filter;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = AppScope.of(context);
    final q = _query.toLowerCase();
    final scripts = state.scripts
        .where((s) => _filter == null || s.status == _filter)
        .where(
          (s) =>
              q.isEmpty ||
              s.title.toLowerCase().contains(q) ||
              s.body.toLowerCase().contains(q),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l.appTitle),
        actions: [
          IconButton(
            tooltip: l.prompterSettings,
            icon: const Icon(Icons.tune),
            onPressed: () => showSettingsSheet(
              context,
              settings: state.settings,
              onChanged: state.updateSettings,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _newScript(context),
        icon: const Icon(Icons.add),
        label: Text(l.newScript),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: SearchBar(
              hintText: l.searchScripts,
              leading: const Icon(Icons.search),
              elevation: const WidgetStatePropertyAll(0),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          SizedBox(
            height: 52,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  for (final f in [null, ...ScriptStatus.values])
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: Text(
                          l.filterCount(
                            f?.label(l) ?? l.filterAll,
                            state.scripts
                                .where((s) => f == null || s.status == f)
                                .length,
                          ),
                        ),
                        selected: _filter == f,
                        onSelected: (_) => setState(() => _filter = f),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: scripts.isEmpty
                ? _EmptyState(filtered: state.scripts.isNotEmpty)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                    itemCount: scripts.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, i) => _ScriptCard(
                      key: ValueKey(scripts[i].id),
                      script: scripts[i],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// J1: pick a template, then open the editor.
Future<void> _newScript(BuildContext context) async {
  final l = context.l10n;
  final template = await showModalBottomSheet<ScriptTemplate>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              l.startFromTemplate,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          for (final t in scriptTemplates(l))
            ListTile(
              leading: Icon(
                t.body.isEmpty
                    ? Icons.note_add_outlined
                    : Icons.view_agenda_outlined,
              ),
              title: Text(t.name),
              subtitle: Text(t.description),
              onTap: () => Navigator.pop(context, t),
            ),
        ],
      ),
    ),
  );
  if (template == null || !context.mounted) return;
  final script = Storage.newScript().copyWith(
    body: template.body,
    targetSeconds: () => template.body.isEmpty ? null : 60,
  );
  _edit(context, script);
}

void _edit(BuildContext context, Script script) => Navigator.push(
  context,
  MaterialPageRoute<void>(builder: (_) => EditorScreen(script: script)),
);

enum _Action { edit, duplicate, share, caption, draft, ready, recorded, delete }

class _ScriptCard extends StatelessWidget {
  const _ScriptCard({super.key, required this.script});

  final Script script;

  Future<void> _float(BuildContext context) async {
    if (!ensureSpeakable(context, script)) return;
    final l = context.l10n;
    final state = AppScope.read(context);
    final messenger = ScaffoldMessenger.of(context);
    if (!await FloatingPrompter.ensurePermission()) {
      messenger.showSnackBar(
        SnackBar(content: Text(l.overlayPermissionNeeded)),
      );
      return;
    }
    await FloatingPrompter.show(
      storage: state.storage,
      script: script,
      settings: state.settings,
    );
    messenger.showSnackBar(SnackBar(content: Text(l.floatingStarted)));
  }

  Future<void> _onAction(BuildContext context, _Action action) async {
    final l = context.l10n;
    final state = AppScope.read(context);
    final messenger = ScaffoldMessenger.of(context);
    switch (action) {
      case _Action.edit:
        _edit(context, script);
      case _Action.duplicate:
        final copy = await state.duplicate(
          script.id,
          titleSuffix: l.copySuffix,
        );
        messenger.showSnackBar(
          SnackBar(content: Text(l.duplicatedScript(copy.title))),
        );
      case _Action.share:
        final box = context.findRenderObject() as RenderBox?;
        await SharePlus.instance.share(
          ShareParams(
            title: script.title,
            text: '${script.title}\n\n${script.body}',
            sharePositionOrigin: box == null
                ? null
                : box.localToGlobal(Offset.zero) & box.size,
          ),
        );
      case _Action.caption:
        if (!ensureSpeakable(context, script)) return;
        await Clipboard.setData(ClipboardData(text: spokenText(script.body)));
        messenger.showSnackBar(SnackBar(content: Text(l.captionCopied)));
      case _Action.draft:
        await state.upsert(script.copyWith(status: ScriptStatus.draft));
      case _Action.ready:
        await state.upsert(script.copyWith(status: ScriptStatus.ready));
      case _Action.recorded:
        await state.upsert(script.copyWith(status: ScriptStatus.recorded));
      case _Action.delete:
        final removed = await state.delete(script.id);
        if (removed == null) return;
        messenger.showSnackBar(
          SnackBar(
            content: Text(l.deletedScript(removed.title)),
            action: SnackBarAction(
              label: l.undo,
              onPressed: () => state.restore(removed),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final wpm = AppScope.of(context).settings.wpm;
    final target = script.targetSeconds;
    final meta = [
      l.words(script.wordCount),
      '~${formatDuration(script.durationAt(wpm))}'
          '${target != null ? ' / ${targetLabel(target)}' : ''}',
      if (script.takes > 0) l.takes(script.takes),
    ].join(' · ');
    final statusActions = {
      ScriptStatus.draft: _Action.draft,
      ScriptStatus.ready: _Action.ready,
      ScriptStatus.recorded: _Action.recorded,
    };

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _edit(context, script),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    statusIcon(script.status),
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      script.title.isEmpty ? l.untitled : script.title,
                      style: theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton<_Action>(
                    onSelected: (a) => _onAction(context, a),
                    itemBuilder: (_) => [
                      _item(_Action.edit, Icons.edit_outlined, l.edit),
                      _item(_Action.duplicate, Icons.copy_all, l.duplicate),
                      _item(_Action.share, Icons.share_outlined, l.share),
                      _item(
                        _Action.caption,
                        Icons.closed_caption_outlined,
                        l.copyAsCaption,
                      ),
                      const PopupMenuDivider(),
                      for (final MapEntry(key: status, value: action)
                          in statusActions.entries)
                        if (status != script.status)
                          _item(
                            action,
                            statusIcon(status),
                            l.markAs(status.label(l)),
                          ),
                      const PopupMenuDivider(),
                      _item(_Action.delete, Icons.delete_outline, l.delete),
                    ],
                  ),
                ],
              ),
              Text(
                spokenText(script.body).replaceAll('\n', ' '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(meta, style: theme.textTheme.bodySmall),
              OverflowBar(
                alignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () =>
                        _open(context, (_) => ReadScreen(script: script)),
                    icon: const Icon(Icons.record_voice_over_outlined),
                    label: Text(l.rehearse),
                  ),
                  if (FloatingPrompter.isSupported)
                    TextButton.icon(
                      onPressed: () => _float(context),
                      icon: const Icon(Icons.picture_in_picture_alt_outlined),
                      label: Text(l.float),
                    ),
                  FilledButton.icon(
                    onPressed: () => _open(
                      context,
                      (_) => CameraPrompterScreen(script: script),
                    ),
                    icon: const Icon(Icons.videocam),
                    label: Text(l.record),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _open(BuildContext context, WidgetBuilder builder) {
    if (!ensureSpeakable(context, script)) return;
    Navigator.push(context, MaterialPageRoute<void>(builder: builder));
  }

  PopupMenuItem<_Action> _item(_Action value, IconData icon, String text) =>
      PopupMenuItem(
        value: value,
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(text)),
          ],
        ),
      );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filtered});

  final bool filtered;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.subject,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              filtered ? l.nothingHere : l.noScriptsYet,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              filtered ? l.nothingHereHint : l.noScriptsHint,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
