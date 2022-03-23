import 'package:weather_me/router/area_list/model/lookup_area.dart';
import 'package:weather_me/router/home/cards/live_weather/model/now.dart';

class AllArea {
  final AreaLiveWeather nearMe;
  final List<AreaLiveWeather> favorites;
  final List<AreaLiveWeather> recently;

  AllArea({
    required this.nearMe,
    required this.favorites,
    required this.recently,
  });

  factory AllArea.empty() => AllArea(
        nearMe: AreaLiveWeather.empty(),
        favorites: [],
        recently: [],
      );
}

class AreaLiveWeather {
  final LookupArea city;
  final Now now;

  AreaLiveWeather({
    required this.city,
    required this.now,
  });

  factory AreaLiveWeather.empty() => AreaLiveWeather(
        city: LookupArea.empty(),
        now: Now.empty(),
      );
}
