import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    // Lets the app send the user to its Settings page, e.g. after camera
    // permission was denied.
    guard let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "AprompterSystem")
    else { return }
    let channel = FlutterMethodChannel(
      name: "aprompter/system", binaryMessenger: registrar.messenger())
    channel.setMethodCallHandler { call, result in
      guard call.method == "openAppSettings",
        let url = URL(string: UIApplication.openSettingsURLString)
      else {
        result(FlutterMethodNotImplemented)
        return
      }
      UIApplication.shared.open(url) { opened in result(opened) }
    }
  }
}
