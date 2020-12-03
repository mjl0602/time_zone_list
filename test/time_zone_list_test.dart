import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_zone_list/time_zone_list.dart';

void main() {
  const MethodChannel channel = MethodChannel('time_zone_list');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    // expect(await TimeZoneList.platformVersion, '42');
  });
}
