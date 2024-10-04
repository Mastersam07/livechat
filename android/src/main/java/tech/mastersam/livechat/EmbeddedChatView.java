package tech.mastersam.livechat;

import android.content.Intent;
import android.net.Uri;
import android.content.Context;
import android.view.View;
import com.livechatinc.inappchat.ChatWindowConfiguration;
import com.livechatinc.inappchat.ChatWindowErrorType;
import com.livechatinc.inappchat.ChatWindowViewImpl;
import io.flutter.plugin.platform.PlatformView;
import java.util.HashMap;
import java.util.Map;

public class EmbeddedChatView implements PlatformView {

    private final ChatWindowViewImpl chatWindowView;

    EmbeddedChatView(Context context, Object args) {
        
        chatWindowView = new ChatWindowViewImpl(context);
        chatWindowView.setFocusable(true);
        chatWindowView.setFocusableInTouchMode(true);

        // Extract parameters from Flutter to configure the chat window
        Map<String, Object> params = (Map<String, Object>) args;
        String licenseNo = (String) params.get("licenseNo");
        String groupId = (String) params.get("groupId");
        String visitorName = (String) params.get("visitorName");
        String visitorEmail = (String) params.get("visitorEmail");

        ChatWindowConfiguration config = new ChatWindowConfiguration.Builder()
            .setLicenceNumber(licenseNo)
            .setGroupId(groupId)
            .setVisitorName(visitorName)
            .setVisitorEmail(visitorEmail)
            .build();

        chatWindowView.setConfiguration(config);

        chatWindowView.initialize();
        chatWindowView.showChatWindow();
    }

    @Override
    public View getView() {
        return chatWindowView;
    }

    @Override
    public void dispose() {
        // Clean up resources if necessary
    }
}
