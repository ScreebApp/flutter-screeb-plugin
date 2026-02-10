import Flutter
import Screeb
import SwiftUI

public class SwiftPluginScreebPlugin: NSObject, FlutterPlugin {
  static var channel: FlutterMethodChannel? = nil
  static let instance = SwiftPluginScreebPlugin()

  public static func register(with registrar: FlutterPluginRegistrar) {
    Screeb.setSecondarySDK(name: "flutter", version: "3.1.0")
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
                let initOptions: [String: Any?]? = args[3] as? [String: Any?]
                let hooks: [String: Any?]? = args[4] as? [String: Any?]
                let language: String? = args[5] as? String
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
                                            Screeb.onHookResult(hookId, result)
                                        }
                                    }
                                }
                            }}
                        }
                    }
                }

                let initOptionsDict: NSDictionary = NSDictionary(dictionary: (initOptions ?? [:]).compactMapValues { $0 })
                let initOptionsFinal = InitOptions(dict: initOptionsDict)
                Screeb.initSdk(context: nil, channelId: channelId, identity: userId, visitorProperty: property ?? [:], initOptions: initOptionsFinal, hooks: mapHooks as GlobalHooks?, language: language)
                result(true)
            } else {
                result(FlutterError(code: "-1", message: "iOS could not extract flutter arguments in method: \(call.method)", details: nil))
            }
        case "setIdentity":
            if let userId = args[0] as? String{
                let property: [String: Any?]? = args[1] as? [String: Any?]
                Screeb.setIdentity(uniqueVisitorId: userId, visitorProperty: property ?? [:])
                result(true)
            } else {
                result(FlutterError(code: "-1", message: "iOS could not extract flutter arguments in method: \(call.method)", details: nil))
            }
        case "setProperty":
            if let property = args[0] as? [String: Any] {
                Screeb.visitorProperty(visitorProperty: property ?? [:])
                result(true)
            } else {
                result(FlutterError(code: "-1", message: "iOS could not extract flutter arguments in method: \(call.method)", details: nil))
            }
        case "assignGroup":
            if let groupName = args[1] as? String {
                let groupType: String? = args[0] as? String;
                let property: [String: Any?]? = args[2] as? [String: Any?]
                Screeb.assignGroup(type: groupType, name: groupName, properties: property ?? [:])
                result(true)
            } else {
                result(FlutterError(code: "-1", message: "iOS could not extract flutter arguments in method: \(call.method)", details: nil))
            }
        case "unassignGroup":
            if let groupName = args[1] as? String {
                let groupType: String? = args[0] as? String;
                let property: [String: Any?]? = args[2] as? [String: Any?]
                Screeb.unassignGroup(type: groupType, name: groupName, properties: property ?? [:])
                result(true)
            } else {
                result(FlutterError(code: "-1", message: "iOS could not extract flutter arguments in method: \(call.method)", details: nil))
            }
        case "trackEvent":
            if let eventId = args[0] as? String {
                let property: [String: Any?]? = args[1] as? [String: Any?]
                Screeb.trackEvent(name: eventId, trackingEventProperties: property ?? [:])
                result(true)
            } else {
                result(FlutterError(code: "-1", message: "iOS could not extract flutter arguments in method: \(call.method)", details: nil))
            }
        case "trackScreen":
            if let screen = args[0] as? String {
                let property: [String: Any?]? = args[1] as? [String: Any?]
                Screeb.trackScreen(name: screen, trackingEventProperties: property ?? [:])
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
                let distributionId: String? = args[6] as? String
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
                                        Screeb.onHookResult(hookId, result)
                                    }
                                }
                            }}
                        }
                    }
                }
                Screeb.startSurvey(
                    surveyId: surveyId,
                    allowMultipleResponses: allowMultipleResponses,
                    hiddenFields: hiddenFields ?? [:],
                    ignoreSurveyStatus: ignoreSurveyStatus,
                    hooks: mapHooks as SurveyHooks?,
                    language: language,
                    distributionId: distributionId
                )
                result(true)
            } else {
                result(FlutterError(code: "-1", message: "iOS could not extract flutter arguments in method: \(call.method)", details: nil))
            }
        case "startMessage":
            if let messageId = args[0] as? String {
                let allowMultipleResponses: Bool = (args[1] as? Bool) ?? true
                let hiddenFields: [String: Any?]? = args[2] as? [String: Any?]
                let ignoreMessageStatus: Bool = (args[3] as? Bool) ?? true
                let hooks: [String: Any?]? = args[4] as? [String: Any?]
                let language: String? = args[5] as? String
                let distributionId: String? = args[6] as? String
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
                                        Screeb.onHookResult(hookId, result)
                                    }
                                }
                            }}
                        }
                    }
                }
                Screeb.startMessage(
                    messageId: messageId,
                    allowMultipleResponses: allowMultipleResponses,
                    hiddenFields: hiddenFields ?? [:],
                    ignoreMessageStatus: ignoreMessageStatus,
                    hooks: mapHooks as SurveyHooks?,
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
            let surveyId: String? = args[0] as? String
            Screeb.closeSurvey(surveyId: surveyId)
            result(true)
        case "closeMessage":
            let messageId: String? = args[0] as? String
            Screeb.closeMessage(messageId: messageId)
            result(true)
        case "sessionReplayStart":
            Screeb.sessionReplayStart()
            result(true)
        case "sessionReplayStop":
            Screeb.sessionReplayStop()
            result(true)
        case "resetIdentity":
            Screeb.resetIdentity()
            result(true)
        case "getIdentity":
            Screeb.getIdentity { identity, error in
                if let error = error {
                    result(FlutterError(code: "GET_IDENTITY_ERROR", message: error.localizedDescription, details: nil))
                } else {
                    result(identity)
                }
            }
        case "debug":
            Screeb.debug { debugInfo, error in
                if let error = error {
                    result(FlutterError(code: "DEBUG_ERROR", message: error.localizedDescription, details: nil))
                } else {
                    result(debugInfo)
                }
            }
        case "debugTargeting":
            Screeb.debugTargeting { debugInfo, error in
                if let error = error {
                    result(FlutterError(code: "DEBUG_TARGETING_ERROR", message: error.localizedDescription, details: nil))
                } else {
                    result(debugInfo)
                }
            }
        default:
            result(FlutterError(code: "-1", message: "iOS could not extract flutter arguments in method: \(call.method)", details: nil))
            break
        }
  }
}
