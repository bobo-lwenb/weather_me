import 'package:flutter/material.dart';
import 'package:weather_me/utils_box/callback/call_back.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_color.dart';

/// 指示条时方块的导航条
class CubeNavigation extends StatefulWidget {
  final List<String> labels;
  final IntCallback? callback;

  const CubeNavigation({
    Key? key,
    required this.labels,
    this.callback,
  }) : super(key: key);

  @override
  _CubeNavigationState createState() => _CubeNavigationState();
}

class _CubeNavigationState extends State<CubeNavigation> {
  final double _itemWidth = 180.px;
  final double _itemHeight = 60.px;
  final double _spacing = 10.px;

  late final ValueNotifier<int> _notifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = List.empty(growable: true);
    // 在头部插入一个指示器的组件，待会要在算总宽度的时候减一
    ValueListenableBuilder builder = ValueListenableBuilder<int>(
      valueListenable: _notifier,
      builder: (context, value, child) {
        Widget indicator = AnimatedPositioned(
          duration: const Duration(milliseconds: 150),
          top: _spacing / 2,
          left: _spacing / 2 + _itemWidth * value,
          child: Container(
            height: _itemHeight - _spacing,
            width: _itemWidth - _spacing,
            decoration: BoxDecoration(
              color: tomato,
              borderRadius: BorderRadius.all(Radius.circular(10.px)),
            ),
          ),
        );
        return indicator;
      },
    );
    tabs.add(builder);
    double left = 0;
    for (var item in widget.labels) {
      Widget tab = SizedBox(
        width: _itemWidth,
        height: _itemHeight,
        child: Center(child: Text(item)),
      );
      Positioned positioned = Positioned(
        top: 0.px,
        left: left,
        child: tab,
      );
      tabs.add(positioned);
      left += _itemWidth;
    }
    GestureDetector detector = GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Stack(children: tabs),
      onTapUp: (details) {
        int index = details.localPosition.dx ~/ _itemWidth;
        _notifier.value = index;
        if (widget.callback != null) widget.callback!(index);
      },
    );
    Widget container = Container(
      width: _itemWidth * (tabs.length - 1),
      height: _itemHeight,
      decoration: BoxDecoration(
        color: containerBackgroundColor(context),
        borderRadius: BorderRadius.all(Radius.circular(10.px)),
      ),
      child: detector,
    );
    return Center(child: container);
  }
}

/// 列表和图表之间切换的组件
class NavigationPage extends StatefulWidget {
  final List<String> tabs;
  final List<Widget> children;
  final IntCallback? callback;

  const NavigationPage({
    Key? key,
    required this.tabs,
    required this.children,
    this.callback,
  }) : super(key: key);

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  late final ValueNotifier<int> _notifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    CubeNavigation cubeBar = CubeNavigation(
      labels: widget.tabs,
      callback: (index) {
        _notifier.value = index;
        if (widget.callback != null) widget.callback!(index);
      },
    );
    ValueListenableBuilder builder = ValueListenableBuilder<int>(
      valueListenable: _notifier,
      builder: (context, index, child) {
        IndexedStack indexedStack = IndexedStack(
          index: index,
          children: widget.children,
        );
        return indexedStack;
      },
    );
    Column column = Column(children: [
      cubeBar,
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(top: padding24),
          child: builder,
        ),
      ),
    ]);
    return column;
  }
}
