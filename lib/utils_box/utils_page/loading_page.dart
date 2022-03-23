import 'package:flutter/material.dart';
import 'package:weather_me/router/home/home_widgets/refresh_banner.dart';
import 'package:weather_me/utils_box/utils_color.dart';

/// 等待数据加载页面
class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    lowerBound: 0,
    upperBound: 9,
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget builder = AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
          painter: RefreshPainter(
            process: _controller.value,
            isRefresh: true,
          ),
        );
      },
    );
    return Container(
      alignment: Alignment.center,
      color: contentBackgroundColor(context),
      child: SizedBox(
        width: refreshWidth,
        height: refreshHeight,
        child: builder,
      ),
    );
  }
}
