import 'package:weather_me/router/area_list/model/lookup_area.dart';
import 'package:weather_me/router/warning/model/warning.dart';

class WarningWrapper {
  final LookupArea city;
  final List<Warning> list;

  WarningWrapper({
    required this.city,
    required this.list,
  });
}
