package com.akhyarsadad.aprompter

import android.app.Activity
import android.app.ActivityManager
import android.content.ComponentName
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.net.Uri
import android.os.BatteryManager
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.Parcelable
import android.os.StatFs
import android.provider.OpenableColumns
import android.provider.Settings
import android.util.Log
import android.view.View
import android.view.WindowManager
import android.webkit.MimeTypeMap
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.InputStream
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.locks.ReentrantLock
import kotlin.concurrent.withLock

// A FragmentActivity so local_auth can show the biometric prompt (app lock).
class MainActivity : FlutterFragmentActivity() {
    private var importChannel: MethodChannel? = null

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
        // Text and files shared into the app; ImportActivity collects them.
        // Only this main engine gets the channel, not the floating prompter's.
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "aprompter/import")
        ImportInbox.attach(channel)
        importChannel = channel
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        importChannel?.let { ImportInbox.detach(it) }
        importChannel = null
        super.cleanUpFlutterEngine(flutterEngine)
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

/**
 * Invisible entry point for "Share to APrompter" and "Open with APrompter".
 *
 * The share filters are here and not on MainActivity because a share starts
 * its target inside the sending app's task: a singleTop MainActivity would be
 * created a second time there, with a second Flutter engine writing the same
 * saved scripts. singleTask would avoid that, but Play Billing (RevenueCat)
 * needs standard or singleTop: with singleTask, reopening the app from the
 * launcher icon after confirming a payment in a bank app clears the billing
 * screen and cancels the purchase. So this activity hands the shared content
 * to ImportInbox, brings the task of the single existing MainActivity to the
 * front (starts it only when there is none) and finishes.
 *
 * Duplicates: only this activity reads share intents, once, in onCreate
 * (never when restored or relaunched from Recents). MainActivity never reads
 * its intent, so recreating or relaunching it cannot import anything again.
 */
class ImportActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        try {
            val received: Intent? = intent
            val fromRecents = received != null &&
                (received.flags and Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY) != 0
            if (received != null && savedInstanceState == null && !fromRecents) {
                ImportInbox.parse(this, received)?.let { ImportInbox.enqueue(this, it) }
            }
        } catch (e: Exception) {
            Log.w(ImportInbox.TAG, "Could not import shared content", e)
        }
        try {
            // The content travels through ImportInbox, not an intent: once the
            // items are read, ImportInbox calls `incoming` on the channel the
            // running MainActivity registered (it never needs onNewIntent), and
            // a MainActivity that starts fresh asks for them with takePending.
            // So bringing the existing task forward is all a share needs.
            if (!bringAppTaskToFront()) {
                // No task has MainActivity at its base (the app is not running,
                // or only an emptied task is left in Recents), so this starts
                // the only one. The launcher's own intent (same action, category
                // and component), so the task keeps a plain launcher intent for
                // later relaunches.
                startActivity(
                    Intent(Intent.ACTION_MAIN)
                        .addCategory(Intent.CATEGORY_LAUNCHER)
                        .setClass(this, MainActivity::class.java)
                        .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP),
                )
            }
        } catch (e: Exception) {
            Log.w(ImportInbox.TAG, "Could not open APrompter", e)
        }
        // Theme.NoDisplay: must finish before onResume.
        finish()
    }

    /**
     * Brings the task whose base activity is MainActivity to the front, as the
     * user left it (an open purchase sheet, file picker or Custom Tab stays on
     * top), right above the app that shared, so Back returns there. Returns
     * false when there is no such task or it could not be brought forward.
     *
     * It starts the task's own base intent. Android reuses the task's
     * MainActivity only for an intent equal to the one that started the task
     * (same action, data, type, package, component and categories): then a
     * MainActivity on top gets onNewIntent, and a covered one stays covered.
     * A fixed launcher intent is not equal for a task started with a package
     * in its intent (getLaunchIntentForPackage, e.g. "Open" in the Play Store),
     * which gets a NEW MainActivity on top of whatever covers the old one: a
     * second Flutter engine writing the same scripts.
     *
     * Not AppTask.moveToFront: on Android 9 to 15 it moves the home screen to
     * the front first, so Back from APrompter would go to the launcher instead
     * of back to the app that shared.
     */
    private fun bringAppTaskToFront(): Boolean {
        val main = ComponentName(this, MainActivity::class.java)
        val manager: ActivityManager? = getSystemService(ActivityManager::class.java)
        val tasks: List<ActivityManager.AppTask> = try {
            manager?.appTasks ?: return false
        } catch (e: RuntimeException) {
            Log.w(ImportInbox.TAG, "Could not list APrompter's tasks", e)
            return false
        }
        for (task in tasks) {
            try {
                val info: ActivityManager.RecentTaskInfo? = task.taskInfo
                val base: Intent? = info?.baseIntent
                if (info?.baseActivity == main && base != null) {
                    // Only the filter part (no extras), always explicit, and
                    // only these flags: not the launcher's RESET_TASK_IF_NEEDED,
                    // which may clear or reparent what sits above MainActivity.
                    startActivity(
                        base.cloneFilter()
                            .setComponent(main)
                            .setFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP),
                    )
                    return true
                }
            } catch (e: RuntimeException) {
                // SecurityException, IllegalArgumentException when the task was
                // removed meanwhile, or ActivityNotFoundException: the caller
                // then starts MainActivity with the launcher intent.
                Log.w(ImportInbox.TAG, "Could not bring APrompter's task to the front", e)
            }
        }
        return false
    }
}

