import 'dart:async';

import 'package:flutter/services.dart';

class PluginScreeb {
  static const MethodChannel _channel = MethodChannel('plugin_screeb');

  /// Provides a way to initialize the SDK with a specific channel ID
  ///
  /// Call this method first elsewhere subsequent calls will fail
  /// Providing a [channelId] is mandatory, please visit your account to find
  /// the identifier
  static Future<bool?> initSdk(String channelId) async {
    final bool? success = await _channel.invokeMethod('initSdk', [channelId]);
    return success;
  }

  /// Provides an authentified id for the user of the app
  ///
  /// Providing a [userId] is important to sharpen the Screeb targeting engine
  /// and avoid survey triggering more than necessary.
  static Future<bool?> setIdentity(String userId) async {
    final bool? success = await _channel.invokeMethod('setIdentity', [userId]);
    return success;
  }

  /// Send to Screeb backend an tracking [eventId] with optional [properties]
  static Future<bool?> sendTrackingEvent(
      String eventId, Map<String, dynamic>? properties) async {
    final bool? success =
        await _channel.invokeMethod('sendTrackingEvent', [eventId, properties]);
    return success;
  }

  /// Send to Screeb backend an tracking [screen] name with optional [properties]
  ///
  /// This api call is important to trigger a survey where the targeting is
  /// configured using screens parameters.
  static Future<bool?> sendTrackingScreen(
      String screen, Map<String, dynamic>? properties) async {
    final bool? success =
        await _channel.invokeMethod('sendTrackingScreen', [screen, properties]);
    return success;
  }

  /// Send to Screeb backend the user's custom [properties]
  ///
  /// This api call is important to trigger a survey where the targeting is
  /// configured using visitor properties parameters.
  static Future<bool?> visitorProperty(Map<String, dynamic>? properties) async {
    final bool? success =
        await _channel.invokeMethod('visitorProperty', [properties]);
    return success;
  }
}
