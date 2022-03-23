import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/router/home/cards/sun_moon/model/moon_active.dart';
import 'package:weather_me/router/home/cards/sun_moon/model/sun_active.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_time.dart';

class Pallet extends CustomPainter {
  BuildContext context;
  final SunActive sun;
  final MoonActive moon;

  Pallet({
    required this.context,
    required this.sun,
    required this.moon,
  });

  /// 总分钟数
  final _totalMinutes = 24 * 60;
  late final _sunStartAngle = minutes(sun.sunrise) / _totalMinutes * pi * 2;
  late final _sunEndAngle = minutes(sun.sunset) / _totalMinutes * pi * 2;
  late final _moonStartAngle = minutes(moon.moonrise) / _totalMinutes * pi * 2;
  late final _moonEndAngle = minutes(moon.moonset) / _totalMinutes * pi * 2;

  /// 圆盘的paint
  late final Paint _pallectPaint = Paint()
    ..color = Color(int.parse('3e4145', radix: 16)).withAlpha(255)
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 8.px;

  /// 圆盘白天时间的paint
  late final Paint _dayPaint = Paint()
    ..color = Colors.orangeAccent
    ..isAntiAlias = true;

  /// 圆盘太阳时间的paint
  late final Paint _sunPaint = Paint()
    ..color = Colors.orangeAccent
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 8.px;

  /// 圆盘黑夜时间的paint
  late final Paint _nightPaint = Paint()
    ..color = Colors.blueGrey
    ..isAntiAlias = true;

  /// 圆盘月亮时间的paint
  late final Paint _moonPaint = Paint()
    ..color = Colors.blueGrey
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 8.px;

  @override
  void paint(Canvas canvas, Size size) {
    // 计算圆盘半径
    double radius = min(size.width, size.height) / 2 - 100.px;

    _drawPallect(canvas, size, radius);
    _drawDial(canvas, size, radius);
    _drawText(canvas, size);
  }

  /// 绘制文本
  void _drawText(Canvas canvas, Size size) {
    Size sunrise = _measureText(
      "${l10n(context).sunRise} ${hourMinuteTime(sun.sunrise)}",
      Colors.orangeAccent,
    );
    _textPaint.paint(canvas, Offset(padding36, 0));
    _measureText(
      "${l10n(context).sunSet} ${hourMinuteTime(sun.sunset)}",
      Colors.orangeAccent,
    );
    _textPaint.paint(canvas, Offset(padding36, sunrise.height));

    Size moonrise = _measureText(
      "${l10n(context).moonRise} ${hourMinuteTime(moon.moonrise)}",
      Colors.blueGrey,
    );
    _textPaint.paint(canvas, Offset(size.width - moonrise.width - padding36, 0));
    _measureText(
      "${l10n(context).moonSet} ${hourMinuteTime(moon.moonset)}",
      Colors.blueGrey,
    );
    _textPaint.paint(canvas, Offset(size.width - moonrise.width - padding36, sunrise.height));
  }

  /// 绘制太阳月亮的时间位置
  void _drawDial(Canvas canvas, Size size, double radius) {
    // 绘制太阳的时间刻度
    Rect rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: radius * 2.5,
      height: radius * 2.5,
    );
    canvas.drawArc(
      rect,
      _sunStartAngle - pi / 2,
      _sunEndAngle - _sunStartAngle,
      false,
      _sunPaint,
    );
    // 绘制月亮的时间刻度
    rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: radius * 1.5,
      height: radius * 1.5,
    );
    canvas.drawArc(
      rect,
      _moonStartAngle - pi / 2,
      _moonEndAngle - _moonStartAngle,
      false,
      _moonPaint,
    );
  }

  /// 绘制背景圆盘
  void _drawPallect(Canvas canvas, Size size, double radius) {
    // 绘制圆盘内背景色
    Rect rectBack = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: radius,
      height: radius,
    );
    canvas.drawArc(
      rectBack,
      _sunStartAngle - pi / 2,
      _sunEndAngle - _sunStartAngle,
      true,
      _dayPaint,
    );
    canvas.drawArc(
      rectBack,
      _sunEndAngle - pi / 2,
      2 * pi - (_sunEndAngle - _sunStartAngle),
      true,
      _nightPaint,
    );

    // 绘制四个时间刻度
    Size textSize = _measureText(
      '0',
      Color(int.parse('3e4145', radix: 16)).withAlpha(255),
    );
    Offset centerOffset = Offset(
      (size.width - textSize.width) / 2,
      (size.height - textSize.height) / 2,
    );
    _textPaint.paint(canvas, centerOffset - Offset(0, radius));

    textSize = _measureText(
      '6',
      Color(int.parse('3e4145', radix: 16)).withAlpha(255),
    );
    centerOffset = Offset(
      (size.width - textSize.width) / 2,
      (size.height - textSize.height) / 2,
    );
    _textPaint.paint(canvas, centerOffset + Offset(radius, 0));

    textSize = _measureText(
      '12',
      Color(int.parse('3e4145', radix: 16)).withAlpha(255),
    );
    centerOffset = Offset(
      (size.width - textSize.width) / 2,
      (size.height - textSize.height) / 2,
    );
    _textPaint.paint(canvas, centerOffset + Offset(0, radius));

    textSize = _measureText(
      '18',
      Color(int.parse('3e4145', radix: 16)).withAlpha(255),
    );
    centerOffset = Offset(
      (size.width - textSize.width) / 2,
      (size.height - textSize.height) / 2,
    );
    _textPaint.paint(canvas, centerOffset - Offset(radius, 0));

    // 绘制四段背景弧线
    Rect rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: radius * 2,
      height: radius * 2,
    );
    canvas.drawArc(rect, -pi / 180 * 84, pi / 180 * 77, false, _pallectPaint);
    canvas.drawArc(rect, pi / 180 * 7, pi / 180 * 74, false, _pallectPaint);
    canvas.drawArc(rect, pi / 180 * 98, pi / 180 * 75, false, _pallectPaint);
    canvas.drawArc(rect, pi / 180 * 187, pi / 180 * 77, false, _pallectPaint);
  }

  @override
  bool shouldRepaint(covariant Pallet oldDelegate) {
    return oldDelegate.moon != moon || oldDelegate.sun != sun;
  }

  // 绘制时间
  late TextPainter _textPaint;

  /// 测量文本的宽高
  Size _measureText(String text, Color color) {
    _textPaint = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    _textPaint.layout(maxWidth: double.maxFinite, minWidth: 0);
    double width = _textPaint.width;
    double height = _textPaint.height;
    return Size(width, height);
  }
}
