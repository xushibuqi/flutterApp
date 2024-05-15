import 'dart:convert';
import 'package:http/http.dart';

import '../service/GlobalExceptionHandler.dart';
import 'permission.dart';
import 'httpUtil.dart';
import 'method.dart';

// 通过经纬度反编译城市
Future<void> getCityFromCoordinates() async {
  Map<String, String> locationInfo = await getLocationInformation();
  try {
    String apiUrl = "https://restapi.amap.com/v3/geocode/regeo";
    if (locationInfo["lat"] != null && locationInfo["long"] != null) {
      Map<String, String> queryParams = {
        'key': 'eef31620ebc49212fb9cd0d10625bd92',
        'location': '${locationInfo["long"]},${locationInfo["lat"]}',
      };
      Map<String, dynamic> data = await getUrl(apiUrl, queryParams);
      Map<String, dynamic> m1 = data["regeocode"];
      String address = m1["formatted_address"];
      Map<String, dynamic> m2 = m1["addressComponent"];
      String adcode = m2["adcode"];
      String city = m2.containsKey("city") ? m2["city"].toString() : "unknown";
      saveToLocal("adcode", adcode);
      saveToLocal("city", city);
      saveToLocal("address", address);
    }
  } catch (e) {
    GlobalExceptionHandler.logCustomError("通过经纬度查询城市失败");
    print("通过经纬度查询城市失败");
  }
}
