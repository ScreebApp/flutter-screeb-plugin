import UIKit
import Flutter
import Screeb

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let controller = self.window?.rootViewController
    Screeb.initSdk(context: controller, channelId: "5c62c145-91f1-4abd-8aa2-63d7847db1e1")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
