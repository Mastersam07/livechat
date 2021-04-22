import 'dart:async';

import 'package:flutter/services.dart';

class Livechat {
  static const MethodChannel _channel = const MethodChannel('livechatt');

  /// Get platform version
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Begin chat by invoking method channel
  static Future<void> beginChat(String licenseNo, String groupId,
      String visitorName, String visitorEmail) async {
    await _channel.invokeMethod('beginChat', <String, dynamic>{
      'licenseNo': licenseNo,
      'groupId': groupId,
      'visitorName': visitorName,
      'visitorEmail': visitorEmail,
    });
  }
}
