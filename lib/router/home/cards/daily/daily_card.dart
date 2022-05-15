import 'package:flutter/material.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/router/daily/sheet/daily_sheet_page.dart';
import 'package:weather_me/router/home/cards/daily/expand_container.dart';
import 'package:weather_me/router/home/cards/daily/model/daily.dart';
import 'package:weather_me/router/home/cards/hourly/hourly_card.dart';
import 'package:weather_me/utils_box/navigator_manager.dart';
import 'package:weather_me/utils_box/utils_color.dart';
import 'package:weather_me/utils_box/utils_image.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_time.dart';
import 'package:weather_me/utils_box/weather_convert.dart';

/// 首页7日天气预报的卡片
class DailyCard extends StatefulWidget {
  final List<Daily> dailys;

  const DailyCard({
    Key? key,
    required this.dailys,
  }) : super(key: key);

  @override
  DailyCardState createState() => DailyCardState();
}

class DailyCardState extends State<DailyCard> with SingleTickerProviderStateMixin {
  final double _shrinkHeight = (padding6 + 134.px) * 3 + padding6 * 3;
  final double _expandHeight = (padding6 + 134.px) * 7 + padding6 * 7;

  /// 显示更多文字样式
  final TextStyle _day30Style = const TextStyle(color: Colors.blueAccent);

  @override
  Widget build(BuildContext context) {
    if (widget.dailys.isEmpty) return Container(color: containerBackgroundColor(context));

    MinAndMax minMax = minAndMaxDaily(widget.dailys);
    ListView listView = ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.dailys.length,
      itemBuilder: (context, index) {
        Daily daily = widget.dailys[index];
        return DailyItem(
          daily: daily,
          minMax: minMax,
        );
      },
    );
    Widget expande = ExpandContainer(
      shrinkHeight: _shrinkHeight,
      expandHeight: _expandHeight,
      title: _buildTitle(),
      content: listView,
    );
    return expande;
  }

  Widget _buildTitle() {
    Widget title = Text(
      l10n(context).forecast7,
      style: Theme.of(context).textTheme.headline6,
    );
    Widget more = GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.fromLTRB(padding18, padding18, 0, padding18),
        child: Text(l10n(context).forecast30, style: _day30Style),
      ),
      onTap: () => AppRouterDelegate.of(context).push('daily'),
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
}

/// item的高度
final double itemHeight = 134.px;

class DailyItem extends StatelessWidget {
  final MinAndMax minMax;
  final Daily daily;

  DailyItem({
    Key? key,
    required this.minMax,
    required this.daily,
  }) : super(key: key);

  final double _tempBarWidth = 72.px;
  final GlobalKey _globalKey = GlobalKey();

  late final double _maxTemp = minMax.max;
  late final double _minTemp = minMax.min;
  late final double _range = _maxTemp - _minTemp;

  @override
  Widget build(BuildContext context) {
    Widget date = _buildDate(context, daily);
    Widget temp = _buildTemp(daily);
    Row row = Row(children: [
      Expanded(flex: 2, child: date),
      Expanded(flex: 5, child: temp),
    ]);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding6),
      child: Container(
        padding: EdgeInsets.all(padding24),
        height: itemHeight,
        decoration: BoxDecoration(
          color: contentBackgroundColor(context),
          borderRadius: BorderRadius.circular(30.px),
        ),
        child: row,
      ),
    );
  }

  Widget _buildTemp(Daily daily) {
    Widget dayIcon = svgFillAsset(
      name: daily.iconDay,
      color: icon2IconColor(daily.iconDay),
      size: 40.px,
    );
    Widget maxTemp = Text("${daily.tempMax}°", textAlign: TextAlign.center);
    Widget tempBar = _buildTempBar();
    Widget minTemp = Text("${daily.tempMin}°", textAlign: TextAlign.center);
    Widget nightIcon = svgFillAsset(
      name: daily.iconNight,
      color: icon2IconColor(daily.iconNight),
      size: 40.px,
    );
    Row row = Row(children: [
      Expanded(flex: 1, child: dayIcon),
      Expanded(flex: 2, child: maxTemp),
      Expanded(flex: 3, child: tempBar),
      Expanded(flex: 2, child: minTemp),
      Expanded(flex: 1, child: nightIcon),
    ]);
    return row;
  }

  Widget _buildDate(BuildContext context, Daily daily) {
    Column column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(weekTime(context, daily.fxDate)),
        Text(dateTime(context, daily.fxDate),
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.5),
                  fontSize: 26.px,
                )),
      ],
    );
    return column;
  }

  Widget _buildTempBar() {
    Widget barContainer = _buildBar(daily, _tempBarWidth);
    Container tempBar = Container(
      key: _globalKey,
      // width: width,
      height: 10.px,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(5.px),
      ),
      child: barContainer,
    );
    return SizedBox(
      key: key,
      width: _tempBarWidth,
      child: tempBar,
    );
  }

  Widget _buildBar(Daily daily, double width) {
    // 计算距离最高温的宽度
    double maxPercent = (_maxTemp - double.parse(daily.tempMax)) / _range;
    double maxPercentWidth = maxPercent.abs() * width;
    // 计算距离最低温的宽度
    double minPercent = (double.parse(daily.tempMin) - _minTemp) / _range;
    double minPercentWidth = minPercent.abs() * width;

    Row row = Row(
      children: [
        Container(width: maxPercentWidth),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.deepOrange, Colors.blueAccent],
                stops: [0.0, 1.0],
              ),
              borderRadius: BorderRadius.circular(5.px),
            ),
          ),
        ),
        Container(width: minPercentWidth),
      ],
    );
    return row;
  }
}
