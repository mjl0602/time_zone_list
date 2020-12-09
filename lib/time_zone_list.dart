import 'dart:async';

import 'package:flutter/services.dart';

class TimeZoneList {
  static const MethodChannel _channel = const MethodChannel('time_zone_list');

  static Future<List<TimeZoneInfo>> getList([DateTime dateTime]) async {
    dateTime ??= DateTime.now();
    final Map result = await _channel.invokeMethod('getTimeZoneList', {
      'dateTime': dateTime.millisecondsSinceEpoch ~/ 1000,
    });
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

  static Future<TimeZoneInfo> current() async {
    final Map e = await _channel.invokeMethod('getCurrentTimeZone');
    var offset = e['offset'] ~/ 1;
    bool inDST = e['inDST'] == 1;
    if (inDST) {
      offset -= 3600000;
    }
    return TimeZoneInfo(
      tag: e['tag'],
      rawOffset: offset,
      rawDstOffset: inDST ? 3600000 : 0,
    );
  }

  static Future<TimeZoneInfo> timeZone(String tag, [DateTime dateTime]) async {
    dateTime ??= DateTime.now();
    print('time: $dateTime');
    final Map e = await _channel.invokeMethod('getTimeZone', {
      'tag': tag,
      'dateTime': dateTime.millisecondsSinceEpoch ~/ 1000,
    });
    var offset = e['offset'] ~/ 1;
    bool inDST = e['inDST'] == 1;

    // print('=: ${DateTime.fromMillisecondsSinceEpoch(e['time'])}');
    if (inDST) {
      offset -= 3600;
    }
    return TimeZoneInfo(
      tag: e['tag'],
      rawOffset: offset,
      rawDstOffset: inDST ? 3600 : 0,
    );
  }
}

class TimeZoneInfo {
  /// 时区名称
  final String tag;

  /// 标准的时区偏差，单位为秒，中国为+8小时
  final int rawOffset;

  /// 夏令时产生的的时区偏差，单位为秒
  final int rawDstOffset;

  bool get inDST => rawOffset != 0;

  TimeZoneInfo({
    this.tag,
    this.rawOffset,
    this.rawDstOffset,
  });

  TimeZoneInfo.fromOffset({
    String tag,
    int offset,
    bool inDST,
  }) : this(
          tag: tag,
          rawOffset: offset += inDST ? 3600000 : 0,
          rawDstOffset: inDST ? 3600000 : 0,
        );

  Duration get offset => Duration(seconds: rawOffset + rawDstOffset);
  Duration get gmtOffset => Duration(seconds: rawOffset);
  Duration get dstOffset => Duration(seconds: rawDstOffset);

  String get timeZone {
    var h = offset.inHours;
    if (dstOffset.inHours == 0) {
      return 'GMT${h.tSign}:00';
    } else {
      return 'DST${h.tSign}:00';
    }
  }

  String get desc {
    return '$tag:$timeZone';
  }

  @override
  String toString() {
    if (dstOffset.inHours == 0) {
      return '$tag GMT${gmtOffset.inHours}:00';
    }
    return '$tag: $timeZone(GMT${gmtOffset.inHours}:00 DST:${dstOffset.inHours}:00)';
  }
}

extension _TimeZoneSignNum on num {
  String get tSign {
    if (this >= 0) {
      return '+${this.toString().padLeft(2, '0')}';
    } else {
      var n = this.abs();
      return '-${n.toString().padLeft(2, '0')}';
    }
  }
}
