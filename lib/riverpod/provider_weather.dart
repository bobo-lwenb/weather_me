import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/dio_net/geo_dio.dart';
import 'package:weather_me/dio_net/weather_dio.dart';
import 'package:weather_me/riverpod/provider_location.dart';
import 'package:weather_me/riverpod/weather_model.dart';
import 'package:weather_me/router/aqi_forecast/model/aqi_daily.dart';
import 'package:weather_me/router/area_list/model/lookup_area.dart';
import 'package:weather_me/router/home/cards/aqi/model/aqi_now.dart';
import 'package:weather_me/router/home/cards/daily/model/daily.dart';
import 'package:weather_me/router/home/cards/hourly/model/hourly.dart';
import 'package:weather_me/router/home/cards/living_index/model/living_index.dart';
import 'package:weather_me/router/warning/model/warning.dart';
import 'package:weather_me/router/warning/model/warning_wrapper.dart';
import 'package:weather_me/utils_box/weather/weather_container.dart';

/// 首页天气数据
final weatherProvider = FutureProvider.autoDispose<WeatherModel>((ref) async {
  final cancelToken = CancelToken();
  // ref.onDispose(() => cancelToken.cancel());
  LookupArea city = ref.watch(areaProvider);
  if (city.id == '--') return WeatherModel.empty();
  List list = await Future.wait([
    weatherDio.liveWeather(location: city.id, cancelToken: cancelToken),
    weatherDio.hourly(location: city.id, cancelToken: cancelToken),
    weatherDio.daily(location: city.id, cancelToken: cancelToken),
    weatherDio.apiNow(location: city.id, cancelToken: cancelToken),
    weatherDio.livingIndex(location: city.id, cancelToken: cancelToken),
    weatherDio.sun(location: city.id, cancelToken: cancelToken),
    weatherDio.moon(location: city.id, cancelToken: cancelToken),
    weatherDio.warning(location: city.id, cancelToken: cancelToken),
    weatherDio.minutely(city: city, cancelToken: cancelToken),
  ]);
  ref.refresh(sunActiveProvider);
  ref.read(sunActiveProvider.notifier).updateSunActive(list[5]);
  return WeatherModel(
    city: city,
    now: list[0],
    hourlyList: list[1],
    dailyList: list[2],
    aqiNow: list[3],
    livingList: list[4],
    sunActive: list[5],
    moonActive: list[6],
    warning: list[7],
    minutes: list[8],
  );
});

/// 72逐小时天气预报
final hourly72Provider = FutureProvider.autoDispose<List<Hourly>>((ref) async {
  final cancelToken = CancelToken();
  ref.onDispose(() => cancelToken.cancel());
  LookupArea city = ref.watch(areaProvider);
  if (city.id == '--') return [];
  List<Hourly> list = await weatherDio.hourly(
    location: city.id,
    time: '72h',
    cancelToken: cancelToken,
  );
  return list;
});

/// 30日天气预报
final daily30Provider = FutureProvider.autoDispose<List<Daily>>((ref) async {
  final cancelToken = CancelToken();
  ref.onDispose(() => cancelToken.cancel());
  LookupArea city = ref.watch(areaProvider);
  if (city.id == '--') return [];
  List<Daily> list = await weatherDio.daily(
    location: city.id,
    day: '30d',
    cancelToken: cancelToken,
  );
  return list;
});

/// 实时空气质量
final aqiNowProvider = FutureProvider.autoDispose<AqiNow>((ref) async {
  final cancelToken = CancelToken();
  ref.onDispose(() => cancelToken.cancel());
  LookupArea city = ref.watch(areaProvider);
  if (city.id == '--') return AqiNow.empty();
  AqiNow aqiNow = await weatherDio.apiNow(location: city.id, cancelToken: cancelToken);
  return aqiNow;
});

/// 空气质量预报
final aqiDailyProvider = FutureProvider.autoDispose<List<AqiDaily>>((ref) async {
  final cancelToken = CancelToken();
  ref.onDispose(() => cancelToken.cancel());
  LookupArea city = ref.watch(areaProvider);
  if (city.id == '--') return [];
  List<AqiDaily> list = await weatherDio.aqiDaily(
    location: city.id,
    cancelToken: cancelToken,
  );
  return list;
});

