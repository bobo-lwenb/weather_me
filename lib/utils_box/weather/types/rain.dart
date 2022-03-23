import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/utils_box/weather/weather_container.dart';
import 'package:weather_me/utils_box/size_fit.dart';

/// 下雨
class Rain extends ConsumerStatefulWidget {
  final bool isDay;
  final bool isRotate;
  final RainType type;

  const Rain({
    Key? key,
    required this.isDay,
    this.isRotate = true,
    required this.type,
  }) : super(key: key);

  @override
  _RainState createState() => _RainState();
}

class _RainState extends ConsumerState<Rain> with SingleTickerProviderStateMixin, WeatherController {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final List<RaindRop> _raindRops = List.generate(
    _raindRopNum(widget.type),
    (index) => RaindRop(isDay: widget.isDay, type: widget.type),
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
    Widget rain = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        for (var raindRop in _raindRops) {
          raindRop.fall();
        }
        return CustomPaint(
          painter: RainPainter(
            isDay: widget.isDay,
            type: widget.type,
            raindRops: _raindRops,
          ),
        );
      },
    );
    return rain;
  }

  int _raindRopNum(RainType type) {
    int num = 50;
    switch (type) {
      case RainType.showers:
        num = 30;
        break;
      case RainType.drizzle:
        num = 10;
        break;
      case RainType.lightRain:
        num = 100;
        break;
      case RainType.mediumRain:
        num = 200;
        break;
      case RainType.heavyRain:
        num = 300;
        break;
      case RainType.rainstorm:
        num = 500;
        break;
      case RainType.torrentialRain:
        num = 700;
        break;
      case RainType.superTorrentialRain:
        num = 800;
        break;
      case RainType.extremeRainfall:
        num = 1000;
        break;
      default:
    }
    return num;
  }
}

class RainPainter extends CustomPainter {
  final bool isDay;
  final RainType type;
  final List<RaindRop> raindRops;

  RainPainter({
    required this.isDay,
    required this.type,
    required this.raindRops,
  });

  late final Paint _paint = Paint()
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(clipRect);
    canvas.save();
    Color color = isDay ? Colors.grey[400]! : Colors.blueGrey;
    for (var rainrop in raindRops) {
      _paint
        ..color = color.withAlpha((rainrop.alpha * 255).toInt())
        ..strokeWidth = rainrop.width;
      Offset start = Offset(rainrop.x, rainrop.y);
      Offset end = Offset(rainrop.x, rainrop.y - rainrop.length);
      canvas.drawLine(start, end, _paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class RaindRop {
  final bool isDay;
  final RainType type;

  RaindRop({
    required this.isDay,
    required this.type,
  });

  late double x = _x();
  late double y = _y();
  late double velocity = _velocity();
  late double length = _length();
  late double width = _width(type);
  late double alpha = _alpha();

  void fall() {
    y += velocity;
    if (y > logicHeight) {
      x = _x();
      y = 0;
      velocity = _velocity();
      length = _length();
      width = _width(type);
      alpha = _alpha();
    }
  }

  double _x() => Random().nextDouble() * logicWidth;

  double _y() => Random().nextDouble() * logicHeight;

  double _velocity() => Random().nextDouble() * 20.px + 20.px;

  double _length() => Random().nextDouble() * 60.px + 60.px;

  double _width(RainType type) {
    double width = _thin();
    switch (type) {
      case RainType.showers:
      case RainType.drizzle:
      case RainType.lightRain:
      case RainType.mediumRain:
        width = _thin();
        break;
      case RainType.heavyRain:
      case RainType.rainstorm:
      case RainType.torrentialRain:
      case RainType.superTorrentialRain:
      case RainType.extremeRainfall:
        width = _thick();
        break;
    }
    return width;
  }

  double _thin() => Random().nextDouble() * 1.px + 1.px;

  double _thick() => Random().nextDouble() * 2.px + 2.px;

  double _alpha() => Random().nextDouble();
}

enum RainType {
  /// 阵雨、强阵雨、雷阵雨、强雷阵雨、雷阵雨伴有冰雹、阵雨夹雪
  showers,

  /// 毛毛雨/细雨
  drizzle,

  /// 小雨、小到中雨、雨、雨夹雪
  lightRain,

  /// 中雨、冻雨、中到大雨、雨雪天气
  mediumRain,

  /// 大雨、大到暴雨
  heavyRain,

  /// 暴雨、暴雨到大暴雨
  rainstorm,

  /// 大暴雨、大暴雨到特大暴雨
  torrentialRain,

  /// 特大暴雨
  superTorrentialRain,

  /// 极端降雨
  extremeRainfall,
}
