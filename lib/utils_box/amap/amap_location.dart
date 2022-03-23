import 'dart:async';
import 'dart:io';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_me/utils_box/amap/amap_key.dart';

/// 高德定位
class AmapLocation {
  late final AMapFlutterLocation _locationPlugin = AMapFlutterLocation();
  late StreamSubscription<Map<String, Object>> _locationListener;

  /// 初始化
  void init() {
    AMapFlutterLocation.setApiKey(androidKey, iosKey); // android、iOS的key需要自行申请
  }

  /// 定位功能是否可用
  Future<bool> askForLocation(BuildContext context) async {
    bool? isPrivacy = await _askForPrivacy(context);
    if (isPrivacy == null || !isPrivacy) return false;
    bool isGranted = await _requestPermission();
    if (isGranted) {
      /// iOS 获取native精度类型
      if (Platform.isIOS) _requestAccuracyAuthorization();
    }
    return isGranted;
  }

  /// 开始定位
  void startLocation(Function(Map<String, dynamic>) fun) {
    _locationListener = _locationPlugin.onLocationChanged().listen((Map<String, Object> result) {
      if (result['adCode'] != null) {
        fun(result);
        _locationPlugin.destroy();
      }
    });
    _setLocationOption();
    _locationPlugin.startLocation();
  }

  /// 停止定位
  void stopLocation() {
    _locationPlugin.stopLocation();
  }

  /// 释放
  void dispose() {
    /// 移除定位监听
    _locationListener.cancel();

    /// 销毁定位
    _locationPlugin.destroy();
  }

  /// 设置定位参数
  void _setLocationOption() {
    AMapLocationOption locationOption = AMapLocationOption();

    ///是否单次定位
    locationOption.onceLocation = false;

    ///是否需要返回逆地理信息
    locationOption.needAddress = true;

    ///逆地理信息的语言类型
    locationOption.geoLanguage = GeoLanguage.DEFAULT;

    locationOption.desiredLocationAccuracyAuthorizationMode = AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;

    locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

    ///设置Android端连续定位的定位间隔
    locationOption.locationInterval = 2000;

    ///设置Android端的定位模式<br>
    ///可选值：<br>
    ///<li>[AMapLocationMode.Battery_Saving]</li>
    ///<li>[AMapLocationMode.Device_Sensors]</li>
    ///<li>[AMapLocationMode.Hight_Accuracy]</li>
    locationOption.locationMode = AMapLocationMode.Hight_Accuracy;

    ///设置iOS端的定位最小更新距离<br>
    locationOption.distanceFilter = -1;

    ///设置iOS端期望的定位精度
    /// 可选值：<br>
    /// <li>[DesiredAccuracy.Best] 最高精度</li>
    /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>
    /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
    /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
    /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
    locationOption.desiredAccuracy = DesiredAccuracy.Best;

    ///设置iOS端是否允许系统暂停定位
    locationOption.pausesLocationUpdatesAutomatically = false;

    ///将定位参数设置给定位插件
    _locationPlugin.setLocationOption(locationOption);
  }

  /// 隐私政策
  Future<bool?> _askForPrivacy(BuildContext context) async {
    /// 设置是否已经包含高德隐私政策并弹窗展示显示用户查看，如果未包含或者没有弹窗展示，高德定位SDK将不会工作
    ///
    /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy
    /// <b>必须保证在调用定位功能之前调用， 建议首次启动App时弹出《隐私政策》并取得用户同意</b>
    ///
    /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy
    ///
    /// [hasContains] 隐私声明中是否包含高德隐私政策说明
    ///
    /// [hasShow] 隐私权政策是否弹窗展示告知用户
    AMapFlutterLocation.updatePrivacyShow(true, true);
    AMapFlutterLocation.updatePrivacyAgree(true);
    return true;
    // return showModalBottomSheet<bool>(
    //   context: context,
    //   isDismissible: false,
    //   builder: (context) {
    //     return GestureDetector(
    //       child: SizedBox(
    //         height: window.physicalSize.height,
    //         child: const Text('_askForPrivacy'),
    //       ),
    //       onTap: () {
    //         /// 设置是否已经取得用户同意，如果未取得用户同意，高德定位SDK将不会工作
    //         ///
    //         /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy
    //         ///
    //         /// <b>必须保证在调用定位功能之前调用, 建议首次启动App时弹出《隐私政策》并取得用户同意</b>
    //         ///
    //         /// [hasAgree] 隐私权政策是否已经取得用户同意
    //         AMapFlutterLocation.updatePrivacyAgree(true);
    //         Navigator.of(context).pop(true);
    //       },
    //     );
    //   },
    // );
  }

  /// 获取iOS native的accuracyAuthorization类型
  void _requestAccuracyAuthorization() async {
    AMapAccuracyAuthorization currentAccuracyAuthorization = await _locationPlugin.getSystemAccuracyAuthorization();
    if (currentAccuracyAuthorization == AMapAccuracyAuthorization.AMapAccuracyAuthorizationFullAccuracy) {
      // log("精确定位类型");
    } else if (currentAccuracyAuthorization == AMapAccuracyAuthorization.AMapAccuracyAuthorizationReducedAccuracy) {
      // log("模糊定位类型");
    } else {
      // log("未知定位类型");
    }
  }

  /// 请求定位权限
  Future<bool> _requestPermission() async {
    bool hasLocationPermission = await _requestLocationPermission();
    return hasLocationPermission;
  }

  /// 申请定位权限 - 授予定位权限返回true， 否则返回false
  Future<bool> _requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      // 已经授权
      return true;
    } else {
      // 未授权则发起一次申请
      status = await Permission.location.request();
      return status == PermissionStatus.granted;
    }
  }
}
