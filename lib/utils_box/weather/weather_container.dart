import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/router/home/cards/sun_moon/model/sun_active.dart';
import 'package:weather_me/utils_box/weather/weather_animation.dart';

class WeatherContainer extends StatefulWidget {
  final String icon;

  const WeatherContainer({
    Key? key,
    required this.icon,
  }) : super(key: key);

  @override
  BackgroundContainerState createState() => BackgroundContainerState();
}

class BackgroundContainerState extends State<WeatherContainer> {
  @override
  Widget build(BuildContext context) {
    return WeatherAnimation(icon: widget.icon);
  }
}

/// 用于控制天气背景的播放和暂停
mixin WeatherController {
  void togglePlay(WidgetRef ref, bool isStop) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(isPlayProvider.notifier).toggle(isStop);
    });
  }

  void listenPlay(WidgetRef ref, AnimationController controller) {
    ref.listen<bool>(isPlayProvider, (older, newer) {
      newer ? controller.repeat() : controller.stop();
    });
  }
}

/// 天气背景动画播放开关的 provider
final isPlayProvider = StateNotifierProvider<IsPalyNotifier, bool>((ref) {
  return IsPalyNotifier();
});

class IsPalyNotifier extends StateNotifier<bool> {
  IsPalyNotifier() : super(false);

  void toggle(bool isStop) => state = isStop;
}

/// 日升日落的provider
final sunActiveProvider = StateNotifierProvider<SunActiveNotifier, SunActive>((ref) {
  return SunActiveNotifier();
});

class SunActiveNotifier extends StateNotifier<SunActive> {
  SunActiveNotifier() : super(SunActive.empty());

  void updateSunActive(SunActive active) => state = active;

  /// 判断白天黑夜，用于天气背景的颜色切换
  bool isDay() {
    DateTime startTime = DateTime.parse(state.sunrise).toLocal();
    DateTime endTime = DateTime.parse(state.sunset).toLocal();
    DateTime now = DateTime.now().toLocal();
    return now.isAfter(startTime) && now.isBefore(endTime) ? true : false;
  }
}
