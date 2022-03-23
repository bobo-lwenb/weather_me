import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_me/router/aqi_forecast/aqi_forecast_page.dart';
import 'package:weather_me/router/area_list/arae_list.dart';
import 'package:weather_me/router/daily/daily_page.dart';
import 'package:weather_me/router/home/home_container.dart';
import 'package:weather_me/router/hourly/hourly_page.dart';
import 'package:weather_me/router/living_forecast/living_forecast_page.dart';
import 'package:weather_me/router/setting/about_app.dart';
import 'package:weather_me/router/setting/appearance.dart';
import 'package:weather_me/router/setting/language.dart';
import 'package:weather_me/utils_box/utils_page/page_not_found.dart';
import 'package:weather_me/router/setting/setting_page.dart';
import 'package:weather_me/router/setting/unit.dart';
import 'package:weather_me/router/warning/warning_page.dart';

/// 路由跳转的便捷方法
void push(BuildContext context, {required String name}) => AppRouterDelegate.of(context).push(name);

class AppRouterDelegate extends RouterDelegate<String> with PopNavigatorRouterDelegateMixin<String>, ChangeNotifier {
  final _stack = <String>[];

  static AppRouterDelegate of(BuildContext context) {
    final delegate = Router.of(context).routerDelegate;
    assert(delegate is AppRouterDelegate, 'Delegate type must match');
    return delegate as AppRouterDelegate;
  }

  List<String> get stack => List.unmodifiable(_stack);

  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  String? get currentConfiguration => _stack.isNotEmpty ? _stack.last : null;

  @override
  Future<void> setInitialRoutePath(String configuration) {
    return setNewRoutePath(configuration);
  }

  @override
  Future<void> setNewRoutePath(String configuration) {
    _stack.add(configuration);
    return SynchronousFuture<void>(null);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _onPopPage,
      pages: [for (var name in _stack) _page(name)],
    );
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (_stack.isNotEmpty) {
      if (_stack.last == route.settings.name) {
        _stack.remove(route.settings.name);
        notifyListeners();
      }
    }
    return route.didPop(result);
  }

  void push(String newRoute) {
    _stack.add(newRoute);
    notifyListeners();
  }

  void remove(String routeName) {
    _stack.remove(routeName);
    notifyListeners();
  }

  Page _page(String name) {
    Widget widget;
    switch (name) {
      case '/':
        widget = const HomeContainer();
        break;
      case 'area_list': // 地区管理
        widget = const AreaList();
        break;
      case 'hourly': // 逐小时预报
        widget = const HourlyPage();
        break;
      case 'daily': // 逐天预报
        widget = const DailyPage();
        break;
      case 'aqi_forecast': // 空气质量预报
        widget = const AqiForecastPage();
        break;
      case 'living_forecast': // 生活指数预报
        widget = const LivingForecastPage();
        break;
      case 'warning': // 气象灾害预警
        widget = const WarningPage();
        break;
      case 'setting': // 设置页面
        widget = const SettingPage();
        break;
      case 'language': // 语言选择
        widget = const Language();
        break;
      case 'appearance': // 外观选择
        widget = const Appearance();
        break;
      case 'unit': // 单位选择
        widget = const Unit();
        break;
      case 'about': // 关于应用
        widget = const AboutApp();
        break;
      case 'license':
        widget = const LicensePage();
        break;
      default:
        widget = const PageNotFound();
    }
    return PageWrapper(
      key: ValueKey(name),
      name: name,
      child: widget,
    );
  }
}

class AppRouteParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(RouteInformation routeInformation) {
    return SynchronousFuture(routeInformation.location!);
  }

  @override
  RouteInformation? restoreRouteInformation(String configuration) {
    return RouteInformation(location: configuration);
  }
}

class PageWrapper extends Page {
  final Widget child;

  const PageWrapper({
    required LocalKey key,
    required String name,
    required this.child,
  }) : super(key: key, name: name);

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => child,
    );
  }
}
