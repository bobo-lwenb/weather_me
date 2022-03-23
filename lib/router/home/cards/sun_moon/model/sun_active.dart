import 'package:json_annotation/json_annotation.dart';

part 'sun_active.g.dart';

@JsonSerializable()
class SunActive {
  final String fxLink; //"http://hfx.link/2ax1",
  final String sunrise; //"2022-03-20T06:16+08:00",
  final String sunset; //"2022-03-20T18:27+08:00",

  SunActive({
    required this.fxLink,
    required this.sunrise,
    required this.sunset,
  });

  factory SunActive.fromJson(Map<String, dynamic> json) => _$SunActiveFromJson(json);

  Map<String, dynamic> toJson() => _$SunActiveToJson(this);

  factory SunActive.empty() => SunActive(
        fxLink: '--',
        sunrise: '--',
        sunset: '--',
      );
}
