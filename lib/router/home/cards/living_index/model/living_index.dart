import 'package:json_annotation/json_annotation.dart';

part 'living_index.g.dart';

@JsonSerializable()
class LivingIndex {
  final String date; //"2022-02-23",
  final String type; //"1",
  final String name; // "运动指数",
  final String level; //"3",
  final String category; //"较不宜",
  final String text; //"天气较好，但考虑天气寒冷，推荐您进行室内运动，户外运动时请注意保暖并做好准备活动。"

  LivingIndex({
    required this.date,
    required this.type,
    required this.name,
    required this.level,
    required this.category,
    required this.text,
  });

  factory LivingIndex.fromJson(Map<String, dynamic> json) => _$LivingIndexFromJson(json);

  Map<String, dynamic> toJson() => _$LivingIndexToJson(this);

  factory LivingIndex.empty() => LivingIndex(
        date: '--',
        type: '--',
        name: '--',
        level: '--',
        category: '--',
        text: '--',
      );
}
