import 'package:flutter/foundation.dart';
import 'package:gal/gal.dart';

/// The gallery album takes are saved into.
const takesAlbum = 'APrompter';

/// Saves the video at [path] into the "APrompter" album. Saving asks for
/// gallery access itself when it's needed.
///
/// iOS may refuse an app its own album when the person allowed access to
/// only some photos. The take is then saved to the library without the
/// album rather than not at all. On Android the album is just a folder, so
/// a failure there (and a full phone anywhere) is passed on as is.
Future<void> saveTakeToGallery(String path) async {
  try {
    await Gal.putVideo(path, album: takesAlbum);
  } on GalException catch (e) {
    if (defaultTargetPlatform != TargetPlatform.iOS ||
        e.type == GalExceptionType.notEnoughSpace ||
        e.type == GalExceptionType.notSupportedFormat) {
      rethrow;
    }
    await Gal.putVideo(path);
  }
}
