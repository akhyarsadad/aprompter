import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  /// Brightness before the prompter turned it up, restored afterwards.
  private var savedBrightness: CGFloat?

  /// `aprompter/import`: scripts shared in through the Share Extension.
  private var importChannel: FlutterMethodChannel?
  private var importObservers: [NSObjectProtocol] = []
  private var importObserversInstalled = false
  /// Serializes all inbox reads, so two takePending calls can never hand out
  /// the same item twice.
  private let importQueue = DispatchQueue(label: "com.akhyarsadad.aprompter.import")

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    if let importRegistrar = engineBridge.pluginRegistry.registrar(forPlugin: "AprompterImport") {
      setUpImportChannel(
        FlutterMethodChannel(
          name: "aprompter/import", binaryMessenger: importRegistrar.messenger()))
    }

    guard let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "AprompterSystem")
    else { return }
    let channel = FlutterMethodChannel(
      name: "aprompter/system", binaryMessenger: registrar.messenger())
    channel.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      // Sends the user to the app's Settings page, e.g. after camera
      // permission was denied.
      case "openAppSettings":
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
          result(false)
          return
        }
        UIApplication.shared.open(url) { opened in result(opened) }
      // Free space for recordings, in bytes.
      case "freeSpace":
        let home = URL(fileURLWithPath: NSHomeDirectory())
        let values = try? home.resourceValues(
          forKeys: [.volumeAvailableCapacityForImportantUsageKey])
        if let bytes = values?.volumeAvailableCapacityForImportantUsage {
          result(NSNumber(value: bytes))
        } else {
          result(nil)
        }
      // Battery level 0–100 and whether it is charging; nil if unknown.
      case "battery":
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        let level = device.batteryLevel
        if level < 0 {
          result(nil)
        } else {
          result([
            "level": Int(level * 100),
            "charging": device.batteryState == .charging || device.batteryState == .full,
          ])
        }
      // Full brightness while prompting (sunlight), then back.
      case "setBright":
        let on = (call.arguments as? Bool) ?? false
        let screen = UIScreen.main
        if on {
          if self?.savedBrightness == nil { self?.savedBrightness = screen.brightness }
          screen.brightness = 1.0
        } else if let saved = self?.savedBrightness {
          screen.brightness = saved
          self?.savedBrightness = nil
        }
        result(true)
      case "deviceInfo":
        result(["manufacturer": "Apple", "lowRam": false])
      // Keeps a folder (takes kept inside the app) out of iCloud Backup,
      // as Android's backup rules do; this covers everything inside it.
      case "excludeFromBackup":
        guard let path = call.arguments as? String else {
          result(false)
          return
        }
        var url = URL(fileURLWithPath: path, isDirectory: true)
        var values = URLResourceValues()
        values.isExcludedFromBackup = true
        do {
          try url.setResourceValues(values)
          result(true)
        } catch {
          result(false)
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  // MARK: - Share Extension import

  /// Dart calls `takePending` (on start and whenever we send `incoming`); it
  /// returns the items the Share Extension saved and removes them, so each
  /// item is delivered exactly once. A large share is handed over in parts
  /// (see ImportInbox.maxBytesPerTake): after replying, `incoming` is sent
  /// again while items are left.
  private func setUpImportChannel(_ channel: FlutterMethodChannel) {
    importChannel = channel
    let queue = importQueue
    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "takePending" else {
        result(FlutterMethodNotImplemented)
        return
      }
      queue.async {
        let taken = ImportInbox.takePending()
        DispatchQueue.main.async {
          result(taken.items)
          if taken.hasMore {
            self?.importChannel?.invokeMethod("incoming", arguments: nil)
          }
        }
      }
    }

    guard !importObserversInstalled else { return }
    importObserversInstalled = true

    // Usual flow: share from another app, then switch to APrompter.
    importObservers.append(
      NotificationCenter.default.addObserver(
        forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main
      ) { [weak self] _ in
        self?.notifyDartIfImportsPending()
      })

    // Shared while APrompter stays on screen (iPad Split View / Slide Over):
    // the extension posts this Darwin notification after saving.
    CFNotificationCenterAddObserver(
      CFNotificationCenterGetDarwinNotifyCenter(),
      Unmanaged.passUnretained(self).toOpaque(),
      { _, observer, _, _, _ in
        guard let observer = observer else { return }
        let appDelegate = Unmanaged<AppDelegate>.fromOpaque(observer).takeUnretainedValue()
        DispatchQueue.main.async { appDelegate.notifyDartIfImportsPending() }
      },
      ImportInbox.changedNotification as CFString,
      nil,
      .deliverImmediately)
  }

  /// Sends `incoming` when the inbox holds anything; Dart then calls takePending.
  private func notifyDartIfImportsPending() {
    guard let channel = importChannel else { return }
    importQueue.async {
      guard ImportInbox.hasPending() else { return }
      DispatchQueue.main.async { channel.invokeMethod("incoming", arguments: nil) }
    }
  }
}

