package com.akhyarsadad.aprompter

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.Uri
import android.os.BatteryManager
import android.os.Build
import android.os.StatFs
import android.provider.Settings
import android.view.View
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// A FragmentActivity so local_auth can show the biometric prompt (app lock).
class MainActivity : FlutterFragmentActivity() {
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
                    // Free space for recordings, in bytes.
                    "freeSpace" -> result.success(
                        try {
                            StatFs(filesDir.absolutePath).availableBytes
                        } catch (e: Exception) {
                            null
                        },
                    )
                    "battery" -> result.success(battery())
                    // Full brightness while prompting (sunlight), then back.
                    "setBright" -> {
                        val on = call.arguments as? Boolean ?: false
                        val params = window.attributes
                        params.screenBrightness = if (on) {
                            WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_FULL
                        } else {
                            WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_NONE
                        }
                        window.attributes = params
                        result.success(true)
                    }
                    "deviceInfo" -> {
                        val am = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
                        result.success(
                            mapOf(
                                "manufacturer" to Build.MANUFACTURER.lowercase(),
                                // Android Go and other low-RAM phones can't
                                // draw over other apps.
                                "lowRam" to am.isLowRamDevice,
                            ),
                        )
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun battery(): Map<String, Any>? {
        val status = registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            ?: return null
        val level = status.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
        val scale = status.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        if (level < 0 || scale <= 0) return null
        val plugged = status.getIntExtra(BatteryManager.EXTRA_PLUGGED, 0)
        return mapOf("level" to level * 100 / scale, "charging" to (plugged != 0))
    }

    /**
     * Marks the floating prompter window as secure, so screen recordings,
     * screen sharing and live streams show it as blank instead of leaking
     * the script, and keeps the screen on while it shows (reading over a
     * slides or notes app). The overlay plugin has no option for this, so
     * its window is looked up directly. Returns false while the window
     * isn't up yet.
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
            val wanted = WindowManager.LayoutParams.FLAG_SECURE or
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
            if (params.flags and wanted != wanted) {
                params.flags = params.flags or wanted
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
