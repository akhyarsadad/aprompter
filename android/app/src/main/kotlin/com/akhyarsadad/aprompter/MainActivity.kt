package com.akhyarsadad.aprompter

import android.app.Activity
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.Parcelable
import android.provider.OpenableColumns
import android.provider.Settings
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.InputStream
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    private var importChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Lets the app send the user to its system settings page, e.g. after
        // camera permission was denied.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "aprompter/system")
            .setMethodCallHandler { call, result ->
                if (call.method == "openAppSettings") {
                    val intent = Intent(
                        Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                        Uri.fromParts("package", packageName, null),
                    ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    startActivity(intent)
                    result.success(true)
                } else {
                    result.notImplemented()
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
 * to ImportInbox, brings up the single existing MainActivity and finishes.
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
            // The launcher's own intent (same action, category and component),
            // so this behaves exactly like tapping the app icon: onNewIntent on
            // a MainActivity that is on top, the task as the user left it
            // otherwise (an open purchase sheet is not closed), a new task when
            // the app is not running; never a second MainActivity. The content
            // travels through ImportInbox, not this intent, so the task keeps a
            // plain launcher intent for later relaunches.
            startActivity(
                Intent(Intent.ACTION_MAIN)
                    .addCategory(Intent.CATEGORY_LAUNCHER)
                    .setClass(this, MainActivity::class.java)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP),
            )
        } catch (e: Exception) {
            Log.w(ImportInbox.TAG, "Could not open APrompter", e)
        }
        // Theme.NoDisplay: must finish before onResume.
        finish()
    }
}

