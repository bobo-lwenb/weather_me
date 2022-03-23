import 'package:json_annotation/json_annotation.dart';

part 'moon_active.g.dart';

@JsonSerializable()
class MoonActive {
  final String fxLink; //"http://hfx.link/2ax1",
  final String moonrise; //"2022-03-20T06:16+08:00",
  final String moonset; //"2022-03-20T18:27+08:00",

  MoonActive({
    required this.fxLink,
    required this.moonrise,
    required this.moonset,
  });

  factory MoonActive.fromJson(Map<String, dynamic> json) => _$MoonActiveFromJson(json);

  Map<String, dynamic> toJson() => _$MoonActiveToJson(this);

  factory MoonActive.empty() => MoonActive(
        fxLink: '--',
        moonrise: '--',
        moonset: '--',
      );
}
