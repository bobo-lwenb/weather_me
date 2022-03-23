import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/router/home/cards/daily/model/daily.dart';
import 'package:weather_me/router/home/cards/hourly/hourly_card.dart';
import 'package:weather_me/router/hourly/hourly_page.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_color.dart';
import 'package:weather_me/utils_box/utils_image.dart';
import 'package:weather_me/utils_box/utils_time.dart';
import 'package:weather_me/utils_box/utils_unit.dart';
import 'package:weather_me/utils_box/weather_convert.dart';

/// 列表页面
class DailySheetPage extends StatefulWidget {
  final List<Daily> list;

  const DailySheetPage({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  _DailySheetPageState createState() => _DailySheetPageState();
}

class _DailySheetPageState extends State<DailySheetPage> {
  late final MinAndMax _minMax = minAndMaxDaily(widget.list);

  @override
  Widget build(BuildContext context) {
    ListView listView = ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: widget.list.length,
      itemBuilder: (context, index) {
        Daily daily = widget.list[index];
        return SheetItem(
          daily: daily,
          isMax: double.parse(daily.tempMax) == _minMax.max,
          isMin: double.parse(daily.tempMin) == _minMax.min,
        );
      },
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding24),
      child: listView,
    );
  }
}

/// 获取最高最低温
MinAndMax minAndMaxDaily(List<Daily> list) {
  Daily daily = list.first;
  double maxTemp = double.parse(daily.tempMax);
  double minTemp = double.parse(daily.tempMin);
  for (var item in list) {
    double max = double.parse(item.tempMax);
    if (max > maxTemp) maxTemp = max;
    double min = double.parse(item.tempMin);
    if (min < minTemp) minTemp = min;
  }
  return MinAndMax(min: minTemp, max: maxTemp);
}

class SheetItem extends StatelessWidget {
  final Daily daily;
  final bool isMax;
  final bool isMin;

  SheetItem({
    Key? key,
    required this.daily,
    required this.isMax,
    required this.isMin,
  }) : super(key: key);

  /// 日期的文字样式
  late final TextStyle _dateStyle = TextStyle(fontSize: 36.px);

  /// 温度范围的文字样式
  late final TextStyle _tempStyle = TextStyle(fontSize: 48.px);

  /// 温度提示的文字样式
  late final TextStyle _tipsStyle = TextStyle(
    color: Colors.white,
    fontSize: 22.px,
  );

  @override
  Widget build(BuildContext context) {
    Column content = Column(
      children: [
        _buildtitleRow(context, daily),
        _buildBodyRow(context, daily),
      ],
    );
    Column column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: padding36, top: padding48, bottom: padding24),
          child: _buildDate(context, daily.fxDate),
        ),
        Container(
          padding: EdgeInsets.all(padding36),
          decoration: BoxDecoration(
              color: containerBackgroundColor(context),
              borderRadius: BorderRadius.all(
                Radius.circular(padding24),
              )),
          child: content,
        ),
      ],
    );
    return column;
  }

  Widget _buildDate(BuildContext context, String time) {
    String weekString = weekTime(context, time);
    String dateString = dateTime(context, time);
    Widget date = Text("$weekString $dateString", style: _dateStyle);
    return date;
  }

  Widget _buildtitleRow(BuildContext context, Daily daily) {
    Widget iconDay = svgFillAsset(
      name: daily.iconDay,
      color: icon2IconColor(daily.iconDay),
      size: 48.px,
    );
    Widget iconNight = svgFillAsset(
      name: daily.iconNight,
      color: icon2IconColor(daily.iconNight),
      size: 48.px,
    );
    Widget temp = Text("${daily.tempMax}° ~ ${daily.tempMin}°", style: _tempStyle);
    Widget tipMax = isMax ? _buildTip(l10n(context).tempHighest, Colors.orangeAccent) : const SizedBox();
    Widget tipMin = isMin ? _buildTip(l10n(context).tempLowest, Colors.blueAccent) : const SizedBox();
    Row row = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        iconDay,
        SizedBox(width: padding12),
        temp,
        SizedBox(width: padding12),
        iconNight,
        const Expanded(child: SizedBox()),
        tipMax,
        SizedBox(width: padding12),
        tipMin,
      ],
    );

    String describeText = dayDescription(context, daily);
    Widget describe = Text(
      describeText,
      style: Theme.of(context).textTheme.bodyText2,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        row,
        SizedBox(height: padding24),
        describe,
        SizedBox(height: padding24),
        const Divider(),
      ],
    );
  }

  /// 获取高低温提示组件
  Widget _buildTip(String text, Color color) {
    Container container = Container(
      padding: EdgeInsets.symmetric(vertical: padding6, horizontal: padding12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(padding18)),
      ),
      child: Text(text, style: _tipsStyle),
    );
    return container;
  }

  Widget _buildBodyRow(BuildContext context, Daily daily) {
    Widget precip = TextCube(title: "${daily.precip}mm", subTitle: l10n(context).precipitation);
    Widget humidity = TextCube(title: "${daily.humidity}%", subTitle: l10n(context).humidity);
    Widget vis = Consumer(builder: (context, ref, child) {
      String unit = distanceUnit(ref);
      return TextCube(title: "${daily.vis}$unit", subTitle: l10n(context).visibility);
    });
    Row one = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: Align(alignment: Alignment.centerLeft, child: precip)),
        Expanded(flex: 3, child: Align(alignment: Alignment.centerLeft, child: humidity)),
        Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: vis)),
      ],
    );

    Widget uvIndex = TextCube(title: uvIndex2Text(context, daily.uvIndex), subTitle: l10n(context).uv);
    Widget sunrise = TextCube(title: daily.sunrise, subTitle: l10n(context).sunRise);
    Widget sunset = TextCube(title: daily.sunset, subTitle: l10n(context).sunSet);
    Row two = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: Align(alignment: Alignment.centerLeft, child: uvIndex)),
        Expanded(flex: 3, child: Align(alignment: Alignment.centerLeft, child: sunrise)),
        Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: sunset)),
      ],
    );

    Widget moonPhase = TextCube(title: "${daily.moonPhaseIcon}%", subTitle: daily.moonPhase);
    Widget moonrise = TextCube(title: daily.moonrise, subTitle: l10n(context).moonRise);
    Widget moonset = TextCube(title: daily.moonset, subTitle: l10n(context).moonSet);
    Row three = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: Align(alignment: Alignment.centerLeft, child: moonPhase)),
        Expanded(flex: 3, child: Align(alignment: Alignment.centerLeft, child: moonrise)),
        Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: moonset)),
      ],
    );

    Widget cloud = TextCube(title: "${daily.cloud}%", subTitle: l10n(context).cloudiness);
    Widget pressure = TextCube(title: "${daily.pressure}hPa", subTitle: l10n(context).pressure);
    Row four = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: Align(alignment: Alignment.centerLeft, child: cloud)),
        Expanded(flex: 5, child: Align(alignment: Alignment.centerLeft, child: pressure)),
      ],
    );

    return Column(
      children: [
        SizedBox(height: padding24),
        one,
        SizedBox(height: padding36),
        two,
        SizedBox(height: padding36),
        three,
        SizedBox(height: padding36),
        four,
      ],
    );
  }
}
