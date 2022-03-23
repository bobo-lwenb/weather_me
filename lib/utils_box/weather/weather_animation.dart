import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/utils_box/utils_color.dart';
import 'package:weather_me/utils_box/weather/types/cloudy.dart';
import 'package:weather_me/utils_box/weather/types/foggy.dart';
import 'package:weather_me/utils_box/weather/types/lightning.dart';
import 'package:weather_me/utils_box/weather/types/rain.dart';
import 'package:weather_me/utils_box/weather/types/sand_storm.dart';
import 'package:weather_me/utils_box/weather/types/snow.dart';
import 'package:weather_me/utils_box/weather/types/starry_sky.dart';
import 'package:weather_me/utils_box/weather/types/sunny.dart';
import 'package:weather_me/utils_box/weather/weather_container.dart';
import 'package:weather_me/utils_box/weather/wind_mill.dart';

class WeatherAnimation extends ConsumerStatefulWidget {
  final String icon;

  const WeatherAnimation({
    Key? key,
    required this.icon,
  }) : super(key: key);

  @override
  ConsumerState<WeatherAnimation> createState() => _WeatherAnimationState();
}

class _WeatherAnimationState extends ConsumerState<WeatherAnimation> {
  @override
  Widget build(BuildContext context) {
    bool isDay = ref.read(sunActiveProvider.notifier).isDay();
    return _weather(widget.icon, isDay);
  }

