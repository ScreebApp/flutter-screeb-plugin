import Flutter
import UIKit
import Screeb

public class SwiftPluginScreebPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "plugin_screeb", binaryMessenger: registrar.messenger())
    let instance = SwiftPluginScreebPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [Any] else { return }
    switch call.method {
        case "initSdk":
            if let channelId = args[0] as? String {
                if let controller = UIApplication.shared.keyWindow?.rootViewController as? UIViewController {
                    Screeb.initSdk(context: controller, channelId: channelId)
                    result(true)
                } else {
                    result(false)
                }
            } else {
                result(FlutterError(code: "-1",
                                    message: "iOS could not extract flutter arguments in method: \(call.method)",
                                    details: nil))
            }
        case "setIdentity":
            if let userId = args[0] as? String {
                Screeb.setIdentity(uniqueVisitorId: userId)
                result(true)
            } else {
                result(FlutterError(code: "-1",
                                    message: "iOS could not extract flutter arguments in method: \(call.method)",
                                    details: nil))
            }
        case "sendTrackingEvent":
            if let eventId = args[0] as? String, let property = args[1] as? [String: Any] {
                Screeb.trackEvent(name: eventId, trackingEventProperties: self.mapToAnyEncodable(map: property))
                result(true)
            } else {
                result(FlutterError(code: "-1",
                                    message: "iOS could not extract flutter arguments in method: \(call.method)",
                                    details: nil))
            }
        case "sendTrackingScreen":
            if let screen = args[0] as? String, let property = args[1] as? [String: Any] {
                Screeb.trackScreen(name: screen, trackingEventProperties: self.mapToAnyEncodable(map: property))
                result(true)
            } else {
                result(FlutterError(code: "-1",
                                    message: "iOS could not extract flutter arguments in method: \(call.method)",
                                    details: nil))
            }
        case "visitorProperty":
            if let _property = args[0] as? [String: Any] {
                let property = self.mapToAnyEncodable(map: _property)
                Screeb.visitorProperty(visitorProperty: property)
                result(true)
            } else {
                result(FlutterError(code: "-1",
                                    message: "iOS could not extract flutter arguments in method: \(call.method)",
                                    details: nil))
            }
            default:
                result(FlutterError(code: "-1", message: "iOS could not extract " +
                       "flutter arguments in method: \(call.method)", details: nil))
                break
        }
  }

  private func mapToAnyEncodable(map: [String: Any]) -> [String: AnyEncodable?] {
      return map.mapValues{
          value in
          switch value {
          case is String:
              return AnyEncodable(value as! String)
          case is Bool:
              return AnyEncodable(value as! Bool)
          case is Float:
              return AnyEncodable(value as! Float)
          case is Int:
              return AnyEncodable(value as! Int)
          default: break
          }
          return nil
      }
  }

}
