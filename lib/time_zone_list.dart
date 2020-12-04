import 'dart:async';

import 'package:flutter/services.dart';

class TimeZoneList {
  static const MethodChannel _channel = const MethodChannel('time_zone_list');

  static Future<List<TimeZoneInfo>> getTimeZoneList([DateTime dateTime]) async {
    dateTime ??= DateTime.now();
    final Map result = await _channel.invokeMethod('getTimeZoneList', {
      'dateTime': dateTime.millisecondsSinceEpoch ~/ 1000,
    });
    List list = result["list"];
    // print(list.first['time']);
    // print(list.first['timeStamp']);
    // print(dateTime.millisecondsSinceEpoch ~/ 1000);
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
  Duration get gmtOffset => Duration(seconds: rawOffset);
  Duration get dstOffset => Duration(seconds: rawDstOffset);

  @override
  String toString() {
    // return '$tag:${offset.inHours}:00';
    if (dstOffset.inHours == 0) {
      return '$tag:${offset.inHours} GMT${gmtOffset.inHours}:00';
    }
    return '$tag:${offset.inHours} GMT${gmtOffset.inHours}:00 DST:${dstOffset.inHours}:00';
  }
}
