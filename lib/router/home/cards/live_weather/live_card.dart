import 'package:flutter/material.dart';
import 'package:weather_me/riverpod/weather_model.dart';
import 'package:weather_me/router/home/cards/live_weather/model/now.dart';
import 'package:weather_me/utils_box/utils_image.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/weather_convert.dart';

class LiveCard extends StatefulWidget {
  final WeatherModel model;

  const LiveCard({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  LiveCardState createState() => LiveCardState();
}

class LiveCardState extends State<LiveCard> {
  late final TextStyle _tempStyle = const TextStyle(fontSize: 26);
  late final TextStyle _textStyle = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    // 天气图标
    Now now = widget.model.now;
    Widget weather = _buildInfo(now);

    // 天气概览
    Widget summary = _buildSummary(widget.model);

    Column column = Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: padding36,
            bottom: padding12,
            left: padding36,
            right: padding36,
          ),
          child: weather,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: padding36, horizontal: 70.px),
          child: summary,
        ),
        SizedBox(height: padding12),
      ],
    );
    return column;
  }

  /// 构建天气概览
  Widget _buildSummary(WeatherModel model) {
    String summary = weatherDescription(context, model);
    return Text(
      summary,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        color: Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.7),
      ),
    );
  }

  /// 构建天气信息
  Widget _buildInfo(Now now) {
    Widget icon = svgFillAsset(
      name: now.icon,
      color: icon2IconColor(now.icon),
      size: 120.px,
    );
    // 温度
    Widget temp = Text("${now.temp}°", style: _tempStyle);
    // 天气文字
    Widget text = Text(now.text, style: _textStyle);
    Column column1 = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [temp, SizedBox(height: padding6), text],
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [icon, SizedBox(width: padding48), column1],
    );
  }
}
