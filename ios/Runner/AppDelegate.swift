import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  /// Brightness before the prompter turned it up, restored afterwards.
  private var savedBrightness: CGFloat?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

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
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
