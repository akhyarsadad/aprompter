import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/l10n.dart';
import '../models/script.dart';
import '../models/script_markup.dart';
import '../models/templates.dart';
import '../services/app_state.dart';
import '../services/backup.dart';
import '../services/floating_prompter.dart';
import '../services/storage.dart';
import '../services/system_settings.dart';
import '../widgets/guards.dart';
import '../widgets/settings_sheet.dart';
import 'camera_prompter_screen.dart';
import 'editor_screen.dart';
import 'read_screen.dart';
import 'takes_screen.dart';
import 'trash_screen.dart';

/// Script library (journey J7).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScriptStatus? _filter;
  String _query = '';

  // F9: pace changed in the floating window is picked up on return.
  late final _lifecycle = AppLifecycleListener(
    onResume: () => AppScope.read(context).reloadSettings(),
  );

  @override
  void initState() {
    super.initState();
    _lifecycle;
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = AppScope.of(context);
    final q = foldForSearch(_query);
    final scripts = state.scripts
        .where((s) => _filter == null || s.status == _filter)
        .where(
          (s) =>
              q.isEmpty ||
              foldForSearch(s.title).contains(q) ||
              foldForSearch(s.body).contains(q),
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
          PopupMenuButton<_LibraryAction>(
            onSelected: (a) => _onLibraryAction(context, a),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: _LibraryAction.trash,
                child: _MenuRow(Icons.delete_sweep_outlined, l.recentlyDeleted),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: _LibraryAction.backup,
                child: _MenuRow(Icons.backup_outlined, l.backUpScripts),
              ),
              PopupMenuItem(
                value: _LibraryAction.restore,
                child: _MenuRow(Icons.settings_backup_restore, l.restoreBackup),
              ),
            ],
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

enum _LibraryAction { trash, backup, restore }

Future<void> _onLibraryAction(
  BuildContext context,
  _LibraryAction action,
) async {
  final l = context.l10n;
  final state = AppScope.read(context);
  final messenger = ScaffoldMessenger.of(context);
  switch (action) {
    case _LibraryAction.trash:
      await Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (_) => const TrashScreen()),
      );
    case _LibraryAction.backup:
      final now = DateTime.now();
      final box = context.findRenderObject() as RenderBox?;
      await SharePlus.instance.share(
        ShareParams(
          title: l.backupShareTitle,
          files: [
            XFile.fromData(
              utf8.encode(Backup.encode(state.scripts, now: now)),
              mimeType: 'application/json',
              name: Backup.fileName(now),
            ),
          ],
          fileNameOverrides: [Backup.fileName(now)],
          sharePositionOrigin: box == null
              ? null
              : box.localToGlobal(Offset.zero) & box.size,
        ),
      );
    case _LibraryAction.restore:
      final file = await FilePicker.pickFile();
      if (file == null) return;
      String? text;
      try {
        text = utf8.decode(await file.readAsBytes(), allowMalformed: true);
      } catch (_) {
        text = null;
      }
      final scripts = text == null ? null : Backup.decode(text);
      if (scripts == null) {
        messenger.showSnackBar(SnackBar(content: Text(l.notABackup)));
        return;
      }
      final count = await state.importScripts(scripts);
      messenger.showSnackBar(SnackBar(content: Text(l.importedScripts(count))));
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 20),
      const SizedBox(width: 12),
      Expanded(child: Text(text)),
    ],
  );
}

/// Lower-cases and strips accents so "cafe" finds "Café" and "istanbul"
/// finds "İstanbul".
String foldForSearch(String text) {
  final lower = text.replaceAll('İ', 'i').replaceAll('I', 'ı').toLowerCase();
  final out = StringBuffer();
  for (final rune in lower.runes) {
    final c = String.fromCharCode(rune);
    out.write(_accents[c] ?? c);
  }
  // Dotless ı only differs from i in Turkish casing; search treats them alike.
  return out.toString().replaceAll('ı', 'i');
}

