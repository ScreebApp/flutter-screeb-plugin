import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class PluginScreeb {
  static const MethodChannel _channel = MethodChannel('plugin_screeb');

  /// Provides a way to initialize the SDK with a specific channel ID by
  /// platform Android and iOS
  ///
  /// Call this method first elsewhere subsequent calls will fail
  /// Providing a [androidChannelId] and [iosChannelId] is mandatory, please visit your account to find
  /// the identifiers
  static Future<bool?> initSdk(
      String androidChannelId,
      String iosChannelId,
      String? userId,
      [Map<String, dynamic>? properties]) async {
    if (Platform.isIOS) {
      return await _channel.invokeMethod('initSdk', [iosChannelId, userId, formatDates(properties)]);
    } else if (Platform.isAndroid) {
      return await _channel.invokeMethod('initSdk', [androidChannelId, userId, formatDates(properties)]);
    }
  }

  /// Provides an authentified id for the user of the app with optional [properties]
  ///
  /// Providing a [userId] is important to sharpen the Screeb targeting engine
  /// and avoid survey triggering more than necessary.
  static Future<bool?> setIdentity(String userId, [Map<String, dynamic>? properties]) async {
    final bool? success = await _channel.invokeMethod('setIdentity', [userId, formatDates(properties)]);
    return success;
  }

  /// Send to Screeb backend a tracking [eventId] with optional [properties]
  static Future<bool?> trackEvent(
      String eventId, [Map<String, dynamic>? properties]) async {
    final bool? success =
        await _channel.invokeMethod('trackEvent', [eventId, formatDates(properties)]);
    return success;
  }

  /// Send to Screeb backend a tracking [screen] name with optional [properties]
  ///
  /// This api call is important to trigger a survey where the targeting is
  /// configured using screens parameters.
  static Future<bool?> trackScreen(
      String screen, [Map<String, dynamic>? properties]) async {
    final bool? success =
        await _channel.invokeMethod('trackScreen', [screen, formatDates(properties)]);
    return success;
  }

  /// Send to Screeb backend the user's custom [properties]
  ///
  /// This api call is important to trigger a survey where the targeting is
  /// configured using visitor properties parameters.
  static Future<bool?> setProperty(Map<String, dynamic>? properties) async {
    final bool? success =
        await _channel.invokeMethod('setProperty', [formatDates(properties)]);
    return success;
  }

  static Map<String, dynamic>? formatDates(Map<String, dynamic>? properties) {
    var newMap =  <String, dynamic>{};
    if (properties?.isEmpty == true){
      return properties;
    }
    properties?.forEach((key, value) {
      if (value is DateTime) {
        String newValue = '${value.toIso8601String()}+${value.timeZoneOffset.inHours.toString()}:00';
        newMap[key] = newValue;
      } else {
        newMap[key] = value;
      }
    });

    return newMap;
  }
}
