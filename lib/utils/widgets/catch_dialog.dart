import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../configs/const/app_colors.dart';

 CatchDialog({required String messageError ,required String title ,String  titleBottom='OK'}){
  return  Get.defaultDialog(
          title: "$title",
          titleStyle: TextStyle(color: Colors.black.withOpacity(0.9),fontSize: 18),
          middleText: "$messageError",
          middleTextStyle: TextStyle(color: Colors.black.withOpacity(0.7),fontSize: 15),
          barrierDismissible: false,
          confirm: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor
              ),
          onPressed: () {
           Get.back();
          },
         child: Text("${titleBottom}"),
 ));
}