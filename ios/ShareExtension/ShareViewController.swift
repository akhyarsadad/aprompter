import UIKit
import UniformTypeIdentifiers

/// "Share to APrompter".
///
/// Saves whatever was shared (text from Notes, Messages, Mail…, or documents
/// from Files, Mail and other apps) into the App Group inbox and shows a short
/// confirmation. APrompter collects the items through the `aprompter/import`
/// channel (`takePending`) the next time it is active. The app is never
/// launched from here.
///
/// Inbox format (read by `ImportInbox` in Runner/AppDelegate.swift): one JSON
/// file per item in `<App Group>/ImportInbox/`, named
/// `<15-digit ms timestamp>-<4-digit index>-<UUID>.json`, so sorting by name
/// gives arrival order without reading file dates. Keys (all optional): `text`,
/// `subject`, `name`, `mimeType`, `bytesBase64`, `tooLarge`. Each file is
/// written to `ImportStaging/` first and then moved into the inbox, so the app
/// never sees a half-written item.
final class ShareViewController: UIViewController {
  private let card = UIView()
  private let spinner = UIActivityIndicatorView(style: .large)
  private let iconView = UIImageView()
  private let titleLabel = UILabel()
  private let messageLabel = UILabel()
  private let button = UIButton(type: .system)

  private let cancelFlag = CancelFlag()
  private var started = false
  private var importDone = false
  private var finished = false

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    modalPresentationStyle = .overFullScreen
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    modalPresentationStyle = .overFullScreen
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Only the Cancel/Done button (or the auto-close) ends the request.
    isModalInPresentation = true
    buildCard()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    guard !started else { return }
    started = true

    let extensionItems =
      extensionContext?.inputItems.compactMap { $0 as? NSExtensionItem } ?? []
    let cancelFlag = self.cancelFlag
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      let saved = ShareImporter.importItems(extensionItems, isCancelled: { cancelFlag.isSet })
      DispatchQueue.main.async {
        self?.showResult(success: saved > 0)
      }
    }
  }

  // MARK: - UI

  private func buildCard() {
    view.backgroundColor = UIColor.black.withAlphaComponent(0.25)

    // Lifted a step in dark mode so the card stands out from the dimmed app.
    card.backgroundColor = UIColor(dynamicProvider: { traits in
      traits.userInterfaceStyle == .dark ? .secondarySystemBackground : .systemBackground
    })
    card.layer.cornerRadius = 20
    card.layer.cornerCurve = .continuous
    card.layer.shadowColor = UIColor.black.cgColor
    card.layer.shadowOpacity = 0.18
    card.layer.shadowRadius = 24
    card.layer.shadowOffset = CGSize(width: 0, height: 8)
    card.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(card)

    spinner.hidesWhenStopped = true
    spinner.startAnimating()

    iconView.contentMode = .center
    iconView.isHidden = true

    titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    titleLabel.adjustsFontForContentSizeCategory = true
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 0
    titleLabel.isHidden = true

    messageLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    messageLabel.adjustsFontForContentSizeCategory = true
    messageLabel.textColor = .secondaryLabel
    messageLabel.textAlignment = .center
    messageLabel.numberOfLines = 0
    messageLabel.isHidden = true

    button.setTitle(
      NSLocalizedString("Cancel", comment: "Share extension: stop adding the shared item"),
      for: .normal)
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    button.titleLabel?.adjustsFontForContentSizeCategory = true
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

    let stack = UIStackView(arrangedSubviews: [spinner, iconView, titleLabel, messageLabel, button])
    stack.axis = .vertical
    stack.alignment = .fill
    stack.spacing = 12
    stack.translatesAutoresizingMaskIntoConstraints = false
    card.addSubview(stack)

    let preferredWidth = card.widthAnchor.constraint(equalToConstant: 300)
    preferredWidth.priority = .defaultHigh
    NSLayoutConstraint.activate([
      card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      card.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      card.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
      card.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),
      card.topAnchor.constraint(
        greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      card.bottomAnchor.constraint(
        lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
      preferredWidth,
      stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 24),
      stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
      stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
      stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
      button.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
    ])
  }

  private func showResult(success: Bool) {
    guard !finished else { return }
    importDone = true

    spinner.stopAnimating()
    spinner.isHidden = true

    let symbol = success ? "checkmark.circle.fill" : "exclamationmark.triangle.fill"
    iconView.image = UIImage(
      systemName: symbol,
      withConfiguration: UIImage.SymbolConfiguration(pointSize: 44, weight: .semibold))
    iconView.tintColor = success ? .systemGreen : .systemOrange
    iconView.isHidden = false

    titleLabel.text =
      success
      ? NSLocalizedString(
        "Added to APrompter",
        comment: "Share extension: the shared text or file was saved for the app")
      : NSLocalizedString(
        "Couldn't add this to APrompter",
        comment: "Share extension: nothing in the share could be saved")
    titleLabel.isHidden = false

    messageLabel.text = NSLocalizedString(
      "Open APrompter to start reading.",
      comment: "Share extension: hint shown after the item was saved")
    messageLabel.isHidden = !success

    button.setTitle(
      NSLocalizedString("Done", comment: "Share extension: close the confirmation"),
      for: .normal)

    UIAccessibility.post(notification: .announcement, argument: titleLabel.text)

    if success {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
        self?.finish()
      }
    }
  }

  @objc private func buttonTapped() {
    if importDone {
      finish()
      return
    }
    // Cancel while still loading: stop before anything else is saved.
    cancelFlag.set()
    guard !finished else { return }
    finished = true
    extensionContext?.cancelRequest(withError: CocoaError(.userCancelled))
  }

  private func finish() {
    guard !finished else { return }
    finished = true
    extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
  }
}

