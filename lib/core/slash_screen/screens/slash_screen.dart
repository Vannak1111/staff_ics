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
    controller.registerNotification();
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
      body: Container(
        color: AppColor.primaryColor,
        child: Center(
          child: Image.asset("assets/image/utils/adaptive_icon_foreground.png"),
        ),
      ),
    );
  }
}
