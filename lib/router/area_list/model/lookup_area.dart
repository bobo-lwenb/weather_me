import 'package:json_annotation/json_annotation.dart';

part 'lookup_area.g.dart';

@JsonSerializable()
class LookupArea {
  final String name; //"柳北",
  final String id; //"101300311",
  final String lat; //"24.35914",
  final String lon; //"109.40657",
  final String adm2; //"柳州",
  final String adm1; //"广西壮族自治区",
  final String country; //"中国",
  final String tz; //"Asia/Shanghai",
  final String utcOffset; //"+08:00",
  final String isDst; //"0",
  final String type; //"city",
  final String rank; //"35",
  final String fxLink; //"http://hfx.link/1u211"

  LookupArea({
    required this.name,
    required this.id,
    required this.lat,
    required this.lon,
    required this.adm2,
    required this.adm1,
    required this.country,
    required this.tz,
    required this.utcOffset,
    required this.isDst,
    required this.type,
    required this.rank,
    required this.fxLink,
  });

  factory LookupArea.fromJson(Map<String, dynamic> json) => _$LookupAreaFromJson(json);

  Map<String, dynamic> toJson() => _$LookupAreaToJson(this);

  factory LookupArea.empty() => LookupArea(
        name: '--',
        id: '--',
        lat: '--',
        lon: '--',
        adm2: '--',
        adm1: '--',
        country: '--',
        tz: '--',
        utcOffset: '--',
        isDst: '--',
        type: '--',
        rank: '--',
        fxLink: '--',
      );
}
