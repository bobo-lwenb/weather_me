import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/riverpod/weather_model.dart';
import 'package:weather_me/router/home/cards/live_weather/model/now.dart';
import 'package:weather_me/router/home/cards/live_weather/wind_direction.dart';
import 'package:weather_me/router/home/cards/minutely/minutely_card.dart';
import 'package:weather_me/router/home/cards/minutely/model/minutes.dart';
import 'package:weather_me/router/hourly/hourly_page.dart';
import 'package:weather_me/router/warning/model/warning.dart';
import 'package:weather_me/utils_box/navigator_manager.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_color.dart';
import 'package:weather_me/utils_box/utils_unit.dart';

class LiveExpandedCard extends StatefulWidget {
  final WeatherModel model;

  const LiveExpandedCard({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  _LiveExpandCaedState createState() => _LiveExpandCaedState();
}

class _LiveExpandCaedState extends State<LiveExpandedCard> {
  @override
  Widget build(BuildContext context) {
    // 灾害预警
    List<Warning> warnings = widget.model.warning;
    Widget warning = _buildWarning(warnings);

    // 分钟降水/雪信息
    Widget minutely = _buildMinutely(widget.model.minutes);

    // 天气信息
    Now now = widget.model.now;
    Widget weatherInfo = _buildWeatherInfo(now);

    return Padding(
      padding: EdgeInsets.only(left: padding36, right: padding36, bottom: padding36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          warning,
          SizedBox(height: padding24),
          minutely,
          SizedBox(height: padding24),
          weatherInfo,
        ],
      ),
    );
  }

  /// 构建天气灾害预警
  Widget _buildWarning(List<Warning> list) {
    String warningText;
    if (list.isEmpty) {
      warningText = l10n(context).noDisaster;
    } else {
      warningText = list.length > 1
          ? l10n(context).variousDisaster
          : "${list.first.typeName}${list.first.level} ${l10n(context).warning}";
    }
    Widget warning = Text(warningText);
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(padding36),
        decoration: BoxDecoration(
          color: contentBackgroundColor(context),
          borderRadius: BorderRadius.all(Radius.circular(padding24)),
        ),
        child: Row(children: [
          warning,
          const Expanded(child: SizedBox()),
          const Icon(Icons.play_arrow_rounded),
        ]),
      ),
      onTap: () => AppRouterDelegate.of(context).push('warning'),
    );
  }

  /// 构建降水信息
  Widget _buildMinutely(Minutes minutes) {
    return Container(
      padding: EdgeInsets.all(padding36),
      decoration: BoxDecoration(
        color: contentBackgroundColor(context),
        borderRadius: BorderRadius.all(Radius.circular(padding24)),
      ),
      child: SizedBox(
        height: 250.px,
        child: MinutelyCard(minutes: minutes),
      ),
    );
  }

  /// 构建实时天气信息项目
  Widget _buildWeatherInfo(Now now) {
    // 天气信息项目
    Widget feelsLike = TextCube(title: "${now.feelsLike}°", subTitle: l10n(context).sensation);
    Widget precip = TextCube(title: "${now.precip}mm", subTitle: l10n(context).precipitation);
    Widget vis = Consumer(builder: (context, ref, child) {
      String unit = distanceUnit(ref);
      return TextCube(title: "${now.vis}$unit", subTitle: l10n(context).visibility);
    });
    Widget cloud = TextCube(title: "${now.cloud}%", subTitle: l10n(context).cloudiness);
    Widget humidity = TextCube(title: "${now.humidity}%", subTitle: l10n(context).humidity);
    Widget dew = TextCube(title: "${now.dew}°", subTitle: l10n(context).dewPoint);
    GridView gridView = GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.3,
        mainAxisSpacing: padding12,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [feelsLike, precip, vis, cloud, humidity, dew],
    );

    // 风向
    Widget direction = WindDirection(angle: now.wind360);
    // 风力等级
    Locale locale = Localizations.localeOf(context);
    Widget level = locale.languageCode == 'en'
        ? Text("${now.windDir} ${l10n(context).level} ${now.windScale}")
        : Text("${now.windDir} ${now.windScale}${l10n(context).level}");
    // 风速
    Widget speed = Consumer(builder: (context, ref, child) {
      String unit = speedUnit(ref);
      return Text("${now.windSpeed} $unit");
    });
    Column wind = Column(
      children: [
        SizedBox(
          width: 200.px,
          height: 200.px,
          child: direction,
        ),
        SizedBox(height: padding36),
        level,
        SizedBox(height: padding12),
        speed,
      ],
    );

    return Container(
      decoration: BoxDecoration(
        color: contentBackgroundColor(context),
        borderRadius: BorderRadius.all(Radius.circular(padding24)),
      ),
      padding: EdgeInsets.symmetric(vertical: padding36),
      child: Row(
        children: [
          Expanded(child: wind),
          Expanded(child: gridView),
        ],
      ),
    );
  }
}
