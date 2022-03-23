import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/router/warning/model/warning.dart';
import 'package:weather_me/router/warning/model/warning_wrapper.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/style.dart';
import 'package:weather_me/utils_box/utils_color.dart';
import 'package:weather_me/utils_box/weather_convert.dart';

class WarningNear extends StatefulWidget {
  final List<WarningWrapper> wrappers;

  const WarningNear({
    Key? key,
    required this.wrappers,
  }) : super(key: key);

  @override
  _EarningNearState createState() => _EarningNearState();
}

class _EarningNearState extends State<WarningNear> {
  @override
  Widget build(BuildContext context) {
    Widget title = Container(
      alignment: Alignment.centerLeft,
      height: 100.px,
      child: Text(
        l10n(context).nearbyWarning,
        style: Theme.of(context).textTheme.headline6!,
      ),
    );
    Widget titleItem = Row(
      children: [
        Expanded(child: Text(l10n(context).city, textAlign: TextAlign.center)),
        Expanded(child: Text(l10n(context).warning, textAlign: TextAlign.center)),
        Expanded(
          child: Text(l10n(context).level, textAlign: TextAlign.center),
        ),
      ],
    );
    Widget titleContainer = widget.wrappers.isEmpty
        ? const SizedBox()
        : Container(
            padding: EdgeInsets.symmetric(vertical: padding18, horizontal: padding36),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(padding24)),
            ),
            child: titleItem,
          );

    Widget content = widget.wrappers.isEmpty
        ? Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: padding24),
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
                  l10n(context).noDisasterNearby,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.5)),
                ),
              ],
            ),
          )
        : MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.wrappers.length,
              itemBuilder: (context, index) {
                return NearItem(
                  wrapper: widget.wrappers[index],
                  backColor: index.isEven
                      ? isDark(context)
                          ? Color(int.parse('c63c26', radix: 16)).withAlpha(255)
                          : Color(int.parse('F2F2F2', radix: 16)).withAlpha(255)
                      : isDark(context)
                          ? Color(int.parse('1b315e', radix: 16)).withAlpha(255)
                          : Color(int.parse('EFF8FB', radix: 16)).withAlpha(255),
                );
              },
            ),
          );

    Column column = Column(children: [
      title,
      titleContainer,
      content,
    ]);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding24),
      child: Container(
        padding: EdgeInsets.only(left: padding36, right: padding36, bottom: padding48),
        decoration: BoxDecoration(
          color: widget.wrappers.isEmpty
              ? isDark(context)
                  ? Colors.blueAccent[400]!.withOpacity(0.5)
                  : Colors.blue[50]
              : containerBackgroundColor(context),
          borderRadius: BorderRadius.all(Radius.circular(padding24)),
        ),
        child: column,
      ),
    );
  }
}

class NearItem extends ConsumerWidget {
  final WarningWrapper wrapper;
  final Color backColor;

  const NearItem({
    Key? key,
    required this.wrapper,
    required this.backColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (wrapper.list.isEmpty) return const SizedBox();

    Widget name = Text(
      wrapper.city.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    Widget adm1 = Text(
      wrapper.city.adm1,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    Column area = Column(children: [name, adm1]);

    Warning warning = wrapper.list.first;
    Widget typeName = Text(warning.typeName, textAlign: TextAlign.center);
    Widget level = Container(
      padding: EdgeInsets.all(padding6),
      decoration: BoxDecoration(
        color: warningLevel2Color(warning.level),
        borderRadius: BorderRadius.all(Radius.circular(padding12)),
      ),
      child: Text(
        warning.level,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
              color: Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.9),
            ),
      ),
    );
    Row row = Row(
      children: [
        Expanded(child: area),
        Expanded(child: typeName),
        Expanded(child: level),
      ],
    );
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: padding6),
        child: Container(
          padding: EdgeInsets.all(padding36),
          decoration: BoxDecoration(
            color: backColor,
            borderRadius: BorderRadius.all(Radius.circular(padding24)),
          ),
          child: row,
        ),
      ),
      onTap: () {},
    );
  }
}
