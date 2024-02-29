import 'dart:collection';
import 'dart:io';
import 'dart:core';
import 'package:buqi/utils/method.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

void getDeviceInfo() async {
  LinkedHashMap<String, String> map = LinkedHashMap();
  LinkedHashMap<String, String> newMap = LinkedHashMap();
  String env = "";
  String device = "unknown";
  if (kIsWeb) {
    String userAgent = html.window.navigator.userAgent;
    env = "web";
    // 正则表达式匹配不同部分
    RegExp osRegex = RegExp(r'(\b(?:Windows|Macintosh|Linux|iOS|Android)\b)\s*([^;]+)?\s*');
    // 匹配操作系统
    RegExpMatch? osMatch = osRegex.firstMatch(userAgent);
    String osInfo = osMatch?.group(1) ?? "";
    String osVersion = osMatch?.group(2)?.trim() ?? "";
    // 正则表达式匹配不同浏览器名称和版本号
    RegExp browserRegex = RegExp(r'(Chrome|Firefox|Safari|Edge|Opera)[\s/]+(\d+\.\d+(\.\d+)?)');

    // 匹配浏览器名称和版本号
    RegExpMatch? browserMatch = browserRegex.firstMatch(userAgent);
    String browserName = browserMatch?.group(1) ?? "Unknown";
    String browserVersion = browserMatch?.group(2) ?? "";

    map.putIfAbsent("外部环境 : ", () => "$osInfo $osVersion");
    map.putIfAbsent("浏览器 : ", () => browserName);
    map.putIfAbsent("版本 : ", () => browserVersion);
    device="web";
  } else {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      env = "android";
      device="android ${androidInfo.model}";
      map.putIfAbsent("品牌 : ", () => androidInfo.brand);
      map.putIfAbsent("设备型号 : ", () => androidInfo.model);
      map.putIfAbsent("安卓版本 : ", () => androidInfo.version.release);
      map.putIfAbsent(
          "支持的cpu架构 : ", () => androidInfo.supportedAbis.toString());
      map.putIfAbsent(
          "分辨率以及像素 : ",
              () =>
          "${androidInfo.displayMetrics.widthPx}*${androidInfo.displayMetrics.heightPx}  ${androidInfo.displayMetrics.xDpi}");
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      env = "ios";
      device="ios ${iosInfo.model}";
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macInfo = await deviceInfoPlugin.macOsInfo;
      env = "mac";
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfoPlugin.windowsInfo;
      env = "win";
      device="win ${windowsInfo.computerName}";
      map.putIfAbsent("电脑名称 : ", () => windowsInfo.computerName);
      map.putIfAbsent("系统名 : ", () => windowsInfo.productName);
      map.putIfAbsent("系统版本 : ", () => windowsInfo.displayVersion);
      map.putIfAbsent("安装时间 : ", () => windowsInfo.installDate.toString());
      map.putIfAbsent("用户名 : ", () => windowsInfo.userName);
      map.putIfAbsent("注册账号 : ", () => windowsInfo.registeredOwner);
      map.putIfAbsent("核心数 : ", () => windowsInfo.numberOfCores.toString());
      map.putIfAbsent("内存(G) : ", () => (windowsInfo.systemMemoryInMegabytes/1024).toString());

    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await deviceInfoPlugin.linuxInfo;
      env = "linux";
    }
  }
  newMap.putIfAbsent("运行环境 : ", () => env);
  newMap.addAll(map);
  saveToLocal("device", device);
  saveMap("devices",newMap);
}
