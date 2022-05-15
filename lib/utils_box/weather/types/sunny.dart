import 'package:flutter/material.dart';
import 'package:weather_me/utils_box/weather/weather_container.dart';
import 'package:weather_me/utils_box/utils_image.dart';
import 'package:weather_me/utils_box/size_fit.dart';

/// 晴天
class Sunny extends StatefulWidget {
  final bool isDay;

  const Sunny({
    Key? key,
    required this.isDay,
  }) : super(key: key);

  @override
  SunnyState createState() => SunnyState();
}

class SunnyState extends State<Sunny> with SingleTickerProviderStateMixin, WeatherController {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      width: logicWidth,
      height: logicHeight,
      child: sunny_clear_1,
    );
  }
}
