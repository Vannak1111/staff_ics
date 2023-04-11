import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:staff_ics/core/slash_screen/screens/slash_screen.dart';

import 'configs/route/route.dart';
import 'configs/themes/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await GlobalConfiguration().loadFromAsset('app_settings');
  // await EasyLocalization.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => GetMaterialApp(
        title: 'Staff_ics',
        debugShowCheckedModeBanner: false,
        theme: theme(),
        home: const SlashScreen(),
        routes: route,
        builder: EasyLoading.init(),
      ),
    );
  }
}
