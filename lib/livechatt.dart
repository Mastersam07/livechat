import 'dart:async';

import 'package:flutter/services.dart';

class Livechat {
  static const MethodChannel _channel = const MethodChannel('livechatt');
  static const EventChannel _eventChannel = EventChannel('livechatt/events');

  /// Get platform version
  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Begin chat by invoking method channel
  static Future<void> beginChat(
      String licenseNo, String groupId, String visitorName, String visitorEmail,
      [Map<String, String>? customParams]) async {
    await _channel.invokeMethod('beginChat', <String, dynamic>{
      'licenseNo': licenseNo,
      'groupId': groupId,
      'visitorName': visitorName,
      'visitorEmail': visitorEmail,
      'customParams': customParams,
    });
  }

  /// Clear chat session
  static Future<void> clearSession() async {
    await _channel.invokeMethod('clearSession');
  }

  /// Listen to chat events: new messages, errors, visibility changes, etc.
  static Stream<dynamic> get chatEvents =>
      _eventChannel.receiveBroadcastStream();

  /// Start listening for new messages
  static Stream<String> get newMessages => chatEvents
      .where((event) => event is Map && event.containsKey('text'))
      .map((event) => event['text'] as String);

  /// Start listening for visibility changes
  static Stream<bool> get visibilityChanges => chatEvents
      .where((event) =>
          event is String && event.contains('onChatWindowVisibilityChanged'))
      .map((event) => event.endsWith('true'));

  /// Start listening for errors
  static Stream<Map<String, dynamic>> get errors => chatEvents
      .where((event) => event is Map && event.containsKey('errorDescription'))
      .map((event) => event as Map<String, dynamic>);

  /// Handle URIs
  static Stream<String> get uriHandlers => chatEvents
      .where((event) => event is String && event.contains('handleUri'))
      .map((event) => event.replaceFirst('handleUri: ', ''));
}
