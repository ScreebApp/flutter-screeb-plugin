import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PluginScreeb {
  static const MethodChannel _channel = MethodChannel('plugin_screeb');

  static Map<String, Function> hooksRegistry = <String, Function>{};

  /// Provides a way to initialize the SDK with a specific channel ID
  ///
  /// Call this method first elsewhere subsequent calls will fail
  /// Providing a [channelId] is mandatory, please visit your account to find
  /// the identifiers
  static Future<bool?> initSdk(String channelId,
      {String? userId,
      Map<String, dynamic>? properties,
      Map<String, dynamic>? initOptions,
      Map<String, dynamic>? hooks,
      String? language}) {
    _channel.setMethodCallHandler(channelHandler);

    Map<String, String>? mapHooksId;
    if (hooks != null) {
      mapHooksId = <String, String>{};
      hooks.forEach((key, value) {
        if (key == "version") {
          mapHooksId![key] = value.toString();
        } else {
          String uuid = UniqueKey().toString() + key;
          hooksRegistry[uuid] = value;
          mapHooksId![key] = uuid;
        }
      });
    }

    return _channel.invokeMethod('initSdk', [
      channelId,
      userId,
      _formatDates(properties),
      initOptions,
      mapHooksId,
      language,
    ]);
  }

  /// Provides an id for the user of the app with optional [properties]
  ///
  /// Providing a [userId] is important to sharpen the Screeb targeting engine
  /// and avoid survey triggering more than necessary.
  static Future<bool?> setIdentity(String userId, {Map<String, dynamic>? properties}) =>
      _channel.invokeMethod('setIdentity', [userId, _formatDates(properties)]);

  /// Send to Screeb backend the user's custom [properties]
  ///
  /// This api call is important to trigger a survey where the targeting is
  /// configured using visitor properties parameters.
  static Future<bool?> setProperty(Map<String, dynamic>? properties) =>
      _channel.invokeMethod('setProperty', [_formatDates(properties)]);

  /// Send to Screeb backend a group assignation for current user [properties]
  ///
  /// This api call is important to improve analysis.
  static Future<bool?> assignGroup(String? groupType, String groupName, {Map<String, dynamic>? properties}) =>
      _channel.invokeMethod('assignGroup', [groupType, groupName, _formatDates(properties)]);

  /// Send to Screeb backend a group unassignation for current user [properties]
  ///
  /// This api call is important to improve analysis.
  static Future<bool?> unassignGroup(String? groupType, String groupName, Map<String, dynamic>? properties) =>
      _channel.invokeMethod('unassignGroup', [groupType, groupName, _formatDates(properties)]);

  /// Send to Screeb backend a tracking [eventId] with optional [properties]
  static Future<bool?> trackEvent(String eventId, {Map<String, dynamic>? properties}) =>
      _channel.invokeMethod('trackEvent', [eventId, _formatDates(properties)]);

  /// Send to Screeb backend a tracking [screen] name with optional [properties]
  ///
  /// This api call is important to trigger a survey where the targeting is
  /// configured using screens parameters.
  static Future<bool?> trackScreen(String screen, {Map<String, dynamic>? properties}) =>
      _channel.invokeMethod('trackScreen', [screen, _formatDates(properties)]);

  /// Provide a way to start a survey with a specific [surveyId]
  ///
  /// You can provide optional [properties] to sharpen targeting rules
  /// You can also provide [hooks] to handle survey events
  static Future<bool?> startSurvey(
    String surveyId, {
    bool allowMultipleResponses = true,
    Map<String, dynamic>? properties,
    bool ignoreSurveyStatus = true,
    Map<String, dynamic>? hooks,
    String? language,
    String? distributionId,
  }) {
    Map<String, String>? mapHooksId;
    if (hooks != null) {
      mapHooksId = <String, String>{};
      hooks.forEach((key, value) {
        if (key == "version") {
          mapHooksId![key] = value.toString();
        } else {
          String uuid = UniqueKey().toString() + key;
          hooksRegistry[uuid] = value;
          mapHooksId![key] = uuid;
        }
      });
    }

    return _channel.invokeMethod('startSurvey', [
      surveyId,
      allowMultipleResponses,
      _formatDates(properties),
      ignoreSurveyStatus,
      mapHooksId,
      language,
      distributionId
    ]);
  }

  /// Provide a way to start a message with a specific [messageId]
  ///
  /// You can provide optional [properties] to sharpen targeting rules
  /// You can also provide [hooks] to handle message events
  static Future<bool?> startMessage(
    String messageId, {
    bool allowMultipleResponses = true,
    Map<String, dynamic>? properties,
    bool ignoreMessageStatus = true,
    Map<String, dynamic>? hooks,
    String? language,
    String? distributionId,
  }) {
    Map<String, String>? mapHooksId;
    if (hooks != null) {
      mapHooksId = <String, String>{};
      hooks.forEach((key, value) {
        if (key == "version") {
          mapHooksId![key] = value.toString();
        } else {
          String uuid = UniqueKey().toString() + key;
          hooksRegistry[uuid] = value;
          mapHooksId![key] = uuid;
        }
      });
    }

    return _channel.invokeMethod('startMessage', [
      messageId,
      allowMultipleResponses,
      _formatDates(properties),
      ignoreMessageStatus,
      mapHooksId,
      language,
      distributionId
    ]);
  }

  ///Provide a way to stop the SDK
  ///
  ///Its the opposite of initSdk
  static Future<bool?> closeSdk() => _channel.invokeMethod('closeSdk', []);

  ///Provide a way to close the survey
  ///
  ///Its the opposite of startSurvey
  static Future<bool?> closeSurvey({String? surveyId}) => _channel.invokeMethod('closeSurvey', [surveyId]);

  ///Provide a way to close the message
  ///
  ///Its the opposite of startMessage
  static Future<bool?> closeMessage({String? messageId}) => _channel.invokeMethod('closeMessage', [messageId]);

  ///Provide a way to start session replay recording
  static Future<bool?> sessionReplayStart() => _channel.invokeMethod('sessionReplayStart', []);

  ///Provide a way to stop session replay recording
  ///
  ///Its the opposite of sessionReplayStart
  static Future<bool?> sessionReplayStop() => _channel.invokeMethod('sessionReplayStop', []);

  ///Provide a way to reset the identity of the user
  ///
  ///You can use it on the disconnection of a user for example to make it anonymous
  static Future<bool?> resetIdentity() => _channel.invokeMethod('resetIdentity', []);

  /// Provides a way to get the current visitor identity
  static Future<Map<String, dynamic>?> getIdentity() async {
    final result = await _channel.invokeMethod('getIdentity', []);
    if (result is Map) {
      return Map<String, dynamic>.from(result);
    }
    return null;
  }

  ///Provide a way to get various debug informations
  static Future<String?> debug() async {
    final result = await _channel.invokeMethod('debug', []);
    return result as String?;
  }

  ///Provide a way to debug targeting rules
  ///
  ///If you don't know why your survey isn't showing you can use this command to print debug log
  static Future<String?> debugTargeting() async {
    final result = await _channel.invokeMethod('debugTargeting', []);
    return result as String?;
  }

  // Channel handler
  static Future<dynamic> channelHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case "handleHooks":
        return handleHooks(methodCall.arguments["hookId"], methodCall.arguments["payload"]);
      default:
        throw Exception("Method not implemented");
    }
  }

  // Handle hooks callback
  static Future<dynamic> handleHooks(dynamic hookId, dynamic payload) async {
    if (hooksRegistry.containsKey(hookId)) {
      Function? hook = hooksRegistry[hookId];
      if (hook != null) {
        final result = hook(payload);
        return result;
      }
    }
  }

  /// Format payloads so DateTime properties are correctly interpreted by the SDK
  static Map<String, dynamic>? _formatDates(Map<String, dynamic>? properties) => properties?.map(
        (key, value) => MapEntry(
          key,
          value is DateTime
              ? '${value.toIso8601String()}+${value.timeZoneOffset.inHours.toString().padLeft(2, '0')}:00'
              : value,
        ),
      );
}
