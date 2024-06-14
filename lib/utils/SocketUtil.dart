import 'dart:async';
import 'dart:io';

class socketUtil {
  Socket? _socket;
  String? _host;
  final int  _port=55555;

  socketUtil(String host) {
    _host = host;
  }

  // 连接方法
  Future<bool> connectDevice() async {
    try {
      _socket = await Socket.connect(_host, _port);
      print('Connected to: ${_socket?.remoteAddress.address}:${_socket?.remotePort}');
      return true;
    } catch (e) {
      print('Unable to connect: $e');
      return false;
    }
  }



  // 断开连接方法
  void disconnect() {
    _socket?.close();
    _socket = null;
    print('Socket disconnected');
  }
}
