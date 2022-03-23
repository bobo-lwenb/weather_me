import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/router/setting/provider_setting.dart';
import 'package:weather_me/router/setting/widgets/item_card_layout.dart';
import 'package:weather_me/utils_box/size_fit.dart';

class Unit extends StatefulWidget {
  const Unit({Key? key}) : super(key: key);

  @override
  State<Unit> createState() => _UnitState();
}

class _UnitState extends State<Unit> {
  @override
  Widget build(BuildContext context) {
    // 公制单位
    Widget metric = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${l10n(context).celsius}\n18°C", textAlign: TextAlign.center),
        SizedBox(height: padding12),
        Text("${l10n(context).windSpeed}\n16km/h", textAlign: TextAlign.center),
        SizedBox(height: padding12),
        Text("${l10n(context).visibility}\n26km", textAlign: TextAlign.center),
      ],
    );
    Widget metricContent = CardContent(child: metric);
    Widget metricCard = Consumer(builder: (context, ref, child) {
      Widget card = ItemCard(
        isCheck: ref.watch(unitProvider) == 0,
        title: l10n(context).metric,
        child: metricContent,
        onTap: () => ref.read(unitProvider.notifier).toggle(0),
      );
      return card;
    });

    // 英制单位
    Widget imperial = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${l10n(context).fahrenheit}\n64.4°F", textAlign: TextAlign.center),
        SizedBox(height: padding12),
        Text("${l10n(context).windSpeed}\n9.94mile/h", textAlign: TextAlign.center),
        SizedBox(height: padding12),
        Text("${l10n(context).visibility}\n16.15mile", textAlign: TextAlign.center),
      ],
    );
    Widget imperialContent = CardContent(child: imperial);
    Widget imperialCard = Consumer(builder: (context, ref, child) {
      Widget card = ItemCard(
        isCheck: ref.watch(unitProvider) == 1,
        title: l10n(context).imperial,
        child: imperialContent,
        onTap: () => ref.read(unitProvider.notifier).toggle(1),
      );
      return card;
    });

    List<Widget> children = [metricCard, imperialCard];
    return Scaffold(
      appBar: AppBar(title: Text(l10n(context).unitChoice)),
      body: CardLayout(
        text: l10n(context).unitInfo,
        children: children,
      ),
    );
  }
}
