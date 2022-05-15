import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/router/area_list/model/all_area.dart';
import 'package:weather_me/router/area_list/provider_area.dart';
import 'package:weather_me/router/area_list/widgets/search_shell.dart';
import 'package:weather_me/router/area_list/widgets/swipe_container.dart';
import 'package:weather_me/utils_box/utils_page/loading_page.dart';

class AreaList extends ConsumerStatefulWidget {
  const AreaList({Key? key}) : super(key: key);

  @override
  CityListState createState() => CityListState();
}

class CityListState extends ConsumerState<AreaList> {
  @override
  Widget build(BuildContext context) {
    AsyncValue<AllArea> asyncValue = ref.watch(allAreaProvider);
    AllArea allArea = asyncValue.when(
      data: (allArea) => allArea,
      error: (err, stack) => AllArea.empty(),
      loading: () => AllArea.empty(),
    );
    if (allArea.nearMe.city.id == '--') return const LoadingPage();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(l10n(context).regional)),
      body: SearchShell(
        child: SwipeContainer(
          nearMe: allArea.nearMe,
          favorite: allArea.favorites,
          recently: allArea.recently,
        ),
      ),
    );
  }
}
