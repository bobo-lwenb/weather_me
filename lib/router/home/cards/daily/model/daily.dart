import 'package:json_annotation/json_annotation.dart';

part 'daily.g.dart';

@JsonSerializable()
class Daily {
  final String fxDate; //"2022-02-19"
  final String sunrise; //"07:03",
  final String sunset; //"17:54",
  final String moonrise; //"20:35",
  final String moonset; //"08:58",
  final String moonPhase; //"亏凸月",
  final String moonPhaseIcon; //"805",
  final String tempMax; //"2",
  final String tempMin; //"-9",
  final String iconDay; //"100",
  final String textDay; //"晴",
  final String iconNight; //"150",
  final String textNight; //"晴",
  final String wind360Day; //"315",
  final String windDirDay; //"西北风",
  final String windScaleDay; //"1-2",
  final String windSpeedDay; //"3",
  final String wind360Night; //"0",
  final String windDirNight; //"北风",
  final String windScaleNight; //"1-2",
  final String windSpeedNight; //"3",
  final String humidity; //"45",
  final String precip; //"0.0",
  final String pressure; //"1025",
  final String vis; //"25",
  final String cloud; //"0",
  final String uvIndex; //"4"

  Daily({
    required this.fxDate,
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    required this.moonPhase,
    required this.moonPhaseIcon,
    required this.tempMax,
    required this.tempMin,
    required this.iconDay,
    required this.textDay,
    required this.iconNight,
    required this.textNight,
    required this.wind360Day,
    required this.windDirDay,
    required this.windScaleDay,
    required this.windSpeedDay,
    required this.wind360Night,
    required this.windDirNight,
    required this.windScaleNight,
    required this.windSpeedNight,
    required this.humidity,
    required this.precip,
    required this.pressure,
    required this.vis,
    required this.cloud,
    required this.uvIndex,
  });

  factory Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);

  Map<String, dynamic> toJson() => _$DailyToJson(this);

  factory Daily.empty() => Daily(
        fxDate: '--',
        sunrise: '--',
        sunset: '--',
        moonrise: '--',
        moonset: '--',
        moonPhase: '--',
        moonPhaseIcon: '--',
        tempMax: '--',
        tempMin: '--',
        iconDay: '--',
        textDay: '--',
        iconNight: '--',
        textNight: '--',
        wind360Day: '--',
        windDirDay: '--',
        windScaleDay: '--',
        windSpeedDay: '--',
        wind360Night: '--',
        windDirNight: '--',
        windScaleNight: '--',
        windSpeedNight: '--',
        humidity: '--',
        precip: '--',
        pressure: '--',
        vis: '--',
        cloud: '--',
        uvIndex: '--',
      );
}
