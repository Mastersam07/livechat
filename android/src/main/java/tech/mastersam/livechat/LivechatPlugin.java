package tech.mastersam.livechat;

import android.content.Intent;
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
import io.flutter.plugin.common.PluginRegistry.Registrar;

/// Files imported from livechat android sdk
import com.livechatinc.inappchat.ChatWindowConfiguration;
import com.livechatinc.inappchat.ChatWindowErrorType;
import com.livechatinc.inappchat.ChatWindowView;
import com.livechatinc.inappchat.models.NewMessageModel;

/** LivechatPlugin */
public class LivechatPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware{
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  Activity activity;
  private Context context;
  ChatWindowConfiguration config = null;
  ChatWindowView windowView = null;
  private MethodChannel channel;

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
    final LivechatPlugin instance = new LivechatPlugin();
    instance.onAttachedToEngine(registrar.context(), registrar.messenger());
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    onAttachedToEngine(flutterPluginBinding.getApplicationContext(), flutterPluginBinding.getBinaryMessenger());
  }

  private void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
    this.context = applicationContext;
    channel = new MethodChannel(messenger, "livechatt");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("beginChat")) {
      final String licenseNo = call.argument("licenseNo");
      final String groupId = call.argument("groupId");
      final String visitorName = call.argument("visitorName");
      final String visitorEmail = call.argument("visitorEmail");

      if (licenseNo.trim().equalsIgnoreCase("")) {
        result.error("LICENSE NUMBER EMPTY", null, null);
      }else if (visitorName.trim().equalsIgnoreCase("")) {
        result.error("VISITOR NAME EMPTY", null, null);
      }else if (visitorEmail.trim().equalsIgnoreCase("")) {
        result.error("VISITOR EMAIL EMPTY", null, null);
      }else{
        Intent intent = new Intent(activity, com.livechatinc.inappchat.ChatWindowActivity.class);
        Bundle config = new ChatWindowConfiguration.Builder()
                .setLicenceNumber(licenseNo)
                .setGroupId(groupId)
                .build()
                .asBundle();
        intent.putExtra(com.livechatinc.inappchat.ChatWindowConfiguration.KEY_GROUP_ID, licenseNo);
        intent.putExtra(com.livechatinc.inappchat.ChatWindowConfiguration.KEY_LICENCE_NUMBER, groupId);
        intent.putExtra(com.livechatinc.inappchat.ChatWindowConfiguration.KEY_VISITOR_NAME, visitorName);
        intent.putExtra(com.livechatinc.inappchat.ChatWindowConfiguration.KEY_VISITOR_EMAIL, visitorEmail);
        intent.putExtras(config);
        activity.startActivity(intent);

        result.success(null);
      }
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
    activity = activityPluginBinding.getActivity();
  }

  @Override
  public void onDetachedFromActivity() {

  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding activityPluginBinding) {

  }
}
