import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_ics/modules/home_screen/controllers/home_screen_controller.dart';
import 'package:staff_ics/utils/widgets/custom_appbar.dart';

import '../../../modules/canteen/controllers/fetch_pos.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final homeController =Get.put(HomeScreenController())
;  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notification',onTap: (){
            homeController.notification.value=0;
                  storage.write('notification', 0);
        Get.back();
      },
     ), 
    );
  }
}