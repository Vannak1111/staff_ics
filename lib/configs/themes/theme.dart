import 'package:flutter/material.dart';
import 'package:staff_ics/configs/const/app_colors.dart';

ThemeData theme() {
  return ThemeData(
    primaryColor: AppColor.backgroundColor,
    brightness: Brightness.light,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
          color: Colors.white,
          fontFamily: 'preahvihear',
          fontSize: 26,
          fontWeight: FontWeight.w500),
      titleSmall: TextStyle(
          color: Colors.white,
          fontFamily: 'preahvihear',
          fontSize: 14,
          fontWeight: FontWeight.w400),
      bodySmall: TextStyle(
          color: Colors.white,
          fontFamily: 'preahvihear',
          fontSize: 10,
          fontWeight: FontWeight.w500),
    ),
  );
}
