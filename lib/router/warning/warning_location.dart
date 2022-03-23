import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/router/warning/model/warning.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/style.dart';
import 'package:weather_me/utils_box/utils_color.dart';
import 'package:weather_me/utils_box/utils_image.dart';
import 'package:weather_me/utils_box/utils_time.dart';
import 'package:weather_me/utils_box/weather_convert.dart';

class WarningLocation extends ConsumerStatefulWidget {
  final List<Warning> warnings;

  const WarningLocation({
    Key? key,
    required this.warnings,
  }) : super(key: key);

  @override
  _WarningLocationState createState() => _WarningLocationState();
}

class _WarningLocationState extends ConsumerState<WarningLocation> {
  @override
  Widget build(BuildContext context) {
    if (widget.warnings.isEmpty) {
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: padding24),
        decoration: BoxDecoration(
          color: isDark(context) ? Colors.blueAccent[400]!.withOpacity(0.5) : Colors.blue[50],
          borderRadius: BorderRadius.all(Radius.circular(padding24)),
        ),
        height: 400.px,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.forest_outlined,
              color: Colors.green,
              size: 120.px,
            ),
            SizedBox(height: padding24),
            Text(
              l10n(context).noDisaster,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.5)),
            ),
          ],
        ),
      );
    }
    ListView listView = ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.warnings.length,
      itemBuilder: (context, index) {
        return LocationItem(warning: widget.warnings[index]);
      },
    );
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: listView,
    );
  }
}

class LocationItem extends StatelessWidget {
  final Warning warning;

  LocationItem({
    Key? key,
    required this.warning,
  }) : super(key: key);

  /// title栏的样式
  final TextStyle _titleStyle = TextStyle(fontSize: 36.px, color: black18);

  /// title栏的样式
  final TextStyle _subStyle = TextStyle(fontSize: 28.px, color: black18);

  /// 时间栏的样式
  final TextStyle _timeStyle = const TextStyle(
    color: Colors.black54,
    fontSize: 12,
  );

  @override
  Widget build(BuildContext context) {
    Widget icon = svgAsset(
      name: warning.type,
      color: warningLevel2Color(warning.level),
      size: 120.px,
    );
    Widget title = Text(
      warning.title,
      textAlign: TextAlign.start,
      style: _titleStyle,
    );
    Widget startTime = Text(
      "${l10n(context).warningStart} ${ymdhm(warning.startTime)}",
      textAlign: TextAlign.start,
      style: _timeStyle,
    );
    Widget endTime = Text(
      "${l10n(context).warningEnd} ${ymdhm(warning.endTime)}",
      textAlign: TextAlign.start,
      style: _timeStyle,
    );
    Widget text = Text(
      warning.text.replaceAll('\n', ''),
      style: _subStyle,
    );
    return Container(
      margin: EdgeInsets.symmetric(horizontal: padding24, vertical: padding12),
      padding: EdgeInsets.all(padding36),
      decoration: BoxDecoration(
        color: warningLevel2AlphaColor(warning.level),
        borderRadius: BorderRadius.all(Radius.circular(padding24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          icon,
          SizedBox(height: padding24),
          title,
          SizedBox(height: padding6),
          startTime,
          endTime,
          SizedBox(height: padding24),
          text,
        ],
      ),
    );
  }
}
