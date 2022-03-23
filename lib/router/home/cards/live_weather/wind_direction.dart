import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weather_me/utils_box/size_fit.dart';

class WindDirection extends StatelessWidget {
  final String angle;

  const WindDirection({
    Key? key,
    required this.angle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WindDirectionPainter(angle: angle),
    );
  }
}

/// 绘制风向圆盘
class WindDirectionPainter extends CustomPainter {
  final String angle;

  WindDirectionPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawDirection(canvas, size);
  }

  @override
  bool shouldRepaint(covariant WindDirectionPainter oldDelegate) {
    return oldDelegate.angle != angle;
  }

  /// 绘制风向箭头的paint
  late final Paint _directionPaint = Paint()
    ..isAntiAlias = true
    ..strokeWidth = 4.px
    ..style = PaintingStyle.stroke
    ..color = Color(int.parse('2b4490', radix: 16)).withAlpha(255);

  /// 绘制风向
  void _drawDirection(Canvas canvas, Size size) {
    double windAngle = pi / 180 * double.parse(angle);
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(windAngle);
    canvas.translate(-size.width / 2, -size.height / 2);

    Path directionPath = Path()
      ..moveTo(size.width / 2 - 10.px, 40.px)
      ..lineTo(size.width / 2, 30.px)
      ..lineTo(size.width / 2 + 10.px, 40.px);
    canvas.drawPath(directionPath, _directionPaint);
    canvas.drawLine(
      Offset(size.width / 2, 30.px),
      Offset(size.width / 2, size.height - 30.px),
      _directionPaint,
    );
    canvas.restore();
  }

  /// 绘制背景的paint
  late final Paint _backPaint = Paint()
    ..isAntiAlias = true
    ..strokeWidth = 4.px
    ..style = PaintingStyle.stroke
    ..color = Color(int.parse('3e4145', radix: 16)).withAlpha(255);

  /// 绘制背景
  void _drawBackground(Canvas canvas, Size size) {
    double radius = min(size.width, size.height) / 2;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, _backPaint);

    Size textSize = _measureText(
      'N',
      Color(int.parse('d71345', radix: 16)).withAlpha(255),
    );
    Offset centerOffset = Offset(
      (size.width - textSize.width) / 2,
      (size.height - textSize.height) / 2,
    );
    _textPaint.paint(
      canvas,
      centerOffset - Offset(0, radius) + Offset(0, textSize.height / 2 + 2.px),
    );

    textSize = _measureText(
      'E',
      Color(int.parse('3e4145', radix: 16)).withAlpha(255),
    );
    centerOffset = Offset(
      (size.width - textSize.width) / 2,
      (size.height - textSize.height) / 2,
    );
    _textPaint.paint(
      canvas,
      centerOffset + Offset(radius, 0) - Offset(textSize.width / 2 + 4.px, 0),
    );

    textSize = _measureText(
      'S',
      Color(int.parse('3e4145', radix: 16)).withAlpha(255),
    );
    centerOffset = Offset(
      (size.width - textSize.width) / 2,
      (size.height - textSize.height) / 2,
    );
    _textPaint.paint(
      canvas,
      centerOffset + Offset(0, radius) - Offset(0, textSize.height / 2 + 2.px),
    );

    textSize = _measureText(
      'W',
      Color(int.parse('3e4145', radix: 16)).withAlpha(255),
    );
    centerOffset = Offset(
      (size.width - textSize.width) / 2,
      (size.height - textSize.height) / 2,
    );
    _textPaint.paint(
      canvas,
      centerOffset - Offset(radius, 0) + Offset(textSize.width / 2 + 4.px, 0),
    );
  }

  // 绘制时间
  late TextPainter _textPaint;

  /// 测量文本的宽高
  Size _measureText(String text, Color color) {
    _textPaint = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    _textPaint.layout(maxWidth: 200.px, minWidth: 0);
    double width = _textPaint.width;
    double height = _textPaint.height;
    return Size(width, height);
  }
}
