import 'package:flutter/material.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/riverpod/weather_model.dart';
import 'package:weather_me/router/home/cards/aqi/model/aqi_now.dart';
import 'package:weather_me/router/home/cards/daily/model/daily.dart';
import 'package:weather_me/router/home/cards/live_weather/model/now.dart';

/// 实时天气描述
String weatherDescription(BuildContext context, WeatherModel model) {
  Now now = model.now;
  Daily today = model.dailyList.first;
  AqiNow aqiNow = model.aqiNow;
  String summary = '';
  Locale locale = Localizations.localeOf(context);
  switch (locale.languageCode) {
    case 'zh':
      summary =
          "今天最高${today.tempMax}°最低${today.tempMin}°，现在${now.temp}°；白天${today.textDay}夜晚${today.textNight}；有${now.windDir}${now.windScale}级，空气质量${aqi2Text(context, aqiNow.aqi)}。";
      break;
    case 'en':
      summary =
          "Today the highest is ${today.tempMax}°, the lowest is ${today.tempMin}°, and now it is ${now.temp}°, ${today.textDay} during the day and ${today.textNight} at night; there is a ${now.windDir} wind of level ${now.windScale}, and the air quality is ${aqi2Text(context, aqiNow.aqi)}.";
      break;
    default:
  }
  return summary;
}

/// 当天天气描述
String dayDescription(BuildContext context, Daily daily) {
  String summary = '';
  Locale locale = Localizations.localeOf(context);
  switch (locale.languageCode) {
    case 'zh':
      summary = "白天${daily.textDay}，最高${daily.tempMax}°；夜间${daily.textNight}，最低${daily.tempMin}°";
      break;
    case 'en':
      summary =
          "${daily.textDay} during the day with a high of ${daily.tempMax}°; ${daily.textNight} at night with a low of ${daily.tempMin}°.";
      break;
    default:
  }
  return summary;
}

/// 紫外线强度指数转换为文字描述
String uvIndex2Text(BuildContext context, String uvIndex) {
  int index = int.parse(uvIndex);
  String text = '';
  switch (index) {
    case 1:
      text = l10n(context).weakest;
      break;
    case 2:
      text = l10n(context).weaker;
      break;
    case 3:
      text = l10n(context).medium;
      break;
    case 4:
      text = l10n(context).strong;
      break;
    case 5:
      text = l10n(context).strongest;
      break;
    default:
  }
  return text;
}

/// 根据空气质量指数转换为类别
String aqi2Text(BuildContext context, String aqi) {
  double index = double.parse(aqi);
  if (0 <= index && index <= 50) {
    return l10n(context).excellent;
  } else if (51 <= index && index <= 100) {
    return l10n(context).good;
  } else if (101 <= index && index <= 150) {
    return l10n(context).light;
  } else if (151 <= index && index <= 200) {
    return l10n(context).moderately;
  } else if (201 <= index && index <= 300) {
    return l10n(context).heavy;
  } else if (index > 300) {
    return l10n(context).serious;
  } else {
    return '-';
  }
}

/// 根据空气质量指数转换为颜色
Color aqi2Color(String aqi) {
  double index = double.parse(aqi);
  if (0 <= index && index <= 50) {
    return const Color.fromARGB(255, 0, 228, 0); // 绿
  } else if (51 <= index && index <= 100) {
    return const Color.fromARGB(255, 255, 255, 0); // 黄
  } else if (101 <= index && index <= 150) {
    return const Color.fromARGB(255, 255, 126, 0); // 橙
  } else if (151 <= index && index <= 200) {
    return const Color.fromARGB(255, 255, 0, 0); // 红
  } else if (201 <= index && index <= 300) {
    return const Color.fromARGB(255, 153, 0, 76); // 紫
  } else if (index > 300) {
    return const Color.fromARGB(255, 126, 0, 35); // 褐红
  } else {
    return const Color.fromARGB(255, 255, 255, 255); // 白
  }
}

