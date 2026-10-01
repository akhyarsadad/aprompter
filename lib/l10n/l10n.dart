import 'package:flutter/widgets.dart';

import '../models/script.dart';
import 'app_localizations.dart';

export 'app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Localizations for code that runs before (or outside) the widget tree.
AppLocalizations deviceLocalizations() => lookupAppLocalizations(
  basicLocaleListResolution(
    WidgetsBinding.instance.platformDispatcher.locales,
    AppLocalizations.supportedLocales,
  ),
);

extension StatusLabel on ScriptStatus {
  String label(AppLocalizations l) => switch (this) {
    ScriptStatus.draft => l.statusDraft,
    ScriptStatus.ready => l.statusReady,
    ScriptStatus.recorded => l.statusRecorded,
  };
}
