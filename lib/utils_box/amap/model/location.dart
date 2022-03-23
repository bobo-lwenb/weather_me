import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
  final String callbackTime; //": "2022-02-02 23:07:15",
  final String? locationTime; //": "2022-02-02 23:07:16",
  final double locationType; //": 6,
  final String latitude; //": 24.39848,
  final String longitude; //": 109.401421,
  final double accuracy; //": 550,
  final double altitude; //": 0,
  final double bearing; //": 0,
  final double speed; //": 0,
  final String country; //": "中国",
  final String province; //": "广西壮族自治区",
  final String city; //": "柳州市",
  final String district; //": "柳北区",
  final String street; //": "北外环路",
  final String streetNumber; //": "33号",
  final String cityCode; //": "0772",
  final String adCode; //": "450205",
  final String address; //": "广西壮族自治区柳州市柳北区北外环路33号靠近前进快捷轮胎美容养护中心",
  final String description; //": "在前进快捷轮胎美容养护中心附近"

  Location({
    required this.callbackTime,
    this.locationTime,
    required this.locationType,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.altitude,
    required this.bearing,
    required this.speed,
    required this.country,
    required this.province,
    required this.city,
    required this.district,
    required this.street,
    required this.streetNumber,
    required this.cityCode,
    required this.adCode,
    required this.address,
    required this.description,
  });

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
