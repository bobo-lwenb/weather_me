import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/riverpod/provider_location.dart';
import 'package:weather_me/riverpod/provider_weather.dart';
import 'package:weather_me/router/area_list/model/lookup_area.dart';
import 'package:weather_me/router/home/cards/living_index/model/living_index.dart';
import 'package:weather_me/router/living_forecast/living_forecast.dart';
import 'package:weather_me/utils_box/utils_page/loading_page.dart';

class LivingForecastPage extends ConsumerStatefulWidget {
  const LivingForecastPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LivingForecastPageState();
}

class _LivingForecastPageState extends ConsumerState<LivingForecastPage> {
  @override
  Widget build(BuildContext context) {
    AsyncValue<List<LivingIndex>> asyncValue = ref.watch(livingAllProvider);
    List<LivingIndex> list = asyncValue.when(
      data: (list) => list,
      error: (err, stack) => [],
      loading: () => [],
    );
    if (list.isEmpty) return const LoadingPage();

    LookupArea area = ref.watch(areaProvider);
    return Scaffold(
      appBar: AppBar(title: Text("${area.name}  ${area.adm2}")),
      body: LivingForecast(list: list),
    );
  }
}
