import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart';

import '../service/GlobalExceptionHandler.dart';

Future<Map<String, dynamic>> getUrl(
    String url, Map<String, String> queryParams) async {
  Map<String, dynamic> data = HashMap();

  String fullUrl =
      Uri.parse(url).replace(queryParameters: queryParams).toString();

  // 发起 GET 请求
  Response response = await get(Uri.parse(fullUrl));
  if (response.statusCode == 200) {
    // 请求成功，解析响应数据
    data = json.decode(response.body);
    print("Response data: $data");
    GlobalExceptionHandler.logCustomError("进行一个get请求 : $url");
    GlobalExceptionHandler.logCustomError(data.toString());
  } else {
    // 请求失败
    print("Failed to fetch data. Status code: ${response.statusCode}");
  }

  return data;
}

Future<Map<String, dynamic>> postUrl(
    String url, Map<String, String> queryParams) async {


  Map<String, dynamic> data = HashMap();
  // 发起 POST 请求
  Response response = await post(
    Uri.parse(url),
    body: queryParams,
  );

  if (response.statusCode == 200) {
    // 请求成功，解析响应数据
    data = json.decode(response.body);
    print("Response data: $data");
  } else {
    // 请求失败
    print("Failed to fetch data. Status code: ${response.statusCode}");
  }

  return data;
}
