# time_zone_list

A new flutter plugin get list of time zone name and time zone offset.

## Usage

```dart

var current = await TimeZoneList.current();

var listNow = await TimeZoneList.getList();

var list = await TimeZoneList.getList(
    DateTime(2020, 5, 8, 8, 8, 8),
);

var laZone = await TimeZoneList.timeZone('America/Los_Angeles', date);
```

## Upload

```bash
flutter packages pub publish --server=https://pub.dartlang.org
```