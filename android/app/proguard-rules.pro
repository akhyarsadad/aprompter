# MainActivity.secureOverlay() reaches into the overlay plugin by name.
-keepclassmembers class flutter.overlay.window.flutter_overlay_window.OverlayService {
    private static ** instance;
    private ** flutterView;
    private ** windowManager;
}
