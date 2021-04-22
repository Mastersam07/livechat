#import "LivechatPlugin.h"
#if __has_include(<livechat/livechat-Swift.h>)
#import <livechatt/livechatt-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "livechatt-Swift.h"
#endif

@implementation LivechatPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLivechatPlugin registerWithRegistrar:registrar];
}
@end
