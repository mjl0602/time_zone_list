
import 'dart:async';

import 'package:flutter/services.dart';

class TimeZoneList {
  static const MethodChannel _channel =
      const MethodChannel('time_zone_list');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
