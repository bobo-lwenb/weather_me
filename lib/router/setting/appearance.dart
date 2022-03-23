import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/router/setting/provider_setting.dart';
import 'package:weather_me/router/setting/widgets/item_card_layout.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_color.dart';

class Appearance extends StatefulWidget {
  const Appearance({Key? key}) : super(key: key);

  @override
  State<Appearance> createState() => _AppearanceState();
}

class _AppearanceState extends State<Appearance> {
  @override
  Widget build(BuildContext context) {
    //浅色主题
    Widget light = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Item(title: l10n(context).demoArea, textColor: blackText, backgroundColor: whiteSmoke),
        _Item(title: l10n(context).demoIconText, textColor: blackText, backgroundColor: whiteSmoke),
      ],
    );
    Widget lightContent = CardContent(child: light);
    Widget lightCard = Consumer(builder: (context, ref, child) {
      return ItemCard(
        isCheck: ref.watch(themeProvider) == ThemeMode.light,
        title: l10n(context).lightMode,
        child: lightContent,
        onTap: () => ref.read(themeProvider.notifier).toggle(ThemeMode.light),
        backgroundColor: Colors.white,
      );
    });

    // 深色主题
    Widget dark = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Item(title: l10n(context).demoArea, textColor: whiteText, backgroundColor: black18),
        _Item(title: l10n(context).demoIconText, textColor: whiteText, backgroundColor: black18),
      ],
    );
    Widget darkContent = CardContent(child: dark);
    Widget darkCard = Consumer(builder: (context, ref, child) {
      return ItemCard(
        isCheck: ref.watch(themeProvider) == ThemeMode.dark,
        title: l10n(context).dark,
        child: darkContent,
        onTap: () => ref.read(themeProvider.notifier).toggle(ThemeMode.dark),
        backgroundColor: black28,
      );
    });

    // 跟随系统
    Widget lightPart = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(padding24)),
      ),
      child: lightContent,
    );
    Widget darkPart = Container(
      decoration: BoxDecoration(
        color: black28,
        borderRadius: BorderRadius.all(Radius.circular(padding24)),
      ),
      child: darkContent,
    );
    Widget systemContent = Stack(children: [
      ClipPath(clipper: LeadingTrianglePath(), child: lightPart),
      ClipPath(clipper: TrailingTrianglePath(), child: darkPart),
    ]);
    Widget systemCard = Consumer(builder: (context, ref, child) {
      return ItemCard(
        isCheck: ref.watch(themeProvider) == ThemeMode.system,
        title: l10n(context).system,
        child: systemContent,
        onTap: () => ref.read(themeProvider.notifier).toggle(ThemeMode.system),
      );
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n(context).appearance)),
      body: CardLayout(children: [systemCard, lightCard, darkCard]),
    );
  }
}

class _Item extends StatelessWidget {
  final String title;
  final Color textColor;
  final Color backgroundColor;

  const _Item({
    Key? key,
    required this.title,
    required this.textColor,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: padding48,
      margin: EdgeInsets.all(padding6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(padding6)),
      ),
      child: Text(title, style: TextStyle(fontSize: padding24, color: textColor)),
    );
  }
}
