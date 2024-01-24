import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter 弹出界面示例'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 调用共用的弹出方法
            _showBottomSheet(context);
          },
          child: Text('点击弹出界面'),
        ),
      ),
    );
  }
}