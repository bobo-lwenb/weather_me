import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/riverpod/provider_location.dart';
import 'package:weather_me/riverpod/provider_weather.dart';
import 'package:weather_me/router/area_list/model/lookup_area.dart';
import 'package:weather_me/router/daily/chart/daily_chart_page.dart';
import 'package:weather_me/router/daily/cube_navigation.dart';
import 'package:weather_me/router/daily/sheet/daily_sheet_page.dart';
import 'package:weather_me/router/home/cards/daily/model/daily.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_page/loading_page.dart';
import 'package:weather_me/utils_box/utils_time.dart';

class DailyPage extends ConsumerStatefulWidget {
  const DailyPage({Key? key}) : super(key: key);

  @override
  DailyChartState createState() => DailyChartState();
}

class DailyChartState extends ConsumerState<DailyPage> with SingleTickerProviderStateMixin {
  late List<String> tabs = [l10n(context).sheet, l10n(context).chart];

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<Daily>> asyncValue = ref.watch(daily30Provider);
    List<Daily> list = asyncValue.when(
      data: (list) => list,
      error: (err, stack) => [],
      loading: () => [],
    );
    if (list.isEmpty) return const LoadingPage();

    Describe describe = _describe(list);
    Widget describeWidget = Padding(
      padding: EdgeInsets.symmetric(horizontal: 80.px, vertical: padding24),
      child: Text(_topDescribe(describe), textAlign: TextAlign.center),
    );
    Widget navigationPage = NavigationPage(
      tabs: tabs,
      children: [
        DailySheetPage(list: list),
        DailyChartPage(list: list),
      ],
      callback: (index) {},
    );
    Column column = Column(children: [
      describeWidget,
      Expanded(child: navigationPage),
    ]);

    LookupArea area = ref.watch(areaProvider);
    return Scaffold(
      appBar: AppBar(title: Text("${area.name}  ${area.adm2}")),
      body: column,
    );
  }

  /// ?????????????????????????????????
  String _topDescribe(Describe desc) {
    // ?????????????????????
    String rainnum = desc.rainDateList.isEmpty ? '' : "${desc.rainDateList.length}${l10n(context).dayRain}???";
    String snowNum = desc.snowDateList.isEmpty ? '' : "${desc.snowDateList.length}${l10n(context).daySnow}???";

    // ????????????
    String maxTempText = "";
    for (var item in desc.maxDateList) {
      maxTempText += "???$item";
    }
    maxTempText = maxTempText.substring(1);
    String maxDescribe = "${l10n(context).highestTemp}${desc.maxTemp.toInt()}?????$maxTempText???";

    // ????????????
    String minTempText = "";
    for (var item in desc.minDateList) {
      minTempText += "???$item";
    }
    minTempText = minTempText.substring(1);
    String minDescribe = "${l10n(context).lowestTemp}${desc.minTemp.toInt()}?????$minTempText???";
    return "${l10n(context).willbe30}$rainnum$snowNum$maxDescribe???$minDescribe";
  }

  /// ?????????????????????????????????
  Describe _describe(List<Daily> list) {
    // ??????????????????????????????
    Daily daily = list.first;
    double maxTemp = double.parse(daily.tempMax);
    double minTemp = double.parse(daily.tempMin);
    for (var item in list) {
      double max = double.parse(item.tempMax);
      if (max > maxTemp) maxTemp = max;
      double min = double.parse(item.tempMin);
      if (min < minTemp) minTemp = min;
    }

    // ?????????????????????????????????????????????????????????????????????
    final List<String> maxDateList = List.empty(growable: true);
    final List<String> minDateList = List.empty(growable: true);
    final List<String> rainDateList = List.empty(growable: true);
    final List<String> snowDateList = List.empty(growable: true);
    for (var item in list) {
      double max = double.parse(item.tempMax);
      if (maxTemp == max) maxDateList.add(dateTime(context, item.fxDate));
      double min = double.parse(item.tempMin);
      if (minTemp == min) minDateList.add(dateTime(context, item.fxDate));
      double iconDay = double.parse(item.iconDay);
      double iconNight = double.parse(item.iconNight);
      if ((iconDay >= 300 && iconDay < 400) || (iconNight >= 300 && iconNight < 400)) {
        rainDateList.add(dateTime(context, item.fxDate));
        continue;
      }
      if ((iconDay >= 400 && iconDay < 500) || (iconNight >= 400 && iconNight < 500)) {
        snowDateList.add(dateTime(context, item.fxDate));
      }
    }

    return Describe(
      maxTemp: maxTemp,
      maxDateList: maxDateList,
      minTemp: minTemp,
      minDateList: minDateList,
      rainDateList: rainDateList,
      snowDateList: snowDateList,
    );
  }
}

class Describe {
  /// ?????????
  final double maxTemp;

  /// ??????????????????
  final List<String> maxDateList;

  /// ?????????
  final double minTemp;

  /// ??????????????????
  final List<String> minDateList;

  /// ???????????????
  List<String> rainDateList;

  /// ???????????????
  List<String> snowDateList;

  Describe({
    required this.maxTemp,
    required this.maxDateList,
    required this.minTemp,
    required this.minDateList,
    required this.rainDateList,
    required this.snowDateList,
  });
}
