import Flutter
import UIKit
import Screeb

public class SwiftPluginScreebPlugin: NSObject, FlutterPlugin {
  static var channel: FlutterMethodChannel? = nil
  static let instance = SwiftPluginScreebPlugin()

  public static func register(with registrar: FlutterPluginRegistrar) {
    Screeb.setSecondarySDK(name: "flutter", version: "2.1.10")
    SwiftPluginScreebPlugin.channel = FlutterMethodChannel(name: "plugin_screeb", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(instance, channel: SwiftPluginScreebPlugin.channel!)
    registrar.addApplicationDelegate(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [Any] else { return }
    switch call.method {
        case "initSdk":
            if let channelId = args[0] as? String {
                let userId: String? = args[1] as? String
                let property: [String: Any?]? = args[2] as? [String: Any?]
                let hooks: [String: Any?]? = args[3] as? [String: Any?]
                let language: String? = args[4] as? String
                var mapHooks: [String: Any?]? = nil
                if (hooks != nil) {
                    mapHooks = [:]
                    hooks?.forEach{ hook in
                        if (hook.key == "version") {
                            mapHooks![hook.key] = hook.value as? String
                        } else {
                            mapHooks![hook.key] = {(payload: Any) -> () in DispatchQueue.main.async {
                                SwiftPluginScreebPlugin.channel!.invokeMethod("handleHooks", arguments: ["hookId": hook.value, "payload": String(describing: payload)]) { (result: Any?) in
                                    if let obj = payload as? [String: Any?] {
                                        if let hookId = obj["hook_id"] as? String {
                                            let encoded = self.toAnyEncodable(result)
                                            Screeb.onHookResult(hookId, encoded)
                                        }
                                    }
                                }
                            }}
                        }
                    }
                }
                Screeb.initSdk(context: nil, channelId: channelId, identity: userId, visitorProperty: self.mapToAnyEncodable(map: property), hooks: mapHooks, language: language)
                result(true)
            } else {
                result(FlutterError(code: "-1", message: "iOS could not extract flutter arguments in method: \(call.method)", details: nil))
            }
        case "setIdentity":
            if let userId = args[0] as? String{
                let property: [String: Any?]? = args[1] as? [String: Any?]
                Screeb.setIdentity(uniqueVisitorId: userId, visitorProperty: self.mapToAnyEncodable(map: property))
                result(true)
            } else {
                result(FlutterError(code: "-1", message: "iOS could not extract flutter arguments in method: \(call.method)", details: nil))
            }
        case "setProperty":
            if let _property = args[0] as? [String: Any?] {
                let property = self.mapToAnyEncodable(map: _property)
                Screeb.visitorProperty(visitorProperty: property)
                result(true)
            } else {
                result(FlutterError(code: "-1", message: "iOS could not extract flutter arguments in method: \(call.method)", details: nil))
            }
        case "assignGroup":
            if let groupName = args[1] as? String {
                let groupType: String? = args[0] as? String;
                let property: [String: Any?]? = args[2] as? [String: Any?]
                Screeb.assignGroup(type: groupType, name: groupName, properties: self.mapToAnyEncodable(map: property))
                result(true)
            } else {
                result(FlutterError(code: "-1", message: "iOS could not extract flutter arguments in method: \(call.method)", details: nil))
            }
        case "unassignGroup":
            if let groupName = args[1] as? String {
                let groupType: String? = args[0] as? String;
                let property: [String: Any?]? = args[2] as? [String: Any?]
                Screeb.unassignGroup(type: groupType, name: groupName, properties: self.mapToAnyEncodable(map: property))
                result(true)
            } else {
                result(FlutterError(code: "-1", message: "iOS could not extract flutter arguments in method: \(call.method)", details: nil))
            }
        case "trackEvent":
            if let eventId = args[0] as? String {
                let property: [String: Any?]? = args[1] as? [String: Any?]
                Screeb.trackEvent(name: eventId, trackingEventProperties: self.mapToAnyEncodable(map: property))
                result(true)
            } else {
                result(FlutterError(code: "-1", message: "iOS could not extract flutter arguments in method: \(call.method)", details: nil))
            }
        case "trackScreen":
            if let screen = args[0] as? String {
                let property: [String: Any?]? = args[1] as? [String: Any?]
                Screeb.trackScreen(name: screen, trackingEventProperties: self.mapToAnyEncodable(map: property))
                result(true)
            } else {
                result(FlutterError(code: "-1", message: "iOS could not extract flutter arguments in method: \(call.method)", details: nil))
            }
        case "startSurvey":
            if let surveyId = args[0] as? String {
                let allowMultipleResponses: Bool = (args[1] as? Bool) ?? true
                let hiddenFields: [String: Any?]? = args[2] as? [String: Any?]
                let ignoreSurveyStatus: Bool = (args[3] as? Bool) ?? true
                let hooks: [String: Any?]? = args[4] as? [String: Any?]
                let language: String? = args[5] as? String
                var distributionId: String? = args[6] as? String
                var mapHooks: [String: Any?]? = nil
                if (hooks != nil) {
                    mapHooks = [:]
                    hooks?.forEach{ hook in
                        if (hook.key == "version") {
                            mapHooks![hook.key] = hook.value as? String
                        } else {
                            mapHooks![hook.key] = {(payload:Any) -> () in DispatchQueue.main.async {
                                if let obj = payload as? [String: Any?] {
                                    if let hookId = obj["hook_id"] as? String {
                                        let encoded = self.toAnyEncodable(result)
                                        Screeb.onHookResult(hookId, encoded)
                                    }
                                }
                            }}
                        }
                    }
                }
                Screeb.startSurvey(
                    surveyId: surveyId,
                    allowMultipleResponses: allowMultipleResponses,
                    hiddenFields: self.mapToAnyEncodable(map: hiddenFields).compactMapValues { $0 } as [String : AnyEncodable],
                    ignoreSurveyStatus: ignoreSurveyStatus,
                    hooks: mapHooks,
                    language: language,
                    distributionId: distributionId
                )
                result(true)
            } else {
                result(FlutterError(code: "-1", message: "iOS could not extract flutter arguments in method: \(call.method)", details: nil))
            }
        case "closeSdk":
            Screeb.closeSdk()
            result(true)
        case "closeSurvey":
            Screeb.closeSurvey()
            result(true)
        case "resetIdentity":
            Screeb.resetIdentity()
            result(true)
        case "debug":
            Screeb.debug()
            result(true)
        case "debugTargeting":
            Screeb.debugTargeting()
            result(true)
        default:
            result(FlutterError(code: "-1", message: "iOS could not extract flutter arguments in method: \(call.method)", details: nil))
            break
        }
  }

  private func toAnyEncodable(_ value: Any?) -> AnyEncodable? {
    if let nsValue = value as? NSNumber {
        if CFBooleanGetTypeID() == CFGetTypeID(nsValue) {
            return AnyEncodable(nsValue.boolValue)
        } else if let value = value as? Int {
            return AnyEncodable(value)
        } else if let value = value as? Double {
            return AnyEncodable(value)
        } else if let value = value as? Float {
            return AnyEncodable(value)
        } else {
            return nil
        }
    } else if let value = value as? String {
        return AnyEncodable(value)
    } else if let value = value as? [String: Any?] {
        return AnyEncodable(self.mapToAnyEncodable(map: value))
    } else {
        return nil
    }
  }

  private func mapToAnyEncodable(map: [String: Any?]?) -> [String: AnyEncodable?] {
    var anyEncodableMap: [String: AnyEncodable?] = [:]
    map?.forEach { key, value in
        anyEncodableMap[key] = self.toAnyEncodable(value)
    }
    return anyEncodableMap
  }
}