/** What one share or "Open with" carried, before any file is read. */
internal class ImportRequest(
    val texts: List<String>,
    val uris: List<Uri>,
    /**
     * Shared files that are never opened (APrompter's own, another scheme, or
     * extras that could not be read). Only counted when nothing else in the
     * share can be imported; each becomes an `unreadable` item.
     */
    val refused: Int,
    val subject: String?,
    val type: String?,
)

/**
 * Process-wide inbox behind the `aprompter/import` channel.
 *
 * Files are read eagerly on a background thread (read grants are temporary),
 * then wait here until Dart calls `takePending`, which hands them over once
 * and removes them. Items that arrive before Dart is listening simply wait:
 * Dart calls `takePending` when its home screen is up, and `incoming` tells a
 * running app that more arrived. When too many bytes wait already, the next
 * file is read once Dart has taken them (see MAX_PENDING_BYTES).
 *
 * An item is a text, a file, or both: one share of a text plus one non-empty
 * text-like file comes as ONE item with `text` and `bytes` set; see read().
 * A file that cannot or must not be read comes as `name` (empty when unknown),
 * `mimeType` when known and `unreadable`, so Dart can tell the user instead of
 * the app opening with nothing.
 */
internal object ImportInbox {
    const val TAG = "APrompterImport"

    /**
     * Per-file limit from the channel contract. tooLarge means exactly this:
     * the file itself is over it. Nothing else marks a file tooLarge.
     */
    private const val MAX_FILE_BYTES = 10 * 1024 * 1024

    /**
     * File bytes allowed to wait for Dart at once, so a share (or several) of
     * many large files cannot run the app out of memory: the bytes sit on the
     * Java heap and the codec copies them again. A file is read only while one
     * more of up to MAX_FILE_BYTES fits under this; otherwise the reader thread
     * hands Dart what it has and waits until Dart has taken the pending items.
     * Waiting, not refusing: a file that is not itself over MAX_FILE_BYTES is
     * never reported as tooLarge, and no per-share file count is needed.
     */
    private const val MAX_PENDING_BYTES = 24 * 1024 * 1024

    private const val OCTET_STREAM = "application/octet-stream"

    /** Non-text types the share filters accept (AndroidManifest.xml). */
    private val DOCUMENT_TYPES = setOf(
        "application/rtf",
        "application/x-rtf",
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "application/vnd.oasis.opendocument.text",
        "application/x-subrip",
        "application/xhtml+xml",
    )

