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

  test('can begin chat with plugin without customParams', () async {
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
          'customParams': null,
        },
      ),
    ]);
  });

  test('can begin chat with plugin with customParams', () async {
    await Livechat.beginChat('licenseNo', 'groupId', 'visitorName',
        'visitorEmail', {'organization': 'mastersam.xyz'});
    expect(log, <Matcher>[
      isMethodCall(
        'beginChat',
        arguments: <String, dynamic>{
          'licenseNo': 'licenseNo',
          'groupId': 'groupId',
          'visitorName': 'visitorName',
          'visitorEmail': 'visitorEmail',
          'customParams': {'organization': 'mastersam.xyz'},
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

  test("can begin chat natively without customParams", () async {
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

  test("can begin chat natively with customParams", () async {
    channel.invokeMethod('beginChat', <String, dynamic>{
      'licenseNo': 'licenseNo',
      'groupId': 'groupId',
      'visitorName': 'visitorName',
      'visitorEmail': 'visitorEmail',
      'customParams': {'organization': 'mastersam.xyz'},
    });
    expect(log, <Matcher>[
      isMethodCall(
        'beginChat',
        arguments: <String, dynamic>{
          'licenseNo': 'licenseNo',
          'groupId': 'groupId',
          'visitorName': 'visitorName',
          'visitorEmail': 'visitorEmail',
          'customParams': {'organization': 'mastersam.xyz'},
        },
      ),
    ]);
  });

  tearDown(() {
    log.clear();
    channel.setMockMethodCallHandler(null);
  });
}
