import 'package:flutter/material.dart';
import 'package:weather_me/router/area_list/widgets/search_layer.dart';
import 'package:weather_me/utils_box/size_fit.dart';

/// 搜索功能的壳子架构
class SearchShell extends StatefulWidget {
  final Widget child;

  const SearchShell({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _SearchShellState createState() => _SearchShellState();
}

class _SearchShellState extends State<SearchShell> with SingleTickerProviderStateMixin {
  /// 动画控制器
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 180),
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Stack stack = Stack(children: [
      AnimatedBuilder(
        animation: _controller,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding24),
          child: widget.child,
        ),
        builder: (context, child) {
          return Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 116.px * _controller.value,
            child: child!,
          );
        },
      ),
      SearchLayer(controller: _controller),
    ]);
    return stack;
  }
}
