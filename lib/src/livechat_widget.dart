import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LivechatEmbedded extends StatelessWidget {
  final String licenseNo;
  final String? groupId;
  final String? visitorName;
  final String? visitorEmail;
  final Map<String, String>? customParams;

  LivechatEmbedded({
    required this.licenseNo,
    this.groupId,
    this.visitorName,
    this.visitorEmail,
    this.customParams,
  });

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'embedded_chat_view',
        creationParams: _creationParams(),
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'embedded_chat_view',
        creationParams: _creationParams(),
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return Text('Platform not supported');
    }
  }

  Map<String, dynamic> _creationParams() {
    return {
      'licenseNo': licenseNo,
      'groupId': groupId,
      'visitorName': visitorName,
      'visitorEmail': visitorEmail,
      'customParams': customParams,
    };
  }
}
