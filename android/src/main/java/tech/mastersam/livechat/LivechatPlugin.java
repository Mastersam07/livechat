package tech.mastersam.livechat;

import android.content.Intent;
import androidx.core.app.ActivityCompat;
import android.os.Bundle;
import android.widget.Toast;
import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.StreamHandler;

import com.livechatinc.inappchat.ChatWindowConfiguration;
import com.livechatinc.inappchat.ChatWindowErrorType;
import com.livechatinc.inappchat.ChatWindowView;
import com.livechatinc.inappchat.models.NewMessageModel;

import com.livechatinc.inappchat.ChatWindowEventsListener;
import com.livechatinc.inappchat.ChatWindowUtils;

// import io.flutter.plugin.platform.PlatformViewFactory;
// import io.flutter.plugin.platform.PlatformView;
// import io.flutter.plugin.common.StandardMessageCodec;

import android.net.Uri;

import java.util.HashMap;

public class LivechatPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    private MethodChannel methodChannel;
    private EventChannel eventChannel;
    private Context context;
    private Activity activity;
    private ChatWindowView windowView;
    private EventChannel.EventSink events;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.context = flutterPluginBinding.getApplicationContext();
        setupChannel(flutterPluginBinding.getBinaryMessenger());

        // Register the embedded chat view
        flutterPluginBinding.getPlatformViewRegistry().registerViewFactory("embedded_chat_view", new EmbeddedChatViewFactory());
    }

    private void setupChannel(BinaryMessenger messenger) {
        methodChannel = new MethodChannel(messenger, "livechatt");
        methodChannel.setMethodCallHandler(this);

        eventChannel = new EventChannel(messenger, "livechatt/events");
        eventChannel.setStreamHandler(new StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink eventSink) {
                events = eventSink;  // Capture the event sink for pushing events later
            }

            @Override
            public void onCancel(Object arguments) {
                events = null;  // Clear the event sink when not in use
            }
        });
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case "beginChat":
                handleBeginChat(call, result);
                break;
            case "clearSession":
                clearChatSession(result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void handleBeginChat(@NonNull MethodCall call, @NonNull Result result) {
        final String licenseNo = call.argument("licenseNo");
        final HashMap<String, String> customParams = call.argument("customParams");
        final String groupId = call.argument("groupId");
        final String visitorName = call.argument("visitorName");
        final String visitorEmail = call.argument("visitorEmail");

        if (licenseNo == null || licenseNo.trim().isEmpty()) {
            result.error("LICENSE_ERROR", "License number cannot be empty", null);
            return;
        }

        try {
            ChatWindowConfiguration config = buildChatConfig(licenseNo, groupId, visitorName, visitorEmail, customParams);

            // Set up the event listener for chat events
            windowView = ChatWindowUtils.createAndAttachChatWindowInstance(activity);
            windowView.setConfiguration(config);
            windowView.setEventsListener(new ChatWindowEventsListener() {
                @Override
                public void onWindowInitialized() {
                    if (events != null) {
                        HashMap<String, Object> windowData = new HashMap<>();
                        windowData.put("EventType", "WindowInitialized");
                        events.success(windowData);
                    }
                }

                @Override
                public void onNewMessage(NewMessageModel message, boolean windowVisible) {
                    if (events != null) {
                        HashMap<String, Object> messageData = new HashMap<>();
                        messageData.put("EventType", "NewMessage");
                        messageData.put("text", message.getText());
                        messageData.put("windowVisible", windowVisible);
                        events.success(messageData);
                    }
                }

                @Override
                public void onChatWindowVisibilityChanged(boolean visible) {
                    if (events != null) {
                        HashMap<String, Object> visibilityData = new HashMap<>();
                        visibilityData.put("EventType", "ChatWindowVisibilityChanged");
                        visibilityData.put("visibility", visible);
                        events.success(visibilityData);
                    }
                }

                @Override
                public void onStartFilePickerActivity(Intent intent, int requestCode) {
                    if (events != null) {
                        HashMap<String, Object> eventData = new HashMap<>();
                        eventData.put("EventType", "FilePickerActivity");
                        eventData.put("requestCode", requestCode);
                        events.success(eventData);
                    }
                    activity.startActivityForResult(intent, requestCode);
                }

                @Override
                public void onRequestAudioPermissions(String[] permissions, int requestCode) {
                    if (events != null) {
                        HashMap<String, Object> permissionData = new HashMap<>();
                        permissionData.put("event", "onRequestAudioPermissions");
                        permissionData.put("permissions", permissions);
                        permissionData.put("requestCode", requestCode);
                        events.success(permissionData);
                    }
                    ActivityCompat.requestPermissions(activity, permissions, requestCode);
                }

                @Override
                public boolean onError(ChatWindowErrorType errorType, int errorCode, String errorDescription) {
                    if (events != null) {
                        HashMap<String, Object> errorData = new HashMap<>();
                        errorData.put("errorType", errorType.toString());
                        errorData.put("errorCode", errorCode);
                        errorData.put("errorDescription", errorDescription);
                        events.success(errorData);
                    }
                    return true; 
                }

                @Override
                public boolean handleUri(Uri uri) {
                    if (events != null) {
                        HashMap<String, Object> uriData = new HashMap<>();
                        uriData.put("EventType", "HandleUri");
                        uriData.put("uri", uri.toString());
                        events.success(uriData);
                    }
                    return true;
                }
            });

            windowView.initialize();
            windowView.showChatWindow();

            result.success(null);
        } catch (Exception e) {
            result.error("CHAT_WINDOW_ERROR", "Failed to start chat window", e);
        }
    }

    private ChatWindowConfiguration buildChatConfig(String licenseNo, String groupId, String visitorName, String visitorEmail, HashMap<String, String> customParams) {
        return new ChatWindowConfiguration.Builder()
                .setLicenceNumber(licenseNo)
                .setGroupId(groupId)
                .setVisitorName(visitorName)
                .setVisitorEmail(visitorEmail)
                .setCustomParams(customParams)
                .build();
    }

    private void clearChatSession(Result result) {
        ChatWindowUtils.clearSession(activity);
        if (windowView != null) {
            windowView.reload(false);
        }
        result.success(null);
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        this.activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        teardownChannels();
    }

    private void teardownChannels() {
        if (methodChannel != null) {
            methodChannel.setMethodCallHandler(null);
            methodChannel = null;
        }
        if (eventChannel != null) {
            eventChannel.setStreamHandler(null);
        }
    }

    @Override
    public void onDetachedFromActivity() {
        this.activity = null;
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {}

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        this.activity = binding.getActivity();
    }
}
