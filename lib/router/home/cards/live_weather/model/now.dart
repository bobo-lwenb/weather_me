import 'package:json_annotation/json_annotation.dart';

part 'now.g.dart';

@JsonSerializable()
class Now {
  String obsTime;
  String temp;
  String feelsLike;
  String icon;
  String text;
  String wind360;
  String windDir;
  String windScale;
  String windSpeed;
  String humidity;
  String precip;
  String pressure;
  String vis;
  String cloud;
  String dew;

  Now({
    required this.obsTime,
    required this.temp,
    required this.feelsLike,
    required this.icon,
    required this.text,
    required this.wind360,
    required this.windDir,
    required this.windScale,
    required this.windSpeed,
    required this.humidity,
    required this.precip,
    required this.pressure,
    required this.vis,
    required this.cloud,
    required this.dew,
  });

  factory Now.fromJson(Map<String, dynamic> json) => _$NowFromJson(json);

  Map<String, dynamic> toJson() => _$NowToJson(this);

  factory Now.empty() => Now(
        obsTime: '--',
        temp: '--',
        feelsLike: '--',
        icon: '--',
        text: '--',
        wind360: '--',
        windDir: '--',
        windScale: '--',
        windSpeed: '--',
        humidity: '--',
        precip: '--',
        pressure: '--',
        vis: '--',
        cloud: '--',
        dew: '--',
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Now &&
          runtimeType == other.runtimeType &&
          obsTime == other.obsTime &&
          temp == other.temp &&
          feelsLike == other.feelsLike &&
          icon == other.icon &&
          text == other.text &&
          wind360 == other.wind360 &&
          windDir == other.windDir &&
          windScale == other.windScale &&
          windSpeed == other.windSpeed &&
          humidity == other.humidity &&
          precip == other.precip &&
          pressure == other.pressure &&
          vis == other.vis &&
          cloud == other.cloud &&
          dew == other.dew;

  @override
  int get hashCode =>
      obsTime.hashCode ^
      temp.hashCode ^
      feelsLike.hashCode ^
      icon.hashCode ^
      text.hashCode ^
      wind360.hashCode ^
      windDir.hashCode ^
      windScale.hashCode ^
      windSpeed.hashCode ^
      humidity.hashCode ^
      precip.hashCode ^
      pressure.hashCode ^
      vis.hashCode ^
      cloud.hashCode ^
      dew.hashCode;
}
