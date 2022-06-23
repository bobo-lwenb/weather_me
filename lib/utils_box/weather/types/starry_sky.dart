import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/utils_box/weather/weather_container.dart';
import 'package:weather_me/utils_box/size_fit.dart';

/// 星空
class StarrySky extends ConsumerStatefulWidget {
  final bool isDay;
  final StarrySkyType type;

  const StarrySky({
    Key? key,
    required this.isDay,
    required this.type,
  }) : super(key: key);

  @override
  StarrySkyState createState() => StarrySkyState();
}

class StarrySkyState extends ConsumerState<StarrySky> with SingleTickerProviderStateMixin, WeatherController {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final List<StarConfig> _stars = List.generate(
    widget.type == StarrySkyType.clear ? 500 : 100,
    (index) => StarConfig(),
  );
  late final List<MeteorConfig> _meteors = List.generate(
    widget.type == StarrySkyType.clear ? 2 : 0,
    (index) => MeteorConfig(),
  );

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
    Widget builder = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        for (var star in _stars) {
          star.glint();
        }
        for (var meteor in _meteors) {
          meteor.fling();
        }
        return CustomPaint(
          painter: StarrySkyPainter(
            stars: _stars,
            meteors: _meteors,
          ),
          isComplex: true,
        );
      },
    );
    return builder;
  }
}

class StarrySkyPainter extends CustomPainter {
  late final Paint _paint = Paint()
    ..isAntiAlias = true
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5)
    ..strokeCap = ui.StrokeCap.round;
  late ui.Gradient _gradient;
  final List<StarConfig> stars;
  final List<MeteorConfig> meteors;

  StarrySkyPainter({required this.stars, required this.meteors});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(clipRect);
    canvas.save();
    for (var star in stars) {
      _paint.color = Colors.white.withAlpha((star.alpha * 255).toInt());
      canvas.drawCircle(Offset(star.x, star.y), star.alpha * 3.px, _paint);
    }
    canvas.restore();
    canvas.save();
    _paint
      ..color = Colors.white
      ..strokeWidth = 2.px;
    for (var meteor in meteors) {
      _gradient = ui.Gradient.linear(
        meteor.startPointer,
        meteor.endPointer,
        <Color>[const Color(0xFFFFFFFF), const Color(0x00FFFFFF)],
      );
      _paint.shader = _gradient;
      canvas.drawLine(meteor.startPointer, meteor.endPointer, _paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class StarConfig {
  bool reverse = false;
  late double x = _x();
  late double y = _y();
  late double alpha = _alpha();
  late double radius = _radius();

  double _x() => Random().nextDouble() * logicWidth;

  double _y() => Random().nextDouble() * (logicHeight - 200.px);

  double _alpha() => Random().nextDouble();

  double _radius() => _alpha() * 3.px;

  /// 开始闪烁
  void glint() {
    if (reverse) {
      alpha += 0.005;
      if (alpha > 1) {
        alpha = 1;
        reverse = false;
      }
    } else {
      alpha -= 0.001;
      if (alpha < 0) {
        alpha = 0;
        x = _x();
        y = _y();
        reverse = true;
      }
    }
  }
}

class MeteorConfig {
  // 流星划过的距离
  double _distance = 0;

  // 流星需要滑过的长度
  final double _totalDistance = 1500.px;

  late final double _velocity = _getVelocity();

  // 每一次速度的点位
  late final Offset _velocityPointer = _getVelocityPointer();

  // 流星的长度
  late final double _length = _getLength();

  // 流星的起点
  late Offset startPointer = endPointer;

  // 流星的终点
  late Offset endPointer = Offset(_endX(), _endY());

  late final double _angle = _getAngle();

  double _getVelocity() => Random().nextDouble() * 5.px + 20.px;

  Offset _getVelocityPointer() {
    double x = cos(_angle) * _velocity;
    double y = sin(_angle) * _velocity;
    return Offset(x, y);
  }

  double _getLength() => Random().nextDouble() * 200.px + 300.px;

  double _endX() => Random().nextDouble() * logicWidth * 2;

  double _endY() {
    double tempY = Random().nextDouble() * logicHeight;
    return tempY >= (logicHeight / 3 * 2) ? -tempY : tempY;
  }

  double _getAngle() => Random().nextDouble() * pi / 180 * 45;

  void fling() {
    _distance += _velocity;
    if (_distance < _length) {
      startPointer = _computePointer(startPointer);
    } else if (_distance >= _length && _distance < _totalDistance) {
      startPointer = _computePointer(startPointer);
      endPointer = _computePointer(endPointer);
    } else if (_distance >= _totalDistance) {
      endPointer = _computePointer(endPointer);
      if (startPointer.dx == endPointer.dx || startPointer.dy == endPointer.dy) {
        _distance = 0;
        endPointer = Offset(_endX(), _endY());
        startPointer = endPointer;
      }
    }
  }

  /// 计算点的位置
  Offset _computePointer(Offset pointer) {
    return Offset(
      pointer.dx - _velocityPointer.dx,
      pointer.dy + _velocityPointer.dy,
    );
  }
}

enum StarrySkyType {
  /// 晴
  clear,

  /// 晴间多云
  partlyCloudy,
}
