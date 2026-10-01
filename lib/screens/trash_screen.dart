import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../l10n/l10n.dart';
import '../services/app_state.dart';
import '../services/storage.dart';

/// Deleted scripts, kept for [Storage.trashDays] days so a deletion is
/// never final by accident.
class TrashScreen extends StatelessWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = AppScope.of(context);
    final trash = state.trash;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Scaffold(
      appBar: AppBar(title: Text(l.recentlyDeleted)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              l.trashHint(Storage.trashDays),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          for (final t in trash)
            ListTile(
              title: Text(
                t.script.title.isEmpty ? l.untitled : t.script.title,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '${l.deletedOn(DateFormat.yMMMd(locale).format(t.deletedAt))}'
                ' · ${l.words(t.script.wordCount)}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: l.restore,
                    icon: const Icon(Icons.restore),
                    onPressed: () async {
                      await state.restore(t.script);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            l.restoredScript(
                              t.script.title.isEmpty
                                  ? l.untitled
                                  : t.script.title,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    tooltip: l.deleteForever,
                    icon: const Icon(Icons.delete_forever_outlined),
                    onPressed: () => state.deleteForever(t.script.id),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
