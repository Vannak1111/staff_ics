import 'package:flutter/material.dart';
import 'package:staff_ics/configs/const/app_colors.dart';
import 'package:get/get.dart';

import '../../../utils/widgets/custom_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'ICS',
        onTap: () {
          Get.back();
        },
        isBack: false,
      ),
      body: GestureDetector(
        onTap: () {
          Get.toNamed('canteen');
        },
        child: Container(
          width: double.infinity,
          color: AppColor.backgroundColor,
          child: Center(
              child: Container(
            height: 80,
            color: AppColor.primaryColor,
            width: 80,
          )),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
          child: Row(
        children: [
          Expanded(
              child: Icon(
            Icons.home_sharp,
          )),
          Expanded(
              child: Icon(
            Icons.person,
          ))
        ],
      )),
    );
  }
}
