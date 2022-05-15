import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/utils_box/weather/weather_container.dart';
import 'package:weather_me/utils_box/utils_image.dart';
import 'package:weather_me/utils_box/size_fit.dart';

/// 扬尘、浮尘、沙尘暴
class SandStorm extends ConsumerStatefulWidget {
  final bool isDay;
  final SandStormType type;

  const SandStorm({
    Key? key,
    required this.isDay,
    required this.type,
  }) : super(key: key);

  @override
  SandStormState createState() => SandStormState();
}

class SandStormState extends ConsumerState<SandStorm> with SingleTickerProviderStateMixin, WeatherController {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  late final StormCloudConfig _config1 = StormCloudConfig();
  late final StormCloudConfig _config2 = StormCloudConfig();
  late final StormCloudConfig _config3 = StormCloudConfig();
  late final StormCloudConfig _config4 = StormCloudConfig();
  late final StormCloudConfig _config5 = StormCloudConfig();
  late final StormCloudConfig _config6 = StormCloudConfig();
  late final StormCloudConfig _config7 = StormCloudConfig();
  late final StormCloudConfig _config8 = StormCloudConfig();
  late final StormCloudConfig _config9 = StormCloudConfig();
  late final StormCloudConfig _config10 = StormCloudConfig();

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
        Positioned(child: widget.isDay ? sunny_clear_2 : const SizedBox()),
        _buildCloud(_config1, cloud_thin_1),
        _buildCloud(_config2, cloud_thin_2),
        _buildCloud(_config3, cloud_thin_3),
        _buildCloud(_config4, cloud_thin_4),
        _buildCloud(_config5, cloud_thin_5),
        _buildCloud(_config6, cloud_11),
        _buildCloud(_config7, cloud_12),
        _buildCloud(_config8, cloud_13),
        _buildCloud(_config9, cloud_14),
        _buildCloud(_config10, cloud_15),
      ],
    );
    return SizedBox.expand(child: stack);
  }

  Widget _buildCloud(StormCloudConfig config, Image image) {
    AnimatedBuilder builder = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        config.move();
        return Positioned(
          top: config.top,
          left: config.left,
          child: child!,
        );
      },
      child: image,
    );
    return builder;
  }
}

class StormCloudConfig {
  final double _cellWidth = logicWidth / 4;
  late final List<double> leftPositions = [-_cellWidth, -_cellWidth * 3, -_cellWidth * 2, _cellWidth];
  late double left = leftPositions[Random().nextInt(4)];

  final List<double> velocitys = [.1.px, 0.15.px, .2.px, .25.px];
  late final double velocity = velocitys[Random().nextInt(4)];

  final double _cellHeight = logicHeight / 4;
  late final List<double> topPositions = [-_cellHeight, 0, _cellHeight, _cellHeight * 1 / 2, _cellHeight * 3 / 2];
  late double top = topPositions[Random().nextInt(4)];

  void move() {
    left += velocity;
    if (left > 2 * logicWidth) {
      left = leftPositions[Random().nextInt(4)];
      top = topPositions[Random().nextInt(4)];
    }
  }
}

enum SandStormType {
  /// 扬沙、浮尘
  dust,

  /// 沙尘暴
  sandstorm,

  /// 强沙尘暴
  strongSandstorm
}
