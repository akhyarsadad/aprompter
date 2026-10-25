import 'package:flutter/material.dart';

/// Asks before something is deleted for good. True only when [action] was
/// tapped; Cancel, Back or a tap outside keep everything.
Future<bool> confirmDeletion(
  BuildContext context, {
  required String message,
  required String action,
}) async {
  final sure = await showDialog<bool>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      return AlertDialog(
        icon: const Icon(Icons.delete_forever_outlined),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(action),
          ),
        ],
      );
    },
  );
  return sure ?? false;
}
