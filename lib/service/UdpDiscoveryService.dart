import 'dart:async';
import 'dart:collection';
import 'dart:io';


import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../router/AppRouter.dart';

// 开启新线程 用于发送接收 udp 广播
class UdpDiscoveryService {
  static const int port = 4444;
  static const String broadcastAddress = '255.255.255.255';

  String discoveryMessage = "unknown";

  RawDatagramSocket? _socket;
  final StreamController<String> devicestreamController =
      StreamController<String>();
  final List<String> devices = [];
  final Map<String, int> times = new HashMap();

  UdpDiscoveryService();

  void start() async {




    SharedPreferences prefs = await SharedPreferences.getInstance();
    discoveryMessage = prefs.getString('device') ?? '';
    InternetAddress ip = InternetAddress.anyIPv4;



    //   为了在pc上 多个ip拿出在用的IP地址 目前规则是192.168.3
    if (!kIsWeb && Platform.isWindows) {
      // 定义匹配的正则表达式
      RegExp regex = RegExp(r'^192\.168\.3\.\d{1,3}$');

      // 获取本地所有的网络接口
      NetworkInterface.list().then((interfaces) {
        // 遍历每个网络接口
        interfaces.forEach((interface) {
          // 遍历每个地址
          interface.addresses.forEach((address) {
            // 检查地址是否符合条件
            if (address.type == InternetAddressType.IPv4 &&
                regex.hasMatch(address.address)) {
              ip = address;
            }
          });
        });
      });
    }

    _socket = await RawDatagramSocket.bind(
      ip,
      port,
    );
    _socket?.broadcastEnabled = true;
    Timer.periodic(Duration(seconds: 3), (timer) {
      sendBroadcast();
    });
    _socket?.listen((event) {
      Datagram? datagram = _socket?.receive();
      if (datagram != null) {
        String message = String.fromCharCodes(datagram.data).trim();
        if(message=="*&@"){
          //收到链接信息


        }else{
          String deviceInfo = '${datagram.address}: $message';

          DateTime now = DateTime.now();
          int timestamp = now.millisecondsSinceEpoch;

          // 每次拿到新数据 判断旧数据是否过期
          times.entries
              .where((entry) => timestamp - entry.value > 7000)
              .toList() // 转为列表，避免并发修改异常
              .forEach((entry) {
            removeDevice(entry.key);
            times.remove(entry.key);
          });
          times[deviceInfo] = timestamp;
          if (!devices.contains(deviceInfo)) {
            devices.add(deviceInfo);
          }
          // 更新流 用于通知重构界面
          devicestreamController.add(deviceInfo);
        }

      }
    });


  }

  void stop() {
    _socket?.close();
    devicestreamController.close();
  }

  void addDevice(String device) {
    if (!devices.contains(device)) {
      devices.add(device);
      devicestreamController.add(device);
    }
  }

  void removeDevice(String device) {
    devices.remove(device);
  }

  void sendBroadcast() {
    _socket!.send(
        discoveryMessage.codeUnits, InternetAddress(broadcastAddress), port);
  }
  void sendMsg(String ip) {
    _socket!.send(
        "*&@".codeUnits, InternetAddress(ip), port);
  }

  Stream<String> get deviceStream => devicestreamController.stream;
}
