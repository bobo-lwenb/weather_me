import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/dio_net/geo_dio.dart';
import 'package:weather_me/dio_net/weather_dio.dart';
import 'package:weather_me/router/area_list/model/all_area.dart';
import 'package:weather_me/router/area_list/model/lookup_area.dart';
import 'package:weather_me/router/home/cards/live_weather/model/now.dart';
import 'package:weather_me/utils_box/preferences/prefs_area.dart';

/// 当前位置
/// 获取当前位置
final getAdcodeProvider = FutureProvider.autoDispose<String>((ref) async {
  return await prefsArea.getAdcode();
});

/// 保存当前位置
final setAdcodeProvider = FutureProvider.family.autoDispose<bool, String>((ref, adcode) async {
  if (adcode.isEmpty) return false;
  return await prefsArea.setAdcode(adcode);
});

/// 关注的地区
/// 获取关注地区
final getFavoritesProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  return await prefsArea.getFavorites();
});

/// 增加一项关注地区
final addFavoriteProvider = FutureProvider.family.autoDispose<bool, String>((ref, favorite) async {
  List<String> list = await prefsArea.getFavorites();
  if (list.contains(favorite)) return true;
  list.add(favorite);
  return await prefsArea.setFavorites(list);
});

/// 删除一项关注地区
final removeFavoriteProvider = FutureProvider.autoDispose.family<bool, String>((ref, favorite) async {
  List<String> list = await prefsArea.getFavorites();
  if (!list.contains(favorite)) return false;
  list.remove(favorite);
  return await prefsArea.setFavorites(list);
});

/// 删除所有关注地区
final clearFavoriteProvider = FutureProvider<bool>((ref) async {
  return await prefsArea.clearFavorites();
});

/// 最近查看地区
/// 获取最近查看地区
final getRecentlyProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  return await prefsArea.getRecently();
});

/// 增加一项最近查看地区
final addRecentlyProvider = FutureProvider.autoDispose.family<bool, String>((ref, recently) async {
  List<String> list = await prefsArea.getRecently();
  if (list.contains(recently)) return true;
  list.add(recently);
  return await prefsArea.setRecently(list);
});

/// 删除一项最近查看地区
final removeRecentlyProvider = FutureProvider.autoDispose.family<bool, String>((ref, recently) async {
  List<String> list = await prefsArea.getRecently();
  if (!list.contains(recently)) return false;
  list.remove(recently);
  return await prefsArea.setRecently(list);
});

/// 删除所有最近查看地区
final clearRecentlyProvider = FutureProvider<bool>((ref) async {
  return await prefsArea.clearRecently();
});

/// 用于一次性获取所有地区的provider
/// 包括当前位置、关注的地区、最近查看的地区
final allAreaProvider = FutureProvider.autoDispose<AllArea>((ref) async {
  final cancelToken = CancelToken();
  ref.onDispose(() => cancelToken.cancel());

  // 收下获取地区的adcode或id
  List<Future> areaFutures = List.empty(growable: true);
  areaFutures.add(prefsArea.getAdcode()); // 获取当前位置的数据
  areaFutures.add(prefsArea.getFavorites()); // 获取关注位置的数据
  areaFutures.add(prefsArea.getRecently()); // 获取最近查看位置的数据

  List areaResult = await Future.wait(areaFutures);
  String adcode = areaResult[0];
  List<String> favorotes = areaResult[1];
  List<String> recently = areaResult[2];

  // 根据地区的adcode或id获取实时天气信息
  List<Future> nowFutures = List.empty(growable: true);
  nowFutures.add(_allALW([adcode], cancelToken));
  nowFutures.add(_allALW(favorotes, cancelToken));
  nowFutures.add(_allALW(recently, cancelToken));

  List nowResult = await Future.wait(nowFutures);
  AreaLiveWeather near = nowResult[0].first;
  List<AreaLiveWeather> favoList = nowResult[1];
  List<AreaLiveWeather> recentlyList = nowResult[2];

  return AllArea(
    nearMe: near,
    favorites: favoList,
    recently: recentlyList,
  );
});

Future<List<AreaLiveWeather>> _allALW(List<String> datas, CancelToken cancelToken) async {
  // 获取位置信息
  List<Future<List<LookupArea>>> favoFuture = List.empty(growable: true);
  for (var item in datas) {
    favoFuture.add(geoDio.lookupLocation(adcode: item, cancelToken: cancelToken));
  }
  List listCity = await Future.wait<List<LookupArea>>(favoFuture);

  // 获取天气信息
  List<Future<Now>> nowFuture = List.empty(growable: true);
  for (var item in listCity) {
    nowFuture.add(weatherDio.liveWeather(location: item.first.id, cancelToken: cancelToken));
  }
  List listNow = await Future.wait(nowFuture);
  // 数据的组合
  List<AreaLiveWeather> list = List.empty(growable: true);
  for (int i = 0; i < datas.length; i++) {
    AreaLiveWeather alw = AreaLiveWeather(
      city: listCity[i].first,
      now: listNow[i],
    );
    list.add(alw);
  }

  return list;
}
