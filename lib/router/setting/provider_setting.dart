import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/dio_net/geo_dio.dart';
import 'package:weather_me/dio_net/weather_dio.dart';
import 'package:weather_me/utils_box/preferences/prefs_setting.dart';

/// 用于保存操作系统的 locale
final systemLocaleProvider = StateProvider<Locale?>((ref) {
  return null;
});

/// 语言 provider
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(const Locale('zh', 'CN'));

  void toggle(LocaleType type, WidgetRef ref) async {
    String lang = 'zh';
    switch (type) {
      case LocaleType.system:
        Locale systemLocale = ref.read(systemLocaleProvider.notifier).state!;
        state = systemLocale;
        prefsSetting.setLocaleType(LocaleType.system);
        lang = systemLocale.languageCode;
        break;
      case LocaleType.zh:
        state = const Locale('zh', 'CN');
        prefsSetting.setLocaleType(LocaleType.zh);
        lang = 'zh';
        break;
      case LocaleType.en:
        state = const Locale('en', 'US');
        prefsSetting.setLocaleType(LocaleType.en);
        lang = 'en';
        break;
    }
    weatherDio.toggleLanguage(lang);
    geoDio.toggleLanguage(lang);
  }

  LocaleType type() {
    if (state == const Locale('zh', 'CN')) {
      return LocaleType.zh;
    } else if (state == const Locale('en', 'US')) {
      return LocaleType.en;
    } else {
      return LocaleType.system;
    }
  }
}

/// 语言类型
enum LocaleType {
  /// 跟随系统
  system,

  /// 中文
  zh,

  /// 英语
  en,
}

/// 主题 provider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);

  void toggle(ThemeMode mode) async {
    state = mode;
    prefsSetting.setAppearanceType(mode);
  }
}

/// 单位选择的provider
final unitProvider = StateNotifierProvider<UnitNotifier, int>((ref) {
  return UnitNotifier();
});

/// 0: 公制 1: 英制
class UnitNotifier extends StateNotifier<int> {
  UnitNotifier() : super(0);

  void toggle(int type) async {
    state = type;
    prefsSetting.setUnitType(type);
    String unit = type == 0 ? 'm' : 'i';
    weatherDio.toggleUnit(unit);
    geoDio.toggleUnit(unit);
  }
}
