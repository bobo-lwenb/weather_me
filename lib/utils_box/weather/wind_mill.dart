import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/weather/weather_container.dart';

/// 风车
class WindMill extends ConsumerStatefulWidget {
  final bool isRotate;
  final bool isDay;

  const WindMill({
    Key? key,
    required this.isRotate,
    required this.isDay,
  }) : super(key: key);

  @override
  ConsumerState<WindMill> createState() => _WindMillState();
}

class _WindMillState extends ConsumerState<WindMill> with SingleTickerProviderStateMixin, WeatherController {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    if (widget.isRotate) togglePlay(ref, true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _startAngle = 26;

  @override
  Widget build(BuildContext context) {
    if (widget.isRotate) listenPlay(ref, _controller);
    AnimatedBuilder builder = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        _startAngle += .4;
        return CustomPaint(
          foregroundPainter: ForePainter(
            angle: _startAngle,
            isDay: widget.isDay,
          ),
          child: RepaintBoundary(
            child: CustomPaint(
              painter: BackPainter(isDay: widget.isDay),
            ),
          ),
        );
      },
    );
    return SizedBox(
      width: logicWidth,
      height: logicHeight,
      child: builder,
    );
  }
}

/// 绘制风车的叶片
class ForePainter extends CustomPainter {
  final double angle;
  final bool isDay;

  ForePainter({
    Key? key,
    required this.angle,
    required this.isDay,
  });

  /// 绘制风车叶片的画笔
  late final Paint _vanePaint = Paint()
    ..isAntiAlias = true
    ..strokeWidth = 3.px
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round
    ..color = isDay
        ? Color(int.parse('181d4b', radix: 16)).withAlpha(255)
        : Color(int.parse('281f1d', radix: 16)).withAlpha(255);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < 4; i++) {
      canvas.save();
      canvas.translate(size.width * .735, size.height - 700.px);
      canvas.rotate(-(pi / 2 * i + pi / 180 * angle) % (2 * pi));
      canvas.translate(-size.width * .735, -(size.height - 700.px));
      _drawVane(canvas, size);
      canvas.restore();
    }
  }

  /// 绘制叶片
  void _drawVane(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(size.width * .735, size.height - 700.px),
      Offset(size.width * .735, size.height - 875.px),
      _vanePaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * .72,
        size.height - 870.px,
        35.px,
        130.px,
      ),
      _vanePaint,
    );
  }

  @override
  bool shouldRepaint(covariant ForePainter oldDelegate) {
    return oldDelegate.angle != angle || oldDelegate.isDay != isDay;
  }
}

/// 绘制风车背景，包括山坡、风车的底座
class BackPainter extends CustomPainter {
  final bool isDay;

  BackPainter({
    required this.isDay,
  });

  /// 绘制山坡的画笔
  late final Paint _hillsidePaint = Paint()
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round
    ..shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: isDay
          ? [
              Color(int.parse('b7ba6b', radix: 16)).withAlpha(255),
              Color(int.parse('5c7a29', radix: 16)).withAlpha(255),
            ]
          : [
              Color(int.parse('27342b', radix: 16)).withAlpha(255),
              Color(int.parse('122e29', radix: 16)).withAlpha(255),
            ],
    ).createShader(
      Rect.fromLTWH(0, logicHeight - 400.px, logicWidth, 400.px),
    );

  /// 绘制风车底座的画笔
  late final Paint _housePaint = Paint()
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    _drawHillside(canvas, size);
    _drawWindmillHouse(canvas, size);
  }

  /// 绘制风车的底座
  void _drawWindmillHouse(Canvas canvas, Size size) {
    // 绘制白色的主体
    _housePaint
      ..style = PaintingStyle.fill
      ..color = isDay
          ? Color(int.parse('d3d7d4', radix: 16)).withAlpha(255)
          : Color(int.parse('3e4145', radix: 16)).withAlpha(255);

    Offset controllPoint = Offset(size.width * .735, size.height - 800.px);
    Offset endPoint = Offset(size.width * .77, size.height - 650.px);
    Path path = Path()
      ..reset()
      ..moveTo(size.width * .69, size.height - 500.px)
      ..lineTo(size.width * .7, size.height - 650.px)
      ..quadraticBezierTo(controllPoint.dx, controllPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width * .78, size.height - 500.px)
      ..close();
    canvas.drawPath(path, _housePaint);

    // 绘制黑色边框
    _housePaint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.px
      ..color = Colors.black54;
    canvas.drawPath(path, _housePaint);

    // 绘制门框
    controllPoint = Offset(size.width * .73, size.height - 530.px);
    endPoint = Offset(size.width * .74, size.height - 520.px);
    path
      ..reset()
      ..moveTo(size.width * .72, size.height - 500.px)
      ..lineTo(size.width * .72, size.height - 520.px)
      ..quadraticBezierTo(controllPoint.dx, controllPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width * .74, size.height - 500.px);
    canvas.drawPath(path, _housePaint);

    // 绘制连接叶片的圆点
    _housePaint
      ..style = PaintingStyle.fill
      ..color = Colors.black54;
    canvas.drawCircle(Offset(size.width * .735, size.height - 700.px), 6.px, _housePaint);
  }

  /// 绘制山坡
  void _drawHillside(Canvas canvas, Size size) {
    Offset controllPoint = Offset(size.width / 3, size.height - 550.px);
    Offset endPoint = Offset(size.width, size.height - 550.px);
    Path path = Path()
      ..moveTo(0, size.height - 400.px)
      ..quadraticBezierTo(controllPoint.dx, controllPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, _hillsidePaint);
  }

  @override
  bool shouldRepaint(covariant BackPainter oldDelegate) {
    return oldDelegate.isDay != isDay;
  }
}
