# 💬 livechat

A livechat package for embedding mobile chat window in your mobile application.

## 🎖 Installing

```yaml
dependencies:
  livechat: "^0.0.5"
```

### ⚡️ Import

```dart
import 'package:livechat/livechat.dart';
```

## 🎮 How To Use

> Get the [Crendentials](https://www.livechat.com) for your LiveChat 

### Android
>- Edit AndroidManifest.xml as shown below

#### Internet and Storage Access
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

#### ChatWindow
```xml
<activity android:name="com.livechatinc.inappchat.ChatWindowActivity" android:configChanges="orientation|screenSize" />
```

### iOS - Manifest
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

### Dart Usage

```dart
onPressed: (){
    Livechat.beginChat(LICENSE_NO, GROUP_ID, VISITOR_NAME, VISITOR_EMAIL);
    },
```

For more info, please, refer to the `main.dart` in the example.

### Views

|<img src="https://github.com/Mastersam07/livechat/raw/master/assets/1.png" width="250">|<img src="https://github.com/Mastersam07/livechat/raw/master/assets/2.png" width="250">|

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

## ☀️ Authors
[<img src="https://avatars3.githubusercontent.com/u/31275429?s=460&u=b935d608a06c1604bae1d971e69a731480a27d46&v=4" width="120" />](https://mastersam.tech)
<p>
<a href = "https://github.com/mastersam07"><img src = "https://www.iconninja.com/files/241/825/211/round-collaboration-social-github-code-circle-network-icon.svg" width="18" height = "18"/></a>
<a href = "https://twitter.com/mastersam_"><img src = "https://www.shareicon.net/download/2016/07/06/107115_media.svg" width="18" height="18"/></a>
<a href = "https://www.linkedin.com/in/abada-samuel/"><img src = "https://www.iconninja.com/files/863/607/751/network-linkedin-social-connection-circular-circle-media-icon.svg" width="18" height="18"/></a>
</p>

## ⭐️ License

MIT License