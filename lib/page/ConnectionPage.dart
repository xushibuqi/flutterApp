



import 'package:buqi/service/UdpDiscoveryService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../style/backgroundColor.dart';
import '../style/navigationBar.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({Key? key}) : super(key: key);

  @override
  _DiscoveryPageState createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<ConnectionPage> {


  final UdpDiscoveryService _udpDiscoveryService = UdpDiscoveryService();

  @override
  void initState() {
    super.initState();
    _udpDiscoveryService.start();
  }

  @override
  void dispose() {
    _udpDiscoveryService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SharedGradientContainer(
      childBuilder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('局域网传输'),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: StreamBuilder<String>(
          stream: _udpDiscoveryService.deviceStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String deviceInfo = snapshot.data!;
              if (deviceInfo.endsWith(': disconnected')) {
                String deviceAddress = deviceInfo.split(':').first;
                _udpDiscoveryService.removeDevice(deviceAddress);
              } else {
                _udpDiscoveryService.addDevice(deviceInfo);
              }
            }
            return _udpDiscoveryService.devices.isEmpty
                ? const Center(
              child: Text('未发现局域网设备'),
            )
                : ListView.builder(
              itemCount: _udpDiscoveryService.devices.length,
              itemBuilder: (context, index) {
                String deviceInfo = _udpDiscoveryService.devices[index];
                return Card(
                  color: Color(0x80E87AE8),
                  child: ListTile(
                    title: Text(deviceInfo),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // 连接到选定的设备
                        // 在这里处理连接逻辑
                      },
                      child: const Text('连接'),
                    ),
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBarWidget(1),
      ),
    );
  }
}