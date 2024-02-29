import 'dart:async';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class UdpDiscoveryService {
  static const int port = 4444;
  static const String broadcastAddress = '255.255.255.255';

  String discoveryMessage = "unknown";

  RawDatagramSocket? _socket;
  final StreamController<String> devicestreamController =
      StreamController<String>();
  final List<String> devices = [];
  UdpDiscoveryService();

  void start() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    discoveryMessage = prefs.getString('device') ?? '';
    InternetAddress ip = InternetAddress.anyIPv4;
    //   为了在pc上 多个ip拿出在用的IP地址 目前规则是192.168.3
    if (Platform.isWindows){
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


    _socket = await RawDatagramSocket.bind(ip, port,);
    _socket?.listen((event) {
      Datagram? datagram = _socket?.receive();
      if (datagram != null) {
        String message = String.fromCharCodes(datagram.data).trim();
        String deviceInfo = '${datagram.address}: $message';
        if (!devices.contains(deviceInfo)) {
          devices.add(deviceInfo);
          devicestreamController.add(deviceInfo);
        }
      }
    });
    _socket?.broadcastEnabled = true;
    Timer.periodic(Duration(seconds: 5), (timer) {
      _sendBroadcast();
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
    devicestreamController.add(device);
  }

  void _sendBroadcast() {
    _socket!.send(
        discoveryMessage.codeUnits, InternetAddress(broadcastAddress), port);
  }

  Stream<String> get deviceStream => devicestreamController.stream;
}
