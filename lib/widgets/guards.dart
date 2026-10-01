import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../models/script.dart';

/// Returns true when [script] has lines to say; otherwise explains why the
/// action can't start.
bool ensureSpeakable(BuildContext context, Script? script) {
  if (script != null && script.wordCount > 0) return true;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(context.l10n.nothingToSay)));
  return false;
}
