#import "TimeZoneListPlugin.h"

@implementation TimeZoneListPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"time_zone_list"
            binaryMessenger:[registrar messenger]];
  TimeZoneListPlugin* instance = [[TimeZoneListPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getTimeZoneList" isEqualToString:call.method]) {
      NSMutableArray<NSDictionary *> *list = [NSMutableArray new];
      NSArray *allNames = [NSTimeZone knownTimeZoneNames];
      for (NSString *name in allNames) {
          double offset = [[NSTimeZone timeZoneWithName:name] daylightSavingTimeOffset];
          [list addObject:@{
                        @"name":name,
                        @"offset":[NSNumber numberWithDouble:offset],
          }];

      }
      result(@{@"list":list});
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
