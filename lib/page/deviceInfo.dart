import 'dart:collection';

import 'package:flutter/material.dart';
import '../style/navigationBar.dart';
import '../style/backgroundColor.dart';
import '../utils/deviceUtil.dart';
import '../utils/method.dart';

class deviceInfo extends StatefulWidget {
  @override
  State<deviceInfo> createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<deviceInfo> {
  LinkedHashMap<String, dynamic> _deviceInfo = LinkedHashMap();

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    LinkedHashMap<String, dynamic> deviceInfo = await readMap("devices");
    setState(() {
      _deviceInfo = deviceInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // 让背景延伸到顶部bar
      appBar: AppBar(
        title: Text('Device Info'),
        backgroundColor: Colors.transparent, // 设置为透明
        elevation: 0, // 去除阴影
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SharedGradientContainer(
            childBuilder: (context) => ListView.builder(
              itemCount: _deviceInfo.length,
              itemBuilder: (BuildContext context, int index) {
                String key = _deviceInfo.keys.elementAt(index);
                String value = _deviceInfo[key];
                return Card(
                  color: const Color(0xFF9BDAAD),
                  child: ListTile(
                    title: Text(key+value),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 1.5, // 调整底部间距
            left: 0,
            right: 0,
            child: BottomNavigationBarWidget(3),
          ),
        ],
      ),
    );
  }
}
