# ChangeLog for livechat

## 1.6.0

* **NEW**: Preloaded chat support for instant display
  * Added `initializeChat()` - Initialize LiveChat WebView in background without showing UI
  * Added `showPreloadedChat()` - Show preloaded chat instantly (< 500ms)
  * Added `hideChat()` - Hide chat window without destroying it
  * Added `isInitialized` getter - Check if chat is ready for instant display
* **Performance**: Reduces chat opening time from 3-5 seconds to < 500ms when using preloaded chat
* **Compatibility**: Fully backward compatible - existing `beginChat()` works as before
* **Platform**: Supports both Android and iOS

## 1.5.1

* Embedded chat views support: Users can now embed chat windows within their Flutter app for better control over the layout.
* Added support for streaming events like NewMessage, ChatWindowVisibilityChanged, Error, HandleUri, and FilePickerActivity.
* Set licenseNo as the only required parameter.
* Updated tests

## 1.4.0

* Add support for custom params.

## 1.3.0

* Bump native dependencies.
* Unit tests.

## 1.2.0

* Migrated to null safety.

## 1.1.0

* Fixed pod install issues.
* Fixed podspec issues.

## 1.0.1+3

* Fixed No podspec found on iOS

## 1.0.1+2

## 1.0.1+1

* Fixed issue with plugin name

## 1.0.1

* Fixed conflict with pods on ios
* Renamed plugin

## 1.0.0+1

## 1.0.0

* Completed iOS documentation

## 0.0.5

* Make plugin available to ios

## 0.0.4

* Fixes

## 0.0.3

* Fixed documentation

## 0.0.1

* Include Authors info in README
* Make plugin usable on android devices
