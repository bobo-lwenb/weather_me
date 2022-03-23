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

class WeatherModel {
  final LookupArea city;
  final Now now;
  final List<Hourly> hourlyList;
  final List<Daily> dailyList;
  final AqiNow aqiNow;
  final List<LivingIndex> livingList;
  final SunActive sunActive;
  final MoonActive moonActive;
  final List<Warning> warning;
  final Minutes minutes;

  WeatherModel({
    required this.city,
    required this.now,
    required this.hourlyList,
    required this.dailyList,
    required this.aqiNow,
    required this.livingList,
    required this.sunActive,
    required this.moonActive,
    required this.warning,
    required this.minutes,
  });

  factory WeatherModel.empty() => WeatherModel(
        city: LookupArea.empty(),
        now: Now.empty(),
        hourlyList: [],
        dailyList: [],
        aqiNow: AqiNow.empty(),
        livingList: [],
        sunActive: SunActive.empty(),
        moonActive: MoonActive.empty(),
        warning: [],
        minutes: Minutes.empty(),
      );
}
