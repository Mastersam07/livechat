import Flutter
import UIKit
import LiveChat

public class SwiftLivechatPlugin: NSObject, FlutterPlugin, FlutterStreamHandler, LiveChatDelegate {
  private var isInitialized = false
  private var eventSink: FlutterEventSink?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let methodChannel = FlutterMethodChannel(name: "livechatt", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(name: "livechatt/events", binaryMessenger: registrar.messenger())

    let instance = SwiftLivechatPlugin()
    registrar.addMethodCallDelegate(instance, channel: methodChannel)
    eventChannel.setStreamHandler(instance)

    // `LiveChat.delegate` is weak — `instance` is kept alive by Flutter's
    // method-call delegate registration, so the weak reference stays valid
    // for the lifetime of the Flutter engine.
    LiveChat.delegate = instance

    let factory = EmbeddedChatViewFactory(messenger: registrar.messenger())
    registrar.register(factory, withId: "embedded_chat_view")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)

        case "beginChat":
            handleBeginChat(call: call, result: result)

        case "initializeChat":
            handleInitializeChat(call: call, result: result)

        case "showPreloadedChat":
            handleShowPreloadedChat(result: result)

        case "hideChat":
            handleHideChat(result: result)

        case "isInitialized":
            result(isInitialized)

        case "clearSession":
            LiveChat.clearSession()
            result(nil)

        default:
            result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - FlutterStreamHandler (livechatt/events)

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    self.eventSink = nil
    return nil
  }

  // MARK: - LiveChatDelegate
  // Event payloads mirror the Android plugin's EventType taxonomy so Dart-side
  // listeners read the same shape regardless of platform. The Android plugin
  // emits a third event (`WindowInitialized`) that doesn't have an iOS
  // equivalent in LiveChat 2.x — Dart callers should not rely on it.

  public func chatPresented() {
    eventSink?([
      "EventType": "ChatWindowVisibilityChanged",
      "visibility": true,
    ])
  }

  public func chatDismissed() {
    eventSink?([
      "EventType": "ChatWindowVisibilityChanged",
      "visibility": false,
    ])
  }

  public func received(message: LiveChatMessage) {
    eventSink?([
      "EventType": "NewMessage",
      "text": message.text,
      "windowVisible": LiveChat.isChatPresented,
    ])
  }

  // MARK: - Method handlers

  private func handleBeginChat(call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments = call.arguments as! [String:Any]

    let licenseNo = arguments["licenseNo"] as? String
    let groupId = arguments["groupId"] as? String
    let visitorName = arguments["visitorName"] as? String
    let visitorEmail = arguments["visitorEmail"] as? String
    let customParams = arguments["customParams"] as? [String:String] ?? [:]

    guard let licenseNo = licenseNo, !licenseNo.isEmpty else {
      result(FlutterError(code: "LICENSE_ERROR", message: "License number cannot be empty", details: nil))
      return
    }

    configureLiveChat(licenseNo: licenseNo, groupId: groupId, visitorName: visitorName, visitorEmail: visitorEmail, customParams: customParams)
    ensureActiveWindowScene()
    LiveChat.presentChat()
    result(nil)
  }

  private func handleInitializeChat(call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments = call.arguments as! [String:Any]

    let licenseNo = arguments["licenseNo"] as? String
    let groupId = arguments["groupId"] as? String
    let visitorName = arguments["visitorName"] as? String
    let visitorEmail = arguments["visitorEmail"] as? String
    let customParams = arguments["customParams"] as? [String:String] ?? [:]

    guard let licenseNo = licenseNo, !licenseNo.isEmpty else {
      result(FlutterError(code: "LICENSE_ERROR", message: "License number cannot be empty", details: nil))
      return
    }

    configureLiveChat(licenseNo: licenseNo, groupId: groupId, visitorName: visitorName, visitorEmail: visitorEmail, customParams: customParams)
    isInitialized = true
    result(nil)
  }

  private func handleShowPreloadedChat(result: @escaping FlutterResult) {
    if isInitialized {
      ensureActiveWindowScene()
      LiveChat.presentChat()
      result(nil)
    } else {
      result(FlutterError(code: "NOT_INITIALIZED", message: "Chat is not initialized. Call initializeChat first.", details: nil))
    }
  }

  /// LiveChat 2.x on iOS 13+ uses `UIWindow` overlay that needs a target
  /// `UIWindowScene`. If `LiveChat.windowScene` is not set, the chat window
  /// silently fails to attach (no error, just nothing visible). Default it
  /// to the foreground-active scene right before presenting.
  private func ensureActiveWindowScene() {
    if #available(iOS 13.0, *), LiveChat.windowScene == nil {
      LiveChat.windowScene = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .first { $0.activationState == .foregroundActive }
        ?? UIApplication.shared.connectedScenes
          .compactMap { $0 as? UIWindowScene }
          .first
    }
  }

  private func handleHideChat(result: @escaping FlutterResult) {
    LiveChat.dismissChat()
    result(nil)
  }

  private func configureLiveChat(licenseNo: String, groupId: String?, visitorName: String?, visitorEmail: String?, customParams: [String:String]) {
    LiveChat.licenseId = licenseNo

    if let groupId = groupId {
      LiveChat.groupId = groupId
    }

    if let visitorName = visitorName {
      LiveChat.name = visitorName
    }

    if let visitorEmail = visitorEmail {
      LiveChat.email = visitorEmail
    }

    for (key, value) in customParams {
      LiveChat.setVariable(withKey: key, value: value)
    }
  }
}