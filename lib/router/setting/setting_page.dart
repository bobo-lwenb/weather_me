import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/router/setting/provider_setting.dart';
import 'package:weather_me/utils_box/navigator_manager.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_color.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends ConsumerState<SettingPage> {
  @override
  Widget build(BuildContext context) {
    Column column = Column(
      children: [
        SettingItem(
          leadingIcon: const Icon(Icons.g_translate_rounded),
          content: Text(l10n(context).language),
          trailingContent: Consumer(builder: (context, ref, child) {
            return Text(
              _languageText(ref.watch(localeProvider.notifier).type()),
              style: _textStyle(),
            );
          }),
          trailingIcon: const Icon(Icons.play_arrow_rounded),
          onTap: () => push(context, name: 'language'),
        ),
        SettingItem(
          leadingIcon: const Icon(Icons.style_rounded),
          content: Text(l10n(context).appearance),
          trailingContent: Consumer(builder: (context, ref, child) {
            return Text(
              _appearanceText(ref.watch(themeProvider)),
              style: _textStyle(),
            );
          }),
          trailingIcon: const Icon(Icons.play_arrow_rounded),
          onTap: () => push(context, name: 'appearance'),
        ),
        SettingItem(
          leadingIcon: const Icon(Icons.motion_photos_auto_rounded),
          content: Text(l10n(context).unitChoice),
          trailingContent: Consumer(builder: (context, ref, child) {
            return Text(
              _unitText(ref.watch(unitProvider)),
              style: _textStyle(),
            );
          }),
          trailingIcon: const Icon(Icons.play_arrow_rounded),
          onTap: () => push(context, name: 'unit'),
        ),
        SettingItem(
          leadingIcon: const Icon(Icons.architecture_rounded),
          content: Text(l10n(context).aboutApp),
          trailingIcon: const Icon(Icons.play_arrow_rounded),
          onTap: () => push(context, name: 'about'),
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(title: Text(l10n(context).settings)),
      body: column,
    );
  }

  TextStyle _textStyle() => Theme.of(context).textTheme.bodyText2!.copyWith(
        color: Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.5),
      );

  String _languageText(LocaleType type) {
    String text = '';
    switch (type) {
      case LocaleType.zh:
        text = l10n(context).simplifiedChinese;
        break;
      case LocaleType.en:
        text = l10n(context).english;
        break;
      case LocaleType.system:
        text = l10n(context).system;
        break;
    }
    return text;
  }

  String _appearanceText(ThemeMode mode) {
    String text = '';
    switch (mode) {
      case ThemeMode.light:
        text = l10n(context).lightMode;
        break;
      case ThemeMode.dark:
        text = l10n(context).dark;
        break;
      case ThemeMode.system:
        text = l10n(context).system;
        break;
    }
    return text;
  }

  String _unitText(int type) {
    String text = '';
    switch (type) {
      case 0:
        text = l10n(context).metric;
        break;
      case 1:
        text = l10n(context).imperial;
        break;
    }
    return text;
  }
}

class SettingItem extends StatelessWidget {
  final Widget leadingIcon;
  final Widget content;
  final Widget? trailingContent;
  final Widget trailingIcon;
  final VoidCallback? onTap;

  const SettingItem({
    Key? key,
    required this.leadingIcon,
    required this.content,
    this.trailingContent,
    required this.trailingIcon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Row row = Row(children: [
      leadingIcon,
      SizedBox(width: padding18),
      Expanded(child: content),
      trailingContent != null ? SizedBox(width: padding18) : const SizedBox(),
      trailingContent ?? const SizedBox(),
      SizedBox(width: padding18),
      trailingIcon,
    ]);
    Container container = Container(
      height: 106.px,
      margin: EdgeInsets.only(top: padding24, left: padding24, right: padding24),
      padding: EdgeInsets.all(padding24),
      decoration: BoxDecoration(
        color: containerBackgroundColor(context),
        borderRadius: BorderRadius.all(Radius.circular(padding24)),
      ),
      child: row,
    );
    return GestureDetector(
      child: container,
      onTap: () {
        if (onTap != null) onTap!();
      },
    );
  }
}
