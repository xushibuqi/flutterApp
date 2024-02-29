import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'httpUtil.dart';

// 通过城市获取天气
Future<Map<String, dynamic>> getWeatherByCity(String adcode) async {
  // 文档 地址 https://lbs.amap.com/api/webservice/guide/api/weatherinfo
  Map<String, dynamic> map = HashMap();
  Map<String, String> queryParams = {
    'key': 'eef31620ebc49212fb9cd0d10625bd92',
    'city': adcode,
    'extensions': "base"
  };

  map=await getUrl("https://restapi.amap.com/v3/weather/weatherInfo", queryParams);
  return map;
}

// 获取天气预报
Future<Map<String, dynamic>> getWeatherReport(String adcode) async {
  // 文档 地址 https://lbs.amap.com/api/webservice/guide/api/weatherinfo
  Map<String, dynamic> map = HashMap();
  Map<String, String> queryParams = {
    'key': 'eef31620ebc49212fb9cd0d10625bd92',
    'city': adcode,
    'extensions': "all"
  };
  map=await getUrl("https://restapi.amap.com/v3/weather/weatherInfo", queryParams);
  return map;
}


// 存储数据到本地
Future<void> saveToLocal(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}


// 存储 Map
Future<void> saveMap(String key,Map<String, dynamic> map) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = json.encode(map);
  await prefs.setString(key, jsonString);
}

// 读取 Map
Future<LinkedHashMap<String, dynamic>> readMap(String key) async {
  LinkedHashMap<String, dynamic> map=new LinkedHashMap();
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString(key);
  if (jsonString != null) {
    return json.decode(jsonString) as LinkedHashMap<String, dynamic>;
  }
  return map;
}


Future<T> withTimeout<T>(Duration duration, Future<T> future) async {
  // 创建一个延迟的 Future，等待指定的时间
  Future<T> timeout = Future.delayed(duration, () {
    // 当超时时，抛出 TimeoutException 异常
    throw TimeoutException('Operation timed out after ${duration.inSeconds} seconds');
  });

  // 使用 Future.race 方法，等待 future 和 timeout 中的任意一个完成
  return await Future.any([future, timeout]);
}