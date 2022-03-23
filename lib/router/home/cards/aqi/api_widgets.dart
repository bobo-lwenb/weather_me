import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_color.dart';
import 'package:weather_me/utils_box/weather_convert.dart';

class AqiCircle extends CustomPainter {
  final BuildContext context;
  final String aqi;

  AqiCircle({
    required this.context,
    required this.aqi,
  });

  /// 圆圈背景的paint
  late final _backPaint = Paint()
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..strokeWidth = 6.px;

  /// 圆圈前景的paint
  late final _forePaint = Paint()
    ..color = aqi2Color(aqi)
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 12.px;

  // 绘制时间
  late TextPainter _textPaint;

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    Offset center = Offset(size.width / 2, radius);
    // 绘制圆圈背景
    _backPaint.color = Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.2);
    canvas.drawCircle(center, radius, _backPaint);
    // 绘制圆圈前景
    Rect rect = Rect.fromLTWH(size.width / 2 - radius, 0, radius * 2, radius * 2);
    canvas.drawArc(rect, -90 * pi / 180, 90 * pi / 180, false, _forePaint);

    Size numSize = _measureText(aqi, fontSize: 30);
    _textPaint.paint(
      canvas,
      Offset(
        (size.width - numSize.width) / 2,
        radius - numSize.height / 2,
      ),
    );

    Size textSize = _measureText(aqi2Text(context, aqi));
    _textPaint.paint(
      canvas,
      Offset(
        (size.width - textSize.width) / 2,
        radius * 2 + padding12,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant AqiCircle oldDelegate) {
    return aqi != oldDelegate.aqi;
  }

  /// 测量文本的宽高
  Size _measureText(String text, {double fontSize = 16}) {
    _textPaint = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          color: Theme.of(context).textTheme.bodyText2!.color,
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

class Pollutant extends StatelessWidget {
  final String index;
  final double percent;
  final String text;

  Pollutant({
    Key? key,
    required this.index,
    required this.percent,
    required this.text,
  }) : super(key: key);

  late final ValueNotifier<double> _notifier = ValueNotifier(0.px);
  late final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _notifier.value = _globalKey.currentContext!.size!.width;
    });
    // 污染物数值
    Widget top = Text(index);
    // 污染物数值占比
    ValueListenableBuilder builder = ValueListenableBuilder<double>(
      valueListenable: _notifier,
      builder: (context, width, child) {
        return Container(
          width: percent * width,
          height: padding6,
          decoration: BoxDecoration(
            color: tomato,
            borderRadius: BorderRadius.all(Radius.circular(3.px)),
          ),
        );
      },
    );
    Widget bar = Container(
      alignment: Alignment.centerLeft,
      key: _globalKey,
      height: 6.px,
      decoration: BoxDecoration(
        color: contentBackgroundColor(context),
        borderRadius: BorderRadius.all(Radius.circular(3.px)),
      ),
      child: builder,
    );
    // 污染物项目
    Widget bottom = Text(
      text,
      style: Theme.of(context).textTheme.bodyText2!.copyWith(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.5),
          ),
    );

    Column column = Column(
      children: [
        top,
        SizedBox(height: padding12),
        bar,
        SizedBox(height: padding12),
        bottom,
      ],
    );
    return Padding(
      padding: EdgeInsets.all(padding12),
      child: column,
    );
  }
}