// MARK: - Import

/// One thing to hand to the app (see the `aprompter/import` contract).
private struct SharedItem {
  var text: String?
  var subject: String?
  var name: String?
  var mimeType: String?
  var bytes: Data?
  var tooLarge = false
}

private final class CancelFlag {
  private let lock = NSLock()
  private var value = false

  var isSet: Bool {
    lock.lock()
    defer { lock.unlock() }
    return value
  }

  func set() {
    lock.lock()
    value = true
    lock.unlock()
  }
}

/// Holds an NSItemProvider result handed over from its callback queue.
private final class ResultBox {
  private let lock = NSLock()
  private var stored: SharedItem?

  var item: SharedItem? {
    get {
      lock.lock()
      defer { lock.unlock() }
      return stored
    }
    set {
      lock.lock()
      stored = newValue
      lock.unlock()
    }
  }
}

private enum ShareImporter {
  static let appGroupId = "group.com.akhyarsadad.aprompter"
  /// Darwin notification the app listens for (ImportInbox.changedNotification).
  static let inboxChangedNotification = "com.akhyarsadad.aprompter.importInboxChanged"
  /// Same cap as on Android: bigger files are passed on as `tooLarge`, without bytes.
  static let maxFileBytes = 10 * 1024 * 1024
  /// Per load attempt; iCloud files may have to download first.
  static let loadTimeout: Double = 60

  /// Plain-text flavours whose in-memory data is decoded into `text`.
  static let plainTextIdentifiers: Set<String> = [
    "public.plain-text",
    "public.utf8-plain-text",
    "public.utf16-plain-text",
    "public.utf16-external-plain-text",
    "public.text",
  ]

  private enum Attempt {
    case fileURL
    case text(UTType)
    case document(UTType)
  }

