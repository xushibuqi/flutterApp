import 'dart:async';
import 'dart:io';
void startUdpServer() {
  RawDatagramSocket.bind(InternetAddress.anyIPv4, 12345,)
      .then((RawDatagramSocket socket) {
    print('UDP server running on ${socket.address.address}:${socket.port}');

    socket.listen((RawSocketEvent event) {
      if (event == RawSocketEvent.read) {
        Datagram? datagram = socket.receive();
        if (datagram != null) {
          String message = String.fromCharCodes(datagram.data).trim();
          print('Received message: $message');
          if (message == 'Hello from Flutter') {
            // 如果接收到来自 Flutter 应用的消息，则回复确认
            socket.send('Device discovered'.codeUnits, datagram.address, datagram.port);
          }
        }
      }
    });
  });
}

Future<void> sendUdpBroadcast() async {
  final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
  socket.broadcastEnabled = true;
  final data = 'Hello from Flutter'.codeUnits;
  socket.send(data, InternetAddress('255.255.255.255'), 12345);
  print('UDP broadcast sent');
}