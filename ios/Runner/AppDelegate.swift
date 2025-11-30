import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var blurView: UIVisualEffectView?
  private let screenshotChannel = "screenshot_prevention"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: screenshotChannel,
        binaryMessenger: controller.binaryMessenger
      )

      channel.setMethodCallHandler { [weak self] call, result in
        switch call.method {
        case "enableSecureMode":
          self?.applyScreenshotBlur()
          result(nil)
        case "disableSecureMode":
          self?.removeScreenshotBlur()
          result(nil)
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func applicationWillResignActive(_ application: UIApplication) {
    // Add a blur to hide app content in app switcher / background
    guard let window = self.window else { return }
    let blurEffect = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.frame = window.bounds
    blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    window.addSubview(blurView)
    window.bringSubviewToFront(blurView)
    self.blurView = blurView
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    // Remove blur when returning to foreground
    removeScreenshotBlur()
  }

  private func applyScreenshotBlur() {
    guard let window = self.window, blurView == nil else { return }
    let blurEffect = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.frame = window.bounds
    blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    window.addSubview(blurView)
    window.bringSubviewToFront(blurView)
    self.blurView = blurView
  }

  private func removeScreenshotBlur() {
    blurView?.removeFromSuperview()
    blurView = nil
  }
}
