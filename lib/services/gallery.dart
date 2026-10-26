import 'package:gal/gal.dart';

/// The gallery album takes are saved into.
const takesAlbum = 'APrompter';

/// Saves the video at [path] into the "APrompter" album, asking for access
/// first when needed.
///
/// iOS lets an app find or make its own album only with full photo access.
/// With limited access the album step fails, so the take is then saved to
/// the library without the album rather than not at all. If that fails
/// too (access refused, phone full), its error is passed on.
Future<void> saveTakeToGallery(String path) async {
  if (!await Gal.hasAccess(toAlbum: true)) {
    await Gal.requestAccess(toAlbum: true);
  }
  try {
    await Gal.putVideo(path, album: takesAlbum);
  } on GalException {
    await Gal.putVideo(path);
  }
}
