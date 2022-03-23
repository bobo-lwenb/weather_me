import 'package:flutter/material.dart';
import 'package:weather_me/router/area_list/model/all_area.dart';
import 'package:weather_me/router/area_list/model/lookup_area.dart';
import 'package:weather_me/router/home/cards/live_weather/model/now.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_image.dart';
import 'package:weather_me/utils_box/weather_convert.dart';

/// 可滑动item的内容组件
class AreaContent extends StatelessWidget {
  final AreaLiveWeather info;

  const AreaContent({
    Key? key,
    required this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Now now = info.now;
    LookupArea city = info.city;

    Column weather = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        svgFillAsset(name: now.icon, color: icon2IconColor(now.icon)),
        SizedBox(height: padding6),
        Text("${now.temp}°"),
      ],
    );
    Column location = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(city.name, style: const TextStyle(fontSize: 20)),
        Text("${city.adm1}，${city.country}", maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
    Widget fore = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(padding24)),
      ),
      child: Row(
        children: [
          weather,
          SizedBox(width: padding24),
          Expanded(child: location),
        ],
      ),
    );
    return fore;
  }
}
