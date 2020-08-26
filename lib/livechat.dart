import 'dart:async';

import 'package:flutter/services.dart';

class Livechat {
  static const MethodChannel _channel =
      const MethodChannel('livechat');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> beginChat(String licenseNo, String groupId, String visitorName, String visitorEmail) async {
    await _channel.invokeMethod('beginChat', <String, dynamic>{
      'licenseNo': licenseNo,
      'groupId': groupId,
      'visitorName': visitorName,
      'visitorEmail': visitorEmail,
    });
  }
}
