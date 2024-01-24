import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weather_animation/weather_animation.dart';
import 'weatherUnit.dart';

WrapperScene weather(Map<String, dynamic> weatherMap, String address,
    BuildContext context, String cloud) {
  List<dynamic> list = weatherMap["lives"];
  Map<String, dynamic> wMap = list[0];
  String weatherToday = wMap["weather"];
  WeatherInfo weatherInfo = WeatherInfo(
    address: address,
    province: "${wMap["province"] ?? ""} ${wMap["city"] ?? ""}",
    weather: wMap["weather"] ?? "",
    temperature: wMap["temperature"] ?? "",
    windDirection: wMap["winddirection"] ?? "",
    windPower: wMap["windpower"] ?? "",
    humidity: wMap["humidity"] ?? "",
    reportTime: wMap["reporttime"] ?? "",
    adcode: wMap["adcode"] ?? "",
  );

  if (cloud == "real") {
    weatherToday = wMap["weather"];
  } else if (cloud == "cloud") {
    weatherToday = "阴";
  } else if (cloud == "sun") {
    weatherToday = "晴";
  } else if (cloud == "rain") {
    weatherToday = "雨";
  } else if (cloud == "snow") {
    weatherToday = "雪";
  }

  if (weatherToday.contains("雨")) {
    return rain(weatherInfo, context);
  } else if (weatherToday.contains("雪")) {
    return snow(weatherInfo, context);
  } else if (weatherToday.contains("阴")) {
    return overcastSky(weatherInfo, context);
  } else {
    return clear(weatherInfo, context);
  }
}

WrapperScene clear(WeatherInfo weatherInfo, BuildContext context) {
  return WrapperScene(
    sizeCanvas: Size(
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height,
    ),
    isLeftCornerGradient: false,
    colors: const [
      Color(0xffd50000),
      Color(0xffffd54f),
    ],
    children: [
      const SunWidget(
        sunConfig: SunConfig(
            width: 360,
            blurSigma: 17,
            blurStyle: BlurStyle.solid,
            isLeftLocation: true,
            coreColor: Color(0xfff57c00),
            midColor: Color(0xffffee58),
            outColor: Color(0xffffa726),
            animMidMill: 1500,
            animOutMill: 1500),
      ),
      WeatherInfoBox(
        weatherInfo: weatherInfo,
      ),
    ],
  );
}

// 雨
WrapperScene rain(WeatherInfo weatherInfo, BuildContext context) {
  return WrapperScene(
    sizeCanvas: Size(
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height,
    ),
    isLeftCornerGradient: true,
    colors: const [
      Color(0xff424242),
      Color(0xffcfd8dc),
    ],
    children: [
      const RainWidget(
        rainConfig: RainConfig(
            count: 30,
            lengthDrop: 13,
            widthDrop: 4,
            color: Color(0xff9e9e9e),
            isRoundedEndsDrop: true,
            widgetRainDrop: null,
            fallRangeMinDurMill: 500,
            fallRangeMaxDurMill: 1500,
            areaXStart: 41,
            areaXEnd: 264,
            areaYStart: 208,
            areaYEnd: 620,
            slideX: 2,
            slideY: 0,
            slideDurMill: 2000,
            slideCurve: Cubic(0.40, 0.00, 0.20, 1.00),
            fallCurve: Cubic(0.55, 0.09, 0.68, 0.53),
            fadeCurve: Cubic(0.95, 0.05, 0.80, 0.04)),
      ),
      const CloudWidget(
        cloudConfig: CloudConfig(
            size: 232,
            color: Color(0xb2bdbdbd),
            icon: IconData(63056, fontFamily: 'MaterialIcons'),
            widgetCloud: null,
            x: 119,
            y: -39,
            scaleBegin: 1,
            scaleEnd: 1.1,
            scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00),
            slideX: 11,
            slideY: 13,
            slideDurMill: 4000,
            slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),
      ),
      const CloudWidget(
        cloudConfig: CloudConfig(
            size: 250,
            color: Color(0x92fafafa),
            icon: IconData(63056, fontFamily: 'MaterialIcons'),
            widgetCloud: null,
            x: 20,
            y: 3,
            scaleBegin: 1,
            scaleEnd: 1.08,
            scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00),
            slideX: 20,
            slideY: 0,
            slideDurMill: 3000,
            slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),
      ),
      const CloudWidget(
        cloudConfig: CloudConfig(
            size: 160,
            color: Color(0xb5fafafa),
            icon: IconData(63056, fontFamily: 'MaterialIcons'),
            widgetCloud: null,
            x: 140,
            y: 97,
            scaleBegin: 1,
            scaleEnd: 1.1,
            scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00),
            slideX: 20,
            slideY: 4,
            slideDurMill: 2000,
            slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),
      ),
      WeatherInfoBox(
        weatherInfo: weatherInfo,
      ),
    ],
  );
}