  /// Saves everything importable, one attachment at a time so only one file
  /// is in memory at once (share extensions have a tight memory limit).
  /// Must not run on the main thread. Returns how many items were saved.
  static func importItems(_ extensionItems: [NSExtensionItem], isCancelled: () -> Bool) -> Int {
    guard let inbox = Inbox() else { return 0 }
    var saved = 0
    var seenTexts = Set<String>()

    for extensionItem in extensionItems {
      let subject = trimmed(extensionItem.attributedTitle?.string)
      var foundAny = false

      for provider in extensionItem.attachments ?? [] {
        if isCancelled() { return saved }
        autoreleasepool {
          guard var item = load(provider) else { return }
          foundAny = true
          if let text = item.text {
            // Some apps attach the same text more than once.
            guard seenTexts.insert(text).inserted else { return }
            item.subject = subject
          }
          if inbox.write(item) {
            saved += 1
          }
        }
      }

      // Text that only came as the item's content text (no usable attachment).
      if !foundAny, !isCancelled(),
        let text = extensionItem.attributedContentText?.string,
        trimmed(text) != nil,
        seenTexts.insert(text).inserted
      {
        var item = SharedItem()
        item.text = text
        item.subject = subject
        item.mimeType = "text/plain"
        if inbox.write(item) {
          saved += 1
        }
      }
    }

    if saved > 0 {
      CFNotificationCenterPostNotification(
        CFNotificationCenterGetDarwinNotifyCenter(),
        CFNotificationName(rawValue: inboxChangedNotification as CFString),
        nil,
        nil,
        true)
    }
    return saved
  }

