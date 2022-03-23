import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/router/home/cards/hourly/hourly_card.dart';
import 'package:weather_me/router/home/cards/hourly/model/hourly.dart';
import 'package:weather_me/utils_box/callback/call_back.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/style.dart';
import 'package:weather_me/utils_box/utils_color.dart';
import 'package:weather_me/utils_box/utils_unit.dart';

class HourlyChart extends StatefulWidget {
  final List<Hourly> list;
  final IntCallback? result;

  const HourlyChart({
    Key? key,
    required this.list,
    this.result,
  }) : super(key: key);

  @override
  State<HourlyChart> createState() => _HourlyChartState();
}

class _HourlyChartState extends State<HourlyChart> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: itemWidth * (widget.list.length + 1),
        height: 800.px,
        child: Consumer(builder: (context, ref, child) {
          String unit = speedUnit(ref);
          return Polyline(
            list: widget.list,
            result: widget.result,
            speedUnit: unit,
          );
        }),
      ),
    );
  }
}

/// 每一项的宽度
final double itemWidth = 120.px;

/// 使用 RenderObjec 实现
class Polyline extends LeafRenderObjectWidget {
  final List<Hourly> list;
  final IntCallback? result;
  final String speedUnit;

  const Polyline({
    Key? key,
    required this.list,
    this.result,
    required this.speedUnit,
  }) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderPolyline(
      context: context,
      list: list,
      speedUnit: speedUnit,
      result: result,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderPolyline renderObject) {
    renderObject
      ..context = context
      ..list = list
      ..result = result;
  }
}

class RenderPolyline extends RenderBox {
  BuildContext context;
  List<Hourly> list;
  final String speedUnit;
  IntCallback? result;

  RenderPolyline({
    required this.context,
    required this.list,
    required this.speedUnit,
    this.result,
  });

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.biggest;

  @override
  bool get sizedByParent => true;

  @override
  bool hitTestSelf(Offset position) => true;

  /// 温度的背景刻度线和最左侧的y轴
  late final Paint paintBackground = Paint()
    ..color = Colors.grey
    ..isAntiAlias = true
    ..strokeWidth = 1.px;

  /// 表格温度部分的间距，也是距离上边界的间距
  final double _latticeHeight = 70.px;

  /// 表格距离左边届的间距
  final double _paddingLeft = 70.px + padding24;

  @override
  void paint(PaintingContext context, Offset offset) {
    Canvas canvas = context.canvas;
    // 绘制最左侧的y轴
    canvas.drawLine(
      Offset(_paddingLeft, _latticeHeight) + offset,
      Offset(_paddingLeft, size.height) + offset,
      paintBackground,
    );
    _drawTemperature(canvas, offset);
    _drawWind(canvas, offset);
    _drawPrecip(canvas, offset);
    _drawIndicator(canvas, offset);
  }

  /// 指示线温度部分的paint
  late final Paint _tempIndicatorPaint = Paint()
    ..color = tomato
    ..isAntiAlias = true
    ..strokeWidth = 4.px;

  /// 指示线风速部分的paint
  late final Paint _windIndicatorPaint = Paint()
    ..color = Colors.black87
    ..isAntiAlias = true
    ..strokeWidth = 4.px;

  /// 　指示线上文字的背景框
  late final Paint _rectPaint = Paint()..isAntiAlias = true;

  /// 指示线温度部分起点的y坐标
  late final double _tempTopStart = _latticeHeight;

  /// 指示线温度部分起点的y坐标
  late final double _tempBottomEnd = _latticeHeight * 5;

  /// 指示线风速部分起点的y坐标
  late final double _windTopStart = _latticeHeight * 6;

  /// 指示线风速部分终点的y坐标
  late final double _windBottomEnd = _navTop - 10.px;

  /// 指示线x轴的坐标
  late double left = _paddingLeft + itemWidth / 2;

  /// 指示线位置
  int _index = 0;
  final double _minIndex = 0;
  late final double _maxIndex = list.length - 1;

  /// 指示线上一次滑动的偏移量
  late Offset _lastOffset = Offset.zero;

  /// 绘制指示线的文本的TextPaint
  late TextPainter indicatorTextPainter;

