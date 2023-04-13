import 'package:flutter/material.dart';
import 'package:staff_ics/configs/const/app_colors.dart';
import 'package:get/get.dart';
import 'package:staff_ics/modules/home_screen/controllers/home_screen_controller.dart';
import 'package:staff_ics/modules/profile/controllers/profile_controller.dart';
import 'package:staff_ics/modules/profile/screens/profile_screen.dart';
import 'package:staff_ics/utils/widgets/custom_appbar.dart';

import '../../canteen/controllers/fetch_pos.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _profileController = Get.put(ProfileController());
  final homeController = Get.put(HomeScreenController());
  @override
  void initState() {

    if(storage.read('notification')!=null){
  homeController.notification.value= storage.read('notification');
    }
    
    _profileController
        .fetchProfile(apiKey: storage.read('user_token'))
        .then((value) {
      storage.write('isName', value.data.data[0].name);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          appBar: homeController.currentIndex.value == 1?CustomAppBar(title: "Profile",isBack: false,): AppBar(
            backgroundColor: AppColor.primaryColor,
            automaticallyImplyLeading: false,
            title: Text(
              "ICS",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 19,
                  ),
            ),
            actions: [
              
              GestureDetector(
                onTap: (){
                
                  Get.toNamed('notification');
                },
                child: Container(
                  width: 40,
                  child: Stack(
                    children: [
                      Positioned(
                          left: 5,
                          top: 20,
                          child: Icon(
                            Icons.notifications,
                            color: AppColor.backgroundColor,
                            size: 25,
                          )),
                      if(homeController.notification.value!=0)
                      Positioned(
                          top: 20,
                          left: 20,
                          child: Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                                color: Colors.red, shape: BoxShape.circle),
                            child: Center(
                                child: Text(
                              "${homeController.notification.value}",
                              style: TextStyle(color: Colors.white, fontSize: 13),
                            )),
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
          body: homeController.currentIndex.value == 1
              ? ProfileScreen()
              : GestureDetector(
                  onTap: () {
                    Get.toNamed('canteen');
                  },
                  child: Container(
                    width: double.infinity,
                    color: AppColor.backgroundColor,
                    child: Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/image/canteen/canteen.png"))),
                      ),
                    ),
                  ),
                ),
          bottomNavigationBar: Container(
            child: Row(children: [
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  homeController.currentIndex.value = 0;
                },
                child: Container(
                    color: Colors.transparent,
                    height: 60,
                    child: Icon(Icons.home_filled,color: homeController.currentIndex.value ==0?AppColor.primaryColor: Colors.grey,)),
              )),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  homeController.currentIndex.value = 1;
                },
                child: Container(
                    color: Colors.transparent,
                    height: 60,
                    child: Icon(Icons.person_rounded,color: homeController.currentIndex.value ==1?AppColor.primaryColor: Colors.grey,)),
              ))
            ]),
          )),
    );
  }
}
