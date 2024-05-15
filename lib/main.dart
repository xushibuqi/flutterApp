import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:buqi/service/GlobalExceptionHandler.dart';
import 'package:buqi/utils/acquireLocation.dart';
import 'package:buqi/utils/deviceUtil.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:io';
import 'router/AppRouter.dart';
import 'style/backgroundColor.dart';
import 'style/navigationBar.dart';

void main() {
  AppRouter.init();
  GlobalExceptionHandler.setupExceptionHandler(); // 异常处理
  runApp(const MyApp());
  _init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'buqi application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

void _init() {
  // 这里放置你希望在应用启动时执行的初始化操作
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS) ) {
    getCityFromCoordinates();
  }
  getDeviceInfo();
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SharedGradientContainer(
        childBuilder: (context) => Stack(
          children: [
            Positioned(
              top: 200, // 根据需要调整位置
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedTextKit(
                  pause: const Duration(milliseconds: 1000), // 动画结束后暂停时间
                  animatedTexts: [
                    WavyAnimatedText(
                      "welcome",
                      textStyle: const TextStyle(
                          fontSize: 60, color: Color(0xffede7e1)), // 设置字体大小和颜色
                    )
                  ],
                  repeatForever: true, // 使动画无限循环
                ),
              ),
            ),

            Positioned(
              bottom: 150, // 调整底部间距
              left: 0,
              right: 0,
              child: LoadingAnimationWidget.newtonCradle(
                color: Colors.white,
                size: 150,
              ),
            ),

            // 底部导航栏
            Positioned(
              bottom: 1.5, // 调整底部间距
              left: 0,
              right: 0,
              child: BottomNavigationBarWidget(0),
            ),
          ],
        ),
      ),
    );
  }
}
