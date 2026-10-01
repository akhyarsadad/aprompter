import 'package:flutter/material.dart';

import '../models/script.dart';
import '../services/app_state.dart';
import '../services/floating_prompter.dart';
import '../services/storage.dart';
import '../widgets/settings_sheet.dart';
import 'camera_prompter_screen.dart';
import 'editor_screen.dart';
import 'read_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final scripts = state.scripts;
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
        onPressed: () => _edit(context, Storage.newScript()),
        icon: const Icon(Icons.add),
        label: const Text('New script'),
      ),
      body: scripts.isEmpty
          ? const _EmptyState()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              itemCount: scripts.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, i) => _ScriptCard(script: scripts[i]),
            ),
    );
  }
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
    final d = script.estimatedDuration;
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
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ],
              ),
              Text(
                script.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${script.wordCount} words · ~${d.inMinutes}m ${d.inSeconds % 60}s',
                style: theme.textTheme.bodySmall,
              ),
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
                    icon: const Icon(Icons.chrome_reader_mode_outlined),
                    label: const Text('Read'),
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
  const _EmptyState();

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
            const Text('No scripts yet', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            const Text(
              'Tap "New script" to write what you want to say.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
