import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:livechatt/livechatt.dart';

void main() {
  const MethodChannel channel = MethodChannel('livechatt');
  const EventChannel eventChannel = EventChannel('livechatt/events');
  TestWidgetsFlutterBinding.ensureInitialized();
  final List<MethodCall> log = <MethodCall>[];
  final StreamController<dynamic> eventController =
      StreamController<dynamic>.broadcast();

  bool deepEqual(a, b) {
    if (a is Map && b is Map) {
      if (a.length != b.length) return false;
      for (final key in a.keys) {
        if (!b.containsKey(key) || !deepEqual(a[key], b[key])) {
          return false;
        }
      }
      return true;
    } else {
      return a == b;
    }
  }

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      log.add(methodCall);
      switch (methodCall.method) {
        case 'getPlatformVersion':
          return '42';
        case 'beginChat':
          return true;
        case 'clearSession':
          return null;
        default:
          return null;
      }
    });

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(eventChannel, MockStreamHandler.inline(
      onListen: (Object? arguments, MockStreamHandlerEventSink events) {
        eventController.stream.listen(
          events.success,
          onError: (error) => events.error(
              code: 'error', message: error.toString(), details: null),
        );
      },
    ));
  });

  tearDownAll(() {
    log.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    eventController.close();
  });

  testWidgets('embeddedChat renders correctly on Android',
      (WidgetTester tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    await tester.pumpWidget(MaterialApp(
      home: Livechat.embeddedChat(
        licenseNo: '18650673',
        visitorName: 'John Doe',
        visitorEmail: 'john@example.com',
      ),
    ));

    expect(find.byType(AndroidView), findsOneWidget);

    // Clean up after the test
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('embeddedChat renders correctly on iOS',
      (WidgetTester tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    await tester.pumpWidget(MaterialApp(
      home: Livechat.embeddedChat(
        licenseNo: '18650673',
        visitorName: 'John Doe',
        visitorEmail: 'john@example.com',
      ),
    ));

    expect(find.byType(UiKitView), findsOneWidget);

    // Clean up after the test
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets(
      'embeddedChat shows unsupported message on other platforms(Fuchsia)',
      (WidgetTester tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

    await tester.pumpWidget(MaterialApp(
      home: Livechat.embeddedChat(
        licenseNo: '18650673',
        visitorName: 'Unknown',
        visitorEmail: 'unknown@example.com',
      ),
    ));

    expect(find.text('Platform not supported'), findsOneWidget);

    // Clean up after the test
    debugDefaultTargetPlatformOverride = null;
  });

  test('getPlatformVersion from plugin', () async {
    expect(await Livechat.platformVersion, '42');
    expect(
      log.any((methodCall) =>
          methodCall.method == 'getPlatformVersion' &&
          methodCall.arguments == null),
      true,
    );
  });

  test('can begin chat with plugin without customParams', () async {
    await Livechat.beginChat(
      'licenseNo',
      groupId: 'groupId',
      visitorName: 'visitorName',
      visitorEmail: 'visitorEmail',
    );
    expect(
      log.any((methodCall) =>
          methodCall.method == 'beginChat' &&
          deepEqual(methodCall.arguments as Map, {
            'licenseNo': 'licenseNo',
            'groupId': 'groupId',
            'visitorName': 'visitorName',
            'visitorEmail': 'visitorEmail',
            'customParams': null,
          })),
      true,
    );
  });

  test('can begin chat with plugin with customParams', () async {
    await Livechat.beginChat(
      'licenseNo',
      groupId: 'groupId',
      visitorName: 'visitorName',
      visitorEmail: 'visitorEmail',
      customParams: {'organization': 'mastersam.xyz'},
    );
    expect(
      log.any((methodCall) =>
          methodCall.method == 'beginChat' &&
          deepEqual(methodCall.arguments as Map, {
            'licenseNo': 'licenseNo',
            'groupId': 'groupId',
            'visitorName': 'visitorName',
            'visitorEmail': 'visitorEmail',
            'customParams': {'organization': 'mastersam.xyz'},
          })),
      true,
    );
  });

  test('can clear chat session', () async {
    await Livechat.clearSession();
    expect(
      log.any((methodCall) =>
          methodCall.method == 'clearSession' && methodCall.arguments == null),
      true,
    );
  });

  test('streams new messages from event channel', () async {
    final futureMessage = Livechat.newMessages.first;

    eventController.add({
      'EventType': 'NewMessage',
      'text': 'Hello, World!',
      'windowVisible': true,
    });

    expectLater(futureMessage, completion('Hello, World!'));
  });

  test('streams visibility changes from event channel', () async {
    final futureMessage = Livechat.visibilityChanges.first;

    eventController.add({
      'EventType': 'ChatWindowVisibilityChanged',
      'visibility': true,
    });

    expectLater(futureMessage, completion(true));
  });

  test('streams errors from event channel', () async {
    final futureMessage = Livechat.errors.first;

    eventController.add({
      'EventType': 'Error',
      'errorType': 'WebViewClient',
      'errorCode': -2,
      'errorDescription': 'Failed to load the chat window',
    });

    expectLater(
        futureMessage,
        completion({
          'EventType': 'Error',
          'errorType': 'WebViewClient',
          'errorCode': -2,
          'errorDescription': 'Failed to load the chat window',
        }));
  });

  test('streams URI handling from event channel', () async {
    final futureMessage = Livechat.uriHandlers.first;

    eventController.add({
      'EventType': 'HandleUri',
      'uri': 'https://example.com',
    });

    expectLater(futureMessage, completion('https://example.com'));
  });

  test('streams file picker activity from event channel', () async {
    final futureMessage = Livechat.filePickerActivity.first;

    eventController.add({
      'EventType': 'FilePickerActivity',
      'requestCode': 21354,
    });

    expectLater(futureMessage, completion(21354));
  });

  test('streams window initialization event from event channel', () async {
    final futureMessage = Livechat.windowInitialized.first;

    eventController.add({
      'EventType': 'WindowInitialized',
    });

    expectLater(futureMessage, completion(true));
  });
}
