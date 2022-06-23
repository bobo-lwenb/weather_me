import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_me/utils_box/utils_color.dart';

bool isDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? true : false;

/// 浅色主题
ThemeData lightThemeData(BuildContext context) => ThemeData.light().copyWith(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: whiteSmoke,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black),
        toolbarTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.black),
      ),
      scaffoldBackgroundColor: whiteSmoke,
      textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.black),
      iconTheme: Theme.of(context).iconTheme.copyWith(color: tomato),
    );

/// 深色主题
ThemeData darkThemeData(BuildContext context) => ThemeData.dark().copyWith(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: black18,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
        toolbarTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
      ),
      scaffoldBackgroundColor: black18,
      textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.white),
      iconTheme: Theme.of(context).iconTheme.copyWith(color: tomato),
    );
