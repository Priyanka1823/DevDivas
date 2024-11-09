//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<auth0_flutter/Auth0FlutterPlugin.h>)
#import <auth0_flutter/Auth0FlutterPlugin.h>
#else
@import auth0_flutter;
#endif

#if __has_include(<image_picker_ios/FLTImagePickerPlugin.h>)
#import <image_picker_ios/FLTImagePickerPlugin.h>
#else
@import image_picker_ios;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [Auth0FlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"Auth0FlutterPlugin"]];
  [FLTImagePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTImagePickerPlugin"]];
}

@end
