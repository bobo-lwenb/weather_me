// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_me/utils_box/size_fit.dart';

Image getImageByLogicWidth(String imageName) => Image.asset(
      "lib/images/$imageName",
      width: logicWidth,
      height: logicWidth,
    );

final Image cloud_1 = getImageByLogicWidth('cloud_1.png');
final Image cloud_2 = getImageByLogicWidth('cloud_2.png');
final Image cloud_3 = getImageByLogicWidth('cloud_3.png');
final Image cloud_4 = getImageByLogicWidth('cloud_4.png');
final Image cloud_5 = getImageByLogicWidth('cloud_5.webp');
final Image cloud_6 = getImageByLogicWidth('cloud_6.png');
final Image cloud_7 = getImageByLogicWidth('cloud_7.png');
final Image cloud_8 = getImageByLogicWidth('cloud_8.png');
final Image cloud_9 = getImageByLogicWidth('cloud_9.png');
final Image cloud_10 = getImageByLogicWidth('cloud_10.png');
final Image cloud_11 = getImageByLogicWidth('cloud_11.png');
final Image cloud_12 = getImageByLogicWidth('cloud_12.png');
final Image cloud_13 = getImageByLogicWidth('cloud_13.png');
final Image cloud_14 = getImageByLogicWidth('cloud_14.png');
final Image cloud_15 = getImageByLogicWidth('cloud_15.png');

final Image cloud_thin_1 = getImageByLogicWidth('cloud_thin_1.png');
final Image cloud_thin_2 = getImageByLogicWidth('cloud_thin_2.png');
final Image cloud_thin_3 = getImageByLogicWidth('cloud_thin_3.png');
final Image cloud_thin_4 = getImageByLogicWidth('cloud_thin_4.png');
final Image cloud_thin_5 = getImageByLogicWidth('cloud_thin_5.png');

final Image fog_1 = getImageByLogicWidth('fog_1.png');
final Image fog_2 = getImageByLogicWidth('fog_2.png');
final Image fog_3 = getImageByLogicWidth('fog_3.png');
final Image fog_4 = getImageByLogicWidth('fog_4.png');
final Image fog_5 = getImageByLogicWidth('fog_5.png');

final Image lightning_top_1 = getImageByLogicWidth('lightning_1.webp');
final Image lightning_top_2 = getImageByLogicWidth('lightning_2.webp');
final Image lightning_top_3 = getImageByLogicWidth('lightning_3.webp');
final Image lightning_top_4 = getImageByLogicWidth('lightning_4.webp');
final Image lightning_top_5 = getImageByLogicWidth('lightning_5.webp');
final Image lightning_6 = getImageByLogicWidth('lightning_6.png');
final Image lightning_7 = getImageByLogicWidth('lightning_7.png');
final Image lightning_8 = getImageByLogicWidth('lightning_8.png');
final Image lightning_9 = getImageByLogicWidth('lightning_9.png');

final Image sunny_clear_1 = getImageByLogicWidth('sunny_clear_1.png');
final Image sunny_clear_2 = getImageByLogicWidth('sunny_clear_2.png');

final Image logoLight = Image.asset("lib/images/hf_logo_light.png", height: padding36);
final Image logoDark = Image.asset("lib/images/hf_logo_dark.png", height: padding42);

SvgPicture svgAsset({required String name, required Color color, double? size}) => SvgPicture.asset(
      "lib/images/icons/$name.svg",
      color: color,
      width: size ?? 55.px,
      height: size ?? 55.px,
    );

SvgPicture svgFillAsset({required String name, required Color color, double? size}) => SvgPicture.asset(
      "lib/images/icons/$name-fill.svg",
      color: color,
      width: size ?? 55.px,
      height: size ?? 55.px,
    );
