import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_me/l10n/intl_func.dart';

/// 获取周几
String weekTime(BuildContext context, String time) {
  DateTime dateTime = DateTime.parse(time).toLocal();
  String weekString;
  switch (dateTime.weekday) {
    case 1:
      weekString = l10n(context).monday;
      break;
    case 2:
      weekString = l10n(context).tuesday;
      break;
    case 3:
      weekString = l10n(context).wednesday;
      break;
    case 4:
      weekString = l10n(context).thursday;
      break;
    case 5:
      weekString = l10n(context).friday;
      break;
    case 6:
      weekString = l10n(context).saturday;
      break;
    case 7:
      weekString = l10n(context).sunday;
      break;
    default:
      weekString = '--';
      break;
  }
  return weekString;
}

/// 获取日期
/// 如：2月22日
String dateTime(BuildContext context, String time) {
  DateTime dateTime = DateTime.parse(time).toLocal();
  DateFormat format = DateFormat(l10n(context).dateTime);
  String date = format.format(dateTime);
  return date;
}

/// 获取小时
/// 如：01时
String hourTime(BuildContext context, String time) {
  DateTime dateTime = DateTime.parse(time).toLocal();
  DateFormat format = DateFormat('HH');
  String hour = format.format(dateTime);
  return hour;
}

/// 获取小时数和分钟
/// 如：12:12
String hourMinuteTime(String time) {
  DateTime dateTime = DateTime.parse(time).toLocal();
  DateFormat format = DateFormat('HH:mm');
  String hour = format.format(dateTime);
  return hour;
}

/// 获取格式连载一起的年月日
/// 如：20220225
String connectDate(String time) {
  DateTime dateTime = DateTime.parse(time).toLocal();
  DateFormat format = DateFormat('yyyyMMdd');
  String date = format.format(dateTime);
  return date;
}

/// 获取分钟数
/// 如：02:10 则返回 2 * 60 + 10 = 130
int minutes(String time) {
  DateTime dateTime = DateTime.parse(time).toLocal();
  int hour = dateTime.hour;
  int minute = dateTime.minute;
  return hour * 60 + minute;
}

/// 获取年月日 时分的格式时间
/// 如：2022-02-26 09:54
String ymdhm(String time) {
  DateTime dateTime = DateTime.parse(time).toLocal();
  DateFormat format = DateFormat('yyyy-MM-dd HH:mm');
  String date = format.format(dateTime);
  return date;
}
