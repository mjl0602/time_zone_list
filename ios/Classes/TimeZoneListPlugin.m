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
      NSNumber *timeStamp = call.arguments[@"dateTime"];
      NSDate *targetDate = [NSDate dateWithTimeIntervalSince1970:timeStamp.longValue];
      NSMutableArray<NSDictionary *> *list = [NSMutableArray new];
      NSArray *allNames = [NSTimeZone knownTimeZoneNames];
      for (NSString *name in allNames) {
          double offset = [[NSTimeZone timeZoneWithName:name] daylightSavingTimeOffsetForDate:targetDate];
          NSInteger timestamp = [[NSTimeZone timeZoneWithName:name] secondsFromGMTForDate:targetDate];
          [list addObject:@{
                        @"tag":name,
                        @"secondsFromGMT":[NSNumber numberWithLong: timestamp-offset],
                        @"dst":[NSNumber numberWithDouble:offset],
          }];
      }
      result(@{@"list":list});
  }else if ([@"getCurrentTimeZone" isEqualToString:call.method]) {
      NSDate *targetDate = [NSDate date];
      NSTimeZone *timeZone = [NSTimeZone localTimeZone];
      double offset = [timeZone daylightSavingTimeOffsetForDate:targetDate];
      NSInteger timestamp = [timeZone secondsFromGMTForDate:targetDate];
      result(@{
          @"tag":timeZone.name,
          @"offset":[NSNumber numberWithLong: timestamp],
          @"inDST": offset == 0 ? @0 : @1,
//          @"time": timeStamp,
             });
  }else if ([@"getTimeZone" isEqualToString:call.method]) {
      NSNumber *timeStamp = call.arguments[@"dateTime"];
      NSString *tag = call.arguments[@"tag"];
      NSDate *targetDate = [NSDate dateWithTimeIntervalSince1970:timeStamp.longValue];
      NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:tag];
      double offset = [timeZone daylightSavingTimeOffsetForDate:targetDate];
      NSInteger timestamp = [timeZone secondsFromGMTForDate:targetDate];
      result(@{
          @"tag":timeZone.name,
          @"offset":[NSNumber numberWithLong: timestamp],
          @"inDST": offset == 0 ? @0 : @1,
//          @"time": timeStamp,
             });
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
