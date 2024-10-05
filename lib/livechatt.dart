import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'src/livechat_widget.dart';

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
    String licenseNo, {
    String? groupId,
    String? visitorName,
    String? visitorEmail,
    Map<String, String>? customParams,
  }) async {
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

  /// Listen for new messages
  static Stream<String> get newMessages => chatEvents
      .where((event) => event is Map && event['EventType'] == 'NewMessage')
      .map((event) => event['text'] as String);

  /// Listen for visibility changes
  static Stream<bool> get visibilityChanges => chatEvents
      .where((event) =>
          event is Map && event['EventType'] == 'ChatWindowVisibilityChanged')
      .map((event) => event['visibility'] as bool);

  /// Listen for errors
  static Stream<Map<String, dynamic>> get errors => chatEvents
          .where((event) => event is Map && event['EventType'] == 'Error')
          .map((event) {
        final errorEvent = event as Map<Object?, Object?>;
        return errorEvent.map((key, value) => MapEntry(key.toString(), value));
      });

  /// Listen for URI handling
  static Stream<String> get uriHandlers => chatEvents
      .where((event) => event is Map && event['EventType'] == 'HandleUri')
      .map((event) => event['uri'] as String);

  /// Listen for file picker activity
  static Stream<int> get filePickerActivity => chatEvents
      .where(
          (event) => event is Map && event['EventType'] == 'FilePickerActivity')
      .map((event) => event['requestCode'] as int);

  /// Listen for window initialization
  static Stream<bool> get windowInitialized => chatEvents
      .where(
          (event) => event is Map && event['EventType'] == 'WindowInitialized')
      .map((_) => true);

  /// Expose the embedded chat widget
  static Widget embeddedChat({
    required String licenseNo,
    String? groupId,
    String? visitorName,
    String? visitorEmail,
    Map<String, String>? customParams,
  }) {
    return LivechatEmbedded(
      licenseNo: licenseNo,
      groupId: groupId,
      visitorName: visitorName,
      visitorEmail: visitorEmail,
      customParams: customParams,
    );
  }
}
