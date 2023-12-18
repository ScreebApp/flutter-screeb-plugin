import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PluginScreeb {
  static const MethodChannel _channel = MethodChannel('plugin_screeb');

  static Map<String, Function> hooksRegistry = <String, Function>{};

  /// Provides a way to initialize the SDK with a specific channel ID by
  /// platform Android and iOS
  ///
  /// Call this method first elsewhere subsequent calls will fail
  /// Providing a [androidChannelId] and [iosChannelId] is mandatory, please visit your account to find
  /// the identifiers
  static Future<bool?> initSdk(String androidChannelId, String iosChannelId, String? userId,
      [Map<String, dynamic>? properties, Map<String, dynamic>? hooks]) {
    _channel.setMethodCallHandler(channelHandler);

    Map<String, String>? mapHooksId;
    if (hooks != null) {
      mapHooksId = <String, String>{};
      hooks.forEach((key, value) {
        if (key == "version") {
          mapHooksId![key] = value.toString();
        } else {
          // Random UUID
          String uuid = UniqueKey().toString();
          hooksRegistry[uuid] = value;
          mapHooksId![key] = uuid;
        }
      });
    }

    if (Platform.isIOS) {
      return _channel.invokeMethod('initSdk', [iosChannelId, userId, _formatDates(properties), mapHooksId]);
    } else if (Platform.isAndroid) {
      return _channel.invokeMethod('initSdk', [androidChannelId, userId, _formatDates(properties), mapHooksId]);
    }

    return Future.value(false);
  }

  /// Provides an id for the user of the app with optional [properties]
  ///
  /// Providing a [userId] is important to sharpen the Screeb targeting engine
  /// and avoid survey triggering more than necessary.
  static Future<bool?> setIdentity(String userId, [Map<String, dynamic>? properties]) =>
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
  static Future<bool?> assignGroup(String? groupType, String groupName, Map<String, dynamic>? properties) =>
      _channel.invokeMethod('assignGroup', [groupType, groupName, _formatDates(properties)]);

  /// Send to Screeb backend a group unassignation for current user [properties]
  ///
  /// This api call is important to improve analysis.
  static Future<bool?> unassignGroup(String? groupType, String groupName, Map<String, dynamic>? properties) =>
      _channel.invokeMethod('unassignGroup', [groupType, groupName, _formatDates(properties)]);

  /// Send to Screeb backend a tracking [eventId] with optional [properties]
  static Future<bool?> trackEvent(String eventId, [Map<String, dynamic>? properties]) =>
      _channel.invokeMethod('trackEvent', [eventId, _formatDates(properties)]);

  /// Send to Screeb backend a tracking [screen] name with optional [properties]
  ///
  /// This api call is important to trigger a survey where the targeting is
  /// configured using screens parameters.
  static Future<bool?> trackScreen(String screen, [Map<String, dynamic>? properties]) =>
      _channel.invokeMethod('trackScreen', [screen, _formatDates(properties)]);

  /// Send to Screeb backend a tracking [screen] name with optional [properties]
  ///
  /// This api call is important to trigger a survey where the targeting is
  /// configured using screens parameters.
  static Future<bool?> startSurvey(
    String surveyId, [
    bool allowMultipleResponses = true,
    Map<String, dynamic>? properties,
    bool ignoreSurveyStatus = true,
    Map<String, dynamic>? hooks,
  ]) {
    Map<String, String>? mapHooksId;
    if (hooks != null) {
      mapHooksId = <String, String>{};
      hooks.forEach((key, value) {
        if (key == "version") {
          mapHooksId![key] = value.toString();
        } else {
          // Random UUID
          String uuid = UniqueKey().toString();
          hooksRegistry[uuid] = value;
          mapHooksId![key] = uuid;
        }
      });
    }

    return _channel.invokeMethod(
        'startSurvey', [surveyId, allowMultipleResponses, _formatDates(properties), ignoreSurveyStatus, mapHooksId]);
  }

  ///Provide a way to stop the SDK
  ///
  ///Its the opposite of initSdk
  static Future<bool?> closeSdk() => _channel.invokeMethod('closeSdk', []);

  ///Provide a way to close the survey
  ///
  ///Its the opposite of startSurvey
  static Future<bool?> closeSurvey() => _channel.invokeMethod('closeSurvey', []);

  ///Provide a way to reset the identity of the user
  ///
  ///You can use it on the disconnection of a user for example to make it anonymous
  static Future<bool?> resetIdentity() => _channel.invokeMethod('resetIdentity', []);

  ///Provide a way to get various debug informations
  static Future<bool?> debug() => _channel.invokeMethod('debug', []);

  ///Provide a way to debug targeting rules
  ///
  ///If you don't know why your survey isn't showing you can use this command to print debug log
  static Future<bool?> debugTargeting() => _channel.invokeMethod('debugTargeting', []);

  // Channel handler
  static Future<dynamic> channelHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case "handleHooks":
        handleHooks(methodCall.arguments["hookId"], methodCall.arguments["payload"]);
        break;
      default:
        throw Exception("Method not implemented");
    }
  }

  // Handle hooks callback
  static dynamic handleHooks(dynamic hookId, dynamic payload) {
    if (hooksRegistry.containsKey(hookId)) {
      Function? hook = hooksRegistry[hookId];
      if (hook != null) {
        hook(payload);
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
