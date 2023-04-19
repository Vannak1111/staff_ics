import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:staff_ics/configs/const/app_colors.dart';

ThemeData theme() {
  return ThemeData(
    useMaterial3: true,
    primaryColor: AppColor.primaryColor,
    textTheme: TextTheme(
      titleLarge: const TextStyle(
          color: Colors.white,
          fontFamily: 'preahvihear',
          fontSize: 26,
          fontWeight: FontWeight.w500),
       titleMedium: TextStyle(
          fontSize: SizerUtil.deviceType == DeviceType.tablet ? 14.sp : 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColor.backgroundColor,),
      titleSmall: TextStyle(
          fontSize: SizerUtil.deviceType == DeviceType.tablet ? 9.sp : 11.sp,
          fontWeight: FontWeight.bold,
          color: AppColor.primaryColor,),
          bodyLarge:  TextStyle(
                  fontSize: SizerUtil.deviceType == DeviceType.tablet ? 20 : 16,
                  color:  AppColor.primaryColor
                  ,),
          bodyMedium: TextStyle(
                  fontSize: SizerUtil.deviceType == DeviceType.tablet ? 18 : 14,
                  color:  Colors.black,fontWeight: FontWeight.bold
                  ,),
                
      bodySmall:  TextStyle(
                  fontSize: SizerUtil.deviceType == DeviceType.tablet ? 18 : 14,
                  color: const Color(0xff1a0785),
    ),
    ),);
}
