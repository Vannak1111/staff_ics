import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:staff_ics/configs/const/app_colors.dart';
import 'package:staff_ics/core/slash_screen/controllers/slash_screen_controller.dart';

class SlashScreen extends StatefulWidget {
  const SlashScreen({super.key});

  @override
  State<SlashScreen> createState() => _SlashScreenState();
}

class _SlashScreenState extends State<SlashScreen> {
  final controller = Get.put(SlashScreenController());
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    debugPrint("nice to meet you hihih");
    if (storage.read('user_token') == null) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        Get.toNamed('login');
      });
    } else {
      Future.delayed(const Duration(milliseconds: 1000), () {
        Get.toNamed('home');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: Container(
        color: AppColor.backgroundColor,
        child: Center(
            child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      "assets/image/utils/adaptive_icon_foreground.png"))),
        )),
      ),
    );
  }
}