/// 根据空气质量指数转换为文本描述
AqiDescribe aqi2Describe(BuildContext context, String aqi) {
  double index = double.parse(aqi);
  if (0 <= index && index <= 50) {
    return AqiDescribe(influence: l10n(context).influence1, advice: l10n(context).advice1);
  } else if (51 <= index && index <= 100) {
    return AqiDescribe(influence: l10n(context).influence2, advice: l10n(context).advice2);
  } else if (101 <= index && index <= 150) {
    return AqiDescribe(influence: l10n(context).influence3, advice: l10n(context).advice3);
  } else if (151 <= index && index <= 200) {
    return AqiDescribe(influence: l10n(context).influence4, advice: l10n(context).advice4);
  } else if (201 <= index && index <= 300) {
    return AqiDescribe(influence: l10n(context).influence5, advice: l10n(context).advice5);
  } else if (index > 300) {
    return AqiDescribe(influence: l10n(context).influence6, advice: l10n(context).advice6);
  } else {
    return AqiDescribe(influence: '', advice: '');
  }
}

class AqiDescribe {
  final String influence;
  final String advice;

  AqiDescribe({
    required this.influence,
    required this.advice,
  });
}

/// 根据生活指数type转换为Icon
IconData livingType2IconData(String type) {
  IconData iconData;
  switch (type) {
    case '1': // 运动指数
      iconData = Icons.directions_run;
      break;
    case '2': // 洗车指数
      iconData = Icons.local_car_wash;
      break;
    case '3': // 穿衣指数
      iconData = Icons.healing;
      break;
    case '4': // 钓鱼指数
      iconData = Icons.waves;
      break;
    case '5': // 紫外线指数
      iconData = Icons.flourescent;
      break;
    case '6': // 旅游指数
      iconData = Icons.delivery_dining;
      break;
    case '7': // 花粉过敏指数
      iconData = Icons.emoji_nature;
      break;
    case '8': // 舒适度指数
      iconData = Icons.settings_accessibility;
      break;
    case '9': // 感冒指数
      iconData = Icons.sick;
      break;
    case '10': // 空气污染扩散条件指数
      iconData = Icons.swap_calls;
      break;
    case '11': // 空调开启指数
      iconData = Icons.stream;
      break;
    case '12': // 太阳镜指数
      iconData = Icons.bakery_dining;
      break;
    case '13': // 化妆指数
      iconData = Icons.face;
      break;
    case '14': // 晾晒指数
      iconData = Icons.checkroom;
      break;
    case '15': // 交通指数
      iconData = Icons.traffic;
      break;
    case '16': // 防晒指数
      iconData = Icons.beach_access;
      break;
    default:
      iconData = Icons.info;
  }
  return iconData;
}

/// 根据生活指数type转换为简短文本
String livingType2Short(BuildContext context, String type) {
  String shortText;
  switch (type) {
    case '1': // 运动指数
      shortText = l10n(context).exercise;
      break;
    case '2': // 洗车指数
      shortText = l10n(context).carWash;
      break;
    case '3': // 穿衣指数
      shortText = l10n(context).dressing;
      break;
    case '4': // 钓鱼指数
      shortText = l10n(context).fishing;
      break;
    case '5': // 紫外线指数
      shortText = l10n(context).uv;
      break;
    case '6': // 旅游指数
      shortText = l10n(context).travel;
      break;
    case '7': // 花粉过敏指数
      shortText = l10n(context).hayFever;
      break;
    case '8': // 舒适度指数
      shortText = l10n(context).comfort;
      break;
    case '9': // 感冒指数
      shortText = l10n(context).cold;
      break;
    case '10': // 空气污染扩散条件指数
      shortText = l10n(context).diffusion;
      break;
    case '11': // 空调开启指数
      shortText = l10n(context).conditioner;
      break;
    case '12': // 太阳镜指数
      shortText = l10n(context).sunglass;
      break;
    case '13': // 化妆指数
      shortText = l10n(context).makeup;
      break;
    case '14': // 晾晒指数
      shortText = l10n(context).drying;
      break;
    case '15': // 交通指数
      shortText = l10n(context).transportation;
      break;
    case '16': // 防晒指数
      shortText = l10n(context).sunscreen;
      break;
    default:
      shortText = '';
  }
  return shortText;
}

