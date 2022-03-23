import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/dio_net/geo_dio.dart';
import 'package:weather_me/router/area_list/model/lookup_area.dart';

/// 获取高德定位后的adCode、ID、经纬度、文本的provider
final adCodeProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

/// 监听 adCode 的区域查询
final lookupProvider = FutureProvider.autoDispose<LookupArea>((ref) async {
  final cancelToken = CancelToken();
  ref.onDispose(() => cancelToken.cancel());
  ref.keepAlive();
  String adcode = ref.watch<String>(adCodeProvider);
  if (adcode.isEmpty) return LookupArea.empty();
  List<LookupArea> list = await geoDio.lookupLocation(adcode: adcode, cancelToken: cancelToken);
  return list.isEmpty ? LookupArea.empty() : list.first;
});

/// 用于保存使用 adCode 查询到的地区信息的provider
final areaProvider = StateProvider.autoDispose<LookupArea>((ref) {
  AsyncValue<LookupArea> asyncValue = ref.watch(lookupProvider);
  LookupArea city = asyncValue.when(
    data: (city) => city,
    error: (err, stack) => LookupArea.empty(),
    loading: () => LookupArea.empty(),
  );
  if (city.id == '--') return LookupArea.empty();
  return city;
});

/// 保存城市搜索文本的 provider
final searchStringProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

/// 用于城市搜索查询的地区信息列表的provider
final searchCityProvider = FutureProvider.autoDispose<List<LookupArea>>((ref) async {
  final cancelToken = CancelToken();
  ref.onDispose(() => cancelToken.cancel());
  String searchString = ref.watch<String>(searchStringProvider);
  if (searchString.isEmpty) return [];
  List<LookupArea> list = await geoDio.lookupLocation(adcode: searchString, cancelToken: cancelToken);
  return list;
});