    /** Script files by name, for providers that give no useful type. */
    private val TEXT_EXTENSIONS = setOf(
        "txt", "text", "md", "markdown", "fountain", "rtf", "docx", "odt",
        "srt", "vtt", "html", "htm", "xhtml",
    )

    private val lock = ReentrantLock()
    /** Signalled when Dart has taken the pending items. */
    private val drained = lock.newCondition()
    private val pending = ArrayList<HashMap<String, Any>>() // guarded by lock
    private var pendingBytes = 0 // guarded by lock; grows only on the reader thread
    private val reader: ExecutorService = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())
    private var channel: MethodChannel? = null // main thread only

    fun attach(channel: MethodChannel) {
        channel.setMethodCallHandler { call, result ->
            if (call.method == "takePending") {
                result.success(takePending())
            } else {
                result.notImplemented()
            }
        }
        this.channel = channel
    }

    fun detach(channel: MethodChannel) {
        channel.setMethodCallHandler(null)
        if (this.channel === channel) this.channel = null
    }

    private fun takePending(): List<Map<String, Any>> = lock.withLock {
        val taken = ArrayList<Map<String, Any>>(pending)
        pending.clear()
        pendingBytes = 0
        drained.signalAll()
        taken
    }

    /** Hands items to Dart: they wait in [pending], and `incoming` tells a running app. */
    private fun queue(items: List<HashMap<String, Any>>) {
        if (items.isEmpty()) return
        lock.withLock {
            pending.addAll(items)
            pendingBytes += byteCount(items)
        }
        mainHandler.post { channel?.invokeMethod("incoming", null) }
    }

    /** True when [held] bytes not queued yet plus one more file fit next to the pending ones. */
    private fun hasRoom(held: Int): Boolean = lock.withLock {
        pendingBytes + held <= MAX_PENDING_BYTES - MAX_FILE_BYTES
    }

    /**
     * Blocks the reader thread until one more file fits next to the pending
     * items. Only called while something is pending, for which `incoming` was
     * posted (or Dart's start-up takePending is still to come), so Dart will
     * take it and end the wait.
     */
    private fun awaitRoom() {
        lock.withLock {
            while (pendingBytes > MAX_PENDING_BYTES - MAX_FILE_BYTES) drained.awaitUninterruptibly()
        }
    }

    private fun byteCount(items: List<Map<String, Any>>): Int {
        var total = 0
        for (item in items) (item["bytes"] as? ByteArray)?.let { total += it.size }
        return total
    }

    private fun textItems(texts: List<String>): List<HashMap<String, Any>> =
        texts.map { hashMapOf<String, Any>("text" to it) }

    /** A shared file Dart gets no content of: it could not, or must not, be read. */
    private fun unreadableItem(name: String?, mimeType: String?): HashMap<String, Any> {
        val item = hashMapOf<String, Any>("name" to (name ?: ""), "unreadable" to true)
        mimeType?.let { item["mimeType"] = it }
        return item
    }

    /**
     * Pulls text and Uris out of a SEND, SEND_MULTIPLE or VIEW intent. No I/O.
     * Returns null when the intent carries nothing to import.
     */
    fun parse(context: Context, intent: Intent): ImportRequest? {
        val action = intent.action
        try {
            val texts = ArrayList<String>()
            val uris = ArrayList<Uri>()
            when (intent.action) {
                Intent.ACTION_SEND -> {
                    intent.getCharSequenceExtra(Intent.EXTRA_TEXT)?.let { texts.add(it.toString()) }
                    streamExtra(intent)?.let { uris.add(it) }
                }
                Intent.ACTION_SEND_MULTIPLE -> {
                    val textList = intent.getCharSequenceArrayListExtra(Intent.EXTRA_TEXT)
                    if (textList != null) {
                        for (text in textList) {
                            if (text != null) texts.add(text.toString())
                        }
                    } else {
                        intent.getCharSequenceExtra(Intent.EXTRA_TEXT)?.let { texts.add(it.toString()) }
                    }
                    uris.addAll(streamListExtra(intent))
                    if (uris.isEmpty()) streamExtra(intent)?.let { uris.add(it) }
                }
                Intent.ACTION_VIEW -> intent.data?.let { uris.add(it) }
                else -> return null
            }
            // Some apps only fill ClipData, so fall back to it, but only when
            // the extras carried nothing at all. When they did, ClipData holds
            // either a copy of them (Android mirrors EXTRA_TEXT and EXTRA_STREAM
            // there) or the preview image the share sheet shows for a text
            // share (it takes ClipData item 0), which is not shared content.
            val clip = intent.clipData
            if (intent.action != Intent.ACTION_VIEW && clip != null &&
                texts.isEmpty() && uris.isEmpty()
            ) {
                for (i in 0 until clip.itemCount) {
                    val item = clip.getItemAt(i) ?: continue
                    item.uri?.let { uris.add(it) }
                    item.text?.let { texts.add(it.toString()) }
                }
            }
            val subject = listOf(Intent.EXTRA_SUBJECT, Intent.EXTRA_TITLE).firstNotNullOfOrNull { key ->
                intent.getCharSequenceExtra(key)?.toString()?.trim()?.takeIf { it.isNotEmpty() }
            }
            val usableTexts = texts.filter { it.isNotBlank() }
            val all = uris.distinct()
            val accepted = all.filter { isAcceptedUri(context, it) }
            // Uris that are never opened (APrompter's own files, other schemes)
            // are reported as unreadable when nothing else in the share can be
            // imported, so the app does not open with nothing happening. Next
            // to importable content they are left out, like media.
            val refused = if (usableTexts.isEmpty() && accepted.isEmpty()) all.size else 0
            if (usableTexts.isEmpty() && accepted.isEmpty() && refused == 0) return null
            return ImportRequest(
                texts = usableTexts,
                uris = accepted,
                refused = refused,
                subject = subject,
                type = intent.type,
            )
        } catch (e: Exception) {
            // Malformed extras from the sending app (e.g. BadParcelableException).
            Log.w(TAG, "Could not read the shared intent", e)
            // Something was shared, but none of it can be read: say so.
            val shared = action == Intent.ACTION_SEND || action == Intent.ACTION_SEND_MULTIPLE ||
                action == Intent.ACTION_VIEW
            return if (shared) ImportRequest(emptyList(), emptyList(), 1, null, intent.type) else null
        }
    }

    /**
     * Reads the request's files off the main thread, then queues the items.
     * Call from ImportActivity.onCreate, while it still holds the share's
     * read grants.
     */
    fun enqueue(context: Context, request: ImportRequest) {
        val app = context.applicationContext
        val kept = request.uris.filter { keepReadAccess(app, it) }
        reader.execute {
            try {
                read(app, request)
            } catch (e: Throwable) {
                // Never let a bad file take the app down from this thread.
                Log.w(TAG, "Import failed", e)
            } finally {
                for (uri in kept) releaseReadAccess(app, uri)
            }
        }
    }

    /**
     * The read grants that come with a share belong to ImportActivity and are
     * revoked when it is destroyed, which is right after it finishes. Granting
     * the Uri to our own package once more makes a grant without an owning
     * activity, so the background read works however long it takes (e.g. a
     * cloud file that is downloaded on open). Returns true if it made one.
     */
    private fun keepReadAccess(context: Context, uri: Uri): Boolean {
        if (uri.scheme != ContentResolver.SCHEME_CONTENT) return false
        try {
            val granted = context.checkUriPermission(
                uri,
                android.os.Process.myPid(),
                android.os.Process.myUid(),
                Intent.FLAG_GRANT_READ_URI_PERMISSION,
            ) == PackageManager.PERMISSION_GRANTED
            if (!granted) return false // readable without a grant, or not at all
            // Revoking afterwards would also drop a persisted grant to this Uri.
            val persisted = context.contentResolver.persistedUriPermissions.any {
                it.uri == uri && it.isReadPermission
            }
            if (persisted) return false
            context.grantUriPermission(context.packageName, uri, Intent.FLAG_GRANT_READ_URI_PERMISSION)
            return true
        } catch (e: Exception) {
            Log.w(TAG, "Could not keep read access to a shared file", e)
            return false
        }
    }

    private fun releaseReadAccess(context: Context, uri: Uri) {
        // Only the targeted revoke (API 26+) is limited to grants held by this
        // app; on 24-25 the extra read grant simply lasts until reboot.
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        try {
            context.revokeUriPermission(context.packageName, uri, Intent.FLAG_GRANT_READ_URI_PERMISSION)
        } catch (e: Exception) {
            Log.w(TAG, "Could not release read access to a shared file", e)
        }
    }

    /** One shared Uri, looked at but not read yet. */
    private class SharedFile(
        val uri: Uri,
        val name: String?,
        /** Type reported to Dart: the provider's, else the share's. */
        val mimeType: String?,
        /** Image, video or audio by the provider's type or the file name. */
        val media: Boolean,
        /** Text, or a document type the share filters accept. */
        val textLike: Boolean,
        /**
         * False for a path inside APrompter's own data, or a Uri that could
         * not even be looked at: reported to Dart as unreadable, never opened.
         */
        val readable: Boolean,
    )

    /** Reads the request's files and queues them, with its texts, for Dart. Reader thread only. */
    private fun read(context: Context, request: ImportRequest) {
        val shared = request.uris.map { describe(context, it, request.type) }
        // Images, video and audio cannot become a script, and they come along
        // with what can: a note with a photo attached (sent as */*, which
        // matches any filter), or a text share's preview image from an app
        // that only fills ClipData. Skip them then. A share of nothing but
        // media still goes to Dart, so the user is told it cannot be imported
        // instead of the app opening with nothing.
        val documents = shared.filter { !it.media }
        val files = if (documents.isEmpty() && request.texts.isEmpty()) shared else documents
        // This share's texts and files that are not queued yet.
        val texts = ArrayList(request.texts)
        val read = ArrayList<HashMap<String, Any>>()
        repeat(request.refused) { read.add(unreadableItem(null, mimeType(null, request.type))) }
        var split = false
        for (file in files) {
            val held = byteCount(read)
            if (!hasRoom(held)) {
                // No room for one more file of up to 10 MB. Never tooLarge for
                // that: queue what this share read so far (so Dart can take it)
                // and wait until Dart has taken the pending items. Only a share
                // of several files gets split this way, so the one-text-plus-
                // one-file merge below is not affected.
                if (held > 0) {
                    queue(textItems(texts) + read)
                    texts.clear()
                    read.clear()
                    split = true
                }
                awaitRoom()
            }
            read.add(readFile(context, file))
        }
        // iOS skips empty files. An empty file that came with text is left out
        // the same way, so the text alone becomes the script; an empty file
        // shared on its own still goes to Dart, which says it is empty.
        if (texts.isNotEmpty()) read.removeAll { (it["bytes"] as? ByteArray)?.isEmpty() == true }
        val items = ArrayList<HashMap<String, Any>>()
        val single = read.singleOrNull()
        val singleBytes = single?.get("bytes") as? ByteArray
        if (texts.size == 1 && files.size == 1 && files[0].textLike &&
            single != null && singleBytes != null && singleBytes.isNotEmpty()
        ) {
            // One text plus one text-like file in a single share is one thing:
            // a notes app attaching its export (.md, .txt, .docx) next to the
            // body. Deliver ONE item carrying both `text` and `bytes` (plus
            // name and mimeType) so the user gets one script, not two; Dart
            // picks the richer part. Otherwise (the file could not be read, was
            // too large, empty, or is another kind of file) text and file go as
            // separate items, so the text is never lost behind a file Dart
            // cannot use.
            single["text"] = texts[0]
            items.add(single)
        } else {
            items.addAll(textItems(texts))
            items.addAll(read)
        }
        // A title hint only makes sense for a single item; several files
        // sharing one subject would all get the same title. A split share
        // had several items, some already queued above.
        val subject = request.subject
        if (subject != null && items.size == 1 && !split) items[0]["subject"] = subject
        queue(items)
    }

    /**
     * Name and type of one Uri, without reading it. A file:// path inside the
     * app's own data is described from the path alone and marked unreadable,
     * so it is reported to Dart but never opened.
     */
    private fun describe(context: Context, uri: Uri, intentType: String?): SharedFile {
        try {
            val readable = uri.scheme != ContentResolver.SCHEME_FILE || !isPrivatePath(context, uri)
            val resolver = context.contentResolver
            val name = (if (readable) displayName(resolver, uri) else null) ?: nameFromPath(uri)
            val fromProvider: String? = if (!readable) {
                null
            } else {
                try {
                    resolver.getType(uri)
                } catch (e: Exception) {
                    null
                }
            }
            // The file's own type: the provider's unless it has none or only
            // the generic one, else what its extension stands for. Not the
            // share's type, which covers the whole share.
            val extension = name?.substringAfterLast('.', "")?.lowercase().orEmpty()
            val ownType: String? = fromProvider?.takeIf { it.isNotEmpty() && it != OCTET_STREAM }
                ?: extension.takeIf { it.isNotEmpty() }?.let {
                    MimeTypeMap.getSingleton().getMimeTypeFromExtension(it)
                }
            val base = baseType(ownType)
            val media = base != null &&
                (base.startsWith("image/") || base.startsWith("video/") || base.startsWith("audio/"))
            val textLike = extension in TEXT_EXTENSIONS || isTextType(ownType ?: intentType)
            return SharedFile(uri, name, mimeType(fromProvider, intentType), media, textLike, readable)
        } catch (e: Exception) {
            Log.w(TAG, "Could not look at a shared file", e)
            // Reported as unreadable, never opened.
            return SharedFile(
                uri, null, mimeType(null, intentType), media = false, textLike = false, readable = false,
            )
        }
    }

    /**
     * One file as a channel item. Over MAX_FILE_BYTES: name only, tooLarge.
     * When it cannot be read at all (no permission, gone, refused, a private
     * path): name only, unreadable.
     */
    private fun readFile(context: Context, file: SharedFile): HashMap<String, Any> {
        if (file.readable) {
            try {
                val input = context.contentResolver.openInputStream(file.uri)
                if (input != null) {
                    val bytes = input.use { readCapped(it, MAX_FILE_BYTES) }
                    val item = HashMap<String, Any>()
                    file.name?.let { item["name"] = it }
                    file.mimeType?.let { item["mimeType"] = it }
                    if (bytes != null) item["bytes"] = bytes else item["tooLarge"] = true
                    return item
                }
            } catch (e: SecurityException) {
                Log.w(TAG, "No permission to read a shared file", e)
            } catch (e: Exception) {
                // IOException (FileNotFoundException, ...) or a misbehaving provider.
                Log.w(TAG, "Could not read a shared file", e)
            }
        }
        return unreadableItem(file.name, file.mimeType)
    }

    /** The stream's bytes, or null as soon as it is longer than [cap]. */
    private fun readCapped(input: InputStream, cap: Int): ByteArray? {
        val out = ByteArrayOutputStream(minOf(cap, 64 * 1024))
        val buffer = ByteArray(64 * 1024)
        var total = 0
        while (true) {
            val count = input.read(buffer)
            if (count < 0) break
            total += count
            if (total > cap) return null
            out.write(buffer, 0, count)
        }
        return out.toByteArray()
    }

    private fun displayName(resolver: ContentResolver, uri: Uri): String? {
        if (uri.scheme == ContentResolver.SCHEME_CONTENT) {
            try {
                resolver.query(uri, arrayOf(OpenableColumns.DISPLAY_NAME), null, null, null)?.use { cursor ->
                    if (cursor.moveToFirst()) {
                        val index = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                        if (index >= 0 && !cursor.isNull(index)) {
                            val name = cursor.getString(index)
                            if (!name.isNullOrBlank()) return name
                        }
                    }
                }
            } catch (e: Exception) {
                // Some providers do not answer queries; fall back to the path.
            }
        }
        return nameFromPath(uri)
    }

    /** e.g. ".../document/primary:Scripts/Hook ideas.md" -> "Hook ideas.md". No I/O. */
    private fun nameFromPath(uri: Uri): String? {
        val last = uri.lastPathSegment ?: return null
        return last.substringAfterLast('/').substringAfterLast(':').takeIf { it.isNotBlank() }
    }

    /** The type reported to Dart: the provider's, else the share's. */
    private fun mimeType(fromProvider: String?, intentType: String?): String? {
        val fromIntent = intentType?.takeIf { it != "*/*" }
        return when {
            fromProvider.isNullOrEmpty() -> fromIntent
            fromProvider == OCTET_STREAM && fromIntent != null -> fromIntent
            else -> fromProvider
        }
    }

    /** "Text/Plain; charset=utf-8" -> "text/plain". */
    private fun baseType(type: String?): String? =
        type?.substringBefore(';')?.trim()?.lowercase()?.takeIf { it.isNotEmpty() }

    private fun isTextType(type: String?): Boolean {
        val base = baseType(type) ?: return false
        return base.startsWith("text/") || base in DOCUMENT_TYPES
    }

    @Suppress("DEPRECATION")
    private fun streamExtra(intent: Intent): Uri? =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            // Typed getters only from 34: on 33 they can throw (as in IntentCompat).
            intent.getParcelableExtra(Intent.EXTRA_STREAM, Uri::class.java)
        } else {
            intent.getParcelableExtra<Parcelable>(Intent.EXTRA_STREAM) as? Uri
        }

    @Suppress("DEPRECATION")
    private fun streamListExtra(intent: Intent): List<Uri> {
        val list: List<Any?>? =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                intent.getParcelableArrayListExtra(Intent.EXTRA_STREAM, Uri::class.java)
            } else {
                intent.getParcelableArrayListExtra<Parcelable>(Intent.EXTRA_STREAM)
            }
        return list.orEmpty().filterIsInstance<Uri>()
    }

    /**
     * Only content:// and file:// Uris, and never APrompter's own providers
     * (another app could otherwise make the app import its own private files).
     */
    private fun isAcceptedUri(context: Context, uri: Uri): Boolean = when (uri.scheme) {
        ContentResolver.SCHEME_CONTENT -> {
            // "content://10@authority/..." addresses another user's provider.
            val authority = uri.authority?.substringAfterLast('@')
            val own = context.packageName
            authority != null && authority != own && !authority.startsWith("$own.")
        }
        ContentResolver.SCHEME_FILE -> uri.path != null
        else -> false
    }

    /**
     * True for file:// paths inside the app's own data directories or /proc,
     * and for paths that cannot be resolved (never opened either).
     */
    private fun isPrivatePath(context: Context, uri: Uri): Boolean {
        val path = uri.path ?: return true
        return try {
            val real = File(path).canonicalPath
            if (real == "/proc" || real.startsWith("/proc/")) return true
            val info = context.applicationInfo
            listOfNotNull(info.dataDir, info.deviceProtectedDataDir).any { dir ->
                val root = File(dir).canonicalPath
                real == root || real.startsWith(root + File.separator)
            }
        } catch (e: Exception) {
            Log.w(TAG, "Could not resolve a shared file path", e)
            true
        }
    }
}