  /// 绘制指示线
  void _drawIndicator(Canvas canvas, Offset offset) {
    canvas.drawLine(
      Offset(left, _tempTopStart) + offset,
      Offset(left, _tempBottomEnd) + offset,
      _tempIndicatorPaint,
    );
    canvas.drawLine(
      Offset(left, _windTopStart) + offset,
      Offset(left, _windBottomEnd) + offset,
      _windIndicatorPaint,
    );
    _drawIndicatorText(canvas, offset, left);
    // 移动指示线
    bool directionToRight = (offset.dx - _lastOffset.dx) > 0 ? false : true; // 判断滑动方向
    double percentage = offset.dx.abs() / (size.width + logicWidth);
    double percentageWidth = percentage * logicWidth + _paddingLeft / 2;
    if (directionToRight) {
      if (percentageWidth >= (left + offset.dx) && _index < _maxIndex) {
        left += itemWidth;
        _index++;
        if (result != null) result!(_index);
      }
    } else {
      if (percentageWidth < (left + offset.dx - itemWidth) && _minIndex < _index) {
        left -= itemWidth;
        _index--;
        if (result != null) result!(_index);
      }
    }
    _lastOffset = offset; // 更新上次滑动偏移量
  }

  /// 绘制指示线文本的调度方法
  void _drawIndicatorText(Canvas canvas, Offset offset, double left) {
    Hourly hourly = list[_index.toInt()];
    String temp = "${hourly.temp}°";
    _drawText(canvas, temp, offset, left, _latticeHeight, tomato);
    String windSpeed = "${hourly.windSpeed}$speedUnit";
    _drawText(canvas, windSpeed, offset, left, _latticeHeight * 6, Colors.black87);
  }