//雪
WrapperScene snow(WeatherInfo weatherInfo, BuildContext context) {
  return WrapperScene(
    sizeCanvas: Size(
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height,
    ),
    isLeftCornerGradient: true,
    colors: const [
      Color(0xff3949ab),
      Color(0xff90caf9),
      Color(0xffd6d6d6),
    ],
    children: [
      const SnowWidget(
        snowConfig: SnowConfig(
            count: 30,
            size: 20,
            color: Color(0xb3ffffff),
            icon: IconData(57399, fontFamily: 'MaterialIcons'),
            widgetSnowflake: null,
            areaXStart: 42,
            areaXEnd: 240,
            areaYStart: 200,
            areaYEnd: 540,
            waveRangeMin: 20,
            waveRangeMax: 70,
            waveMinSec: 5,
            waveMaxSec: 20,
            waveCurve: Cubic(0.45, 0.05, 0.55, 0.95),
            fadeCurve: Cubic(0.60, 0.04, 0.98, 0.34),
            fallMinSec: 10,
            fallMaxSec: 60),
      ),
      const CloudWidget(
        cloudConfig: CloudConfig(
            size: 202,
            color: Color(0xa8fafafa),
            icon: IconData(63056, fontFamily: 'MaterialIcons'),
            widgetCloud: null,
            x: 0,
            y: 0,
            scaleBegin: 1,
            scaleEnd: 1.08,
            scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00),
            slideX: 20,
            slideY: 0,
            slideDurMill: 3000,
            slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),
      ),
      const CloudWidget(
        cloudConfig: CloudConfig(
            size: 160,
            color: Color(0xa8fafafa),
            icon: IconData(63056, fontFamily: 'MaterialIcons'),
            widgetCloud: null,
            x: 140,
            y: 97,
            scaleBegin: 1,
            scaleEnd: 1.1,
            scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00),
            slideX: 20,
            slideY: 4,
            slideDurMill: 2000,
            slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),
      ),
      WeatherInfoBox(
        weatherInfo: weatherInfo,
      ),
    ],
  );
}

//阴天
WrapperScene overcastSky(WeatherInfo weatherInfo, BuildContext context) {
  return WrapperScene(
    sizeCanvas: Size(
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height,
    ),
    isLeftCornerGradient: true,
    colors: const [
      Color(0xff283593),
      Color(0xffff8a65),
    ],
    children: [
      const SunWidget(
        sunConfig: SunConfig(
            width: 262,
            blurSigma: 10,
            blurStyle: BlurStyle.solid,
            isLeftLocation: true,
            coreColor: Color(0xffffa726),
            midColor: Color(0xd6ffee58),
            outColor: Color(0xffff9800),
            animMidMill: 2000,
            animOutMill: 2000),
      ),
      const CloudWidget(
        cloudConfig: CloudConfig(
            size: 250,
            color: Color(0x65212121),
            icon: IconData(63056, fontFamily: 'MaterialIcons'),
            widgetCloud: null,
            x: 20,
            y: 35,
            scaleBegin: 1,
            scaleEnd: 1.08,
            scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00),
            slideX: 20,
            slideY: 0,
            slideDurMill: 3000,
            slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),
      ),
      const CloudWidget(
        cloudConfig: CloudConfig(
            size: 160,
            color: Color(0x77212121),
            icon: IconData(63056, fontFamily: 'MaterialIcons'),
            widgetCloud: null,
            x: 140,
            y: 130,
            scaleBegin: 1,
            scaleEnd: 1.1,
            scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00),
            slideX: 20,
            slideY: 4,
            slideDurMill: 2000,
            slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),
      ),
      WeatherInfoBox(
        weatherInfo: weatherInfo,
      ),
    ],
  );
}
