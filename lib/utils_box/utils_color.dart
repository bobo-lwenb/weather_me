import 'package:flutter/material.dart';
import 'package:weather_me/utils_box/style.dart';

/// 浅色主题的背景
const whiteSmoke = Color(0xFFF5F5F5);
const gainsboro = Color(0xFFDCDCDC);

/// 浅色主题的内容的背景
const white = Color(0xFFFFFFFF);

/// 浅色主题的文本
const blackText = Color(0xFF000000);

/// 深色主题的背景
const black18 = Color(0xFF121212);

/// 深色主题的内容的背景
const black28 = Color(0xFF1C1C1C);

/// 深色主题的文本
const whiteText = Color(0xFFFFFFFF);

/// icon
const tomato = Color(0xFFFF6347);

/// 容器的背景
Color containerBackgroundColor(BuildContext context) => isDark(context) ? black28 : white;

/// 页面的背景
Color backgroundColor(BuildContext context) => isDark(context) ? black18 : gainsboro;

/// 内容的背景
Color contentBackgroundColor(BuildContext context) => isDark(context) ? black18 : whiteSmoke;
