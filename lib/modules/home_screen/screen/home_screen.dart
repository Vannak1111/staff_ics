import 'package:flutter/material.dart';
import 'package:staff_ics/configs/const/app_colors.dart';
import 'package:get/get.dart';
import 'package:staff_ics/modules/home_screen/controllers/home_screen_controller.dart';
import 'package:staff_ics/modules/profile/controllers/profile_controller.dart';
import 'package:staff_ics/modules/profile/screens/profile_screen.dart';

import '../../../utils/widgets/custom_appbar.dart';
import '../../canteen/controllers/fetch_pos.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _profileController = Get.put(ProfileController());
  @override
  void initState() {
    _profileController
        .fetchProfile(apiKey: storage.read('user_token'))
        .then((value) {
      storage.write('isName', value.data.data[0].name);
      debugPrint("name ======== ${storage.read('isName')}");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeScreenController());
    return Obx(
      () => Scaffold(
        appBar: CustomAppBar(
          title: homeController.currentIndex.value == 1 ? 'Profile' : 'ICS',
          onTap: () {
            Get.back();
          },
          isBack: false,
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
        bottomNavigationBar: 
        Container(
         
          child: Row(children: [
          Expanded(child: GestureDetector(
            onTap: (){
              homeController.currentIndex.value=0;
            },
            child: Container(
           color: Colors.transparent,
              height: 60,
              child: Icon(Icons.home_filled)),
          )),
           Expanded(child: GestureDetector(
              onTap: (){
              homeController.currentIndex.value=1;
            },
             child: Container(
              color: Colors.transparent,
              height: 60,
              child: Icon(Icons.person_rounded)),
           ))
        ]),)
       
      ),
    );
  }
}
