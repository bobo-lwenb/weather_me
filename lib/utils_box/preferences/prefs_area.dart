import 'package:shared_preferences/shared_preferences.dart';

AreaPreferences prefsArea = AreaPreferences();

class AreaPreferences {
  final String _adcode = 'adcode';
  final String _favorites = 'favorites';
  final String _recently = 'recently';

  /// 保存当前位置的adcode
  Future<bool> setAdcode(String adcode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(_adcode, adcode);
  }

  /// 读取当前位置的adcode
  Future<String> getAdcode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? adcode = preferences.getString(_adcode);
    return adcode ?? '';
  }

  /// 清除当前位置的adcode
  Future<bool> clearAdcode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.remove(_adcode);
  }

  /// 保存关注列表的id
  Future<bool> setFavorites(List<String> favorites) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setStringList(_favorites, favorites);
  }

  /// 读取关注列表的id
  Future<List<String>> getFavorites() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? list = preferences.getStringList(_favorites);
    return list ?? [];
  }

  /// 清除当前位置的adcode
  Future<bool> clearFavorites() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.remove(_favorites);
  }

  /// 保存最近查看列表的id
  Future<bool> setRecently(List<String> recently) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setStringList(_recently, recently);
  }

  /// 读取最近查看列表的id
  Future<List<String>> getRecently() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? list = preferences.getStringList(_recently);
    return list ?? [];
  }

  /// 清除最近查看位置的adcode
  Future<bool> clearRecently() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.remove(_recently);
  }
}
