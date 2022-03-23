import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/router/setting/provider_setting.dart';

/// 获取距离单位
String distanceUnit(WidgetRef ref) {
  String unit = '';
  int result = ref.watch(unitProvider);
  switch (result) {
    case 0:
      unit = 'km';
      break;
    case 1:
      unit = 'mile';
      break;
  }
  return unit;
}

/// 获取时速单位
String speedUnit(WidgetRef ref) {
  String unit = '';
  int result = ref.watch(unitProvider);
  switch (result) {
    case 0:
      unit = 'km/h';
      break;
    case 1:
      unit = 'mile/h';
      break;
  }
  return unit;
}
