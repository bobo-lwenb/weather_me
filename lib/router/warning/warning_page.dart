import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/riverpod/provider_location.dart';
import 'package:weather_me/riverpod/provider_weather.dart';
import 'package:weather_me/router/area_list/model/lookup_area.dart';
import 'package:weather_me/router/warning/model/warning.dart';
import 'package:weather_me/router/warning/model/warning_wrapper.dart';
import 'package:weather_me/router/warning/warning_location.dart';
import 'package:weather_me/router/warning/warning_near.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_page/loading_page.dart';

class WarningPage extends ConsumerStatefulWidget {
  const WarningPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WarningPageState();
}

class _WarningPageState extends ConsumerState<WarningPage> {
  @override
  Widget build(BuildContext context) {
    AsyncValue<List<WarningWrapper>> asyncValue = ref.watch(warningListProvider);
    List<WarningWrapper>? wrappers = asyncValue.when(
      data: (list) => list,
      error: (err, stack) => null,
      loading: () => null,
    );
    if (wrappers == null) return const LoadingPage();

    LookupArea area = ref.watch(areaProvider);
    List<Warning> warnings = List.empty(growable: true);
    for (var item in wrappers) {
      if (item.city.id == area.id) {
        warnings.addAll(item.list);
        continue;
      }
    }
    Widget warningLocation = WarningLocation(warnings: warnings);
    Widget warningNear = WarningNear(wrappers: wrappers);

    return Scaffold(
      appBar: AppBar(title: Text("${area.name}  ${area.adm2}")),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: padding24)),
          SliverToBoxAdapter(child: warningLocation),
          SliverToBoxAdapter(child: SizedBox(height: padding48)),
          SliverToBoxAdapter(child: warningNear),
        ],
      ),
    );
  }
}
