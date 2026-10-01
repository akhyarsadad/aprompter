import 'package:flutter/material.dart';

import '../models/script.dart';
import '../models/templates.dart';
import '../services/app_state.dart';
import '../services/floating_prompter.dart';
import '../services/storage.dart';
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
        title: const Text('APrompter'),
        actions: [
          IconButton(
            tooltip: 'Prompter settings',
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
        label: const Text('New script'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: SearchBar(
              hintText: 'Search scripts',
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
                          '${f?.label ?? 'All'} (${state.scripts.where((s) => f == null || s.status == f).length})',
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
                    itemBuilder: (context, i) =>
                        _ScriptCard(script: scripts[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

/// J1: pick a template, then open the editor.
Future<void> _newScript(BuildContext context) async {
  final template = await showModalBottomSheet<ScriptTemplate>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'Start from a template',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          for (final t in scriptTemplates)
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

class _ScriptCard extends StatelessWidget {
  const _ScriptCard({required this.script});

  final Script script;

  Future<void> _float(BuildContext context) async {
    final state = AppScope.read(context);
    final messenger = ScaffoldMessenger.of(context);
    if (!await FloatingPrompter.ensurePermission()) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Allow "Display over other apps" to use the floating prompter.',
          ),
        ),
      );
      return;
    }
    await FloatingPrompter.show(
      storage: state.storage,
      script: script,
      settings: state.settings,
    );
    messenger.showSnackBar(
      const SnackBar(
        content: Text(
          'Prompter is floating. Open your camera app and tap the '
          'text to start.',
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete script?'),
        content: Text('"${script.title}" will be removed permanently.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await AppScope.read(context).delete(script.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wpm = AppScope.of(context).settings.wpm;
    final target = script.targetSeconds;
    final meta = [
      '${script.wordCount} words',
      '~${formatDuration(script.durationAt(wpm))}'
          '${target != null ? ' / ${targetLabel(target)}' : ''}',
      if (script.takes > 0)
        '${script.takes} take${script.takes == 1 ? '' : 's'}',
    ].join(' · ');
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
                      script.title.isEmpty ? 'Untitled' : script.title,
                      style: theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (v) {
                      if (v == 'edit') _edit(context, script);
                      if (v == 'delete') _delete(context);
                      for (final s in ScriptStatus.values) {
                        if (v == s.name) {
                          AppScope.read(context)
                              .upsert(script.copyWith(status: s));
                        }
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      for (final s in ScriptStatus.values)
                        if (s != script.status)
                          PopupMenuItem(
                            value: s.name,
                            child: Text('Mark as ${s.label}'),
                          ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                script.body.replaceAll(
                  RegExp(r'^(#|//).*$\n?', multiLine: true),
                  '',
                ),
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
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => ReadScreen(script: script),
                      ),
                    ),
                    icon: const Icon(Icons.record_voice_over_outlined),
                    label: const Text('Rehearse'),
                  ),
                  if (FloatingPrompter.isSupported)
                    TextButton.icon(
                      onPressed: () => _float(context),
                      icon: const Icon(Icons.picture_in_picture_alt_outlined),
                      label: const Text('Float'),
                    ),
                  FilledButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => CameraPrompterScreen(script: script),
                      ),
                    ),
                    icon: const Icon(Icons.videocam),
                    label: const Text('Record'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filtered});

  final bool filtered;

  @override
  Widget build(BuildContext context) {
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
              filtered ? 'Nothing here' : 'No scripts yet',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              filtered
                  ? 'Try another filter or search.'
                  : 'Tap "New script" and pick a template to get started.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
