import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/router/home/cards/minutely/model/minutely.dart';
import 'package:weather_me/router/home/cards/minutely/model/minutes.dart';
import 'package:weather_me/utils_box/size_fit.dart';

class MinutelyCard extends ConsumerStatefulWidget {
  final Minutes minutes;

  const MinutelyCard({
    Key? key,
    required this.minutes,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MinutelyState();
}

class _MinutelyState extends ConsumerState<MinutelyCard> {
  @override
  Widget build(BuildContext context) {
    if (widget.minutes.minutely.isEmpty) return const SizedBox();
    return CustomPaint(
      painter: MinutelyPainter(
        context: context,
        minutes: widget.minutes,
      ),
      isComplex: true,
    );
  }
}

class MinutelyPainter extends CustomPainter {
  final BuildContext context;
  final Minutes minutes;

  MinutelyPainter({
    required this.context,
    required this.minutes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawHistogram(canvas, size);
  }

  /// 横线间隔
  final double _spacing = 50.px;

  /// 横线数量
  final int _lineNumber = 4;

  /// 绘制横线的开始位置
  final double _lineStart = 38.px;

  /// 横线画笔
  late final Paint _linePaint = Paint()
    ..color = Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.5)
    ..isAntiAlias = true
    ..strokeWidth = 2.px
    ..strokeCap = StrokeCap.round;

  /// 绘制文字和横线
  void _drawBackground(Canvas canvas, Size size) {
    // 绘制降水/雪概况信息文字
    Size sizeText = _measureText(
      minutes.summary,
      size.width,
      Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.5),
    );
    _textPaint.paint(canvas, Offset((size.width - sizeText.width) / 2, 0));

    // 绘制底部时间
    sizeText = _measureText(
      l10n(context).now,
      size.width,
      Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.5),
    );
    _textPaint.paint(canvas, Offset(0, size.height - sizeText.height));

    sizeText = _measureText(
      '30min',
      size.width,
      Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.5),
    );
    _textPaint.paint(canvas, Offset(size.width / 4 - sizeText.width / 2, size.height - sizeText.height));

    sizeText = _measureText(
      '60min',
      size.width,
      Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.5),
    );
    _textPaint.paint(canvas, Offset(size.width / 2 - sizeText.width / 2, size.height - sizeText.height));

    sizeText = _measureText(
      '90min',
      size.width,
      Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.5),
    );
    _textPaint.paint(canvas, Offset(size.width / 4 * 3 - sizeText.width / 2, size.height - sizeText.height));

    sizeText = _measureText(
      '120min',
      size.width,
      Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.5),
    );
    _textPaint.paint(canvas, Offset(size.width - sizeText.width, size.height - sizeText.height));

    // 绘制横线
    double lineHeight = size.height - _lineStart;
    for (int i = 0; i < _lineNumber; i++) {
      canvas.drawLine(
        Offset(0, lineHeight),
        Offset(size.width, lineHeight),
        _linePaint,
      );
      lineHeight -= _spacing;
    }
  }

  /// 最大降水量
  late final double _maxPrecip = _max(minutes.minutely);

  /// 最高柱子的高度
  late final double _maxColumnHeight = _spacing * (_lineNumber - 1) - 25.px;

  /// 柱子画笔
  late final Paint _columnPaint = Paint()
    ..isAntiAlias = true
    ..strokeWidth = 2.px
    ..strokeCap = StrokeCap.round;

  /// 绘制柱状图
  void _drawHistogram(Canvas canvas, Size size) {
    // 如果最大为0，则不绘制柱状图
    if (_maxPrecip <= 0) return;
    // 柱子的间距
    double columnSpacing = size.width / minutes.minutely.length;
    // 柱子的宽度
    double columnWidth = size.width / minutes.minutely.length / 2;
    // 柱子的x坐标
    double left = columnSpacing / 4;
    for (var minute in minutes.minutely) {
      double eachHeight = double.parse(minute.precip) / _maxPrecip * _maxColumnHeight;
      double top = size.height - eachHeight - _lineStart;

      // 圆角矩形
      RRect rRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(left, top, columnWidth, eachHeight),
        topLeft: Radius.circular(4.px),
        topRight: Radius.circular(4.px),
      );
      canvas.drawRRect(
        rRect,
        _columnPaint..color = minute.type != 'snow' ? Colors.blue[200]! : Colors.blueGrey,
      );
      left += columnSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant MinutelyPainter oldDelegate) {
    return oldDelegate.minutes == minutes;
  }

  // 绘制时间
  late TextPainter _textPaint;

  /// 测量文本的宽高
  Size _measureText(String text, double maxWidth, Color color) {
    _textPaint = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: 24.px, color: color),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    _textPaint.layout(maxWidth: maxWidth, minWidth: 0);
    double width = _textPaint.width;
    double height = _textPaint.height;
    return Size(width, height);
  }

  /// 回去最大数
  double _max(List<Minutely> list) {
    double max = double.parse(list.first.precip);
    for (var minute in list) {
      if (double.parse(minute.precip) > max) max = double.parse(minute.precip);
    }
    return max;
  }
}
