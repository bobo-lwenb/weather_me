import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/router/setting/provider_setting.dart';
import 'package:weather_me/router/setting/widgets/item_card_layout.dart';

class Language extends StatefulWidget {
  const Language({Key? key}) : super(key: key);

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  @override
  Widget build(BuildContext context) {
    // 中文的卡片
    Widget zh = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Height36(text: '语言选择'),
        Height36(text: '柳北 柳州'),
        Height36(text: '广西壮族自治区'),
        Height36(text: '晴间多云'),
      ],
    );
    Widget zhContent = CardContent(child: zh);
    Widget zhCard = Consumer(builder: (context, ref, child) {
      Widget card = ItemCard(
        isCheck: ref.watch(localeProvider) == const Locale('zh', 'CN'),
        title: '简体中文',
        child: zhContent,
        onTap: () => ref.read(localeProvider.notifier).toggle(LocaleType.zh, ref),
      );
      return card;
    });

    // 英文的卡片
    Widget en = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Height36(text: 'language choice'),
        Height36(text: 'LiuBei LiuZhou'),
        Height36(text: 'GuangXi'),
        Height36(text: 'Partly Cloudy'),
      ],
    );
    Widget enContent = CardContent(child: en);
    Widget enCard = Consumer(builder: (context, ref, child) {
      Widget card = ItemCard(
        isCheck: ref.watch(localeProvider) == const Locale('en', 'US'),
        title: 'Eglish',
        child: enContent,
        onTap: () => ref.read(localeProvider.notifier).toggle(LocaleType.en, ref),
      );
      return card;
    });

    // 跟随系统的卡片
    Widget systemContent = Stack(children: [
      ClipPath(clipper: LeadingTrianglePath(), child: zhContent),
      ClipPath(clipper: TrailingTrianglePath(), child: enContent),
    ]);
    Widget systemCard = Consumer(builder: (context, ref, child) {
      Widget card = ItemCard(
        isCheck: ref.watch(localeProvider) == ref.read(systemLocaleProvider.notifier).state!,
        title: l10n(context).system,
        child: systemContent,
        onTap: () => ref.read(localeProvider.notifier).toggle(LocaleType.system, ref),
      );
      return card;
    });

    List<Widget> children = [systemCard, zhCard, enCard];
    return Scaffold(
      appBar: AppBar(title: Text(l10n(context).language)),
      body: CardLayout(
        text: l10n(context).langInfo,
        children: children,
      ),
    );
  }
}
