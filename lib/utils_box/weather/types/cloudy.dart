import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/utils_box/weather/weather_container.dart';
import 'package:weather_me/utils_box/utils_image.dart';
import 'package:weather_me/utils_box/size_fit.dart';

/// 多云、阴类型的天气
class Cloudy extends ConsumerStatefulWidget {
  final bool isDay;
  final CloudType type;

  const Cloudy({
    Key? key,
    required this.isDay,
    required this.type,
  }) : super(key: key);

  @override
  PartlyCloudyState createState() => PartlyCloudyState();
}

class PartlyCloudyState extends ConsumerState<Cloudy> with SingleTickerProviderStateMixin, WeatherController {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final CloudConfig _config1 = CloudConfig(type: widget.type);
  late final CloudConfig _config2 = CloudConfig(type: widget.type);
  late final CloudConfig _config3 = CloudConfig(type: widget.type);
  late final CloudConfig _config4 = CloudConfig(type: widget.type);
  late final CloudConfig _config5 = CloudConfig(type: widget.type);
  late final CloudConfig _config6 = CloudConfig(type: widget.type);

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

    List<Widget> children = widget.type == CloudType.partlyCloudy
        ? [
            _buildCloud(_config1, cloud_1),
            _buildCloud(_config2, cloud_2),
            _buildCloud(_config3, cloud_3),
            _buildCloud(_config4, cloud_4),
            _buildCloud(_config5, cloud_5),
            _buildCloud(_config6, cloud_6),
          ]
        : [
            _buildCloud(_config1, cloud_1),
            _buildCloud(_config4, cloud_4),
          ];
    Stack stack = Stack(
      children: children,
    );
    return SizedBox.expand(child: stack);
  }

  Widget _buildCloud(CloudConfig config, Image image) {
    AnimatedBuilder builder = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        config.move();
        Positioned positioned = Positioned(
          top: config.top,
          left: config.left,
          child: child!,
        );
        return positioned;
      },
      child: Opacity(
        opacity: widget.isDay ? .8 : .5,
        child: image,
      ),
    );
    return builder;
  }
}

/// 云朵的配置数据
class CloudConfig {
  final CloudType type;

  CloudConfig({
    required this.type,
  });

  /// 水平方向每一格的宽度，用于计算云朵左侧的起始位置
  final double _cellWidth = logicWidth / 4;

  /// 云朵的左边起始位置
  late final List<double> leftPositions = [-_cellWidth, -_cellWidth * 3, _cellWidth * 2, _cellWidth];
  late double left = leftPositions[Random().nextInt(4)];

  /// 垂直方向每一格的高度，用于计算云朵顶部的位置
  late final double _cellHeight = (type == CloudType.partlyCloudy ? 1 / 3 : 0) * logicHeight / 4;

  /// 云朵的顶端位置
  late final List<double> topPositions = [-_cellHeight, _cellHeight, _cellHeight * 2, _cellHeight * 4];
  late double top = topPositions[Random().nextInt(4)];

  /// 云朵的速度
  final List<double> velocitys = [.1.px, .15.px, .2.px, .25.px];
  late double velocity = velocitys[Random().nextInt(4)];

  void move() {
    left -= velocity;
    if (left < -logicWidth) {
      left = logicWidth;
      top = topPositions[Random().nextInt(4)];
      velocity = velocitys[Random().nextInt(4)];
    }
  }
}

enum CloudType {
  /// 少云
  lessCloudy,

  /// 晴间多云、多云
  partlyCloudy,
}
