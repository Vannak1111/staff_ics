import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_ics/configs/const/app_colors.dart';

class SlashScreen extends StatefulWidget {
  const SlashScreen({super.key});

  @override
  State<SlashScreen> createState() => _SlashScreenState();
}
class _SlashScreenState extends State<SlashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
  Get.toNamed('login');

});
  }
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      color: AppColor.primaryColor,
      child:  Center(child: Image.asset("assets/image/utils/adaptive_icon_foreground.png"),),),);
  }
}