// dart format off
const _accents = {
  'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a', 'ā': 'a',
  'ă': 'a', 'ą': 'a', 'ç': 'c', 'ć': 'c', 'č': 'c', 'ď': 'd', 'đ': 'd',
  'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e', 'ē': 'e', 'ę': 'e', 'ě': 'e',
  'ğ': 'g', 'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i', 'ī': 'i', 'ł': 'l',
  'ñ': 'n', 'ń': 'n', 'ň': 'n', 'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o',
  'ö': 'o', 'ø': 'o', 'ō': 'o', 'ő': 'o', 'ř': 'r', 'ś': 's', 'š': 's',
  'ş': 's', 'ș': 's', 'ß': 'ss', 'ť': 't', 'ț': 't', 'ù': 'u', 'ú': 'u',
  'û': 'u', 'ü': 'u', 'ū': 'u', 'ů': 'u', 'ű': 'u', 'ý': 'y', 'ÿ': 'y',
  'ź': 'z', 'ż': 'z', 'ž': 'z', 'ơ': 'o', 'ư': 'u', 'ạ': 'a', 'ả': 'a',
  'ấ': 'a', 'ầ': 'a', 'ẩ': 'a', 'ẫ': 'a', 'ậ': 'a', 'ắ': 'a', 'ằ': 'a',
  'ẳ': 'a', 'ẵ': 'a', 'ặ': 'a', 'ẹ': 'e', 'ẻ': 'e', 'ẽ': 'e', 'ế': 'e',
  'ề': 'e', 'ể': 'e', 'ễ': 'e', 'ệ': 'e', 'ỉ': 'i', 'ị': 'i', 'ọ': 'o',
  'ỏ': 'o', 'ố': 'o', 'ồ': 'o', 'ổ': 'o', 'ỗ': 'o', 'ộ': 'o', 'ớ': 'o',
  'ờ': 'o', 'ở': 'o', 'ỡ': 'o', 'ợ': 'o', 'ụ': 'u', 'ủ': 'u', 'ứ': 'u',
  'ừ': 'u', 'ử': 'u', 'ữ': 'u', 'ự': 'u', 'ỳ': 'y', 'ỵ': 'y', 'ỷ': 'y',
  'ỹ': 'y',
};
// dart format on

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
          // W12: bring in a script written elsewhere.
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: Text(l.importTextFile),
            subtitle: Text(l.importTextFileHint),
            onTap: () => Navigator.pop(context, _importMarker),
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
  if (identical(template, _importMarker)) return _importTextFile(context);
  final script = Storage.newScript().copyWith(
    body: template.body,
    targetSeconds: () => template.body.isEmpty ? null : 60,
  );
  _edit(context, script);
}

const _importMarker = ScriptTemplate('', '', '');

/// F2: phone makers that close floating windows to save battery.
const _aggressiveOems = {
  'xiaomi',
  'redmi',
  'poco',
  'huawei',
  'honor',
  'oppo',
  'realme',
  'vivo',
  'iqoo',
  'oneplus',
  'samsung',
  'meizu',
  'tecno',
  'infinix',
  'itel',
};

/// Explains, once, what to allow on phones that kill floating windows.
Future<void> _oemTipsOnce(BuildContext context, String manufacturer) async {
  final storage = AppScope.read(context).storage;
  if (!_aggressiveOems.contains(manufacturer) || storage.oemTipsSeen) return;
  await storage.setOemTipsSeen();
  if (!context.mounted) return;
  final l = context.l10n;
  final brand = manufacturer.isEmpty
      ? ''
      : manufacturer[0].toUpperCase() + manufacturer.substring(1);
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.oemTipsTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(l.oemTipsBody(brand)),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: openAppSettings,
              icon: const Icon(Icons.settings),
              label: Text(l.openSettings),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l.continueLabel),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Opens a .txt / .md file as a new script.
Future<void> _importTextFile(BuildContext context) async {
  final l = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  final file = await FilePicker.pickFile(
    type: FileType.custom,
    allowedExtensions: const ['txt', 'md', 'text'],
  );
  if (file == null || !context.mounted) return;
  String? text;
  try {
    final bytes = await file.readAsBytes();
    text = bytes.length > 2000000
        ? null
        : utf8.decode(bytes, allowMalformed: true);
  } catch (_) {
    text = null;
  }
  if (text == null || text.trim().isEmpty || !context.mounted) {
    messenger.showSnackBar(SnackBar(content: Text(l.importTextFailed)));
    return;
  }
  final name = file.name.replaceFirst(RegExp(r'\.[^.]*$'), '');
  final script = Storage.newScript().copyWith(
    title: name,
    body: cleanPastedText(text),
  );
  await AppScope.read(context).upsert(script);
  if (context.mounted) _edit(context, script);
}

void _edit(BuildContext context, Script script) => Navigator.push(
  context,
  MaterialPageRoute<void>(builder: (_) => EditorScreen(script: script)),
);

enum _Action {
  edit,
  duplicate,
  share,
  caption,
  takes,
  draft,
  ready,
  recorded,
  delete,
}

class _ScriptCard extends StatelessWidget {
  const _ScriptCard({super.key, required this.script});

  final Script script;

  Future<void> _float(BuildContext context) async {
    if (!ensureSpeakable(context, script)) return;
    final l = context.l10n;
    final state = AppScope.read(context);
    final messenger = ScaffoldMessenger.of(context);
    final device = await deviceInfo();
    // O6: Android Go / low-RAM phones can't draw over other apps.
    if (device.lowRam) {
      messenger.showSnackBar(SnackBar(content: Text(l.floatLowRam)));
      return;
    }
    if (!context.mounted) return;
    await _oemTipsOnce(context, device.manufacturer);
    if (!context.mounted) return;
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
        await Clipboard.setData(ClipboardData(text: captionText(script.body)));
        messenger.showSnackBar(SnackBar(content: Text(l.captionCopied)));
      case _Action.takes:
        await Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => TakesScreen(script: script)),
        );
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
          '${target != null ? ' / ${targetLabel(l, target)}' : ''}',
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
                      _item(
                        _Action.takes,
                        Icons.video_library_outlined,
                        l.takesTitle,
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
                    )
                  else if (defaultTargetPlatform == TargetPlatform.iOS)
                    // Shown greyed out so people learn why, instead of
                    // hunting for a feature they read about.
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: theme.disabledColor,
                      ),
                      onPressed: () => ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(l.floatNotOnIos))),
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
