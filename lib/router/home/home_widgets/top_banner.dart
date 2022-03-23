import 'package:flutter/material.dart';
import 'package:weather_me/router/home/home_widgets/banner_widget.dart';

/// 第一个Banner
class TopBanner extends StatelessWidget {
  final double height;
  final List<Widget> children;

  const TopBanner({
    Key? key,
    required this.height,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListView listView = ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: children,
    );
    BannerWidget bannerWidget = BannerWidget(
      height: height,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: listView,
      ),
    );
    return bannerWidget;
  }
}
