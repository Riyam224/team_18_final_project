import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var blurView: UIVisualEffectView?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
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
    blurView?.removeFromSuperview()
    blurView = nil
  }
}
