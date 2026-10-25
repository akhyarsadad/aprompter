import 'package:flutter/services.dart';

import 'script_import.dart';

/// Something another app sent to APrompter: text from the share sheet
/// (Google Keep, Apple Notes, Samsung Notes…), a shared file, or a file
/// opened with APrompter.
class IncomingShare {
  const IncomingShare({
    this.text,
    this.subject,
    this.name,
    this.mimeType,
    this.bytes,
    this.tooLarge = false,
    this.unreadable = false,
  });

  /// Reads one item of `takePending`; anything malformed is left out.
  factory IncomingShare.fromMap(Map<Object?, Object?> map) {
    String? string(String key) {
      final value = map[key];
      return value is String && value.isNotEmpty ? value : null;
    }

    final bytes = map['bytes'];
    return IncomingShare(
      text: string('text'),
      subject: string('subject'),
      name: string('name'),
      mimeType: string('mimeType'),
      bytes: bytes is Uint8List
          ? bytes
          : bytes is List<int>
          ? Uint8List.fromList(bytes)
          : null,
      tooLarge: map['tooLarge'] == true,
      unreadable: map['unreadable'] == true,
    );
  }

  /// Shared text (the note's body).
  final String? text;

  /// The share's subject: Google Keep puts the note title here.
  final String? subject;

  /// File name with its extension.
  final String? name;
  final String? mimeType;

  /// File content (at most 10 MB).
  final Uint8List? bytes;

  /// The file was over 10 MB, so its bytes were left behind.
  final bool tooLarge;

  /// Native code couldn't read the file (a cloud file that didn't download,
  /// a revoked permission…), so there are no bytes.
  final bool unreadable;
}

/// Turns what another app sent into scripts. A file wins over text sent
/// along with it (often just "Shared from …"); the text is used when the
/// file can't be.
Future<ImportResult> importShare(IncomingShare share) async {
  if (share.tooLarge) return const ImportFailed(ImportFailure.tooLarge);
  final text = share.text;
  final bytes = share.bytes;
  final ImportResult fromFile;
  if (share.unreadable) {
    fromFile = const ImportFailed(ImportFailure.unreadable);
  } else if (bytes != null) {
    fromFile = await importFromFileAsync(
      share.name ?? '',
      bytes,
      mimeType: share.mimeType,
      title: share.subject,
    );
  } else if (text != null) {
    return importFromTextAsync(text, title: share.subject);
  } else {
    return const ImportFailed(ImportFailure.empty);
  }
  if (fromFile is ImportFailed && text != null) {
    final fromText = await importFromTextAsync(text, title: share.subject);
    // When the text fails too, the file's reason is the one worth telling.
    if (fromText is! ImportFailed) return fromText;
  }
  return fromFile;
}

/// Client of the native `aprompter/import` channel. Native code keeps what
/// was shared until [takePending] hands it over, and calls `incoming` when
/// something new arrives while the app is open.
class IncomingShares {
  IncomingShares({this.channel = defaultChannel});

  static const defaultChannel = MethodChannel('aprompter/import');

  final MethodChannel channel;

  /// Everything shared since the last call; native code forgets it once
  /// returned. Empty where there is no native side (tests, desktop).
  Future<List<IncomingShare>> takePending() async {
    try {
      final items = await channel.invokeMethod<List<Object?>>('takePending');
      return [
        for (final item in items ?? const <Object?>[])
          if (item is Map<Object?, Object?>) IncomingShare.fromMap(item),
      ];
    } on MissingPluginException {
      return const [];
    } on PlatformException {
      return const [];
    }
  }

  /// Calls [onIncoming] whenever native code says something new arrived.
  void listen(void Function() onIncoming) {
    channel.setMethodCallHandler((call) async {
      if (call.method == 'incoming') onIncoming();
      return null;
    });
  }

  void dispose() => channel.setMethodCallHandler(null);
}
