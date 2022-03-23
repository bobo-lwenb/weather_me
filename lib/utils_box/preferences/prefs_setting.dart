import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_me/router/setting/provider_setting.dart';

SettingPreferences prefsSetting = SettingPreferences();

class SettingPreferences {
  final String _locale = 'locale';
  final String _appearance = 'appearance';
  final String _unit = 'unit';

  /// 设置语言类型
  Future<bool> setLocaleType(LocaleType type) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setInt(_locale, type.index);
  }

  /// 获取语言类型
  Future<LocaleType> getLocaleType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? type = preferences.getInt(_locale);
    if (type == null) return LocaleType.system;
    return LocaleType.values[type];
  }

  /// 设置外观类型
  Future<bool> setAppearanceType(ThemeMode mode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setInt(_appearance, mode.index);
  }

  /// 设置外观类型
  Future<ThemeMode> getAppearanceType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? mode = preferences.getInt(_appearance);
    if (mode == null) return ThemeMode.system;
    return ThemeMode.values[mode];
  }

  Future<bool> setUnitType(int type) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setInt(_unit, type);
  }

  Future<int> getUnitType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? type = preferences.getInt(_unit);
    return type ?? 0;
  }
}
