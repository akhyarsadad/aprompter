package com.akhyarsadad.aprompter

import android.content.Intent
import android.net.Uri
import android.provider.Settings
import android.view.View
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "aprompter/system")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    // Lets the app send the user to its system settings page,
                    // e.g. after camera permission was denied.
                    "openAppSettings" -> {
                        val intent = Intent(
                            Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                            Uri.fromParts("package", packageName, null),
                        ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(intent)
                        result.success(true)
                    }
                    "secureOverlay" -> result.success(secureOverlay())
                    else -> result.notImplemented()
                }
            }
    }

    /**
     * Marks the floating prompter window as secure, so screen recordings,
     * screen sharing and live streams show it as blank instead of leaking
     * the script. The overlay plugin has no option for this, so its window
     * is looked up directly. Returns false while the window isn't up yet.
     */
    private fun secureOverlay(): Boolean = try {
        val service = Class.forName(
            "flutter.overlay.window.flutter_overlay_window.OverlayService",
        )
        fun field(name: String) =
            service.getDeclaredField(name).apply { isAccessible = true }
        val instance = field("instance").get(null)
        val view = instance?.let { field("flutterView").get(it) as? View }
        val params = view?.layoutParams as? WindowManager.LayoutParams
        if (view == null || params == null || !view.isAttachedToWindow) {
            false
        } else {
            if (params.flags and WindowManager.LayoutParams.FLAG_SECURE == 0) {
                params.flags = params.flags or WindowManager.LayoutParams.FLAG_SECURE
                val manager = field("windowManager").get(instance) as? WindowManager
                    ?: getSystemService(WINDOW_SERVICE) as WindowManager
                manager.updateViewLayout(view, params)
            }
            true
        }
    } catch (e: Exception) {
        false
    }
}
