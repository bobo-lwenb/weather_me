import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/riverpod/provider_location.dart';
import 'package:weather_me/riverpod/provider_weather.dart';
import 'package:weather_me/riverpod/weather_model.dart';
import 'package:weather_me/router/area_list/model/lookup_area.dart';
import 'package:weather_me/router/home/cards/aqi/api_card.dart';
import 'package:weather_me/router/home/cards/daily/daily_card.dart';
import 'package:weather_me/router/home/cards/hourly/hourly_card.dart';
import 'package:weather_me/router/home/cards/live_weather/live_card.dart';
import 'package:weather_me/router/home/cards/live_weather/live_expanded_card.dart';
import 'package:weather_me/router/home/cards/live_weather/model/now.dart';
import 'package:weather_me/router/home/cards/living_index/living_index_card.dart';
import 'package:weather_me/router/home/cards/sun_moon/sun_moon_card.dart';
import 'package:weather_me/router/home/home_layout.dart';
import 'package:weather_me/router/home/home_widgets/float_banner.dart';
import 'package:weather_me/router/home/home_widgets/refresh_banner.dart';
import 'package:weather_me/router/setting/provider_setting.dart';
import 'package:weather_me/router/warning/model/warning.dart';
import 'package:weather_me/utils_box/amap/amap_location.dart';
import 'package:weather_me/router/area_list/provider_area.dart';
import 'package:weather_me/utils_box/amap/model/location.dart';
import 'package:weather_me/utils_box/preferences/prefs_setting.dart';
import 'package:weather_me/utils_box/utils_color.dart';
import 'package:weather_me/utils_box/navigator_manager.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_image.dart';
import 'package:weather_me/utils_box/utils_page/loading_page.dart';
import 'package:weather_me/utils_box/weather/weather_container.dart';
import 'package:weather_me/utils_box/weather_convert.dart';

class HomeContainer extends ConsumerStatefulWidget {
  const HomeContainer({Key? key}) : super(key: key);

  @override
  HomeContainerState createState() => HomeContainerState();
}

