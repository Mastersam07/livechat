import Flutter
import UIKit
import LiveChat

public class SwiftLivechatPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "livechatt", binaryMessenger: registrar.messenger())
    let instance = SwiftLivechatPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    let factory = EmbeddedChatViewFactory(messenger: registrar.messenger())
    registrar.register(factory, withId: "embedded_chat_view")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
    switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "beginChat":
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

            LiveChat.presentChat()
            result(nil)
        
        case "clearSession":
            LiveChat.clearSession()
            result(nil)

        default:
            result(FlutterMethodNotImplemented)
    }
  }
}
