import 'package:flutter/material.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/style.dart';

/// 浮于头部的信息简介banner
class FloatBanner extends StatelessWidget {
  final Widget icon;
  final Widget child;
  final GestureTapCallback callback;

  const FloatBanner({
    Key? key,
    required this.icon,
    required this.child,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Row row = Row(children: [icon, SizedBox(width: 10.px), child]);
    Container container = Container(
      decoration: BoxDecoration(
          color: isDark(context) ? Colors.black38 : Colors.white38,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.px),
            topRight: Radius.circular(30.px),
            bottomRight: Radius.circular(30.px),
          )),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: row,
      ),
    );
    return GestureDetector(child: container, onTap: callback);
  }
}
