import 'package:url_launcher/url_launcher.dart';

/// Opens [url] in the phone's browser. Does nothing when no browser can
/// take it: there is nothing useful to show instead.
Future<void> openLink(String url) async {
  try {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } catch (_) {}
}
