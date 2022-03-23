import 'package:json_annotation/json_annotation.dart';

part 'warning.g.dart';

@JsonSerializable()
class Warning {
  final String id; //"10101010020220225155753995243139",
  final String sender; //"北京市气象局",
  final String pubTime; //"2022-02-25T15:57+08:00",
  final String title; //"北京市气象台2022年02月25日16时00分发布大风蓝色预警信号",
  final String startTime; //"2022-02-25T16:00+08:00",
  final String endTime; //"2022-02-26T16:00+08:00",
  final String status; //"active",
  final String level; //"蓝色",
  final String type; //"1006",
  final String typeName; //"大风",
  final String text; //"市气象台2022年2月25日16时00分发布大风蓝色预警信号：预计25日23时至26日17时，本市有4级左右偏北风，阵风7级左右；其中，山区阵风可达8级以上，请注意防范。",
  final String related; //"",
  final String urgency; //"",
  final String certainty; //""

  Warning({
    required this.id,
    required this.sender,
    required this.pubTime,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.level,
    required this.type,
    required this.typeName,
    required this.text,
    required this.related,
    required this.urgency,
    required this.certainty,
  });

  factory Warning.fromJson(Map<String, dynamic> json) => _$WarningFromJson(json);

  Map<String, dynamic> toJson() => _$WarningToJson(this);

  factory Warning.empty() => Warning(
        id: '--',
        sender: '--',
        pubTime: '--',
        title: '--',
        startTime: '--',
        endTime: '--',
        status: '--',
        level: '--',
        type: '--',
        typeName: '--',
        text: '--',
        related: '--',
        urgency: '--',
        certainty: '--',
      );
}
