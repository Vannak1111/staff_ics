import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:staff_ics/configs/const/app_colors.dart';

class CustomAppBarAssets extends StatelessWidget {
  final title;
  final assets;
  const CustomAppBarAssets(
      {super.key, required this.title, required this.assets});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          width: 100.w,
          height: 30.h,
          color: AppColor.primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Image.asset(
                '$assets',
                height: 15.h,
                color: Colors.white,
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                "$title",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: SizerUtil.deviceType == DeviceType.tablet
                        ? 16.sp
                        : 18.sp),
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          top: 40,
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
