import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/utils_box/navigator_manager.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_color.dart';
import 'package:weather_me/utils_box/weather/weather_container.dart';
import 'package:weather_me/utils_box/weather/wind_mill.dart';

class AboutApp extends ConsumerStatefulWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends ConsumerState<AboutApp> {
  final ValueNotifier<List<String>> _notifier = ValueNotifier(['', '']);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      PackageInfo info = await PackageInfo.fromPlatform();
      _notifier.value = [info.appName, info.version];
    });
  }

  @override
  Widget build(BuildContext context) {
    ValueListenableBuilder builder = ValueListenableBuilder<List<String>>(
      valueListenable: _notifier,
      builder: (context, value, child) {
        if (value.isEmpty) return const SizedBox();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value[0], style: TextStyle(fontSize: 70.px)),
            Text(l10n(context).developer),
            Text(value[1]),
            GestureDetector(
              child: Text(
                l10n(context).viewLicense,
                style: const TextStyle(decoration: TextDecoration.underline),
              ),
              onTap: () => push(context, name: 'license'),
            ),
          ],
        );
      },
    );

    bool isDay = ref.read(sunActiveProvider.notifier).isDay();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n(context).aboutApp),
        backgroundColor: isDay ? Colors.blueAccent : black28,
      ),
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Positioned(
            child: Container(color: isDay ? Colors.blueAccent : black28),
          ),
          Positioned(
            child: WindMill(isRotate: true, isDay: isDay),
          ),
          Positioned(
            top: padding48 * 2,
            left: padding48 * 2,
            child: builder,
          ),
        ],
      ),
    );
  }
}