  Widget _weather(String icon, bool isDay) {
    List<Color> colors = [Colors.blueGrey, Colors.blueGrey];
    Widget child = const SizedBox();
    switch (icon) {
      case '100': // 晴
      case '150':
        colors = isDay ? [Colors.blueAccent, Colors.blueAccent] : [Colors.black, Colors.black87];
        child = Stack(children: [
          Positioned(
            child: isDay ? const Sunny(isDay: true) : const StarrySky(isDay: false, type: StarrySkyType.clear),
          ),
          Positioned(child: WindMill(isRotate: true, isDay: isDay)),
        ]);
        break;
      case '103': // 晴间多云
      case '153':
        colors = isDay ? [Colors.blueAccent, Colors.blueAccent] : [black18, black28];
        child = Stack(children: [
          Positioned(
            child: isDay ? const Sunny(isDay: true) : const StarrySky(isDay: false, type: StarrySkyType.partlyCloudy),
          ),
          Positioned(child: Cloudy(isDay: isDay, type: CloudType.lessCloudy)),
          Positioned(child: WindMill(isRotate: true, isDay: isDay)),
        ]);
        break;
      case '101': // 多云
      case '151':
        colors = isDay ? [Colors.blueAccent, Colors.blueAccent] : [black18, black28];
        child = Stack(children: [
          Positioned(child: Cloudy(isDay: isDay, type: CloudType.partlyCloudy)),
          Positioned(child: WindMill(isRotate: true, isDay: isDay)),
        ]);
        break;
      case '102': // 少云
      case '152':
        colors = isDay ? [Colors.blueAccent, Colors.blueAccent] : [black18, black28];
        child = Stack(children: [
          Positioned(child: Cloudy(isDay: isDay, type: CloudType.lessCloudy)),
          Positioned(child: WindMill(isRotate: true, isDay: isDay)),
        ]);
        break;
      case '104': // 阴
      case '154':
        colors = isDay
            ? [
                Colors.blueGrey,
                Colors.blueGrey[200]!,
              ]
            : [
                Color(int.parse('1a2933', radix: 16)).withAlpha(255),
                Color(int.parse('5e7c85', radix: 16)).withAlpha(255),
              ];
        child = Stack(children: [
          Positioned(child: Cloudy(isDay: isDay, type: CloudType.lessCloudy)),
          Positioned(child: WindMill(isRotate: true, isDay: isDay)),
        ]);
        break;
      case '300': // 阵雨
      case '350':
      case '301': // 强阵雨
      case '351':
      case '406': // 阵雨夹雪
      case '456':
        colors = isDay
            ? [
                Colors.blueGrey,
                Colors.blueGrey[200]!,
              ]
            : [
                Color(int.parse('1a2933', radix: 16)).withAlpha(255),
                Color(int.parse('5e7c85', radix: 16)).withAlpha(255),
              ];
        child = Stack(children: [
          Positioned(child: Cloudy(isDay: isDay, type: CloudType.lessCloudy)),
          Positioned(child: WindMill(isRotate: true, isDay: isDay)),
          Positioned(child: Rain(isDay: isDay, type: RainType.showers)),
        ]);
        break;
      case '302': // 雷阵雨
      case '304': // 雷阵雨伴有冰雹
        colors = isDay
            ? [
                Colors.blueGrey,
                Colors.blueGrey[200]!,
              ]
            : [
                Color(int.parse('1a2933', radix: 16)).withAlpha(255),
                Color(int.parse('5e7c85', radix: 16)).withAlpha(255),
              ];
        child = Stack(children: [
          Positioned(child: Lightning(isDay: isDay, type: LightningType.thunder)),
          Positioned(child: Cloudy(isDay: isDay, type: CloudType.lessCloudy)),
          Positioned(child: WindMill(isRotate: false, isDay: isDay)),
          Positioned(child: Rain(isDay: isDay, type: RainType.showers)),
        ]);
        break;
      case '303': // 强雷阵雨
        colors = isDay
            ? [
                Colors.blueGrey,
                Colors.blueGrey[200]!,
              ]
            : [
                Color(int.parse('1a2933', radix: 16)).withAlpha(255),
                Color(int.parse('5e7c85', radix: 16)).withAlpha(255),
              ];
        child = Stack(children: [
          Positioned(child: Lightning(isDay: isDay, type: LightningType.strongThunder)),
          Positioned(child: Cloudy(isDay: isDay, type: CloudType.partlyCloudy)),
          Positioned(child: WindMill(isRotate: false, isDay: isDay)),
          Positioned(child: Rain(isDay: isDay, type: RainType.showers)),
        ]);
        break;
      case '309': // 毛毛雨/细雨
        colors = isDay
            ? [
                Colors.blueGrey,
                Colors.blueGrey[200]!,
              ]
            : [
                Color(int.parse('1a2933', radix: 16)).withAlpha(255),
                Color(int.parse('5e7c85', radix: 16)).withAlpha(255),
              ];
        child = Stack(children: [
          Positioned(child: WindMill(isRotate: true, isDay: isDay)),
          Positioned(child: Rain(isDay: isDay, type: RainType.drizzle)),
        ]);
        break;
      case '305': // 小雨
      case '314': // 小到中雨
      case '399': // 雨
      case '404': // 雨夹雪
        colors = isDay
            ? [
                Colors.blueGrey,
                Colors.blueGrey[200]!,
              ]
            : [
                Color(int.parse('1a2933', radix: 16)).withAlpha(255),
                Color(int.parse('5e7c85', radix: 16)).withAlpha(255),
              ];
        child = Stack(children: [
          Positioned(child: Cloudy(isDay: isDay, type: CloudType.lessCloudy)),
          Positioned(child: WindMill(isRotate: true, isDay: isDay)),
          Positioned(child: Rain(isDay: isDay, type: RainType.lightRain)),
        ]);
        break;
      case '306': // 中雨
      case '313': // 冻雨
      case '315': // 中到大雨
      case '405': // 雨雪天气
        colors = isDay
            ? [
                Colors.blueGrey,
                Colors.blueGrey[200]!,
              ]
            : [
                Color(int.parse('1a2933', radix: 16)).withAlpha(255),
                Color(int.parse('5e7c85', radix: 16)).withAlpha(255),
              ];
        child = Stack(children: [
          Positioned(child: Cloudy(isDay: isDay, type: CloudType.partlyCloudy)),
          Positioned(child: WindMill(isRotate: true, isDay: isDay)),
          Positioned(child: Rain(isDay: isDay, type: RainType.mediumRain)),
        ]);
        break;
      case '307': // 大雨
      case '316': // 大到暴雨
        colors = isDay
            ? [
                Colors.blueGrey,
                Colors.black45,
              ]
            : [
                Color(int.parse('1a2933', radix: 16)).withAlpha(255),
                Color(int.parse('5e7c85', radix: 16)).withAlpha(255),
              ];
        child = Stack(children: [
          Positioned(child: Cloudy(isDay: isDay, type: CloudType.partlyCloudy)),
          Positioned(child: WindMill(isRotate: false, isDay: isDay)),
          Positioned(child: Rain(isDay: isDay, type: RainType.heavyRain)),
        ]);
        break;
      case '310': // 暴雨
      case '317': // 暴雨到大暴雨
        colors = isDay
            ? [
                Colors.blueGrey,
                Colors.black45,
              ]
            : [
                Color(int.parse('1a2933', radix: 16)).withAlpha(255),
                Color(int.parse('5e7c85', radix: 16)).withAlpha(255),
              ];
        child = Stack(children: [
          Positioned(child: Cloudy(isDay: isDay, type: CloudType.partlyCloudy)),
          Positioned(child: WindMill(isRotate: false, isDay: isDay)),
          Positioned(child: Rain(isDay: isDay, type: RainType.rainstorm)),
        ]);
        break;
      case '311': // 大暴雨
      case '318': // 大暴雨到特大暴雨
        colors = isDay
            ? [
                Colors.blueGrey,
                Colors.black45,
              ]
            : [
                Color(int.parse('1a2933', radix: 16)).withAlpha(255),
                Color(int.parse('5e7c85', radix: 16)).withAlpha(255),
              ];
        child = Stack(children: [
          Positioned(child: Cloudy(isDay: isDay, type: CloudType.partlyCloudy)),
          Positioned(child: WindMill(isRotate: false, isDay: isDay)),
          Positioned(child: Rain(isDay: isDay, type: RainType.torrentialRain)),
        ]);
        break;
      case '312': // 特大暴雨
        colors = isDay
            ? [
                Colors.blueGrey,
                Colors.black45,
              ]
            : [
                Color(int.parse('1a2933', radix: 16)).withAlpha(255),
                Color(int.parse('5e7c85', radix: 16)).withAlpha(255),
              ];
        child = Stack(children: [
          Positioned(child: Cloudy(isDay: isDay, type: CloudType.partlyCloudy)),
          Positioned(child: WindMill(isRotate: false, isDay: isDay)),
          Positioned(child: Rain(isDay: isDay, type: RainType.superTorrentialRain)),
        ]);
        break;
      case '308': // 极端降雨
        colors = isDay
            ? [
                Colors.blueGrey,
                Colors.black45,
              ]
            : [
                Color(int.parse('1a2933', radix: 16)).withAlpha(255),
                Color(int.parse('5e7c85', radix: 16)).withAlpha(255),
              ];
        child = Stack(children: [
          Positioned(child: Cloudy(isDay: isDay, type: CloudType.partlyCloudy)),
          Positioned(child: WindMill(isRotate: false, isDay: isDay)),
          Positioned(child: Rain(isDay: isDay, type: RainType.extremeRainfall)),
        ]);
        break;
      case '407': // 阵雪
      case '457':
        colors = isDay
            ? [
                Colors.blueGrey,
                Colors.blueGrey[200]!,
              ]
            : [
                Color(int.parse('1a2933', radix: 16)).withAlpha(255),
                Color(int.parse('5e7c85', radix: 16)).withAlpha(255),
              ];
        child = Snow(isDay: isDay, type: SnowType.snowShowers);
        break;
      case '400': // 小雪
      case '408': // 小到中雪
      case '499': // 雪
        colors = isDay
            ? [
                Colors.blueGrey,
                Colors.blueGrey[200]!,
              ]
            : [
                Color(int.parse('1a2933', radix: 16)).withAlpha(255),
                Color(int.parse('5e7c85', radix: 16)).withAlpha(255),
              ];
        child = Snow(isDay: isDay, type: SnowType.lightSnow);
        break;
      case '401': // 中雪
      case '409': // 中到大雪
        colors = isDay
            ? [
                Colors.blueGrey,
                Colors.blueGrey[200]!,
              ]
            : [
                Color(int.parse('1a2933', radix: 16)).withAlpha(255),
                Color(int.parse('5e7c85', radix: 16)).withAlpha(255),
              ];
        child = Snow(isDay: isDay, type: SnowType.mediumSnow);
        break;
      case '402': // 大雪
      case '410': // 大到暴雪
        colors = isDay
            ? [
                Colors.blueGrey,
                Colors.blueGrey[200]!,
              ]
            : [
                Color(int.parse('1a2933', radix: 16)).withAlpha(255),
                Color(int.parse('5e7c85', radix: 16)).withAlpha(255),
              ];
        child = Snow(isDay: isDay, type: SnowType.heavySnow);
        break;
      case '403': // 暴雪
        colors = isDay
            ? [
                Colors.blueGrey,
                Colors.blueGrey[200]!,
              ]
            : [
                Color(int.parse('1a2933', radix: 16)).withAlpha(255),
                Color(int.parse('5e7c85', radix: 16)).withAlpha(255),
              ];
        child = Snow(isDay: isDay, type: SnowType.snowStorm);
        break;
      case '500': // 薄雾
        colors = isDay
            ? [
                Color(int.parse('bebebe', radix: 16)).withAlpha(255),
                Color(int.parse('bebebe', radix: 16)).withAlpha(255),
              ]
            : [
                Colors.black45,
                Colors.black54,
              ];
        child = Foggy(isDay: isDay, type: FoggyType.mist);
        break;
      case '501': // 雾
        colors = isDay
            ? [
                Color(int.parse('bebebe', radix: 16)).withAlpha(255),
                Color(int.parse('bebebe', radix: 16)).withAlpha(255),
              ]
            : [
                Colors.black45,
                Colors.black54,
              ];
        child = Foggy(isDay: isDay, type: FoggyType.fog);
        break;
      case '514': // 大雾
      case '509': // 浓雾
        colors = isDay
            ? [
                Color(int.parse('bebebe', radix: 16)).withAlpha(255),
                Color(int.parse('bebebe', radix: 16)).withAlpha(255),
              ]
            : [
                Colors.black45,
                Colors.black54,
              ];
        child = Foggy(isDay: isDay, type: FoggyType.heavyFog);
        break;
      case '510': // 强浓雾
      case '515': // 特强浓雾
        colors = isDay
            ? [
                Color(int.parse('bebebe', radix: 16)).withAlpha(255),
                Color(int.parse('bebebe', radix: 16)).withAlpha(255),
              ]
            : [
                Colors.black45,
                Colors.black54,
              ];
        child = Foggy(isDay: isDay, type: FoggyType.strongFog);
        break;
      case '502': // 霾
        colors = isDay
            ? [
                Color(int.parse('DEDEBE', radix: 16)).withAlpha(255),
                Color(int.parse('DEDEBE', radix: 16)).withAlpha(255),
              ]
            : [
                Color(int.parse('2F4F4F', radix: 16)).withAlpha(255),
                Color(int.parse('2F4F4F', radix: 16)).withAlpha(255),
              ];
        child = Foggy(isDay: isDay, type: FoggyType.mist);
        break;
      case '511': // 中度霾
        colors = isDay
            ? [
                Color(int.parse('DEDEBE', radix: 16)).withAlpha(255),
                Color(int.parse('DEDEBE', radix: 16)).withAlpha(255),
              ]
            : [
                Color(int.parse('2F4F4F', radix: 16)).withAlpha(255),
                Color(int.parse('2F4F4F', radix: 16)).withAlpha(255),
              ];
        child = Foggy(isDay: isDay, type: FoggyType.fog);
        break;
      case '512': // 重度霾
        colors = isDay
            ? [
                Color(int.parse('DEDEBE', radix: 16)).withAlpha(255),
                Color(int.parse('DEDEBE', radix: 16)).withAlpha(255),
              ]
            : [
                Color(int.parse('2F4F4F', radix: 16)).withAlpha(255),
                Color(int.parse('2F4F4F', radix: 16)).withAlpha(255),
              ];
        child = Foggy(isDay: isDay, type: FoggyType.heavyFog);
        break;
      case '513': // 严重霾
        colors = isDay
            ? [
                Color(int.parse('DEDEBE', radix: 16)).withAlpha(255),
                Color(int.parse('DEDEBE', radix: 16)).withAlpha(255),
              ]
            : [
                Color(int.parse('2F4F4F', radix: 16)).withAlpha(255),
                Color(int.parse('2F4F4F', radix: 16)).withAlpha(255),
              ];
        child = Foggy(isDay: isDay, type: FoggyType.strongFog);
        break;
      case '503': // 扬沙
      case '504': // 浮尘
        colors = isDay
            ? [
                Color(int.parse('c7a252', radix: 16)).withAlpha(255),
                Color(int.parse('dec674', radix: 16)).withAlpha(255),
              ]
            : [
                Color(int.parse('64492b', radix: 16)).withAlpha(255),
                Color(int.parse('64492b', radix: 16)).withAlpha(255),
              ];
        child = SandStorm(isDay: isDay, type: SandStormType.dust);
        break;
      case '507': // 沙尘暴
        colors = isDay
            ? [
                Color(int.parse('c7a252', radix: 16)).withAlpha(255),
                Color(int.parse('dec674', radix: 16)).withAlpha(255),
              ]
            : [
                Color(int.parse('64492b', radix: 16)).withAlpha(255),
                Color(int.parse('64492b', radix: 16)).withAlpha(255),
              ];
        child = SandStorm(isDay: isDay, type: SandStormType.sandstorm);
        break;
      case '508': // 强沙尘暴
        colors = isDay
            ? [
                Color(int.parse('c7a252', radix: 16)).withAlpha(255),
                Color(int.parse('dec674', radix: 16)).withAlpha(255),
              ]
            : [
                Color(int.parse('64492b', radix: 16)).withAlpha(255),
                Color(int.parse('64492b', radix: 16)).withAlpha(255),
              ];
        child = SandStorm(isDay: isDay, type: SandStormType.strongSandstorm);
        break;
      default:
        child = WindMill(isRotate: true, isDay: isDay);
        break;
    }
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
          stops: const [0.0, 1.0],
        ),
      ),
      child: child,
    );
  }
}
