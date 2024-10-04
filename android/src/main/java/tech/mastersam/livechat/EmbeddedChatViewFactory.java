package tech.mastersam.livechat;

import android.content.Context;
import androidx.annotation.NonNull;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.StandardMessageCodec;

public class EmbeddedChatViewFactory extends PlatformViewFactory {

    public EmbeddedChatViewFactory() {
        super(StandardMessageCodec.INSTANCE);
    }

    @Override
    public PlatformView create(Context context, int id, Object args) {
        return new EmbeddedChatView(context, args);
    }
}
