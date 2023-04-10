import 'package:flutter/material.dart';
import 'package:staff_ics/configs/const/app_colors.dart';
import 'package:get/get.dart';
import 'package:staff_ics/modules/home_screen/controllers/home_screen_controller.dart';
import 'package:staff_ics/modules/profile/screens/profile_screen.dart';

import '../../../utils/widgets/custom_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeScreenController());
    final _pageController = PageController();
    return Obx(() =>
     
     Scaffold(
        appBar: CustomAppBar(
          title:homeController.currentIndex.value==1?
          'Profile': 'ICS',
          onTap: () {
            Get.back();
          },
          isBack: false,
        ),
        body: homeController.currentIndex.value==1?ProfileScreen(): GestureDetector(
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
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: homeController.currentIndex.value,
            type: BottomNavigationBarType.fixed,
            onTap: (int index) {
              print("index=$index");

              homeController.currentIndex.value = index;

            
            },
            unselectedItemColor: Colors.grey,
            selectedItemColor: Color(0xff1d1a56),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'profile',
              ),
            ])));
  }
}