/// 根据生活指数type转换为解释文字
String livingType2Explain(BuildContext context, String type) {
  String explainText;
  switch (type) {
    case '1': // 运动指数
      explainText = l10n(context).exerciseDesc;
      break;
    case '2': // 洗车指数
      explainText = l10n(context).carWashDesc;
      break;
    case '3': // 穿衣指数
      explainText = l10n(context).dressingDesc;
      break;
    case '4': // 钓鱼指数
      explainText = l10n(context).fishingDesc;
      break;
    case '5': // 紫外线指数
      explainText = l10n(context).uvDesc;
      break;
    case '6': // 旅游指数
      explainText = l10n(context).travelDesc;
      break;
    case '7': // 花粉过敏指数
      explainText = l10n(context).hayFeverDesc;
      break;
    case '8': // 舒适度指数
      explainText = l10n(context).comfortDesc;
      break;
    case '9': // 感冒指数
      explainText = l10n(context).coldDesc;
      break;
    case '10': // 空气污染扩散条件指数
      explainText = l10n(context).diffusionDesc;
      break;
    case '11': // 空调开启指数
      explainText = l10n(context).conditionerDesc;
      break;
    case '12': // 太阳镜指数
      explainText = l10n(context).sunglassDesc;
      break;
    case '13': // 化妆指数
      explainText = l10n(context).makeupDesc;
      break;
    case '14': // 晾晒指数
      explainText = l10n(context).dryingDesc;
      break;
    case '15': // 交通指数
      explainText = l10n(context).transportationDesc;
      break;
    case '16': // 防晒指数
      explainText = l10n(context).sunscreenDesc;
      break;
    default:
      explainText = '';
  }
  return explainText;
}

