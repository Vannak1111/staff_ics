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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: homeController.currentIndex.value,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            homeController.currentIndex.value = index;
          },
          unselectedItemColor: Colors.grey,
          selectedItemColor: Color(0xff1d1a56),
          items: [
           
            BottomNavigationBarItem(
              icon: Icon(Icons.home,size: 28,),
              label: 'home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person,size: 28,),
              label: 'profile',
            ),
          ],
        ),
      ),
    );
  }
}
