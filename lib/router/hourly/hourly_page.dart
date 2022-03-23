import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/riverpod/provider_location.dart';
import 'package:weather_me/riverpod/provider_weather.dart';
import 'package:weather_me/router/area_list/model/lookup_area.dart';
import 'package:weather_me/router/home/cards/hourly/model/hourly.dart';
import 'package:weather_me/router/hourly/hourly_chart.dart';
import 'package:weather_me/utils_box/utils_color.dart';
import 'package:weather_me/utils_box/utils_image.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_page/loading_page.dart';
import 'package:weather_me/utils_box/utils_time.dart';
import 'package:weather_me/utils_box/utils_unit.dart';
import 'package:weather_me/utils_box/weather_convert.dart';

class HourlyPage extends ConsumerStatefulWidget {
  const HourlyPage({Key? key}) : super(key: key);

  @override
  _HourlyPageState createState() => _HourlyPageState();
}

class _HourlyPageState extends ConsumerState<HourlyPage> {
  late final ValueNotifier<int> _notifier = ValueNotifier(0);

  /// 标题栏文字样式
  final TextStyle _headingStyle = TextStyle(
    fontSize: 42.px,
  );

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<Hourly>> asyncValue = ref.watch(hourly72Provider);
    List<Hourly> list = asyncValue.when(
      data: (list) => list,
      error: (err, stack) => [],
      loading: () => [],
    );
    if (list.isEmpty) return const LoadingPage();
    Widget builder = ValueListenableBuilder<int>(
      valueListenable: _notifier,
      builder: (context, int index, child) {
        Hourly hourly = list[index];
        return _buildRow(hourly);
      },
    );
    ListView listView = ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        HourlyChart(list: list, result: (index) => _update(index)),
        SizedBox(height: padding24),
        Container(
          margin: EdgeInsets.all(padding24),
          padding: EdgeInsets.all(padding36),
          decoration: BoxDecoration(
            color: containerBackgroundColor(context),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: builder,
        ),
      ],
    );
    LookupArea area = ref.watch(areaProvider);
    return Scaffold(
      appBar: AppBar(title: Text("${area.name}  ${area.adm2}")),
      body: listView,
    );
  }

  void _update(int index) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _notifier.value = index;
    });
  }

  Widget _buildRow(Hourly hourly) {
    Widget column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(dateTime(context, hourly.fxTime)),
        _buildtitleRow(hourly),
        _buildBodyRow(hourly),
      ],
    );
    return column;
  }

  Widget _buildtitleRow(Hourly hourly) {
    Widget time = Text("${hourMinuteTime(hourly.fxTime)} ${l10n(context).hour}", style: _headingStyle);
    Widget temp = Text("${hourly.temp}°", style: _headingStyle);
    Widget icon = svgFillAsset(name: hourly.icon, color: icon2IconColor(hourly.icon));
    Widget text = Text(hourly.text, style: _headingStyle);
    Row row = Row(children: [
      icon,
      SizedBox(width: padding12),
      temp,
      SizedBox(width: padding12),
      text,
    ]);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(flex: 4, child: Align(alignment: Alignment.centerLeft, child: time)),
        Expanded(flex: 5, child: Align(alignment: Alignment.centerLeft, child: row)),
      ],
    );
  }

  Widget _buildBodyRow(Hourly hourly) {
    Widget pop = TextCube(title: "${hourly.pop}%", subTitle: l10n(context).probability);
    Widget precip = TextCube(title: "${hourly.precip}mm", subTitle: l10n(context).precipitation);
    Widget humidity = TextCube(title: "${hourly.humidity}%", subTitle: l10n(context).humidity);
    Row one = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: Align(alignment: Alignment.centerLeft, child: pop)),
        Expanded(flex: 3, child: Align(alignment: Alignment.centerLeft, child: precip)),
        Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: humidity)),
      ],
    );

    Widget windDir = TextCube(title: hourly.windDir, subTitle: l10n(context).windScale);
    Widget windSpeed = Consumer(builder: (context, ref, child) {
      String unit = speedUnit(ref);
      return TextCube(title: "${hourly.windSpeed}$unit", subTitle: l10n(context).windSpeed);
    });
    Widget pressure = TextCube(title: "${hourly.pressure}hPa", subTitle: l10n(context).pressure);
    Row two = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: Align(alignment: Alignment.centerLeft, child: windDir)),
        Expanded(flex: 3, child: Align(alignment: Alignment.centerLeft, child: windSpeed)),
        Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: pressure)),
      ],
    );

    Widget cloud = TextCube(title: "${hourly.cloud}%", subTitle: l10n(context).cloudiness);
    Widget dew = TextCube(title: "${hourly.dew}°", subTitle: l10n(context).dewPoint);
    Row three = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: Align(alignment: Alignment.centerLeft, child: cloud)),
        Expanded(flex: 5, child: Align(alignment: Alignment.centerLeft, child: dew)),
      ],
    );
    return Column(
      children: [
        SizedBox(height: padding36),
        one,
        SizedBox(height: padding36),
        two,
        SizedBox(height: padding36),
        three,
      ],
    );
  }
}

class TextCube extends StatelessWidget {
  final String title;
  final String subTitle;

  const TextCube({
    Key? key,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontSize: padding36,
                )),
        SizedBox(height: padding6),
        Text(subTitle,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.5),
                  fontSize: 26.px,
                )),
      ],
    );
  }
}
