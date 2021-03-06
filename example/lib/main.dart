import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:time_zone_list/time_zone_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<TimeZoneInfo> l = [];

  bool isSummer = false;
  String current = 'loading';
  String la = 'loading';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      current = (await TimeZoneList.current()).toString();
      var date = isSummer
          ? DateTime(2020, 5, 8, 8, 8, 8)
          : DateTime(2020, 12, 8, 8, 8, 8);
      var laZone = await TimeZoneList.timeZone('America/Los_Angeles', date);
      la = laZone.toString();
      var list = await TimeZoneList.getList(date);
      // print(res);
      list.sort((a, b) => (a.offset - b.offset).inSeconds);
      l = list;
    } on PlatformException {}

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              setState(() {
                isSummer = !isSummer;
              });
              initPlatformState();
            },
            child: Text(isSummer ? 'Summer' : 'Winter'),
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              color: Color(0xf5f5f4),
              child: Text('Current:$current'),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              color: Color(0xf5f5f4),
              child: Text('LA:$la'),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: l.length,
                itemBuilder: (context, index) => Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 4,
                    // horizontal: 12,
                  ),
                  child: Text(
                    '$index:${l[index]}',
                    style: TextStyle(
                      color: l[index].dstOffset.inHours == 0
                          ? Colors.black
                          : Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
