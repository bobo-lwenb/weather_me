import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/utils_box/weather/weather_container.dart';
import 'package:weather_me/utils_box/utils_image.dart';
import 'package:weather_me/utils_box/size_fit.dart';

/// 雾
class Foggy extends ConsumerStatefulWidget {
  final bool isDay;
  final FoggyType type;

  const Foggy({
    Key? key,
    required this.isDay,
    required this.type,
  }) : super(key: key);

  @override
  FoggyState createState() => FoggyState();
}

class FoggyState extends ConsumerState<Foggy> with SingleTickerProviderStateMixin, WeatherController {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  late final FogConfig _config1 = FogConfig();
  late final FogConfig _config2 = FogConfig();
  late final FogConfig _config3 = FogConfig();
  late final FogConfig _config4 = FogConfig();
  late final FogConfig _config5 = FogConfig();
  late final FogConfig _config6 = FogConfig();
  late final FogConfig _config7 = FogConfig();
  late final FogConfig _config8 = FogConfig();
  late final FogConfig _config9 = FogConfig();
  late final FogConfig _config10 = FogConfig();
  late final FogConfig _config11 = FogConfig();
  late final FogConfig _config12 = FogConfig();
  late final FogConfig _config13 = FogConfig();
  late final FogConfig _config14 = FogConfig();
  late final FogConfig _config15 = FogConfig();

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
    Stack stack = Stack(
      children: [
        _buildFog(_config1, fog_1),
        _buildFog(_config2, fog_1),
        _buildFog(_config3, fog_2),
        _buildFog(_config4, fog_2),
        _buildFog(_config5, fog_3),
        _buildFog(_config6, fog_3),
        _buildFog(_config7, fog_4),
        _buildFog(_config8, fog_4),
        _buildFog(_config9, fog_5),
        _buildFog(_config10, fog_5),
        _buildFog(_config11, cloud_6),
        _buildFog(_config12, cloud_7),
        _buildFog(_config13, cloud_8),
        _buildFog(_config14, cloud_9),
        _buildFog(_config15, cloud_10),
      ],
    );
    return SizedBox.expand(child: stack);
  }

  Widget _buildFog(FogConfig config, Image image) {
    AnimatedBuilder builder = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        config.move();
        Widget widget = Positioned(top: config.top, left: config.left, child: child!);
        return widget;
      },
      child: Opacity(
        opacity: _foggyAlpha(widget.type),
        child: image,
      ),
    );
    return builder;
  }

  double _foggyAlpha(FoggyType type) {
    double alpha = .5;
    switch (type) {
      case FoggyType.mist:
        alpha = .2;
        break;
      case FoggyType.fog:
        alpha = .5;
        break;
      case FoggyType.heavyFog:
        alpha = .7;
        break;
      case FoggyType.strongFog:
        alpha = .9;
        break;
    }
    return alpha;
  }
}

class FogConfig {
  final double _cellWidth = logicWidth / 4;

  late final List<double> leftPositions = [-_cellWidth, -_cellWidth * 3, _cellWidth * 2, _cellWidth];
  late double left = leftPositions[Random().nextInt(4)];

  final double _cellHeigh = logicHeight / 4;
  late final List<double> topPositions = [-_cellHeigh, 0, _cellHeigh, _cellHeigh * 1 / 2, _cellHeigh * 3 / 2];
  late double top = topPositions[Random().nextInt(4)];

  final List<double> velocitys = [.1.px, 0.15.px, .2.px, .25.px];
  late final double velocity = velocitys[Random().nextInt(4)];

  void move() {
    left -= velocity;
    if (left < -logicWidth) {
      left = logicWidth;
      top = topPositions[Random().nextInt(4)];
    }
  }
}

enum FoggyType {
  /// 薄雾
  mist,

  /// 雾
  fog,

  /// 大雾、浓雾
  heavyFog,

  /// 强浓雾、特强浓雾
  strongFog,
}
