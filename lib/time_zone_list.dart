import 'dart:async';

import 'package:flutter/services.dart';

class TimeZoneList {
  static const MethodChannel _channel = const MethodChannel('time_zone_list');

  static Future<List<TimeZoneInfo>> getTimeZoneList() async {
    final Map result = await _channel.invokeMethod('getTimeZoneList');
    List list = result["list"];

    return list
        .map(
          (e) => TimeZoneInfo(
            tag: e['tag'],
            rawOffset: e['secondsFromGMT'] ~/ 1,
            rawDstOffset: e['dst'] ~/ 1,
          ),
        )
        .toList();
  }
}

class TimeZoneInfo {
  /// 时区名称
  final String tag;

  /// 标准的时区偏差，单位为秒，中国为+8小时
  final int rawOffset;

  /// 夏令时产生的的时区偏差，单位为秒
  final int rawDstOffset;

  TimeZoneInfo({
    this.tag,
    this.rawOffset,
    this.rawDstOffset,
  });

  Duration get offset => Duration(seconds: rawOffset + rawDstOffset);

  @override
  String toString() {
    return '$tag:${offset.inHours}:00';
  }
}
