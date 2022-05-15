import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:weather_me/router/daily/sheet/daily_sheet_page.dart';
import 'package:weather_me/router/home/cards/daily/model/daily.dart';
import 'package:weather_me/router/home/cards/hourly/hourly_card.dart';
import 'package:weather_me/utils_box/callback/call_back.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_color.dart';
import 'package:weather_me/utils_box/utils_image.dart';
import 'package:weather_me/utils_box/utils_time.dart';
import 'package:weather_me/utils_box/weather_convert.dart';

/// DailyDrawing的包装类
class DailyDrawingWrapper extends StatelessWidget {
  final List<Daily> list;
  final IntCallback? callback;

  const DailyDrawingWrapper({
    Key? key,
    required this.list,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.empty(growable: true);
    for (var daily in list) {
      DrawingItem item = DrawingItem(daily: daily);
      Widget widget = Listener(
        behavior: HitTestBehavior.opaque,
        child: item,
      );
      items.add(widget);
    }
    DailyDrawing dailyDrawing = DailyDrawing(
      list: list,
      callback: callback,
      children: items,
    );
    Widget scrollView = SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: EdgeInsets.all(padding36),
        width: _itemWidth * list.length + padding36 * 2,
        height: _itemHeight,
        child: dailyDrawing,
      ),
    );
    return Container(
      decoration: BoxDecoration(
          color: containerBackgroundColor(context),
          borderRadius: BorderRadius.all(
            Radius.circular(padding24),
          )),
      child: scrollView,
    );
  }
}

final double _itemHeight = 568.px;
final double _itemWidth = 150.px;

/// 图表部分的item
class DrawingItem extends StatefulWidget {
  final Daily daily;

  const DrawingItem({
    Key? key,
    required this.daily,
  }) : super(key: key);

  @override
  DrawingItemState createState() => DrawingItemState();
}

class DrawingItemState extends State<DrawingItem> {
  @override
  Widget build(BuildContext context) {
    Widget week = Text(weekTime(context, widget.daily.fxDate));
    Widget date = Text(dateTime(context, widget.daily.fxDate));
    Widget iconDay = svgFillAsset(
      name: widget.daily.iconDay,
      color: icon2IconColor(widget.daily.iconDay),
    );
    Widget maxTemp = Text("${widget.daily.tempMax}°");
    Widget minTemp = Text("${widget.daily.tempMin}°");
    Widget iconNight = svgFillAsset(
      name: widget.daily.iconNight,
      color: icon2IconColor(widget.daily.iconNight),
    );
    Column column = Column(children: [
      SizedBox(height: padding24),
      week,
      SizedBox(height: padding6),
      date,
      SizedBox(height: padding24),
      iconDay,
      SizedBox(height: padding12),
      maxTemp,
      SizedBox(height: padding12),
      const Expanded(child: SizedBox()),
      SizedBox(height: padding12),
      minTemp,
      SizedBox(height: padding12),
      iconNight,
      SizedBox(height: padding24),
    ]);
    return SizedBox(
      height: _itemHeight,
      width: _itemWidth,
      child: column,
    );
  }
}

/// 绘制水平图表
class DailyDrawing extends MultiChildRenderObjectWidget {
  final List<Daily> list;
  final IntCallback? callback;

  DailyDrawing({
    Key? key,
    required List<Widget> children,
    required this.list,
    this.callback,
  }) : super(key: key, children: children);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderDailyDrawing(list: list, callback: callback);
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderDailyDrawing renderObject) {
    renderObject
      ..list = list
      ..callback = callback;
  }
}

class DailyDrawingParentData extends ContainerBoxParentData<RenderBox> {}

class RenderDailyDrawing extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, DailyDrawingParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, DailyDrawingParentData> {
  List<Daily> list;
  IntCallback? callback;

  RenderDailyDrawing({
    required this.list,
    this.callback,
  });

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! DailyDrawingParentData) child.parentData = DailyDrawingParentData();
  }

  @override
  void performLayout() {
    RenderBox? child = firstChild;
    double left = 0.px;
    double top = 0.px;
    while (child != null) {
      child.layout(constraints.copyWith(maxWidth: _itemWidth, minWidth: _itemWidth));
      (child.parentData as DailyDrawingParentData).offset = Offset(left, top);
      child = (child.parentData as DailyDrawingParentData).nextSibling;
      left += _itemWidth;
    }
    size = constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    Canvas canvas = context.canvas;
    _drawIndicator(canvas, offset, _index);
    _drawTemperature(canvas, offset);
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  /// 用于判断是否是滑动的常量
  final double _touchSlop = 20.px;

  /// 首次手指按下的位置
  late Offset _firstPosition;

  /// 选中item的下标
  int _index = 0;

  @override
  void handleEvent(PointerEvent event, covariant HitTestEntry entry) {
    if (event is PointerDownEvent) {
      _firstPosition = event.localPosition;
    } else if (event is PointerUpEvent) {
      if ((event.localPosition.dx - _firstPosition.dx).abs() <= _touchSlop) {
        _index = ((event.localPosition.dx - padding36) ~/ _itemWidth);
        if (callback != null) callback!(_index);
        markNeedsPaint();
      }
    }
  }

  late double _selectLeft;
  final double _selectTop = padding36;
  final double _selectHeight = _itemHeight - padding36 * 2;

  /// 选中背景的paint
  late final Paint _selectPaint = Paint()
    ..color = tomato.withOpacity(0.5)
    ..isAntiAlias = true;

  /// 绘制选种背景
  void _drawIndicator(Canvas canvas, Offset offset, int index) {
    _selectLeft = padding36 + _itemWidth * index;
    Rect rect = Rect.fromLTWH(
      _selectLeft + offset.dx - padding36,
      _selectTop,
      _itemWidth,
      _selectHeight,
    );
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(24.px)), _selectPaint);
  }

  final double _top = 294.px;
  final double _heightRange = 90.px;
  late final double _bottom = _top + _heightRange;
  late final MinAndMax _minMax = minAndMaxDaily(list);
  late final double _tempRange = _minMax.max - _minMax.min;

  /// 组件原生具有的偏移量
  final orignOffset = Offset(padding36, padding36);

  /// 绘制温度条的paint
  late final Paint _paintTemp = Paint()
    ..strokeWidth = 10.px
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true;

  /// 绘制温度折线
  void _drawTemperature(Canvas canvas, Offset offset) {
    // 绘制竖直的温度条
    double left = padding36 + _itemWidth / 2;
    for (var daily in list) {
      // 高温点
      double height = _computeHeight(daily.tempMax);
      Offset maxOffset = Offset(left, height) + offset - orignOffset;
      // 低温点
      height = _computeHeight(daily.tempMin);
      Offset minOffset = Offset(left, height) + offset - orignOffset;
      // 绘制温度条
      _paintTemp.shader = ui.Gradient.linear(
        maxOffset,
        minOffset,
        [Colors.deepOrange, Colors.blueAccent],
      );
      canvas.drawLine(
        maxOffset,
        minOffset,
        _paintTemp,
      );

      left += _itemWidth;
    }
  }

  /// 根据温度计算其代表的点具有的高度
  double _computeHeight(String temp) {
    double tempDouble = double.parse(temp);
    double percentHeight = (tempDouble - _minMax.min) / _tempRange;
    double height = percentHeight * _heightRange;
    return _bottom - height;
  }
}
