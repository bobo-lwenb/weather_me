import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/riverpod/provider_location.dart';
import 'package:weather_me/riverpod/provider_weather.dart';
import 'package:weather_me/router/aqi_forecast/model/aqi_daily.dart';
import 'package:weather_me/router/area_list/model/lookup_area.dart';
import 'package:weather_me/router/home/cards/aqi/api_widgets.dart';
import 'package:weather_me/router/home/cards/aqi/model/aqi_now.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_color.dart';
import 'package:weather_me/utils_box/utils_page/loading_page.dart';
import 'package:weather_me/utils_box/utils_time.dart';
import 'package:weather_me/utils_box/weather_convert.dart';

class AqiForecastPage extends ConsumerStatefulWidget {
  const AqiForecastPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AqiForecastState();
}

class _AqiForecastState extends ConsumerState<AqiForecastPage> {
  @override
  Widget build(BuildContext context) {
    AsyncValue<AqiNow> asyncNow = ref.watch(aqiNowProvider);
    AqiNow aqiNow = asyncNow.when(
      data: (aqiNow) => aqiNow,
      error: (err, stack) => AqiNow.empty(),
      loading: () => AqiNow.empty(),
    );
    AsyncValue<List<AqiDaily>> asyncDaily = ref.watch(aqiDailyProvider);
    List<AqiDaily> list = asyncDaily.when(
      data: (dailys) => dailys,
      error: (err, stack) => [],
      loading: () => [],
    );
    if (aqiNow.aqi == '--' || list.isEmpty) return const LoadingPage();

    ListView listView = ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        _buildAqiNow(aqiNow),
        _buildText(aqiNow),
        _buildAqiDaily(list),
      ],
    );
    LookupArea area = ref.watch(areaProvider);
    return Scaffold(
      appBar: AppBar(title: Text("${area.name}  ${area.adm2}")),
      body: listView,
    );
  }

  Widget _buildAqiDaily(List<AqiDaily> list) {
    Widget title = Padding(
      padding: EdgeInsets.only(bottom: padding36),
      child: Text(l10n(context).airForecast, style: _titleTextStyle()),
    );
    ListView listView = ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) {
        AqiDaily daily = list[index];
        return DailyItem(daily: daily);
      },
    );
    Column column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [title, listView],
    );
    Widget content = Padding(
      padding: EdgeInsets.only(
        left: padding24,
        right: padding24,
        bottom: padding24,
      ),
      child: Container(
        padding: EdgeInsets.all(padding36),
        decoration: BoxDecoration(
          color: containerBackgroundColor(context),
          borderRadius: BorderRadius.all(Radius.circular(padding24)),
        ),
        child: column,
      ),
    );
    return content;
  }

  /// 提示标题的文本样式
  TextStyle _titleTextStyle() => Theme.of(context).textTheme.bodyText2!.copyWith(
        fontSize: 36.px,
      );

  /// 提示内容的文本样式
  TextStyle _contentTextStyle() => Theme.of(context).textTheme.bodyText2!.copyWith(
        fontSize: 24.px,
        color: Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.5),
      );

  Widget _buildText(AqiNow aqiNow) {
    if (aqiNow.aqi == '--') return Container(color: Colors.white);
    AqiDescribe describe = aqi2Describe(context, aqiNow.aqi);
    Column column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n(context).healthEffects, style: _titleTextStyle()),
        Text(describe.influence, style: _contentTextStyle()),
        SizedBox(height: padding18),
        Text(l10n(context).recommended, style: _titleTextStyle()),
        Text(describe.advice, style: _contentTextStyle()),
      ],
    );
    Widget content = Padding(
      padding: EdgeInsets.only(
        left: padding24,
        right: padding24,
        bottom: padding24,
      ),
      child: Container(
        padding: EdgeInsets.all(padding36),
        decoration: BoxDecoration(
          color: containerBackgroundColor(context),
          borderRadius: BorderRadius.all(Radius.circular(padding24)),
        ),
        child: column,
      ),
    );
    return content;
  }

  Widget _buildAqiNow(AqiNow aqiNow) {
    if (aqiNow.aqi == '--') return Container(color: Colors.white);
    Widget aqiCircle = CustomPaint(
      painter: AqiCircle(context: context, aqi: aqiNow.aqi),
    );
    Widget pm2_5 = Pollutant(
      index: aqiNow.pm2p5,
      percent: double.parse(aqiNow.pm2p5) / 500,
      text: 'pm2.5',
    );
    Widget pm10 = Pollutant(
      index: aqiNow.pm10,
      percent: double.parse(aqiNow.pm10) / 600,
      text: 'pm10',
    );
    Widget o3 = Pollutant(
      index: aqiNow.o3,
      percent: double.parse(aqiNow.o3) / 1200,
      text: 'O₃',
    );
    Widget co = Pollutant(
      index: aqiNow.co,
      percent: double.parse(aqiNow.co) / 150,
      text: 'CO',
    );
    Widget so2 = Pollutant(
      index: aqiNow.so2,
      percent: double.parse(aqiNow.so2) / 800,
      text: 'SO₂',
    );
    Widget no2 = Pollutant(
      index: aqiNow.no2,
      percent: double.parse(aqiNow.no2) / 3840,
      text: 'NO₂',
    );
    Row row = Row(children: [
      Expanded(child: pm2_5),
      Expanded(child: pm10),
      Expanded(child: o3),
      Expanded(child: co),
      Expanded(child: so2),
      Expanded(child: no2),
    ]);

    Column column = Column(
      children: [
        SizedBox(
          width: 250.px,
          height: 250.px,
          child: aqiCircle,
        ),
        SizedBox(height: 66.px),
        row,
      ],
    );
    Widget content = Padding(
      padding: EdgeInsets.all(padding24),
      child: Container(
        padding: EdgeInsets.all(padding36),
        decoration: BoxDecoration(
          color: containerBackgroundColor(context),
          borderRadius: BorderRadius.all(Radius.circular(padding24)),
        ),
        child: column,
      ),
    );
    return content;
  }
}

class DailyItem extends StatelessWidget {
  final AqiDaily daily;

  const DailyItem({Key? key, required this.daily}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget week = Text(weekTime(context, daily.fxDate));
    Widget aqi = Text("AQI ${daily.aqi}");
    Widget text = Container(
      padding: EdgeInsets.symmetric(vertical: padding12),
      decoration: BoxDecoration(
        color: aqi2Color(daily.aqi),
        borderRadius: BorderRadius.all(Radius.circular(padding12)),
      ),
      child: Text(
        aqi2Text(context, daily.aqi),
        textAlign: TextAlign.center,
        style: TextStyle(color: aqi2Color(daily.aqi).computeLuminance() > .5 ? blackText : whiteText),
      ),
    );
    Row row = Row(children: [
      Expanded(child: week),
      Expanded(child: aqi),
      Expanded(child: text),
    ]);
    return Padding(
      padding: EdgeInsets.only(bottom: padding18),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: padding36, vertical: padding30),
        decoration: BoxDecoration(
          color: contentBackgroundColor(context),
          borderRadius: BorderRadius.all(Radius.circular(padding24)),
        ),
        child: row,
      ),
    );
  }
}
