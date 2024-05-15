import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalExceptionHandler {
  static void setupExceptionHandler() {
    FlutterError.onError = (FlutterErrorDetails details) async {
      // 记录异常日志
      recordError(details);

      // 可以选择是否继续抛出异常
      FlutterError.dumpErrorToConsole(details);
    };
  }

  static void recordError(FlutterErrorDetails details) async {
    // 获取异常信息
    String error = '${details.exception}\n${details.stack}';

    // 根据平台保存日志
    String logPath = await _getLogPath();
    await _writeToFile(logPath, error);
  }

  static Future<String> _getLogPath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    return '$appDocPath/buqi/error_log.txt';
  }

  static Future<void> _writeToFile(String path, String content) async {
    File file = File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    file.writeAsStringSync(content, mode: FileMode.append);
  }

  static String converMsg(String msg) {
    DateTime now = DateTime.now();
    msg = now.toString() + " " + msg + "\n";

    return msg;
  }

  // 自定义传入异常信息的记录方法
  static void logCustomError(String error) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String msg = prefs.getString('device') ?? '';
    String logPath = await _getLogPath();
    print(logPath);

    await _writeToFile(logPath, converMsg("$msg $error"));
  }
}
