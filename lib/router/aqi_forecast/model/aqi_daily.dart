import 'package:json_annotation/json_annotation.dart';

part 'aqi_daily.g.dart';

@JsonSerializable()
class AqiDaily {
  final String fxDate; //"2022-02-23",
  final String aqi; //"48",
  final String level; //"1",
  final String category; //"优",
  final String primary; //"NA"

  AqiDaily({
    required this.fxDate,
    required this.aqi,
    required this.level,
    required this.category,
    required this.primary,
  });

  factory AqiDaily.fromJson(Map<String, dynamic> json) => _$AqiDailyFromJson(json);

  Map<String, dynamic> toJson() => _$AqiDailyToJson(this);

  factory AqiDaily.empty() => AqiDaily(
        fxDate: '--',
        aqi: '--',
        level: '--',
        category: '--',
        primary: '--',
      );
}
