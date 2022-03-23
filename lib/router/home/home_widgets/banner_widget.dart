import 'package:flutter/material.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_color.dart';

/// 规定了卡片的圆角矩形
class BannerWidget extends StatelessWidget {
  final double height;
  final Widget child;

  const BannerWidget({
    Key? key,
    this.height = 0,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Container inner = Container(
      decoration: BoxDecoration(
        color: containerBackgroundColor(context),
        borderRadius: BorderRadius.all(Radius.circular(50.px)),
      ),
      child: child,
    );
    Container outter = height == 0
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: padding24, vertical: padding24 / 2),
            child: inner,
          )
        : Container(
            height: height,
            padding: EdgeInsets.symmetric(horizontal: padding24, vertical: padding24 / 2),
            child: inner,
          );
    return SliverToBoxAdapter(child: outter);
  }
}
