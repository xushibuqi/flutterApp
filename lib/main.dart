import 'package:flutter/material.dart';
import 'style/navigationBar.dart';
import 'style/backgroundColor.dart';
import 'router/AppRouter.dart';
import 'utils/acquireLocation.dart';

void main() {
  AppRouter.init();
  runApp(const MyApp());
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
    // 在初始化时调用获取城市信息的方法
    fetchCityInformation();
  }

  Future<void> fetchCityInformation() async {
    try {
      getCityFromCoordinates();
      // 在这里可以根据需要更新 UI 或执行其他操作
    } catch (e) {
      // 处理异常
      print('Error fetching city information: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: BottomNavigationBarWidget(1),
            ),
          ],
        ),
      ),
    );
  }
}
