import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/utils_box/weather/weather_container.dart';
import 'package:weather_me/utils_box/utils_image.dart';
import 'package:weather_me/utils_box/size_fit.dart';

/// 闪电
class Lightning extends ConsumerStatefulWidget {
  final bool isDay;
  final LightningType type;

  const Lightning({
    Key? key,
    required this.isDay,
    required this.type,
  }) : super(key: key);

  @override
  LightningState createState() => LightningState();
}

class LightningState extends ConsumerState<Lightning> with SingleTickerProviderStateMixin, WeatherController {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final FlashBang _flashBang = FlashBang();
  late final LightningConfig _config1 = LightningConfig(isTop: true);
  late final LightningConfig _config2 = LightningConfig(isTop: true);
  late final LightningConfig _config3 = LightningConfig(isTop: true);
  late final LightningConfig _config4 = LightningConfig(isTop: true);
  late final LightningConfig _config5 = LightningConfig(isTop: true);
  // late final LightningConfig _config6 = LightningConfig(isTop: false);
  // late final LightningConfig _config7 = LightningConfig(isTop: false);
  late final LightningConfig _config8 = LightningConfig(isTop: false);
  late final LightningConfig _config9 = LightningConfig(isTop: false);

  @override
  void initState() {
    super.initState();
    togglePlay(ref, true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    listenPlay(ref, _controller);

    List<Widget> children = widget.type == LightningType.thunder
        ? [
            _buildLightning(_config1, lightning_top_1),
            _buildLightning(_config2, lightning_top_2),
            _buildLightning(_config3, lightning_top_3),
            // _buildLightning(_config4, lightning_top_4),
            // _buildLightning(_config5, lightning_top_5),
          ]
        : [
            _buildFlashAll(_flashBang),
            // _buildLightning(_config1, lightning_top_1),
            // _buildLightning(_config2, lightning_top_2),
            _buildLightning(_config3, lightning_top_3),
            _buildLightning(_config4, lightning_top_4),
            _buildLightning(_config5, lightning_top_5),
            // _buildLightning(_config6, lightning_6),
            // _buildLightning(_config7, lightning_7),
            _buildLightning(_config8, lightning_8),
            _buildLightning(_config9, lightning_9),
          ];
    Stack stack = Stack(
      children: children,
    );
    return SizedBox.expand(child: stack);
  }

  Widget _buildLightning(LightningConfig config, Image image) {
    AnimatedBuilder builder = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        config.flashing();
        return Positioned(
          top: config.top,
          left: config.left,
          child: Opacity(
            opacity: config.alpha,
            child: child!,
          ),
        );
      },
      child: image,
    );
    return builder;
  }

  Widget _buildFlashAll(FlashBang bang) {
    AnimatedBuilder builder = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        bang.flashAll();
        Container container = Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.white, bang.isFlashAll ? Colors.white : Colors.black38],
                stops: const [0.0, 0.6, 1.0]),
          ),
        );
        Opacity opacity = Opacity(
          opacity: bang.alpha,
          child: container,
        );
        return Positioned(child: opacity);
      },
    );
    return builder;
  }
}

class LightningConfig {
  final bool isTop;

  LightningConfig({required this.isTop});

  /// 闪电透明度的变化速度
  late final double _velocity = _getVelocity();

  double _getVelocity() => Random().nextDouble() * 0.005 + 0.005;

  /// 闪电的左侧坐标
  late double left = _getLeft();

  double _getLeft() {
    return isTop ? 0 : -logicWidth / 2 + logicWidth / 2 * Random().nextInt(3);
  }

  /// 闪电的顶部坐标
  late double top = _getTop();

  double _getTop() {
    return isTop ? 0 : -logicHeight / 4 + logicHeight / 4 * Random().nextInt(4);
  }

  /// 闪电透明度
  late double alpha = _alpha();

  double _alpha() => Random().nextDouble();

  /// 用于控制闪电的频率
  late double _timing = alpha;

  void flashing() {
    _timing -= _velocity;
    if (_timing >= 0) {
      alpha -= _velocity;
    } else if (_timing < 0 && _timing > -3) {
      alpha = 0;
    } else {
      alpha = 1;
      _timing = alpha;
      left = _getLeft();
      top = _getTop();
    }
  }
}

class FlashBang {
  late final List<int> _thresholds = [-3, -3];
  late final List<bool> _flashAlls = [true, false];

  late int _threshold = _thresholds[Random().nextInt(2)];

  late bool isFlashAll = _flashAlls[Random().nextInt(2)];

  late final double _velocity = _getVelocity();

  double _getVelocity() => Random().nextDouble() * 0.005 + 0.005;

  double alpha = 0;

  /// 用于控制闪屏的频率
  late double _timing = alpha;

  void flashAll() {
    _timing -= _velocity;
    if (_timing >= 0) {
      alpha -= _velocity;
    } else if (_timing < 0 && _timing > _threshold) {
      alpha = 0;
    } else {
      alpha = 1;
      _timing = alpha;
      _threshold = _thresholds[Random().nextInt(2)];
      isFlashAll = _flashAlls[Random().nextInt(2)];
    }
  }
}

enum LightningType {
  /// 雷
  thunder,

  /// 强雷
  strongThunder
}
