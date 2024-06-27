import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../style/weatherStyle.dart';
import '../utils/method.dart';

class buildWeather extends StatelessWidget {

  String cloud;

  buildWeather({super.key, required this.cloud});

  Future<Map<String, String>> getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String address = prefs.getString('address') ?? '';
    String adcode = prefs.getString('adcode') ?? '';
    Map<String, String> map = {'address': address, 'adcode': adcode};
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>?>(
      // 使用 FutureBuilder 处理异步操作

      future: getAddress(),
      builder: (context, snapshot) {
        appBar: AppBar(
          title: const Text('天气'),
          backgroundColor: Colors.transparent,
        );
        if (snapshot.connectionState == ConnectionState.done) {

          // 异步操作完成，获取到地址信息
          Map<String, String> map = snapshot.data ?? {};
          String adcode = map["adcode"] ?? "";
          String address = map["address"] ?? "";
          // 获取天气信息
          return FutureBuilder<Map<String, dynamic>>(
            future: getWeatherByCity(adcode),
            builder: (context, weatherSnapshot) {
              if (weatherSnapshot.connectionState == ConnectionState.done) {
                // 天气信息获取完成，可以在这里使用天气信息
                Map<String, dynamic> weatherMap = weatherSnapshot.data ?? {};
                return weather(weatherMap, address, context,cloud);
              } else {
                // 天气信息异步操作未完成，可以显示加载指示器等
                return CircularProgressIndicator();
              }
            },
          );
        } else {
          // 异步操作未完成，可以显示加载指示器等
          return CircularProgressIndicator();
        }
      },
    );
  }
}

