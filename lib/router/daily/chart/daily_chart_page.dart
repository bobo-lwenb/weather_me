import 'package:flutter/material.dart';
import 'package:weather_me/router/daily/chart/daily_drawing.dart';
import 'package:weather_me/router/daily/sheet/daily_sheet_page.dart';
import 'package:weather_me/router/home/cards/daily/model/daily.dart';
import 'package:weather_me/router/home/cards/hourly/hourly_card.dart';
import 'package:weather_me/utils_box/size_fit.dart';

class DailyChartPage extends StatefulWidget {
  final List<Daily> list;

  const DailyChartPage({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  _DailyChartPageState createState() => _DailyChartPageState();
}

class _DailyChartPageState extends State<DailyChartPage> {
  late final ValueNotifier<int> _notifier = ValueNotifier(0);
  late final MinAndMax _minMax = minAndMaxDaily(widget.list);

  @override
  Widget build(BuildContext context) {
    ValueListenableBuilder builder = ValueListenableBuilder<int>(
      valueListenable: _notifier,
      builder: (context, index, child) {
        Daily daily = widget.list[index];
        return SheetItem(
          daily: daily,
          isMax: double.parse(daily.tempMax) == _minMax.max,
          isMin: double.parse(daily.tempMin) == _minMax.min,
        );
      },
    );
    ListView listView = ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        DailyDrawingWrapper(
          list: widget.list,
          callback: (index) {
            _notifier.value = index;
          },
        ),
        builder,
      ],
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding24),
      child: listView,
    );
  }
}