class HomeContainerState extends ConsumerState<HomeContainer> {
  late final AmapLocation amapLocation = AmapLocation();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      List list = await Future.wait([
        prefsSetting.getLocaleType(),
        prefsSetting.getAppearanceType(),
        prefsSetting.getUnitType(),
      ]);
      ref.read(localeProvider.notifier).toggle(list[0], ref);
      ref.read(themeProvider.notifier).toggle(list[1]);
      ref.read(unitProvider.notifier).toggle(list[2]);
      _mayLocation();
    });
  }

  @override
  void dispose() {
    amapLocation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 监听locale变化以刷新界面
    ref.listen<Locale?>(localeProvider, (pre, next) {
      if (pre?.languageCode == next?.languageCode) return;
      _refreshWeather();
    });
    // 监听单位变化以刷新界面
    ref.listen<int>(unitProvider, (pre, next) {
      _refreshWeather();
    });
    AsyncValue<WeatherModel> asyncValue = ref.watch(weatherProvider);
    WeatherModel model = asyncValue.when(
      data: (model) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Future.delayed(
            const Duration(seconds: 2),
            () => ref.read(isRefreshProvider.notifier).state = false,
          );
        });
        return model;
      },
      error: (err, stack) => WeatherModel.empty(),
      loading: () => WeatherModel.empty(),
    );
    if (model.city.id == '--') return const LoadingPage();
    Widget container = HomeLayout(
        appBar: _getAppBar(model.city),
        icons: _geticonList(),
        background: _getBackground(model.now),
        floatBanner: _getFloatBanners(model),
        slivers: _getSlivers(model),
        refreshCallback: () {
          ref.read(isRefreshProvider.notifier).state = true;
          _refreshWeather();
        });
    return container;
  }

  Widget _getAppBar(LookupArea city) {
    Row row = Row(
      children: [
        const Icon(Icons.near_me_rounded, size: 20, color: Colors.blueAccent),
        SizedBox(width: 10.px),
        Text(
          "${city.name}  ${city.adm2}  ${city.adm1}",
          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 30.px),
        ),
      ],
    );
    Stack stack = Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Positioned(
          bottom: 38.px,
          child: row,
        ),
        Positioned(
          right: padding24,
          bottom: padding36,
          child: GestureDetector(
            child: const Icon(Icons.subject_rounded),
            onTap: () => AppRouterDelegate.of(context).push('area_list'),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Divider(height: 1.px),
        ),
      ],
    );
    return Container(
      color: backgroundColor(context),
      child: stack,
    );
  }

  Widget _geticonList() {
    bool isDay = ref.read(sunActiveProvider.notifier).isDay();
    Widget iconList = Column(
      children: [
        GestureDetector(
          child: Icon(Icons.settings_suggest_rounded, color: isDay ? Colors.black : Colors.blueGrey),
          onTap: () => AppRouterDelegate.of(context).push('setting'),
        ),
        SizedBox(height: padding24),
        GestureDetector(
          child: Icon(Icons.subject_rounded, color: isDay ? Colors.black : Colors.blueGrey),
          onTap: () => AppRouterDelegate.of(context).push('area_list'),
        ),
        SizedBox(height: padding24),
        GestureDetector(
            child: const Icon(Icons.my_location_outlined),
            onTap: () {
              ref.read(isRefreshProvider.notifier).state = true;
              _mayLocation();
            }),
      ],
    );
    return iconList;
  }

  Widget _getBackground(Now now) {
    return WeatherContainer(icon: now.icon);
  }

  Widget _getFloatBanners(WeatherModel model) {
    Widget column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWarning(model.warning),
        SizedBox(height: 16.px),
        FloatBanner(
          icon: const Icon(Icons.ssid_chart, size: 18, color: Colors.blue),
          child: Text(model.minutes.summary, style: const TextStyle(fontSize: 12)),
          callback: () {},
        ),
        SizedBox(height: 16.px),
        FloatBanner(
          icon: Icon(Icons.filter_vintage, size: 16, color: aqi2Color(model.aqiNow.aqi)),
          child: Text(
            "AQI ${model.aqiNow.aqi} ${aqi2Text(context, model.aqiNow.aqi)}",
            style: const TextStyle(fontSize: 12),
          ),
          callback: () => AppRouterDelegate.of(context).push('aqi_forecast'),
        )
      ],
    );
    return column;
  }

  /// 构建天气预警的banner
  Widget _buildWarning(List<Warning> list) {
    if (list.isEmpty) return const SizedBox();
    Color color =
        list.length > 1 ? Color(int.parse('d93a49', radix: 16)).withAlpha(255) : warningLevel2Color(list.first.level);
    Widget icon = list.length > 1
        ? Icon(Icons.warning_rounded, size: 16, color: color)
        : svgAsset(name: list.first.type, color: color, size: 16);
    String warningText =
        list.length > 1 ? l10n(context).variousDisaster : "${list.first.typeName} ${l10n(context).warning}";
    return FloatBanner(
      icon: icon,
      child: Text(warningText, style: const TextStyle(fontSize: 12)),
      callback: () => AppRouterDelegate.of(context).push('warning'),
    );
  }

  List<Widget> _getSlivers(WeatherModel model) {
    return [
      _buildLocation(model.city),
      LiveCard(model: model),
      LiveExpandedCard(model: model),
      HourlyCard(hourlys: model.hourlyList),
      AqiCard(aqiNow: model.aqiNow),
      DailyCard(dailys: model.dailyList),
      SunMoonCard(sunActive: model.sunActive, moonActive: model.moonActive),
      LivingIndexCard(list: model.livingList),
    ];
  }

  /// 构建位置信息
  Widget _buildLocation(LookupArea city) {
    Row row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.near_me_rounded, size: 20, color: Colors.blueAccent),
        SizedBox(width: 10.px),
        Text("${city.name}  ${city.adm2}  ${city.adm1}"),
      ],
    );
    return Padding(
      padding: EdgeInsets.only(
        top: padding36,
        left: padding36,
        right: padding36,
      ),
      child: row,
    );
  }

  /// 定位当前位置
  void _mayLocation() {
    amapLocation
      ..init()
      ..askForLocation(context).then((value) {
        if (value) {
          amapLocation.startLocation((result) {
            if (result['locationType'] != 0) {
              Location location = Location.fromJson(result);
              ref.read(adCodeProvider);
              ref.read(adCodeProvider.notifier).state = location.adCode;
              // 保存当前位置的adcode
              ref.read(setAdcodeProvider(location.adCode));
            } else {
              AsyncValue<String> asyncValue = ref.watch(getAdcodeProvider);
              String adcode = asyncValue.when(
                data: (adcode) => adcode,
                error: (err, stack) => '',
                loading: () => '',
              );
              ref.read(adCodeProvider.notifier).state = adcode;
            }
          });
        }
      });

    // 测试用代码
    // ref.refresh(adCodeProvider);
    // ref.read(adCodeProvider.notifier).state = '450205';
    // ref.read(setAdcodeProvider('450205'));
  }

  /// 洁面刷新
  void _refreshWeather() {
    String id = ref.read(adCodeProvider.notifier).state;
    ref.refresh(adCodeProvider);
    ref.read(adCodeProvider.notifier).state = id;
  }
}