  /// Tries the provider's representations, best first: a real file, then plain
  /// text (Notes, Messages, .txt/.md files), then other documents (RTF, Word,
  /// ODT, HTML, other data). Photos, videos, audio and web links are skipped.
  private static func load(_ provider: NSItemProvider) -> SharedItem? {
    var attempts: [Attempt] = []
    if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
      attempts.append(.fileURL)
    }
    let types = provider.registeredTypeIdentifiers.compactMap { UTType($0) }
    for type in types where isText(type) {
      attempts.append(.text(type))
    }
    for type in types where !isText(type) && isDocument(type) {
      attempts.append(.document(type))
    }
    for attempt in attempts {
      if let item = loadSynchronously(attempt, provider: provider) {
        return item
      }
    }
    return nil
  }

  private static func isText(_ type: UTType) -> Bool {
    return type.conforms(to: .plainText) || type == .text
  }

  private static func isDocument(_ type: UTType) -> Bool {
    return type.conforms(to: .data)
      && !type.conforms(to: .url)
      && !type.conforms(to: .image)
      && !type.conforms(to: .audiovisualContent)
  }

  /// Runs one NSItemProvider load and blocks this (background) thread until
  /// it reports back. The callbacks run on NSItemProvider's own queues.
  private static func loadSynchronously(_ attempt: Attempt, provider: NSItemProvider) -> SharedItem? {
    let box = ResultBox()
    let semaphore = DispatchSemaphore(value: 0)
    start(attempt, provider: provider) { item in
      box.item = item
      semaphore.signal()
    }
    guard semaphore.wait(timeout: .now() + loadTimeout) == .success else { return nil }
    return box.item
  }

  /// Calls `completion` exactly once.
  private static func start(
    _ attempt: Attempt, provider: NSItemProvider,
    completion: @escaping (SharedItem?) -> Void
  ) {
    let suggestedName = provider.suggestedName
    switch attempt {
    case .fileURL:
      provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) {
        loaded, _ in
        guard let url = ShareImporter.url(from: loaded), url.isFileURL else {
          completion(nil)
          return
        }
        completion(
          ShareImporter.fileItem(
            at: url, type: nil, suggestedName: suggestedName, keepFileName: true))
      }

    case .text(let type):
      provider.loadItem(forTypeIdentifier: type.identifier, options: nil) { loaded, _ in
        completion(
          ShareImporter.makeItem(from: loaded, type: type, suggestedName: suggestedName))
      }

    case .document(let type):
      _ = provider.loadFileRepresentation(forTypeIdentifier: type.identifier) {
        temporaryURL, _ in
        if let temporaryURL = temporaryURL {
          // The copy is deleted when this handler returns, so read it now.
          completion(
            ShareImporter.fileItem(
              at: temporaryURL, type: type, suggestedName: suggestedName, keepFileName: false))
          return
        }
        // Some apps only share documents as in-memory data.
        provider.loadItem(forTypeIdentifier: type.identifier, options: nil) { loaded, _ in
          completion(
            ShareImporter.makeItem(from: loaded, type: type, suggestedName: suggestedName))
        }
      }
    }
  }

  private static func url(from loaded: NSSecureCoding?) -> URL? {
    if let url = loaded as? URL {
      return url
    }
    if let data = loaded as? Data {
      return URL(dataRepresentation: data, relativeTo: nil)
    }
    if let string = loaded as? String {
      return URL(string: string)
    }
    return nil
  }

  /// loadItem can hand back a URL, String, NSAttributedString or Data.
  private static func makeItem(
    from loaded: NSSecureCoding?, type: UTType, suggestedName: String?
  ) -> SharedItem? {
    if let url = loaded as? URL {
      if url.isFileURL {
        return fileItem(at: url, type: type, suggestedName: suggestedName, keepFileName: true)
      }
      return isText(type) ? textItem(url.absoluteString) : nil
    }
    if let string = loaded as? String {
      if isText(type) {
        return textItem(string)
      }
      return dataItem(Data(string.utf8), type: type, suggestedName: suggestedName)
    }
    if let attributed = loaded as? NSAttributedString {
      return textItem(attributed.string)
    }
    if let data = loaded as? Data {
      return dataItem(data, type: type, suggestedName: suggestedName)
    }
    return nil
  }

  private static func textItem(_ text: String) -> SharedItem? {
    guard trimmed(text) != nil else { return nil }
    var item = SharedItem()
    item.text = text
    item.mimeType = "text/plain"
    return item
  }

  /// In-memory data: plain text becomes `text`, anything else a named file.
  private static func dataItem(_ data: Data, type: UTType, suggestedName: String?) -> SharedItem? {
    if data.isEmpty {
      return nil
    }
    if plainTextIdentifiers.contains(type.identifier) {
      let utf16 = type.identifier.hasPrefix("public.utf16")
      if let string = String(data: data, encoding: utf16 ? .utf16 : .utf8) {
        return textItem(string)
      }
    }
    var item = SharedItem()
    let name = fileName(url: nil, type: type, suggestedName: suggestedName, keepFileName: false)
    item.name = name
    item.mimeType = mimeType(fileName: name, type: type)
    if data.count > maxFileBytes {
      item.tooLarge = true
    } else {
      item.bytes = data
    }
    return item
  }

  /// Reads a shared file. Files over the cap keep their name but no bytes.
  private static func fileItem(
    at url: URL, type: UTType?, suggestedName: String?, keepFileName: Bool
  ) -> SharedItem? {
    let scoped = url.startAccessingSecurityScopedResource()
    defer {
      if scoped {
        url.stopAccessingSecurityScopedResource()
      }
    }

    let values = try? url.resourceValues(forKeys: [.isDirectoryKey, .fileSizeKey])
    if values?.isDirectory == true {
      return nil
    }

    var item = SharedItem()
    let name = fileName(url: url, type: type, suggestedName: suggestedName, keepFileName: keepFileName)
    item.name = name
    item.mimeType = mimeType(fileName: name, type: type)

    if let size = values?.fileSize, size > maxFileBytes {
      item.tooLarge = true
      return item
    }
    guard let data = try? Data(contentsOf: url), !data.isEmpty else { return nil }
    if data.count > maxFileBytes {
      item.tooLarge = true
    } else {
      item.bytes = data
    }
    return item
  }

  /// The original file name with its extension (the app picks the parser by
  /// extension). `suggestedName` often lacks the extension.
  private static func fileName(
    url: URL?, type: UTType?, suggestedName: String?, keepFileName: Bool
  ) -> String {
    let urlName = url?.lastPathComponent ?? ""
    let hasURLName = !urlName.isEmpty && urlName != "/"
    if keepFileName && hasURLName {
      return urlName
    }
    let urlExtension = url?.pathExtension ?? ""
    let ext = urlExtension.isEmpty ? (type?.preferredFilenameExtension ?? "") : urlExtension
    if let suggested = trimmed(suggestedName) {
      let suggestedExtension = (suggested as NSString).pathExtension
      if ext.isEmpty || suggestedExtension.lowercased() == ext.lowercased() {
        return suggested
      }
      return suggested + "." + ext
    }
    if hasURLName {
      return urlName
    }
    return ext.isEmpty ? "Shared document" : "Shared document." + ext
  }

  private static func mimeType(fileName: String, type: UTType?) -> String? {
    let ext = (fileName as NSString).pathExtension
    if !ext.isEmpty, let mime = UTType(filenameExtension: ext)?.preferredMIMEType {
      return mime
    }
    return type?.preferredMIMEType
  }

  private static func trimmed(_ string: String?) -> String? {
    guard let string = string else { return nil }
    let result = string.trimmingCharacters(in: .whitespacesAndNewlines)
    return result.isEmpty ? nil : result
  }
}

