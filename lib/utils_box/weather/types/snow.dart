import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/utils_box/weather/weather_container.dart';
import 'package:weather_me/utils_box/size_fit.dart';

/// 下雪
class Snow extends ConsumerStatefulWidget {
  final bool isDay;
  final SnowType type;

  const Snow({
    Key? key,
    required this.isDay,
    required this.type,
  }) : super(key: key);

  @override
  SnowState createState() => SnowState();
}

class SnowState extends ConsumerState<Snow> with SingleTickerProviderStateMixin, WeatherController {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final List<Snowflake> _snowflakes = List.generate(
    _snowflakeNum(widget.type),
    (index) => Snowflake(),
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
    Widget snow = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        for (var snowflake in _snowflakes) {
          snowflake.fall();
        }
        return CustomPaint(
          painter: SnowPainter(
            isDay: widget.isDay,
            type: widget.type,
            snowflake: _snowflakes,
          ),
          isComplex: true,
        );
      },
    );
    return snow;
  }

  int _snowflakeNum(SnowType type) {
    int num = 200;
    switch (type) {
      case SnowType.snowShowers:
        num = 50;
        break;
      case SnowType.lightSnow:
        num = 100;
        break;
      case SnowType.mediumSnow:
        num = 200;
        break;
      case SnowType.heavySnow:
        num = 300;
        break;
      case SnowType.snowStorm:
        num = 500;
        break;
    }
    return num;
  }
}

class SnowPainter extends CustomPainter {
  final bool isDay;
  final SnowType type;
  final List<Snowflake> snowflake;

  SnowPainter({
    required this.isDay,
    required this.type,
    required this.snowflake,
  });

  late final Paint _paint = Paint()..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(clipRect);
    canvas.save();
    for (var snowflake in snowflake) {
      _paint.color = _snowColor(isDay, type, snowflake.alpha);
      canvas.drawCircle(Offset(snowflake.x, snowflake.y), snowflake.radius, _paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  Color _snowColor(bool isDay, SnowType type, double alpha) {
    Color color = Colors.white.withAlpha((alpha * 126).toInt());
    switch (type) {
      case SnowType.snowShowers:
      case SnowType.lightSnow:
        color = isDay ? Colors.white.withAlpha((alpha * 126).toInt()) : Colors.grey.withAlpha((alpha * 126).toInt());
        break;
      case SnowType.mediumSnow:
      case SnowType.heavySnow:
      case SnowType.snowStorm:
        color = isDay ? Colors.white.withAlpha((alpha * 255).toInt()) : Colors.grey.withAlpha((alpha * 255).toInt());
        break;
    }
    return color;
  }
}

class Snowflake {
  late double x = _x();
  late double y = _y();
  late double velocity = _velocity();
  late double radius = _radius();
  late double alpha = _ralpha();

  void fall() {
    y += velocity;
    if (y > logicHeight) {
      x = _x();
      y = 0;
      velocity = _velocity();
      radius = _radius();
      alpha = _ralpha();
    }
  }

  double _x() => Random().nextDouble() * logicWidth;

  double _y() => Random().nextDouble() * logicHeight;

  double _velocity() => Random().nextDouble() * 2.px + 4.px;

  double _radius() => Random().nextDouble() * 2.px + 2.px;

  double _ralpha() => radius / 4.px;
}

enum SnowType {
  /// 阵雪
  snowShowers,

  /// 小雪、小到中雪、雪
  lightSnow,

  ///  中雪、中到大雪
  mediumSnow,

  /// 大雪、大到暴雪
  heavySnow,

  /// 暴雪
  snowStorm
}
