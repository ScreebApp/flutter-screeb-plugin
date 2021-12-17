#import "PluginScreebPlugin.h"
#if __has_include(<plugin_screeb/plugin_screeb-Swift.h>)
#import <plugin_screeb/plugin_screeb-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "plugin_screeb-Swift.h"
#endif

@implementation PluginScreebPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPluginScreebPlugin registerWithRegistrar:registrar];
}
@end
