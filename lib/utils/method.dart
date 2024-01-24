import 'dart:collection';
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
