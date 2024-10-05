import Flutter
import LiveChat

class EmbeddedChatView: NSObject, FlutterPlatformView {
    private var chatWindow: UIView

    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger messenger: FlutterBinaryMessenger?) {
        self.chatWindow = UIView(frame: frame)
        super.init()

        let params = args as! [String: Any]
        let licenseNo = params["licenseNo"] as? String ?? ""
        let groupId = params["groupId"] as? String
        let visitorName = params["visitorName"] as? String ?? ""
        let visitorEmail = params["visitorEmail"] as? String ?? ""
        let customParams = params["customParams"] as? [String: String] ?? [:]

        LiveChat.licenseId = licenseNo
        LiveChat.groupId = groupId
        LiveChat.name = visitorName
        LiveChat.email = visitorEmail

        for (key, value) in customParams {
            LiveChat.setVariable(withKey: key, value: value)
        }

        LiveChat.presentChat()
    }

    func view() -> UIView {
        return chatWindow
    }
}
