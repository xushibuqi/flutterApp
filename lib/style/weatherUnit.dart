import 'package:flutter/material.dart';
import '../style/popupMenu.dart';
import '../utils/method.dart';

// 天气部件
class WeatherInfo {
  final String province;
  final String weather;
  final String temperature;
  final String windDirection;
  final String windPower;
  final String humidity;
  final String reportTime;
  final String address;
  final String adcode;

  WeatherInfo({
    required this.province,
    required this.adcode,
    required this.weather,
    required this.temperature,
    required this.windDirection,
    required this.windPower,
    required this.humidity,
    required this.reportTime,
    required this.address,
  });
}

class WeatherInfoBox extends StatelessWidget {
  final WeatherInfo weatherInfo;

  const WeatherInfoBox({
    Key? key,
    required this.weatherInfo,
  }) : super(key: key);

  Widget buildText(String text, {double fontSize = 12.0}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.black,
        decoration: TextDecoration.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 3,
      bottom: 3,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 180,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start, // 交叉轴对齐方式为 start
          children: [
            GestureDetector(
              onTap: () async {
                Map<String, dynamic> map = await getWeatherReport(weatherInfo.adcode);
                showPage(context, map);
              },
              child: const Text(
                '查看天气预报',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            buildText('你的地址:${weatherInfo.address}'),
            buildText('天气地址:${weatherInfo.province}'),
            buildText('天气:${weatherInfo.weather}'),
            buildText('温度:${weatherInfo.temperature}°C'),
            buildText('风向:${weatherInfo.windDirection}'),
            buildText('风力:${weatherInfo.windPower}'),
            buildText('湿度:${weatherInfo.humidity}%'),
            buildText('天气更新时间:${weatherInfo.reportTime}'),
            // 添加一个可点击的文本
          ],
        ),
      ),
    );
  }
}
