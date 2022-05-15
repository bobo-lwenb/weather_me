import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/router/home/cards/hourly/model/hourly.dart';
import 'package:weather_me/utils_box/utils_color.dart';
import 'package:weather_me/utils_box/utils_image.dart';
import 'package:weather_me/utils_box/navigator_manager.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_time.dart';
import 'package:weather_me/utils_box/utils_unit.dart';
import 'package:weather_me/utils_box/weather_convert.dart';

/// 首页小时天气预报
class HourlyCard extends StatefulWidget {
  final List<Hourly> hourlys;
  const HourlyCard({Key? key, required this.hourlys}) : super(key: key);

  @override
  HourlyCardState createState() => HourlyCardState();
}

class HourlyCardState extends State<HourlyCard> {
  /// 详细的文字样式
  late final TextStyle _detailsStyle = const TextStyle(color: Colors.blueAccent);

  @override
  Widget build(BuildContext context) {
    MinAndMax model = minAndMaxHourly(widget.hourlys);
    ListView listView = ListView.builder(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        Hourly hourly = widget.hourlys[index];
        double height = double.parse(hourly.temp) - model.min;
        double percent = 1 - height / (model.max - model.min);
        return HourlyCardItem(hourly: hourly, emptyPercent: percent);
      },
      itemCount: widget.hourlys.length,
    );
    Container container = Container(
      padding: EdgeInsets.only(left: 16.px, top: 16.px, right: 16.px, bottom: 32.px), // listview外侧的padding
      height: 500.px,
      child: listView,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [_buildTitle(), container],
    );
  }

  Widget _buildTitle() {
    Widget title = Text(
      l10n(context).forecast24,
      style: Theme.of(context).textTheme.headline6,
    );
    Widget more = GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.fromLTRB(padding18, padding18, 0, padding18),
        child: Text(l10n(context).forecast72, style: _detailsStyle),
      ),
      onTap: () => AppRouterDelegate.of(context).push('hourly'),
    );
    Row row = Row(
      children: [
        title,
        const Expanded(flex: 1, child: SizedBox()),
        more,
      ],
    );
    return SizedBox(
      height: 100.px,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding36),
        child: row,
      ),
    );
  }
}

MinAndMax minAndMaxHourly(List<Hourly> list) {
  if (list.isEmpty) return MinAndMax.empty();
  double min = double.parse(list.first.temp);
  double max = double.parse(list.first.temp);
  for (var hourly in list) {
    double temp = double.parse(hourly.temp);
    if (temp < min) {
      min = temp;
      continue;
    }
    if (temp > max) max = temp;
  }
  return MinAndMax(min: min, max: max);
}

class MinAndMax {
  final double min;
  final double max;

  MinAndMax({
    required this.min,
    required this.max,
  });

  factory MinAndMax.empty() => MinAndMax(min: 0, max: 0);
}

class HourlyCardItem extends StatelessWidget {
  final Hourly hourly;
  final double emptyPercent;

  const HourlyCardItem({
    Key? key,
    required this.hourly,
    required this.emptyPercent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Column innerColumn = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("${hourly.temp}°"),
        const Expanded(child: SizedBox()),
        svgFillAsset(
          name: hourly.icon,
          color: icon2IconColor(hourly.icon),
          size: 46.px,
        ),
        SizedBox(height: padding18),
        _rotateIcon(hourly.wind360),
        SizedBox(height: padding18),
        Consumer(builder: (context, ref, child) {
          String unit = speedUnit(ref);
          return Text(
            "${hourly.windSpeed}\n$unit",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.px),
          );
        }),
        SizedBox(height: padding18),
        Text("${hourTime(context, hourly.fxTime)}${l10n(context).hour}"),
      ],
    );
    Widget item = Padding(
      padding: EdgeInsets.symmetric(horizontal: padding12), // item外侧的水平padding
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: padding36, vertical: padding24), // item内侧的padding
        decoration: BoxDecoration(
          color: contentBackgroundColor(context),
          borderRadius: BorderRadius.all(Radius.circular(padding24)),
        ),
        child: innerColumn,
      ),
    );
    Column outterColumn = Column(
      children: [
        Container(height: emptyPercent * 50.px),
        Expanded(child: item),
      ],
    );
    return outterColumn;
  }

  Widget _rotateIcon(String windAngle) {
    Icon icon = Icon(
      Icons.navigation_rounded,
      color: Colors.blueGrey[800],
    );
    double angle = pi / 180 * int.parse(windAngle);
    return Transform.rotate(
      angle: angle,
      child: icon,
    );
  }
}