/// 当日生活指数查询
final livingNowProvider = FutureProvider.autoDispose<List<LivingIndex>>((ref) async {
  final cancelToken = CancelToken();
  ref.onDispose(() => cancelToken.cancel());
  LookupArea city = ref.watch(areaProvider);
  if (city.id == '--') return [];
  List<LivingIndex> list = await weatherDio.livingIndex(
    location: city.id,
    cancelToken: cancelToken,
  );
  return list;
});

/// 未来3日生活指数查询
final livingDailyProvider = FutureProvider.autoDispose<List<LivingIndex>>((ref) async {
  final cancelToken = CancelToken();
  ref.onDispose(() => cancelToken.cancel());
  LookupArea city = ref.watch(areaProvider);
  if (city.id == '--') return [];
  List<LivingIndex> list = await weatherDio.livingIndex(
    location: city.id,
    day: '3d',
    cancelToken: cancelToken,
  );
  return list;
});

/// 当日和未来3日生活指数查询
final livingAllProvider = FutureProvider.autoDispose<List<LivingIndex>>((ref) async {
  final cancelToken = CancelToken();
  ref.onDispose(() => cancelToken.cancel());
  LookupArea city = ref.watch(areaProvider);
  if (city.id == '--') return [];
  List list = await Future.wait([
    weatherDio.livingIndex(location: city.id, cancelToken: cancelToken),
    weatherDio.livingIndex(location: city.id, day: '3d', cancelToken: cancelToken),
  ]);
  List<LivingIndex> all = List.empty(growable: true);
  return all
    ..addAll(list[0])
    ..addAll(list[1]);
});

/// 天气灾害预警
final warningProvider = FutureProvider.autoDispose<List<Warning>>((ref) async {
  final cancelToken = CancelToken();
  ref.onDispose(() => cancelToken.cancel());
  LookupArea city = ref.watch(areaProvider);
  if (city.id == '--') return [];
  List<Warning> list = await weatherDio.warning(
    location: city.id,
    cancelToken: cancelToken,
  );
  return list;
});

/// 查询当地及周边的天气灾害预警
final warningListProvider = FutureProvider.autoDispose<List<WarningWrapper>>((ref) async {
  LookupArea localCity = ref.watch(areaProvider);
  if (localCity.id == '--') return [];

  final cancelToken = CancelToken();
  ref.onDispose(() => cancelToken.cancel());

  // 查询当地所在省份的城市
  List<LookupArea> listCities = await geoDio.lookupLocation(
    adcode: localCity.adm1,
    cancelToken: cancelToken,
  );
  // 查询当地及所在省份的城市的天气灾害预警
  List<Future> futures = List.empty(growable: true);
  futures.add(weatherDio.warning(
    location: localCity.id,
    cancelToken: cancelToken,
  ));

  List<LookupArea> listCitiesTmp = List.empty(growable: true);
  listCitiesTmp.addAll(listCities);
  for (var item in listCities) {
    if (item.adm2.trim() == localCity.adm2.trim()) {
      listCitiesTmp.remove(item);
      continue;
    }
    futures.add(weatherDio.warning(
      location: item.id,
      cancelToken: cancelToken,
    ));
  }
  List results = await Future.wait(futures);

  // 数据的包装
  List<WarningWrapper> wrappers = List.empty(growable: true);
  List<Warning> localWarning = results.removeAt(0);
  if (localWarning.isNotEmpty) {
    WarningWrapper wrapper = WarningWrapper(
      city: localCity,
      list: localWarning,
    );
    wrappers.add(wrapper);
  }

  for (var item in results) {
    if ((item as List<Warning>).isEmpty) continue;
    int index = results.indexOf(item);
    WarningWrapper wrapper = WarningWrapper(
      city: listCitiesTmp[index],
      list: item,
    );
    wrappers.add(wrapper);
  }

  return wrappers;
});