/// The App Group inbox the Share Extension (ios/ShareExtension) writes to:
/// one JSON file per shared item in `ImportInbox/`, named
/// `<15-digit ms timestamp>-<4-digit index>-<UUID>.json`, so sorting by name
/// gives arrival order without reading file dates. Keys: `text`, `subject`,
/// `name`, `mimeType`, `bytesBase64`, `tooLarge`. The extension moves each
/// finished file in atomically, so a file seen here is always complete.
enum ImportInbox {
  static let appGroupId = "group.com.akhyarsadad.aprompter"
  /// Darwin notification posted by the extension after it saved something.
  static let changedNotification = "com.akhyarsadad.aprompter.importInboxChanged"

  private static var directory: URL? {
    FileManager.default
      .containerURL(forSecurityApplicationGroupIdentifier: appGroupId)?
      .appendingPathComponent("ImportInbox", isDirectory: true)
  }

  /// Bytes one `takePending` reply carries at most (about; at least one file
  /// always goes). The codec copies them again, so a share of many large
  /// files is handed over in parts instead of all at once.
  static let maxBytesPerTake = 40 * 1024 * 1024

  static func hasPending() -> Bool {
    return !pendingFiles().isEmpty
  }

  /// Decodes and deletes pending items, oldest first, until about
  /// `maxBytesPerTake` bytes are collected. Files past that stay in the inbox
  /// and `hasMore` is true; only returned (or unreadable) files are deleted.
  /// Empty when the container or the inbox doesn't exist.
  static func takePending() -> (items: [[String: Any]], hasMore: Bool) {
    var items: [[String: Any]] = []
    var collectedBytes = 0
    for file in pendingFiles() {
      // The file's bytes are base64 in the JSON: 3 bytes per 4 characters.
      let fileSize = (try? file.resourceValues(forKeys: [.fileSizeKey]))?.fileSize ?? 0
      let estimatedBytes = fileSize / 4 * 3
      if collectedBytes > 0 && collectedBytes + estimatedBytes > maxBytesPerTake {
        return (items, true)
      }
      // Frees the JSON and its base64 text before the next file is read.
      autoreleasepool {
        if let data = try? Data(contentsOf: file), let item = decode(data) {
          if let bytes = item["bytes"] as? FlutterStandardTypedData {
            collectedBytes += bytes.data.count
          }
          items.append(item)
        }
        // Unreadable files are removed too, so one bad file can't wedge the inbox.
        try? FileManager.default.removeItem(at: file)
      }
    }
    return (items, false)
  }

  private static func pendingFiles() -> [URL] {
    guard let inbox = ImportInbox.directory,
      let names = try? FileManager.default.contentsOfDirectory(atPath: inbox.path)
    else { return [] }
    let jsonNames = names.filter { $0.hasSuffix(".json") && !$0.hasPrefix(".") }
    return jsonNames.sorted().map { inbox.appendingPathComponent($0, isDirectory: false) }
  }

  /// One inbox file -> one `takePending` map: text, subject, name, mimeType,
  /// bytes (FlutterStandardTypedData), tooLarge.
  private static func decode(_ data: Data) -> [String: Any]? {
    guard
      let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any]
    else { return nil }
    var item: [String: Any] = [:]
    for key in ["text", "subject", "name", "mimeType"] {
      if let value = json[key] as? String {
        item[key] = value
      }
    }
    var hasContent = item["text"] != nil
    if let base64 = json["bytesBase64"] as? String, let bytes = Data(base64Encoded: base64) {
      item["bytes"] = FlutterStandardTypedData(bytes: bytes)
      hasContent = true
    }
    if (json["tooLarge"] as? Bool) == true {
      item["tooLarge"] = true
      hasContent = true
    }
    return hasContent ? item : nil
  }
}