/// 根据生活指数level转换为颜色
Color livingLevel2Color(String type, String level) {
  Color backColor;
  switch (type) {
    case '1': // 运动指数
      switch (level) {
        case '1':
          backColor = Color(int.parse('1d953f', radix: 16)).withAlpha(255);
          break;
        case '2':
          backColor = Color(int.parse('5c7a29', radix: 16)).withAlpha(255);
          break;
        case '3':
          backColor = Color(int.parse('bed742', radix: 16)).withAlpha(255);
          break;
        default:
          backColor = Colors.white;
      }
      break;
    case '2': // 洗车指数
      switch (level) {
        case '1':
          backColor = Color(int.parse('1d953f', radix: 16)).withAlpha(255);
          break;
        case '2':
          backColor = Color(int.parse('5c7a29', radix: 16)).withAlpha(255);
          break;
        case '3':
          backColor = Color(int.parse('bed742', radix: 16)).withAlpha(255);
          break;
        case '4':
          backColor = Color(int.parse('fcaf17', radix: 16)).withAlpha(255);
          break;
        default:
          backColor = Colors.white;
      }
      break;
    case '3': // 穿衣指数
      switch (level) {
        case '1':
          backColor = Color(int.parse('181d4b', radix: 16)).withAlpha(255);
          break;
        case '2':
          backColor = Color(int.parse('102b6a', radix: 16)).withAlpha(255);
          break;
        case '3':
          backColor = Color(int.parse('494e8f', radix: 16)).withAlpha(255);
          break;
        case '4':
          backColor = Color(int.parse('78a355', radix: 16)).withAlpha(255);
          break;
        case '5':
          backColor = Color(int.parse('1d953f', radix: 16)).withAlpha(255);
          break;
        case '6':
          backColor = Color(int.parse('f58220', radix: 16)).withAlpha(255);
          break;
        case '7':
          backColor = Color(int.parse('ed1941', radix: 16)).withAlpha(255);
          break;
        default:
          backColor = Colors.white;
      }
      break;
    case '4': // 钓鱼指数
      switch (level) {
        case '1':
          backColor = Color(int.parse('1d953f', radix: 16)).withAlpha(255);
          break;
        case '2':
          backColor = Color(int.parse('5c7a29', radix: 16)).withAlpha(255);
          break;
        case '3':
          backColor = Color(int.parse('bed742', radix: 16)).withAlpha(255);
          break;
        default:
          backColor = Colors.white;
      }
      break;
    case '5': // 紫外线指数
      switch (level) {
        case '1':
          backColor = Color(int.parse('1d953f', radix: 16)).withAlpha(255);
          break;
        case '2':
          backColor = Color(int.parse('5c7a29', radix: 16)).withAlpha(255);
          break;
        case '3':
          backColor = Color(int.parse('bed742', radix: 16)).withAlpha(255);
          break;
        case '4':
          backColor = Color(int.parse('fcaf17', radix: 16)).withAlpha(255);
          break;
        case '5':
          backColor = Color(int.parse('45224a', radix: 16)).withAlpha(255);
          break;
        default:
          backColor = Colors.white;
      }
      break;
    case '6': // 旅游指数
      switch (level) {
        case '1':
          backColor = Color(int.parse('1d953f', radix: 16)).withAlpha(255);
          break;
        case '2':
          backColor = Color(int.parse('5c7a29', radix: 16)).withAlpha(255);
          break;
        case '3':
          backColor = Color(int.parse('bed742', radix: 16)).withAlpha(255);
          break;
        case '4':
          backColor = Color(int.parse('fcaf17', radix: 16)).withAlpha(255);
          break;
        case '5':
          backColor = Color(int.parse('45224a', radix: 16)).withAlpha(255);
          break;
        default:
          backColor = Colors.white;
      }
      break;
    case '7': // 花粉过敏指数
      switch (level) {
        case '1':
          backColor = Color(int.parse('1d953f', radix: 16)).withAlpha(255);
          break;
        case '2':
          backColor = Color(int.parse('5c7a29', radix: 16)).withAlpha(255);
          break;
        case '3':
          backColor = Color(int.parse('bed742', radix: 16)).withAlpha(255);
          break;
        case '4':
          backColor = Color(int.parse('fcaf17', radix: 16)).withAlpha(255);
          break;
        case '5':
          backColor = Color(int.parse('45224a', radix: 16)).withAlpha(255);
          break;
        default:
          backColor = Colors.white;
      }
      break;
    case '8': // 舒适度指数
      switch (level) {
        case '1':
          backColor = Color(int.parse('1d953f', radix: 16)).withAlpha(255);
          break;
        case '2':
          backColor = Color(int.parse('5c7a29', radix: 16)).withAlpha(255);
          break;
        case '3':
          backColor = Color(int.parse('bed742', radix: 16)).withAlpha(255);
          break;
        case '4':
          backColor = Color(int.parse('fcaf17', radix: 16)).withAlpha(255);
          break;
        case '5':
          backColor = Color(int.parse('45224a', radix: 16)).withAlpha(255);
          break;
        case '6':
          backColor = Color(int.parse('aa2116', radix: 16)).withAlpha(255);
          break;
        case '7':
          backColor = Color(int.parse('ed1941', radix: 16)).withAlpha(255);
          break;
        default:
          backColor = Colors.white;
      }
      break;
    case '9': // 感冒指数
      switch (level) {
        case '1':
          backColor = Color(int.parse('1d953f', radix: 16)).withAlpha(255);
          break;
        case '2':
          backColor = Color(int.parse('5c7a29', radix: 16)).withAlpha(255);
          break;
        case '3':
          backColor = Color(int.parse('bed742', radix: 16)).withAlpha(255);
          break;
        case '4':
          backColor = Color(int.parse('fcaf17', radix: 16)).withAlpha(255);
          break;
        default:
          backColor = Colors.white;
      }
      break;
    case '10': // 空气污染扩散条件指数
      switch (level) {
        case '1':
          backColor = Color(int.parse('1d953f', radix: 16)).withAlpha(255);
          break;
        case '2':
          backColor = Color(int.parse('5c7a29', radix: 16)).withAlpha(255);
          break;
        case '3':
          backColor = Color(int.parse('bed742', radix: 16)).withAlpha(255);
          break;
        case '4':
          backColor = Color(int.parse('fcaf17', radix: 16)).withAlpha(255);
          break;
        case '5':
          backColor = Color(int.parse('45224a', radix: 16)).withAlpha(255);
          break;
        default:
          backColor = Colors.white;
      }
      break;
    case '11': // 空调开启指数
      switch (level) {
        case '1':
          backColor = Color(int.parse('fcaf17', radix: 16)).withAlpha(255);
          break;
        case '2':
          backColor = Color(int.parse('ffce7b', radix: 16)).withAlpha(255);
          break;
        case '3':
          backColor = Color(int.parse('8e7437', radix: 16)).withAlpha(255);
          break;
        case '4':
          backColor = Color(int.parse('007947', radix: 16)).withAlpha(255);
          break;
        case '5':
          backColor = Color(int.parse('009ad6', radix: 16)).withAlpha(255);
          break;
        default:
          backColor = Colors.white;
      }
      break;
    case '12': // 太阳镜指数
      switch (level) {
        case '1':
          backColor = Color(int.parse('1d953f', radix: 16)).withAlpha(255);
          break;
        case '2':
          backColor = Color(int.parse('5c7a29', radix: 16)).withAlpha(255);
          break;
        case '3':
          backColor = Color(int.parse('bed742', radix: 16)).withAlpha(255);
          break;
        case '4':
          backColor = Color(int.parse('fcaf17', radix: 16)).withAlpha(255);
          break;
        case '5':
          backColor = Color(int.parse('45224a', radix: 16)).withAlpha(255);
          break;
        default:
          backColor = Colors.white;
      }
      break;
    case '13': // 化妆指数
      switch (level) {
        case '1':
          backColor = Color(int.parse('1d953f', radix: 16)).withAlpha(255);
          break;
        case '2':
          backColor = Color(int.parse('5c7a29', radix: 16)).withAlpha(255);
          break;
        case '3':
          backColor = Color(int.parse('bed742', radix: 16)).withAlpha(255);
          break;
        case '4':
          backColor = Color(int.parse('fcaf17', radix: 16)).withAlpha(255);
          break;
        case '5':
          backColor = Color(int.parse('45224a', radix: 16)).withAlpha(255);
          break;
        case '6':
          backColor = Color(int.parse('aa2116', radix: 16)).withAlpha(255);
          break;
        case '7':
          backColor = Color(int.parse('ed1941', radix: 16)).withAlpha(255);
          break;
        case '8':
          backColor = Color(int.parse('b22c46', radix: 16)).withAlpha(255);
          break;
        default:
          backColor = Colors.white;
      }
      break;
    case '14': // 晾晒指数
      switch (level) {
        case '1':
          backColor = Color(int.parse('1d953f', radix: 16)).withAlpha(255);
          break;
        case '2':
          backColor = Color(int.parse('5c7a29', radix: 16)).withAlpha(255);
          break;
        case '3':
          backColor = Color(int.parse('bed742', radix: 16)).withAlpha(255);
          break;
        case '4':
          backColor = Color(int.parse('fcaf17', radix: 16)).withAlpha(255);
          break;
        case '5':
          backColor = Color(int.parse('45224a', radix: 16)).withAlpha(255);
          break;
        case '6':
          backColor = Color(int.parse('aa2116', radix: 16)).withAlpha(255);
          break;
        default:
          backColor = Colors.white;
      }
      break;
    case '15': // 交通指数
      switch (level) {
        case '1':
          backColor = Color(int.parse('1d953f', radix: 16)).withAlpha(255);
          break;
        case '2':
          backColor = Color(int.parse('5c7a29', radix: 16)).withAlpha(255);
          break;
        case '3':
          backColor = Color(int.parse('bed742', radix: 16)).withAlpha(255);
          break;
        case '4':
          backColor = Color(int.parse('fcaf17', radix: 16)).withAlpha(255);
          break;
        case '5':
          backColor = Color(int.parse('45224a', radix: 16)).withAlpha(255);
          break;
        default:
          backColor = Colors.white;
      }
      break;
    case '16': // 防晒指数
      switch (level) {
        case '1':
          backColor = Color(int.parse('1d953f', radix: 16)).withAlpha(255);
          break;
        case '2':
          backColor = Color(int.parse('5c7a29', radix: 16)).withAlpha(255);
          break;
        case '3':
          backColor = Color(int.parse('bed742', radix: 16)).withAlpha(255);
          break;
        case '4':
          backColor = Color(int.parse('fcaf17', radix: 16)).withAlpha(255);
          break;
        case '5':
          backColor = Color(int.parse('45224a', radix: 16)).withAlpha(255);
          break;
        default:
          backColor = Colors.white;
      }
      break;
    default:
      backColor = Colors.white;
  }
  return backColor;
}

