import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../router/AppRouter.dart';
import 'navigationBar.dart';

//  点击弹出方框
void showWeatherOptions(BuildContext context) {
  final RenderBox overlay =
      Overlay.of(context)!.context.findRenderObject() as RenderBox;
  final RelativeRect position = RelativeRect.fromRect(
    Rect.fromPoints(
      overlay.localToGlobal(overlay.size.bottomLeft(const Offset(0, 0)),
          ancestor: overlay),
      overlay.localToGlobal(overlay.size.bottomRight(const Offset(0, 0)),
          ancestor: overlay),
    ),
    Offset.zero & overlay.size,
  );

  showMenu(
    context: context,
    position: position,
    color: Colors.blueAccent,
    items: [
      PopupMenuItem(
        child: Row(
          children: [
            CustomIconButton(
              icon: FontAwesomeIcons.arrowRight,
              onPressed: () {
                AppRouter.router.navigateTo(context, '/weather/real',
                    transition: TransitionType.fadeIn);
              },
            ),
            const SizedBox(width: 1), // Add spacing between icon and text
            const Text('真实界面'),
          ],
        ),
      ),
      PopupMenuItem(
        child: Row(
          children: [
            CustomIconButton(
              icon: FontAwesomeIcons.cloud,
              onPressed: () {
                AppRouter.router.navigateTo(context, '/weather/cloud',
                    transition: TransitionType.fadeIn);
              },
            ),
            const SizedBox(width: 1), // Add spacing between icon and text
            const Text('云'),
          ],
        ),
      ),
      PopupMenuItem(
        child: Row(
          children: [
            CustomIconButton(
              icon: FontAwesomeIcons.sun,
              onPressed: () {
                AppRouter.router.navigateTo(context, '/weather/sun',
                    transition: TransitionType.fadeIn);
              },
            ),
            const SizedBox(width: 1), // Add spacing between icon and text
            const Text('晴'),
          ],
        ),
      ),
      PopupMenuItem(
        child: Row(
          children: [
            CustomIconButton(
              icon: FontAwesomeIcons.snowflake,
              onPressed: () {
                AppRouter.router.navigateTo(context, '/weather/snow',
                    transition: TransitionType.fadeIn);
              },
            ),
            const SizedBox(width: 1), // Add spacing between icon and text
            const Text('雪'),
          ],
        ),
      ),
      PopupMenuItem(
        child: Row(
          children: [
            CustomIconButton(
              icon: FontAwesomeIcons.cloudShowersHeavy,
              onPressed: () {
                AppRouter.router.navigateTo(context, '/weather/rain',
                    transition: TransitionType.fadeIn);
              },
            ),
            const SizedBox(width: 1), // Add spacing between icon and text
            const Text('雨'),
          ],
        ),
      ),
    ],
  );
}

// 点击弹出界面

// 弹出半屏幕的方法
void showPage(BuildContext context, Map<String, dynamic> map) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      List<dynamic> forecasts = map["forecasts"];
      List<dynamic> casts = forecasts[0]["casts"];
      String time = forecasts[0]["reporttime"];
      return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        color: Colors.lightBlue[200] ?? Colors.red, // 蓝灰色背景,
        padding: const EdgeInsets.all(16.0), // 添加整体的内边距
        child: ListView.builder(
          itemCount: casts.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              // 第一个位置显示顶部内容
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '更新时间:$time',
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.black, // 你想要的颜色
                    ),
                  ),
                  SizedBox(height: 16.0), // 用于添加上边距
                ],
              );
            }

            var weatherData = casts[index - 1];
            return Container(
              margin: const EdgeInsets.only(bottom: 16.0), // 每个 item 加点垂直间距
              padding: const EdgeInsets.all(8.0), // 添加框的内边距
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black ?? Colors.red),
                // 框的边框颜色
                borderRadius: BorderRadius.circular(8.0), // 框的圆角
              ),

              child: buildWeatherDataRow(weatherData),
            );
          },
        ),
      );
    },
  );
}

Widget buildWeatherDataRow(Map<String, dynamic> weatherData) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start, // 文本左对齐
    children: [
      buildText('日期', weatherData["date"]),
      buildText('星期', weatherData["week"]),
      buildText('白天天气', weatherData["dayweather"]),
      buildText('夜晚天气', weatherData["nightweather"]),
      buildText('白天温度', '${weatherData["daytemp"]}°C'),
      buildText('夜晚温度', '${weatherData["nighttemp"]}°C'),
      buildText('白天风向', weatherData["daywind"]),
      buildText('夜晚风向', weatherData["nightwind"]),
      buildText('白天风力', weatherData["daypower"]),
      buildText('夜晚风力', weatherData["nightpower"]),
      buildText('白天温度浮点数', weatherData["daytemp_float"]),
      buildText('夜晚温度浮点数', weatherData["nighttemp_float"]),
    ],
  );
}

Widget buildText(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0), // 每个 item 加点距离
    child: Text(
      '$label: $value',
      style: TextStyle(fontSize: 13.0, color: Colors.grey[900] ?? Colors.red),
    ),
  );
}
