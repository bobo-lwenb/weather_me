import 'package:json_annotation/json_annotation.dart';
import 'package:weather_me/router/home/cards/minutely/model/minutely.dart';

part 'minutes.g.dart';

@JsonSerializable()
class Minutes {
  final String summary; //"未来两小时无降水"
  final List<Minutely> minutely;

  Minutes({
    required this.summary,
    required this.minutely,
  });

  factory Minutes.fromJson(Map<String, dynamic> json) => _$MinutesFromJson(json);

  Map<String, dynamic> toJson() => _$MinutesToJson(this);

  factory Minutes.empty() => Minutes(
        summary: '--',
        minutely: [],
      );
}