/// 预警信息的颜色描述转Color
/// 一般来说，颜色越深，代表预警的严重程度越高，目前使用的颜色包括：
/// 白色、蓝色、绿色、黄色、橙色、红色、黑色
Color warningLevel2Color(String level) {
  Color result;
  switch (level) {
    case '白色':
    case 'White':
      result = Color(int.parse('f2eada', radix: 16)).withAlpha(255);
      break;
    case '蓝色':
    case 'Blue':
      result = Color(int.parse('1b315e', radix: 16)).withAlpha(255);
      break;
    case '绿色':
    case 'Green':
      result = Color(int.parse('1d953f', radix: 16)).withAlpha(255);
      break;
    case '黄色':
    case 'Yellow':
      result = Color(int.parse('fcaf17', radix: 16)).withAlpha(255);
      break;
    case '橙色':
    case 'Orange':
      result = Color(int.parse('f15a22', radix: 16)).withAlpha(255);
      break;
    case '红色':
    case 'Red':
      result = Color(int.parse('d93a49', radix: 16)).withAlpha(255);
      break;
    case '黑色':
    case 'Black':
      result = Color(int.parse('1d1626', radix: 16)).withAlpha(255);
      break;
    default:
      result = Colors.grey;
  }
  return result;
}

/// 预警信息的颜色描述转有透明度的Color
Color warningLevel2AlphaColor(String level) {
  Color result;
  switch (level) {
    case '白色':
    case 'White':
      result = Color(int.parse('f2eada', radix: 16)).withAlpha(255);
      break;
    case '蓝色':
    case 'Blue':
      result = Color(int.parse('E0EEEE', radix: 16)).withAlpha(255);
      break;
    case '绿色':
    case 'Green':
      result = Color(int.parse('F0FFF0', radix: 16)).withAlpha(255);
      break;
    case '黄色':
    case 'Yellow':
      result = Color(int.parse('FFFFF0', radix: 16)).withAlpha(255);
      break;
    case '橙色':
    case 'Orange':
      result = Color(int.parse('FDF5E6', radix: 16)).withAlpha(255);
      break;
    case '红色':
    case 'Red':
      result = Color(int.parse('FFE4E1', radix: 16)).withAlpha(255);
      break;
    case '黑色':
    case 'Black':
      result = Color(int.parse('E8E8E8', radix: 16)).withAlpha(255);
      break;
    default:
      result = Colors.grey;
  }
  return result;
}

