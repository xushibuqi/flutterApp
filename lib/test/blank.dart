import 'package:flutter/material.dart';
import '../style/navigationBar.dart';
import '../style/backgroundColor.dart';

class blank extends StatelessWidget {
  const blank({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Blank Page'),
        backgroundColor: Colors.transparent, // 设置为透明
        elevation: 0, // 去除阴
      ),
      backgroundColor: Colors.transparent,
      body: SharedGradientContainer(
        childBuilder: (context) => Stack(
          children: [
            const Center(
              child: Text("Your Center Content Here"), // 中间的内容
            ),
            // 底部导航栏
            Positioned(
              bottom: 1.5, // 调整底部间距
              left: 0,
              right: 0,
              child: BottomNavigationBarWidget(4),
            ),
          ],
        ),
      ),
    );
  }
}
