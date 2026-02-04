package com.oversketch.time_zone_list;

import android.util.Log;

import androidx.annotation.NonNull;

import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.TimeZone;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * TimeZoneListPlugin
 */
public class TimeZoneListPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "time_zone_list");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("getTimeZoneList")) {
            Map arguments = (Map) call.arguments;
            long rawTimeStamp = ((Integer) arguments.get("dateTime")).longValue();
            long timeStamp = rawTimeStamp;
            timeStamp = timeStamp * 1000;
            final Map<String, ArrayList<Map<String, Object>>> resultMap = new HashMap<>();
            final String[] availableIDs = TimeZone.getAvailableIDs();
            final ArrayList<Map<String, Object>> list = new ArrayList<>(availableIDs.length);
            for (String availableID : availableIDs) {
                final TimeZone timeZone = TimeZone.getTimeZone(availableID);
                if (timeZone.inDaylightTime(new Date(timeStamp))){
                    final Map<String, Object> item = new HashMap<>();
                    item.put("tag", availableID);
                    item.put("secondsFromGMT", (timeZone.getOffset(timeStamp)-3600000) / 1000);
                    item.put("dst", (3600000 / 1000));
                    list.add(item);
                }else{
                    final Map<String, Object> item = new HashMap<>();
                    item.put("tag", availableID);
                    item.put("secondsFromGMT", (timeZone.getOffset(timeStamp)/ 1000));
                    item.put("dst", 0);
                    list.add(item);
                }
            }
            resultMap.put("list", list);
            result.success(resultMap);
        }else if (call.method.equals("getCurrentTimeZone")) {
            final TimeZone timeZone = TimeZone.getDefault();
            final Map<String, Object> item = new HashMap<>();
            long t = System.currentTimeMillis();
            item.put("tag", timeZone.getID());
            item.put("offset", (timeZone.getOffset(t)/ 1000));
            item.put("inDST", timeZone.inDaylightTime(new Date(t)) ? 1 : 0);
            result.success(item);
        }else if (call.method.equals("getTimeZone")) {
            Map arguments = (Map) call.arguments;
            long rawTimeStamp = ((Integer) arguments.get("dateTime")).longValue();
            String timeZoneId = (String) arguments.get("tag");
            long timeStamp = rawTimeStamp * 1000;
            final TimeZone timeZone = TimeZone.getTimeZone(timeZoneId);
            final Map<String, Object> item = new HashMap<>();
            long t = timeStamp + 0;
            item.put("tag", timeZone.getID());
            item.put("offset", (timeZone.getOffset(t)/ 1000));
            item.put("inDST", timeZone.inDaylightTime(new Date(t)) ? 1 : 0);
            item.put("time", t);
            result.success(item);
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