  /// 绘制指示线的文本
  void _drawText(
    Canvas canvas,
    String text,
    Offset offset,
    double left,
    double baseHeight,
    Color rectColor,
  ) {
    // 测量文本
    indicatorTextPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    indicatorTextPainter.layout(maxWidth: 200.px, minWidth: 0);
    double width = indicatorTextPainter.width;
    double height = indicatorTextPainter.height;
    // 绘制背景框
    Rect rect = Rect.fromLTWH(
      left - width / 2 + offset.dx - 10.px,
      baseHeight - height - 15.px + offset.dy,
      width + 20.px,
      height + 10.px,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(10.px)),
      _rectPaint..color = rectColor,
    );
    // 绘制文本
    indicatorTextPainter.paint(
      canvas,
      Offset(
        left - width / 2 + offset.dx,
        // _latticeHeight - height - 10.px,
        baseHeight - height - 10.px,
      ),
    );
  }

  /// 绘制雨量标的paint
  late final Paint _precipPaint = Paint()
    ..color = Colors.blue
    ..isAntiAlias = true
    ..strokeWidth = 3.px;

  /// 绘制雨量柱状图的paint
  late final Paint _pillarPaint = Paint()
    ..color = Colors.blue[100]!
    ..isAntiAlias = true;

  /// 雨量标宽度
  final double _precipWidth = padding30;

  /// 雨量标高度
  final double _precipHeight = padding30;

  /// 雨量标左侧坐标
  late final double _precipLeft = _paddingLeft - _precipWidth - 10.px;

  /// 雨量标顶部坐标
  late final double _precipTop = size.height - _precipHeight * 2 - 10.px;

  /// 最大降雨量
  late double max = _maxPrecip(list);

  /// 绘制x轴的降雨量时间的TextPaint
  late TextPainter hourlyTextPainter;

  /// 绘制x轴的降雨量数字的TextPaint
  late TextPainter precipTextPainter;

  /// 绘制降雨量
  void _drawPrecip(Canvas canvas, Offset offset) {
    _drawPrecipBackground(canvas, offset);
    _drawPrecipContent(canvas, offset);
  }

  /// 绘制降雨量背景
  void _drawPrecipBackground(Canvas canvas, Offset offset) {
    // 绘制雨量标
    canvas.drawPoints(
      PointMode.lines,
      [
        Offset(_precipLeft + padding6, _precipTop + padding6) + offset,
        Offset(_precipLeft + padding6, _precipTop + padding24) + offset,
        Offset(_precipLeft + padding12, _precipTop) + offset,
        Offset(_precipLeft + padding12, _precipTop + padding18) + offset,
        Offset(_precipLeft + padding18, _precipTop + padding6) + offset,
        Offset(_precipLeft + padding18, _precipTop + padding24) + offset,
        Offset(_precipLeft + padding24, _precipTop) + offset,
        Offset(_precipLeft + padding24, _precipTop + padding18) + offset,
      ],
      _precipPaint,
    );
    canvas.drawPoints(
      PointMode.points,
      [
        Offset(_precipLeft + padding6, _precipTop + padding30) + offset,
        Offset(_precipLeft + padding12, _precipTop + padding24) + offset,
        Offset(_precipLeft + padding18, _precipTop + padding30) + offset,
        Offset(_precipLeft + padding24, _precipTop + padding24) + offset,
      ],
      _precipPaint,
    );
  }

  /// 绘制降雨量内容的调度方法
  void _drawPrecipContent(Canvas canvas, Offset offset) {
    double referWidth = _paddingLeft;
    for (var item in list) {
      _drawContent(canvas, offset, item, referWidth);
      referWidth += itemWidth;
    }
  }

  /// 绘制降雨量内容
  void _drawContent(
    Canvas canvas,
    Offset offset,
    Hourly hourly,
    double referWidth,
  ) {
    // 绘制降雨量柱状图
    double proportion = double.parse(hourly.precip) / max;
    double maxheight = 80.px;
    double proHeight = proportion * maxheight;
    canvas.drawRect(
      Rect.fromLTWH(
        referWidth + offset.dx,
        _precipTop + _precipHeight - proHeight + offset.dy,
        itemWidth,
        proHeight,
      ),
      _pillarPaint,
    );
    // 绘制时间
    hourlyTextPainter = TextPainter(
      text: TextSpan(
        text: "${_hourTime(hourly.fxTime)}${l10n(context).hour}",
        style: const TextStyle(
          fontSize: 12.0,
          color: Colors.grey,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    hourlyTextPainter.layout(maxWidth: 200.px, minWidth: 0);
    double width = hourlyTextPainter.width;
    double height = hourlyTextPainter.height;
    hourlyTextPainter.paint(
      canvas,
      Offset(
        referWidth + (itemWidth - width) / 2 + offset.dx,
        size.height - height + offset.dy,
      ),
    );
    // 绘制降雨量
    precipTextPainter = TextPainter(
      text: TextSpan(
        text: "${hourly.precip}mm",
        style: const TextStyle(
          fontSize: 12.0,
          color: Colors.blue,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    precipTextPainter.layout(maxWidth: 200, minWidth: 0);
    width = precipTextPainter.width;
    height = precipTextPainter.height;
    precipTextPainter.paint(
      canvas,
      Offset(
        referWidth + (itemWidth - width) / 2 + offset.dx,
        _precipTop,
      ),
    );
  }

  /// 获取最大降雨量
  double _maxPrecip(List<Hourly> list) {
    double temp = double.parse(list.first.precip);
    for (var item in list) {
      double precip = double.parse(item.precip);
      if (temp < precip) temp = precip;
    }
    return temp;
  }

  /// 获取小时数
  String _hourTime(String time) {
    DateTime dateTime = DateTime.parse(time).toLocal();
    return dateTime.hour.toString();
  }

  /// 绘制风速点和折线的paint
  late final Paint _windPaint = Paint()
    ..color = Colors.black87
    ..isAntiAlias = true
    ..strokeWidth = 4.px;

  /// 绘制风向背景
  late final Paint _windBackground = Paint()..isAntiAlias = true;

  /// 绘制风向标的paint
  late final Paint _navPaint = Paint()
    ..color = Colors.black
    ..isAntiAlias = true;

  /// 风速背景高度
  final double _navBackHeight = 200.px;

  /// 风向标宽度
  final double _navWidth = 22.px;

  /// 风向标高度
  final double _navHeight = padding30;

  /// 风向标左侧坐标
  late final double _navLeft = _paddingLeft - _navWidth - 10.px;

  /// 风向标顶部坐标
  late final double _navTop = 6 * _latticeHeight + _navBackHeight - _navHeight - 10.px;

  /// 可绘制风速的背景高度
  late final _windSpeedHeight = (_navBackHeight - _navHeight - 70.px);
  late final MinAndMax _windMinMax = _minAndMax(list);
  late final _windBetween = _windMinMax.max - _windMinMax.min;

  /// 所有风速代表的坐标点
  final List<Offset> _pointersWind = List.empty(growable: true);

  /// 绘制风速、风向
  void _drawWind(Canvas canvas, Offset offset) {
    _drawWindBackground(canvas, offset);
    _drawWindContent(canvas, offset);
  }

  /// 绘制风速、风向背景
  void _drawWindBackground(Canvas canvas, Offset offset) {
    _windBackground.color = isDark(context) ? const Color(0xFF4F4F4F) : Colors.black12;
    canvas.drawRect(
      Rect.fromLTWH(
        _paddingLeft + offset.dx,
        6 * _latticeHeight + offset.dy,
        size.width - _paddingLeft,
        _navBackHeight,
      ),
      _windBackground,
    );
    _drawWindIcon(canvas, offset, _navLeft); // 坐标轴上的icon
  }

  /// 绘制风向标
  /// left: icon的左侧坐标
  void _drawWindIcon(
    Canvas canvas,
    Offset offset,
    double left, {
    double angle = 0,
  }) {
    double windAngle = pi / 180 * angle;
    canvas.save();
    Path navPath = Path()
      ..moveTo(left + _navWidth / 2 + offset.dx, _navTop)
      ..lineTo(left + offset.dx, _navTop + _navHeight)
      ..lineTo(left + _navWidth / 2 + offset.dx, _navTop + _navHeight * 2 / 3)
      ..lineTo(left + _navWidth + offset.dx, _navTop + _navHeight)
      ..close();
    canvas.translate(left + _navWidth / 2 + offset.dx, _navTop + _navHeight / 2 + offset.dy);
    canvas.rotate(windAngle);
    canvas.translate(-(left + _navWidth / 2 + offset.dx), -(_navTop + _navHeight / 2 + offset.dy));
    canvas.drawPath(navPath, _navPaint);
    canvas.restore();
  }

  /// 绘制风速、风向内容
  void _drawWindContent(Canvas canvas, Offset offset) {
    _pointersWind.clear();
    double leftIcon = _paddingLeft;
    double leftPoint = _paddingLeft;
    for (var item in list) {
      // 绘制风向标
      double left = leftIcon + (itemWidth - _navWidth) / 2;
      _drawWindIcon(canvas, offset, left, angle: double.parse(item.wind360));
      leftIcon += itemWidth;
      // 绘制点
      left = leftPoint + itemWidth / 2;
      double proportionHeight = (double.parse(item.windSpeed) - _windMinMax.min) / _windBetween * _windSpeedHeight;
      double height = _navTop - proportionHeight;
      Offset point = Offset(left, height - padding30);
      _drawWindPolyline(canvas, offset, point);
      _pointersWind.add(point + offset);
      leftPoint += itemWidth;
    }
    // 绘制折线
    canvas.drawPoints(PointMode.polygon, _pointersWind, _windPaint);
  }

  /// 绘制风速折线
  void _drawWindPolyline(Canvas canvas, Offset offset, Offset point) {
    canvas.drawCircle(
      point + offset,
      2.px,
      _windPaint,
    );
  }

  /// 计算风速的最大最小值
  MinAndMax _minAndMax(List<Hourly> list) {
    if (list.isEmpty) return MinAndMax.empty();
    double min = double.parse(list.first.windSpeed);
    double max = double.parse(list.first.windSpeed);
    for (var hourly in list) {
      double temp = double.parse(hourly.windSpeed);
      if (temp < min) {
        min = temp;
        continue;
      }
      if (temp > max) max = temp;
    }
    return MinAndMax(min: min, max: max);
  }

  /// 绘制温度点和折线的paint
  late final Paint _pointPaint = Paint()
    ..color = tomato
    ..isAntiAlias = true
    ..strokeWidth = 4.px;

  /// 绘制最大最小温度虚线的paint
  late final Paint _minMaxPaint = Paint()
    ..color = tomato
    ..strokeWidth = 1.px
    ..isAntiAlias = true
    ..style = PaintingStyle.fill;

  /// 绘制y轴的温度数字的TextPaint
  late TextPainter _tempTextPainter;

  /// 温度部分图表的高度
  late final double tempHeight = _latticeHeight * 4;
  late final MinAndMax _tempMinMax = minAndMaxHourly(list);
  late final _tempBetween = _tempMinMax.max - _tempMinMax.min;

  /// 温度部分的缩放倍数
  late final _scale = _computeScale(_tempBetween);

  /// 虚线间距
  final double _spacing = 15.px;

  /// 所有温度代表的坐标点
  final List<Offset> _pointerTemps = List.empty(growable: true);

  /// 绘制温度部分图表
  void _drawTemperature(Canvas canvas, Offset offset) {
    _drawYAxis(canvas, offset);
    _drawTemperaturePolyline(canvas, offset);
  }

  /// 绘制水平温度刻线
  void _drawYAxis(Canvas canvas, Offset offset) {
    // 刻度线的y轴坐标
    double referHeight = _latticeHeight;
    for (int i = 0; i < 5; i++) {
      // 绘制刻度线
      canvas.drawLine(
        Offset(_paddingLeft, referHeight) + offset,
        Offset(size.width, referHeight) + offset,
        paintBackground,
      );
      referHeight += _latticeHeight;
    }
    _drawMinMaxLine(canvas, offset);
  }

  /// 绘制最大最小温度线和数值
  void _drawMinMaxLine(Canvas canvas, Offset offset) {
    double height = _computeHeight(_tempMinMax.max);
    List<Offset> list = _dottedLine(height, offset);
    canvas.drawPoints(PointMode.lines, list, _minMaxPaint);
    _drawYAxisText(canvas, offset, "${_tempMinMax.max.toInt()}°", height);
    height = _computeHeight(_tempMinMax.min);
    list = _dottedLine(height, offset);
    canvas.drawPoints(PointMode.lines, list, _minMaxPaint);
    _drawYAxisText(canvas, offset, "${_tempMinMax.min.toInt()}°", height);
  }

  /// 计算可以绘制虚线的坐标点
  List<Offset> _dottedLine(double height, Offset offset) {
    List<Offset> list = List.empty(growable: true);
    double left = _paddingLeft;
    while (left < size.width) {
      Offset point = Offset(left, height) + offset;
      list.add(point);
      left += _spacing;
    }
    return list;
  }

  /// 绘制最大最小数值
  void _drawYAxisText(
    Canvas canvas,
    Offset offset,
    String text,
    double eight,
  ) {
    _tempTextPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 14.0, color: Colors.grey),
      ),
      textDirection: TextDirection.ltr,
    );
    _tempTextPainter.layout(maxWidth: 200.px, minWidth: 0);
    double width = _tempTextPainter.width;
    double height = _tempTextPainter.height;
    _tempTextPainter.paint(
      canvas,
      Offset(
        _paddingLeft - width + offset.dx - 5.px,
        eight - height / 2 + offset.dy,
      ),
    );
  }

  /// 绘制温度数据内容
  void _drawTemperaturePolyline(Canvas canvas, Offset offset) {
    double leftPoint = _paddingLeft + itemWidth / 2;
    _pointerTemps.clear();
    for (var item in list) {
      // 绘制温度点
      double height = _computeHeight(double.parse(item.temp));
      Offset point = Offset(leftPoint, height);
      canvas.drawCircle(point + offset, 2.px, _pointPaint);
      _pointerTemps.add(point + offset);
      leftPoint += itemWidth;
    }
    // 绘制折线
    canvas.drawPoints(PointMode.polygon, _pointerTemps, _pointPaint);
  }

  /// 计算温度数值代表的y轴高度
  double _computeHeight(double temp) {
    double proportionHeight = (temp - _tempMinMax.min) / _tempBetween * tempHeight;
    double height = tempHeight + _latticeHeight - proportionHeight;

    double patchheight = _latticeHeight * (3 - 3 / _scale);
    return height / _scale + patchheight;
  }

  /// 计算温度数值的缩小倍数
  double _computeScale(double between) {
    if (between <= 5) {
      return 4.5;
    } else if (between <= 10) {
      return 3.5;
    } else if (between <= 20) {
      return 3;
    } else {
      return 1.5;
    }
  }
}
