import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:weather_me/dio_net/base_dio.dart';
import 'package:weather_me/router/aqi_forecast/model/aqi_daily.dart';
import 'package:weather_me/router/area_list/model/lookup_area.dart';
import 'package:weather_me/router/home/cards/aqi/model/aqi_now.dart';
import 'package:weather_me/router/home/cards/daily/model/daily.dart';
import 'package:weather_me/router/home/cards/hourly/model/hourly.dart';
import 'package:weather_me/router/home/cards/live_weather/model/now.dart';
import 'package:weather_me/router/home/cards/living_index/model/living_index.dart';
import 'package:weather_me/router/home/cards/minutely/model/minutes.dart';
import 'package:weather_me/router/home/cards/sun_moon/model/moon_active.dart';
import 'package:weather_me/router/home/cards/sun_moon/model/sun_active.dart';
import 'package:weather_me/router/warning/model/warning.dart';
import 'package:weather_me/utils_box/utils_time.dart';

var _baseUrl = kDebugMode
    ? 'https://devapi.qweather.com/v7' // 开发版
    : 'https://api.qweather.com/v7'; // 商业版

WeatherDio weatherDio = WeatherDio(baseUrl: _baseUrl);

class WeatherDio extends BaseDio {
  WeatherDio({required String baseUrl}) : super(baseUrl: baseUrl);

  /// 实时天气
  Future<Now> liveWeather({
    required String location,
    String keyWord = 'now',
    CancelToken? cancelToken,
  }) async {
    var params = {'location': location};
    Map<String, dynamic> result = await get(
      path: '/weather/now',
      queryParams: params,
      keyWord: keyWord,
      cancelToken: cancelToken,
    );
    return Now.fromJson(result);
  }

  /// 逐小时天气信息
  Future<List<Hourly>> hourly({
    required String location,
    String time = '24h',
    String keyWord = 'hourly',
    CancelToken? cancelToken,
  }) async {
    List<dynamic> result;
    if (kDebugMode && time == '72h') {
      // 从本地加载json数据
      result = await Future(() async {
        String string = await rootBundle.loadString('lib/assets/json/hourly_72.json');
        Map<String, dynamic> data = json.decode(string);
        return data['hourly'];
      });
    } else {
      var params = {'location': location};
      result = await get(
        path: "/weather/$time",
        queryParams: params,
        keyWord: keyWord,
        cancelToken: cancelToken,
      );
    }
    List<Hourly> list = List.empty(growable: true);
    for (var item in result) {
      Hourly hourly = Hourly.fromJson(item);
      list.add(hourly);
    }
    return list;
  }

  /// 逐天天气预报
  Future<List<Daily>> daily({
    required String location,
    String day = '7d',
    String keyWord = 'daily',
    CancelToken? cancelToken,
  }) async {
    List<dynamic> result;
    if (kDebugMode && day == '30d') {
      // 从本地加载json数据
      result = await Future(() async {
        String string = await rootBundle.loadString('lib/assets/json/daily_30.json');
        Map<String, dynamic> data = json.decode(string);
        return data['daily'];
      });
    } else {
      var params = {'location': location};
      result = await get(
        path: "/weather/$day",
        queryParams: params,
        keyWord: keyWord,
        cancelToken: cancelToken,
      );
    }
    List<Daily> list = List.empty(growable: true);
    for (var item in result) {
      Daily hourly = Daily.fromJson(item);
      list.add(hourly);
    }
    return list;
  }

  /// 实时空气质量
  Future<AqiNow> apiNow({
    required String location,
    CancelToken? cancelToken,
  }) async {
    var params = {'location': location};
    dynamic result = await get(
      path: '/air/now',
      queryParams: params,
      keyWord: 'now',
      cancelToken: cancelToken,
    );
    return AqiNow.fromJson(result);
  }

  /// 空气质量预报
  Future<List<AqiDaily>> aqiDaily({
    required String location,
    String keyWord = 'daily',
    CancelToken? cancelToken,
  }) async {
    List<dynamic> result;
    if (kDebugMode) {
      // 从本地加载json数据
      result = await Future(() async {
        String string = await rootBundle.loadString('lib/assets/json/aqi_forecast.json');
        Map<String, dynamic> data = json.decode(string);
        return data['daily'];
      });
    } else {
      var params = {'location': location};
      result = await get(
        path: '/air/5d',
        queryParams: params,
        keyWord: keyWord,
        cancelToken: cancelToken,
      );
    }
    List<AqiDaily> list = List.empty(growable: true);
    for (var item in result) {
      AqiDaily aqiDaily = AqiDaily.fromJson(item);
      list.add(aqiDaily);
    }
    return list;
  }

  /// 生活指数查询
  /// 1d: 查询当日
  /// 3d: 查询未来3日
  Future<List<LivingIndex>> livingIndex({
    required String location,
    String type = '0',
    String day = '1d',
    String keyWord = 'daily',
    CancelToken? cancelToken,
  }) async {
    List<dynamic> result;
    if (kDebugMode && day == '3d') {
      // 从本地加载json数据
      result = await Future(() async {
        String string = await rootBundle.loadString('lib/assets/json/living_index_3d.json');
        Map<String, dynamic> data = json.decode(string);
        return data['daily'];
      });
    } else {
      var params = {
        'location': location,
        'type': type,
      };
      result = await get(
        path: "/indices/$day",
        queryParams: params,
        keyWord: keyWord,
        cancelToken: cancelToken,
      );
    }
    List<LivingIndex> list = List.empty(growable: true);
    for (var item in result) {
      LivingIndex livingIndex = LivingIndex.fromJson(item);
      list.add(livingIndex);
    }
    return list;
  }

  /// 日出日落
  Future<SunActive> sun({
    required String location,
    CancelToken? cancelToken,
  }) async {
    var params = {
      'location': location,
      'date': connectDate(DateTime.now().toLocal().toString()),
    };
    dynamic result = await get(
      path: '/astronomy/sun',
      queryParams: params,
      cancelToken: cancelToken,
    );
    return SunActive.fromJson(result);
  }

  /// 月升月落
  Future<MoonActive> moon({
    required String location,
    CancelToken? cancelToken,
  }) async {
    var params = {
      'location': location,
      'date': connectDate(DateTime.now().toLocal().toString()),
    };
    dynamic result = await get(
      path: '/astronomy/moon',
      queryParams: params,
      cancelToken: cancelToken,
    );
    return MoonActive.fromJson(result);
  }

  /// 天气灾害预警
  Future<List<Warning>> warning({
    required String location,
    String keyWord = 'warning',
    CancelToken? cancelToken,
  }) async {
    var params = {'location': location};
    List<dynamic> result = await get(
      path: '/warning/now',
      queryParams: params,
      keyWord: keyWord,
      cancelToken: cancelToken,
    );
    List<Warning> list = List.empty(growable: true);
    for (var item in result) {
      Warning warning = Warning.fromJson(item);
      list.add(warning);
    }
    return list;
  }

  /// 分钟级降水
  Future<Minutes> minutely({
    required LookupArea city,
    CancelToken? cancelToken,
  }) async {
    var params = {'location': "${city.lon},${city.lat}"};
    dynamic result = await get(
      path: '/minutely/5m',
      queryParams: params,
      cancelToken: cancelToken,
    );
    return Minutes.fromJson(result);
  }
}