/** What one share or "Open with" carried, before any file is read. */
internal class ImportRequest(
    val texts: List<String>,
    val uris: List<Uri>,
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
 * running app that more arrived.
 */
internal object ImportInbox {
    const val TAG = "APrompterImport"

    /** Per-file limit from the channel contract. */
    private const val MAX_FILE_BYTES = 10 * 1024 * 1024

    /**
     * Total bytes allowed to wait for Dart at once. Keeps a share of many large
     * files from running the app out of memory (the codec copies them again);
     * files past it are reported as tooLarge, like a file over 10 MB.
     */
    private const val MAX_PENDING_BYTES = 24 * 1024 * 1024

    private val lock = Any()
    private val pending = ArrayList<HashMap<String, Any>>() // guarded by lock
    private var pendingBytes = 0 // guarded by lock
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

    private fun takePending(): List<Map<String, Any>> = synchronized(lock) {
        val taken = ArrayList<Map<String, Any>>(pending)
        pending.clear()
        pendingBytes = 0
        taken
    }

    /**
     * Pulls text and Uris out of a SEND, SEND_MULTIPLE or VIEW intent. No I/O.
     * Returns null when the intent carries nothing to import.
     */
    fun parse(context: Context, intent: Intent): ImportRequest? {
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
            // Some apps only fill ClipData (Android also mirrors EXTRA_TEXT and
            // EXTRA_STREAM there), so use it for whatever the extras lacked.
            val clip = intent.clipData
            if (intent.action != Intent.ACTION_VIEW && clip != null &&
                (texts.isEmpty() || uris.isEmpty())
            ) {
                val clipTexts = ArrayList<String>()
                val clipUris = ArrayList<Uri>()
                for (i in 0 until clip.itemCount) {
                    val item = clip.getItemAt(i) ?: continue
                    item.uri?.let { clipUris.add(it) }
                    item.text?.let { clipTexts.add(it.toString()) }
                }
                if (texts.isEmpty()) texts.addAll(clipTexts)
                if (uris.isEmpty()) uris.addAll(clipUris)
            }
            val subject = listOf(Intent.EXTRA_SUBJECT, Intent.EXTRA_TITLE).firstNotNullOfOrNull { key ->
                intent.getCharSequenceExtra(key)?.toString()?.trim()?.takeIf { it.isNotEmpty() }
            }
            val request = ImportRequest(
                texts = texts.filter { it.isNotBlank() },
                uris = uris.distinct().filter { isAcceptedUri(context, it) },
                subject = subject,
                type = intent.type,
            )
            return if (request.texts.isEmpty() && request.uris.isEmpty()) null else request
        } catch (e: Exception) {
            // Malformed extras from the sending app (e.g. BadParcelableException).
            Log.w(TAG, "Could not read the shared intent", e)
            return null
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
                val items = read(app, request)
                if (items.isNotEmpty()) {
                    synchronized(lock) {
                        pending.addAll(items)
                        for (item in items) {
                            (item["bytes"] as? ByteArray)?.let { pendingBytes += it.size }
                        }
                    }
                    mainHandler.post { channel?.invokeMethod("incoming", null) }
                }
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

    private fun read(context: Context, request: ImportRequest): List<HashMap<String, Any>> {
        var budget = MAX_PENDING_BYTES - synchronized(lock) { pendingBytes }
        val files = ArrayList<HashMap<String, Any>>()
        for (uri in request.uris) {
            val cap = minOf(MAX_FILE_BYTES, maxOf(budget, 0))
            val file = readFile(context, uri, request.type, cap) ?: continue
            (file["bytes"] as? ByteArray)?.let { budget -= it.size }
            files.add(file)
        }
        val items = ArrayList<HashMap<String, Any>>()
        if (request.texts.size == 1 && request.uris.size == 1) {
            // One text plus one file in a single share is one thing: a notes
            // app attaching its export next to the body, or a caption on a
            // file. Deliver ONE item with both fields so the user gets one
            // script, not two; Dart picks the richer part. If the file could
            // not be read, the item carries just the text.
            val item = files.firstOrNull() ?: HashMap<String, Any>()
            item["text"] = request.texts[0]
            items.add(item)
        } else {
            for (text in request.texts) items.add(hashMapOf<String, Any>("text" to text))
            items.addAll(files)
        }
        // A title hint only makes sense for a single item; several files
        // sharing one subject would all get the same title.
        val subject = request.subject
        if (subject != null && items.size == 1) items[0]["subject"] = subject
        return items
    }

    /**
     * One file as a channel item, or null when it cannot be read at all
     * (no permission, gone, refused). Over [cap] bytes: name only, tooLarge.
     */
    private fun readFile(context: Context, uri: Uri, intentType: String?, cap: Int): HashMap<String, Any>? {
        try {
            if (uri.scheme == ContentResolver.SCHEME_FILE && isPrivatePath(context, uri)) return null
            val resolver = context.contentResolver
            val item = HashMap<String, Any>()
            displayName(resolver, uri)?.let { item["name"] = it }
            mimeType(resolver, uri, intentType)?.let { item["mimeType"] = it }
            val input = resolver.openInputStream(uri) ?: return null
            val bytes = input.use { readCapped(it, cap) }
            if (bytes != null) item["bytes"] = bytes else item["tooLarge"] = true
            return item
        } catch (e: SecurityException) {
            Log.w(TAG, "No permission to read a shared file", e)
        } catch (e: Exception) {
            // IOException (FileNotFoundException, ...) or a misbehaving provider.
            Log.w(TAG, "Could not read a shared file", e)
        }
        return null
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
        // e.g. ".../document/primary:Scripts/Hook ideas.md" -> "Hook ideas.md"
        val last = uri.lastPathSegment ?: return null
        return last.substringAfterLast('/').substringAfterLast(':').takeIf { it.isNotBlank() }
    }

    private fun mimeType(resolver: ContentResolver, uri: Uri, intentType: String?): String? {
        val fromProvider = try {
            resolver.getType(uri)
        } catch (e: Exception) {
            null
        }
        val fromIntent = intentType?.takeIf { it != "*/*" }
        return when {
            fromProvider.isNullOrEmpty() -> fromIntent
            fromProvider == "application/octet-stream" && fromIntent != null -> fromIntent
            else -> fromProvider
        }
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

    /** True for file:// paths inside the app's own data directories or /proc. */
    private fun isPrivatePath(context: Context, uri: Uri): Boolean {
        val path = uri.path ?: return true
        val real = File(path).canonicalPath
        if (real == "/proc" || real.startsWith("/proc/")) return true
        val info = context.applicationInfo
        return listOfNotNull(info.dataDir, info.deviceProtectedDataDir).any { dir ->
            val root = File(dir).canonicalPath
            real == root || real.startsWith(root + File.separator)
        }
    }
}
