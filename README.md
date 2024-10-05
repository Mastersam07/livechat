# 💬 livechat

[![codecov](https://codecov.io/gh/Mastersam07/livechat/branch/master/graph/badge.svg?token=5J2EA3Q5JJ)](https://codecov.io/gh/Mastersam07/livechat)
![CI](https://github.com/mastersam07/livechat/workflows/CI/badge.svg?style=flat-square)
[![license](https://img.shields.io/badge/license-MIT-success.svg?style=flat-square)](https://github.com/Mastersam07/livechat/blob/master/LICENSE)
[![pub package](https://img.shields.io/pub/v/livechatt.svg?color=success&style=flat-square)](https://pub.dartlang.org/packages/livechatt)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-success.svg?style=flat-square)](https://github.com/Mastersam07/livechat/pulls)
![GitHub contributors](https://img.shields.io/github/contributors/mastersam07/livechat?color=success&style=flat-square)
![GitHub last commit](https://img.shields.io/github/last-commit/mastersam07/livechat?style=flat-square)

A livechat package for embedding mobile chat window in your mobile application.

## 🎖 Installing

```yaml
dependencies:
  livechatt: ^1.5.1
```

### ⚡️ Import

```dart
import 'package:livechatt/livechatt.dart';
```

## 🎮 How To Use

> Get the [Crendentials](https://www.livechat.com) for your LiveChat 

### Android
>- Edit AndroidManifest.xml as shown below

#### Internet and Storage Access
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

#### ChatWindow
```xml
<activity android:name="com.livechatinc.inappchat.ChatWindowActivity" android:configChanges="orientation|screenSize" />
```

### iOS - Manifest
>- Set minimum deployment target of iOS to 11.0

>- Edit info.plist as shown below

#### Sending Files From Device Library
```plist
<key>NSPhotoLibraryUsageDescription</key>
<string>This app requires access to the photo library.</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app require access to the microphone.</string>
<key>NSCameraUsageDescription</key>
<string>This app requires access to the camera.</string>
```

#### Having issues running on ios?
Add the below to your podfile

```podfile
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end
```

### Dart Usage

- Regular usage

```dart
onPressed: (){
    Livechat.beginChat(LICENSE_NO);
},
```

- Cases where there are custom parameters

```dart
var cmap = <String, String>{
    'org': 'organizationTextController.text',
    'position': 'positionTextController.text'
};

onPressed: (){
    Livechat.beginChat(
      LICENSE_NO,
      groupId: GROUP_ID,
      visitorName: VISITOR_NAME,
      visitorEmail: VISITOR_EMAIL,
      customParams: cmap,
    );
},
```

For more info, please, refer to the `main.dart` in the example.

### Embedded Chat Views

The package now supports embedded views for custom positioning within your app’s layout:

```dart

var cmap = <String, String>{
    'org': 'organizationTextController.text',
    'position': 'positionTextController.text'
};

Livechat.embeddedChat(
  licenseNo: 'your_license',
  groupId: 'group_id',
  visitorEmail: 'visitor_email',
  visitorName: 'visitor_name',
  customParams: cmap,
)
```

For more info, please refer to `EmbeddedChatWidget` in `main.dart` in the example.

### Events Streaming

> Android only

The plugin streams various events such as new messages, visibility changes, and errors from the chat window. You can listen to events like this:

```dart
Livechat.chatEvents.listen((event) {
  print(event);
});
```

For specific events, you can stream:

##### New Messages:

```dart
Livechat.newMessages.listen((message) {
  print(message); 
});
```

##### Visibility Changes:

```dart
Livechat.visibilityChanges.listen((isVisible) {
  print("Chat Window is visible: $isVisible");
});
```

##### Errors:

```dart
Livechat.errors.listen((error) {
  print("Error: ${error['errorDescription']}");
});
```

##### Uri handling:

```dart
Livechat.uriHandlers.listen((message) {
  print(message); 
});
```

##### File picker activity:

```dart
Livechat.filePickerActivity.listen((message) {
  print(message); 
});
```

##### Window initialization:

```dart
Livechat.windowInitialized.listen((message) {
  print(message); 
});
```

For more info, please refer to `EmbeddedChatWidget` in `main.dart` in the example.

### Views

<img src="https://github.com/Mastersam07/livechat/raw/master/assets/1.png" width="250"><img src="https://github.com/Mastersam07/livechat/raw/master/assets/2.png" width="250">

## 🐛 Bugs/Requests

If you encounter any problems feel free to open an issue. If you feel the library is
missing a feature, please raise a ticket on Github and I'll look into it.
Pull request are also welcome.

### ❗️ Note

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

## 🤓 Developer(s)

[<img src="https://avatars3.githubusercontent.com/u/31275429?s=460&u=b935d608a06c1604bae1d971e69a731480a27d46&v=4" width="180" />](https://mastersam.tech)
#### **Abada Samuel Oghenero**
<p>
<a href="https://twitter.com/mastersam_"><img src="https://github.com/aritraroy/social-icons/blob/master/twitter-icon.png?raw=true" width="60"></a>
<a href="https://linkedin.com/in/abada-samuel/"><img src="https://github.com/aritraroy/social-icons/blob/master/linkedin-icon.png?raw=true" width="60"></a>
<a href="https://medium.com/@sammytech"><img src="https://github.com/aritraroy/social-icons/blob/master/medium-icon.png?raw=true" width="60"></a>
<a href="https://facebook.com/abada.samueloghenero"><img src="https://github.com/aritraroy/social-icons/blob/master/facebook-icon.png?raw=true" width="60"></a>
</p>

## ⭐️ License

#### <a href="https://github.com/Mastersam07/livechat/blob/master/LICENSE">MIT LICENSE</a>