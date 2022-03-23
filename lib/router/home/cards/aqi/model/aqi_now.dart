import 'package:json_annotation/json_annotation.dart';

part 'aqi_now.g.dart';

@JsonSerializable()
class AqiNow {
  final String pubTime; //"2022-02-22T17:00+08:00",
  final String aqi; //"25",
  final String level; //"1",
  final String category; //"优",
  final String primary; //"NA",
  final String pm10; //"15",
  final String pm2p5; //"8",
  final String no2; //"4",
  final String so2; //"2",
  final String co; //"0.2",
  final String o3; //"78"

  AqiNow({
    required this.pubTime,
    required this.aqi,
    required this.level,
    required this.category,
    required this.primary,
    required this.pm10,
    required this.pm2p5,
    required this.no2,
    required this.so2,
    required this.co,
    required this.o3,
  });

  factory AqiNow.fromJson(Map<String, dynamic> json) => _$AqiNowFromJson(json);

  Map<String, dynamic> toJson() => _$AqiNowToJson(this);

  factory AqiNow.empty() => AqiNow(
      pubTime: '--',
      aqi: '--',
      level: '--',
      category: '--',
      primary: '--',
      pm10: '--',
      pm2p5: '--',
      no2: '--',
      so2: '--',
      co: '--',
      o3: '--');
}
