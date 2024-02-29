import 'dart:convert';

import 'package:fluro/fluro.dart';
import '../page/deviceInfo.dart';
import '../page/weather.dart';
import '../page/ConnectionPage.dart';
import '../page/fileTransfer.dart';
import '../main.dart';
import '../test/blank.dart';


class AppRouter {
  static late FluroRouter router;

  static void init() {
    router = FluroRouter();
    // Define your routes here
    router.define(
      '/home',
      handler: Handler(handlerFunc: (context, params) => const MyHomePage()),
    );
    router.define(
      '/udpConnection',
      handler:
      Handler(handlerFunc: (context, params) => const ConnectionPage()),
    );
    router.define(
      '/weather/:cloud',
      handler: Handler(handlerFunc: (context, params) {
        // 获取查询参数
        String cloud = params['cloud']?.first ?? "real";

        // 将参数传递给页面
        return buildWeather(cloud: cloud);
      }),
    );
    router.define(
      '/blank',
      handler:
      Handler(handlerFunc: (context, params) => const blank()),
    );
    router.define(
      '/device',
      handler:
      Handler(handlerFunc: (context, params) =>  deviceInfo()),
    );
    /* router.define(
      '/second',
      handler: Handler(handlerFunc: (context, params) => BlCubitCounterPage1(type)),
    );*/
      router.define(
      '/details/:id', // Example route with parameter
      handler: Handler(handlerFunc: (_, params) {
        String? idString = params['id']?.first;
        int id = int.tryParse(idString ?? '') ?? 1;
        //   return BlCubitCounterPage2(id: id);
      }),
    );
    router.define(
      '/details',
      handler: Handler(handlerFunc: (_, params) {
        String? dataString = params['data']?.first;
        Map<String, dynamic>? data =
        dataString != null ? jsonDecode(dataString) : null;
        //   return BlCubitCounterPage2(data: data ?? {});
      }),
    );
    // Add more routes as needed
  }
}
