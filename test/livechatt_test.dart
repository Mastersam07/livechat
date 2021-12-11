import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:livechatt/livechatt.dart';

void main() {
  const MethodChannel channel = MethodChannel('livechatt');

  TestWidgetsFlutterBinding.ensureInitialized();
  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);
      switch (methodCall.method) {
        case 'getPlatformVersion':
          return '42';
        case 'beginChat':
          return true;
        default:
          return null;
      }
    });
  });

  test('getPlatformVersion from plugin', () async {
    expect(await Livechat.platformVersion, '42');
  });

  test('can begin chat with plugin', () async {
    await Livechat.beginChat(
        'licenseNo', 'groupId', 'visitorName', 'visitorEmail');
    expect(log, <Matcher>[
      isMethodCall(
        'beginChat',
        arguments: <String, dynamic>{
          'licenseNo': 'licenseNo',
          'groupId': 'groupId',
          'visitorName': 'visitorName',
          'visitorEmail': 'visitorEmail',
        },
      ),
    ]);
  });

  test("can check platform version natively", () async {
    channel.invokeMethod('getPlatformVersion');
    expect(log, <Matcher>[
      isMethodCall(
        'getPlatformVersion',
        arguments: null,
      ),
    ]);
  });

  test("get platform version natively", () async {
    expect(await channel.invokeMethod('getPlatformVersion'), '42');
  });

  test("can begin chat natively", () async {
    channel.invokeMethod('beginChat', <String, dynamic>{
      'licenseNo': 'licenseNo',
      'groupId': 'groupId',
      'visitorName': 'visitorName',
      'visitorEmail': 'visitorEmail',
    });
    expect(log, <Matcher>[
      isMethodCall(
        'beginChat',
        arguments: <String, dynamic>{
          'licenseNo': 'licenseNo',
          'groupId': 'groupId',
          'visitorName': 'visitorName',
          'visitorEmail': 'visitorEmail',
        },
      ),
    ]);
  });

  tearDown(() {
    log.clear();
    channel.setMockMethodCallHandler(null);
  });
}