/// 根据icon代码转换为颜色
Color icon2IconColor(String icon) {
  Color color = Colors.blueGrey;
  switch (icon) {
    case '100': // 晴
    case '103': // 晴间多云
      color = Color(int.parse('f47920', radix: 16)).withAlpha(255);
      break;
    case '101': // 多云
    case '102': // 少云
      color = Color(int.parse('d2553d', radix: 16)).withAlpha(255);
      break;
    case '150': // 晴-夜晚
    case '153': // 晴间多云-夜晚
      color = Color(int.parse('fcaf17', radix: 16)).withAlpha(255);
      break;
    case '151': // 多云
    case '152': // 少云
      color = Color(int.parse('d1923f', radix: 16)).withAlpha(255);
      break;
    case '104': // 阴
      color = Color(int.parse('8a8c8e', radix: 16)).withAlpha(255);
      break;
    case '309': // 毛毛雨/细雨
    case '300': // 阵雨
    case '350':
    case '301': // 强阵雨
    case '351':
    case '406': // 阵雨夹雪
    case '456':
    case '305': // 小雨
    case '314': // 小到中雨
    case '399': // 雨
    case '404': // 雨夹雪
      color = Color(int.parse('33a3dc', radix: 16)).withAlpha(255);
      break;
    case '302': // 雷阵雨
    case '304': // 雷阵雨伴有冰雹
    case '303': // 强雷阵雨
      color = Color(int.parse('33a3dc', radix: 16)).withAlpha(255);
      break;
    case '306': // 中雨
    case '313': // 冻雨
    case '315': // 中到大雨
    case '405': // 雨雪天气
      color = Color(int.parse('2468a2', radix: 16)).withAlpha(255);
      break;
    case '307': // 大雨
    case '316': // 大到暴雨
    case '310': // 暴雨
    case '317': // 暴雨到大暴雨
    case '311': // 大暴雨
    case '318': // 大暴雨到特大暴雨
    case '312': // 特大暴雨
    case '308': // 极端降雨
      color = Color(int.parse('11264f', radix: 16)).withAlpha(255);
      break;
    case '407': // 阵雪
    case '457':
    case '400': // 小雪
    case '408': // 小到中雪
    case '499': // 雪
      color = Color(int.parse('90d7ec', radix: 16)).withAlpha(255);
      break;
    case '401': // 中雪
    case '409': // 中到大雪
      color = Color(int.parse('009ad6', radix: 16)).withAlpha(255);
      break;
    case '402': // 大雪
    case '410': // 大到暴雪
    case '403': // 暴雪
      color = Color(int.parse('2585a6', radix: 16)).withAlpha(255);
      break;
    case '500': // 薄雾
      color = Color(int.parse('a1a3a6', radix: 16)).withAlpha(255);
      break;
    case '501': // 雾
      color = Color(int.parse('999d9c', radix: 16)).withAlpha(255);
      break;
    case '514': // 大雾
    case '509': // 浓雾
      color = Color(int.parse('464547', radix: 16)).withAlpha(255);
      break;
    case '510': // 强浓雾
    case '515': // 特强浓雾
      color = Color(int.parse('130c0e', radix: 16)).withAlpha(255);
      break;
    case '502': // 霾
      color = Color(int.parse('d9d6c3', radix: 16)).withAlpha(255);
      break;
    case '511': // 中度霾
      color = Color(int.parse('d5c59f', radix: 16)).withAlpha(255);
      break;
    case '512': // 重度霾
      color = Color(int.parse('70a19f', radix: 16)).withAlpha(255);
      break;
    case '513': // 严重霾
      color = Color(int.parse('70a19f', radix: 16)).withAlpha(255);
      break;
    case '503': // 扬沙
    case '504': // 浮尘
      color = Color(int.parse('dec674', radix: 16)).withAlpha(255);
      break;
    case '507': // 沙尘暴
    case '508': // 强沙尘暴
      color = Color(int.parse('c99979', radix: 16)).withAlpha(255);
      break;
    default:
      break;
  }
  return color;
}
