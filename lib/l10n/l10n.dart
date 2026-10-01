import 'package:flutter/widgets.dart';

import '../models/script.dart';
import 'app_localizations.dart';

export 'app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Localizations for code that runs before (or outside) the widget tree.
/// Uses [override] (the language picked in the app) or the phone's languages.
AppLocalizations deviceLocalizations([Locale? override]) =>
    lookupAppLocalizations(
      override ??
          resolveAppLocale(WidgetsBinding.instance.platformDispatcher.locales),
    );

/// Picks the best supported language for the phone's preferred [locales].
/// Chinese without a script (older Android: "zh-TW") is mapped to
/// Traditional for Taiwan, Hong Kong and Macau, Simplified elsewhere.
Locale resolveAppLocale(List<Locale>? locales) {
  const traditional = {'TW', 'HK', 'MO'};
  final normalized = [
    for (final l in locales ?? const <Locale>[])
      if (l.languageCode == 'zh' && l.scriptCode == null)
        Locale.fromSubtags(
          languageCode: 'zh',
          scriptCode: traditional.contains(l.countryCode) ? 'Hant' : 'Hans',
          countryCode: l.countryCode,
        )
      else
        l,
  ];
  // Languages we don't translate fall back to English (Flutter would pick
  // the first supported locale otherwise, which is Arabic).
  const english = Locale('en');
  final supported = AppLocalizations.supportedLocales;
  final known = normalized
      .where((l) => supported.any((s) => s.languageCode == l.languageCode))
      .toList();
  if (known.isEmpty) return english;
  return basicLocaleListResolution(known, supported);
}

/// "zh-Hant", "pt", … — stable string form of a supported locale.
String localeTag(Locale locale) => [
  locale.languageCode,
  if (locale.scriptCode != null) locale.scriptCode!,
  if (locale.countryCode != null) locale.countryCode!,
].join('-');

Locale? parseLocaleTag(String? tag) {
  if (tag == null || tag.isEmpty) return null;
  final parts = tag.split(RegExp('[-_]'));
  final locale = Locale.fromSubtags(
    languageCode: parts[0],
    scriptCode: parts.length > 1 && parts[1].length == 4 ? parts[1] : null,
    countryCode: parts.length > 1 && parts[1].length != 4 ? parts[1] : null,
  );
  return AppLocalizations.supportedLocales.contains(locale) ? locale : null;
}

/// Each language's name in that language, for the language picker.
const languageNames = <String, String>{
  'ar': 'العربية',
  'bn': 'বাংলা',
  'de': 'Deutsch',
  'en': 'English',
  'es': 'Español',
  'fa': 'فارسی',
  'fil': 'Filipino',
  'fr': 'Français',
  'he': 'עברית',
  'hi': 'हिन्दी',
  'id': 'Bahasa Indonesia',
  'it': 'Italiano',
  'ja': '日本語',
  'ko': '한국어',
  'ms': 'Bahasa Melayu',
  'nl': 'Nederlands',
  'pl': 'Polski',
  'pt': 'Português',
  'ru': 'Русский',
  'sw': 'Kiswahili',
  'ta': 'தமிழ்',
  'th': 'ไทย',
  'tr': 'Türkçe',
  'uk': 'Українська',
  'ur': 'اردو',
  'vi': 'Tiếng Việt',
  'zh': '简体中文',
  'zh-Hant': '繁體中文',
};

extension StatusLabel on ScriptStatus {
  String label(AppLocalizations l) => switch (this) {
    ScriptStatus.draft => l.statusDraft,
    ScriptStatus.ready => l.statusReady,
    ScriptStatus.recorded => l.statusRecorded,
  };
}
