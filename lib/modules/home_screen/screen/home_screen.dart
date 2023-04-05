import 'package:flutter/material.dart';
import 'package:staff_ics/configs/const/app_colors.dart';
import 'package:get/get.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GestureDetector(
      onTap: (){
        debugPrint("nice to meet you ");
        Get.toNamed('canteen');
      },
      child: SafeArea(
        child: Container(
          width: double.infinity,
          color: AppColor.primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: const [
            Text("ICS"),
             Text("ICS")
          ]),
        ),
      ),),);
  }
}