/// Writes items into the App Group inbox (see the format at the top).
private final class Inbox {
  private let inbox: URL
  private let staging: URL
  /// Shared by all items of this share, so they stay together and in order.
  private let batch: String
  private var nextIndex = 0
  private let fileManager = FileManager.default

  init?() {
    guard
      let container = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: ShareImporter.appGroupId)
    else { return nil }
    inbox = container.appendingPathComponent("ImportInbox", isDirectory: true)
    staging = container.appendingPathComponent("ImportStaging", isDirectory: true)
    let nowMillis = Int64(Date().timeIntervalSince1970 * 1000)
    batch = Inbox.padded(nowMillis, width: 15)
    do {
      try fileManager.createDirectory(at: inbox, withIntermediateDirectories: true, attributes: nil)
      try fileManager.createDirectory(
        at: staging, withIntermediateDirectories: true, attributes: nil)
    } catch {
      return nil
    }
    removeStaleStagingFiles(nowMillis: nowMillis)
  }

  func write(_ item: SharedItem) -> Bool {
    var json: [String: Any] = [:]
    if let text = item.text {
      json["text"] = text
    }
    if let subject = item.subject {
      json["subject"] = subject
    }
    if let name = item.name {
      json["name"] = name
    }
    if let mimeType = item.mimeType {
      json["mimeType"] = mimeType
    }
    if let bytes = item.bytes {
      json["bytesBase64"] = bytes.base64EncodedString()
    }
    if item.tooLarge {
      json["tooLarge"] = true
    }

    let index = Inbox.padded(Int64(nextIndex), width: 4)
    let fileName = "\(batch)-\(index)-\(UUID().uuidString).json"
    nextIndex += 1

    guard let data = try? JSONSerialization.data(withJSONObject: json, options: []) else {
      return false
    }
    let stagedURL = staging.appendingPathComponent(fileName, isDirectory: false)
    do {
      try data.write(to: stagedURL)
      try fileManager.moveItem(
        at: stagedURL, to: inbox.appendingPathComponent(fileName, isDirectory: false))
      return true
    } catch {
      try? fileManager.removeItem(at: stagedURL)
      return false
    }
  }

  /// Leftovers of a share that was killed mid-write. Their age comes from the
  /// timestamp in the name, not from file dates.
  private func removeStaleStagingFiles(nowMillis: Int64) {
    guard let names = try? fileManager.contentsOfDirectory(atPath: staging.path) else { return }
    for name in names {
      let stamp = Int64(String(name.prefix(while: { $0.isASCII && $0.isNumber }))) ?? 0
      if nowMillis - stamp > 60 * 60 * 1000 {
        try? fileManager.removeItem(at: staging.appendingPathComponent(name, isDirectory: false))
      }
    }
  }

  private static func padded(_ value: Int64, width: Int) -> String {
    let digits = String(value)
    guard digits.count < width else { return digits }
    return String(repeating: "0", count: width - digits.count) + digits
  }
}
