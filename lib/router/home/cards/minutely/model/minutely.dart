import 'package:json_annotation/json_annotation.dart';

part 'minutely.g.dart';

@JsonSerializable()
class Minutely {
  final String fxTime; //"2022-02-26T17:15+08:00",
  final String precip; //"0.0",
  final String type; //"rain"

  Minutely({
    required this.fxTime,
    required this.precip,
    required this.type,
  });

  factory Minutely.fromJson(Map<String, dynamic> json) => _$MinutelyFromJson(json);

  Map<String, dynamic> toJson() => _$MinutelyToJson(this);

  factory Minutely.empty() => Minutely(
        fxTime: '--',
        precip: '--',
        type: '--',
      );
}
