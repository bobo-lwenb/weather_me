import 'package:json_annotation/json_annotation.dart';

part 'hourly.g.dart';

@JsonSerializable()
class Hourly {
  final String fxTime; //"2022-02-06T01:00+08:00",
  final String temp; //"-3",
  final String icon; //"151",
  final String text; //"多云",
  final String wind360; //"345",
  final String windDir; //"西北风",
  final String windScale; //"1-2",
  final String windSpeed; //"9",
  final String humidity; //"26",
  final String pop; //"7",
  final String precip; //"0.0",
  final String pressure; //"1028",
  final String cloud; //"84",
  final String dew; //"-20"

  Hourly({
    required this.fxTime,
    required this.temp,
    required this.icon,
    required this.text,
    required this.wind360,
    required this.windDir,
    required this.windScale,
    required this.windSpeed,
    required this.humidity,
    required this.pop,
    required this.precip,
    required this.pressure,
    required this.cloud,
    required this.dew,
  });

  factory Hourly.fromJson(Map<String, dynamic> json) => _$HourlyFromJson(json);

  Map<String, dynamic> toJson() => _$HourlyToJson(this);

  factory Hourly.empty() => Hourly(
        fxTime: '--',
        temp: '--',
        icon: '--',
        text: '--',
        wind360: '--',
        windDir: '--',
        windScale: '--',
        windSpeed: '--',
        humidity: '--',
        pop: '--',
        precip: '--',
        pressure: '--',
        cloud: '--',
        dew: '--',
      );
}
