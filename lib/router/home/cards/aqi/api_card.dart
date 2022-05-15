import 'package:flutter/material.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/router/home/cards/aqi/api_widgets.dart';
import 'package:weather_me/router/home/cards/aqi/model/aqi_now.dart';
import 'package:weather_me/utils_box/navigator_manager.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_color.dart';
import 'package:weather_me/utils_box/utils_time.dart';

class AqiCard extends StatefulWidget {
  final AqiNow aqiNow;

  const AqiCard({
    Key? key,
    required this.aqiNow,
  }) : super(key: key);

  @override
  ApiCardState createState() => ApiCardState();
}

class ApiCardState extends State<AqiCard> {
  /// 显示更多文字样式
  late final TextStyle _moreStyle = const TextStyle(color: Colors.blueAccent);

  @override
  Widget build(BuildContext context) {
    if ('--' == widget.aqiNow.aqi) return Container(color: containerBackgroundColor(context));

    Locale locale = Localizations.localeOf(context);

    Widget title = _buildTitle();
    String timeText = locale.languageCode == 'zh'
        ? "${dateTime(context, widget.aqiNow.pubTime)} ${hourMinuteTime(widget.aqiNow.pubTime)}${l10n(context).postedon}"
        : "${l10n(context).postedon} ${dateTime(context, widget.aqiNow.pubTime)} ${hourMinuteTime(widget.aqiNow.pubTime)}";
    Widget time = Text(
      timeText,
      style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 24.px),
    );
    Widget aqiItem = _buildAqiRow(widget.aqiNow);

    Column column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        Padding(
          padding: EdgeInsets.only(right: padding36, bottom: padding24),
          child: Align(alignment: Alignment.centerRight, child: time),
        ),
        aqiItem,
      ],
    );
    return column;
  }

  Widget _buildTitle() {
    Widget title = Text(
      l10n(context).airQuality,
      style: Theme.of(context).textTheme.headline6,
    );
    Widget more = GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.fromLTRB(padding18, padding18, 0, padding18),
        child: Text(l10n(context).more, style: _moreStyle),
      ),
      onTap: () => AppRouterDelegate.of(context).push('aqi_forecast'),
    );
    Row row = Row(children: [
      title,
      const Expanded(flex: 1, child: SizedBox()),
      more,
    ]);
    return SizedBox(
      height: 100.px,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding36),
        child: row,
      ),
    );
  }

  Widget _buildAqiRow(AqiNow now) {
    // 空气质量指数的圆圈
    Widget circle = SizedBox(
      height: 200.px,
      width: 200.px,
      child: CustomPaint(
        painter: AqiCircle(context: context, aqi: now.aqi),
      ),
    );
    // 污染物项目第一行
    Widget pm2_5 = Pollutant(
      index: now.pm2p5,
      percent: double.parse(now.pm2p5) / 500,
      text: 'pm2.5',
    );
    Widget pm10 = Pollutant(
      index: now.pm10,
      percent: double.parse(now.pm10) / 600,
      text: 'pm10',
    );
    Widget o3 = Pollutant(
      index: now.o3,
      percent: double.parse(now.o3) / 1200,
      text: 'O₃',
    );
    Row row1 = Row(children: [
      Expanded(child: pm2_5),
      Expanded(child: pm10),
      Expanded(child: o3),
    ]);
    // 污染物项目第二行
    Widget co = Pollutant(
      index: now.co,
      percent: double.parse(now.co) / 150,
      text: 'CO',
    );
    Widget so2 = Pollutant(
      index: now.so2,
      percent: double.parse(now.so2) / 800,
      text: 'SO₂',
    );
    Widget no2 = Pollutant(
      index: now.no2,
      percent: double.parse(now.no2) / 3840,
      text: 'NO₂',
    );
    Row row2 = Row(children: [
      Expanded(child: co),
      Expanded(child: so2),
      Expanded(child: no2),
    ]);
    // 组合两行污染物
    Column column = Column(children: [row1, row2]);
    // 圆圈和污染物再组合
    Row row3 = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        circle,
        SizedBox(width: padding36),
        Expanded(child: column),
      ],
    );
    return Padding(
      padding: EdgeInsets.only(
        left: padding36,
        right: padding36,
        top: padding12,
        bottom: 60.px,
      ),
      child: row3,
    );
  }
}
