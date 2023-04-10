import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:sizer/sizer.dart';
import 'package:staff_ics/core/login/screen/login_screen.dart';
import 'package:staff_ics/modules/canteen/screen/canteen_screen.dart';
import 'package:staff_ics/modules/canteen/screen/iWallet/screens/iwallet_screen.dart';
import 'package:staff_ics/modules/canteen/screen/pre_order/screens/pre_order_screen.dart';
import 'package:staff_ics/modules/canteen/screen/topup/screens/topup_screen.dart';
import 'package:staff_ics/modules/home_screen/screen/home_screen.dart';
import 'package:staff_ics/core/slash_screen/screens/slash_screen.dart';

import 'configs/themes/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GlobalConfiguration().loadFromAsset('app_settings');
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
        routes: {
          'login': (context) => const LoginScreen(),
          'home': (context) => const HomeScreen(),
          'canteen': (context) => const CanteenScreen(),
          'top-up': (context) => const TopUpScreen(),
          'iwallet': (context) => const IWalletScreen(index: 0,),
          'pre-order': (context) => const PreOrderScreen(),
        },
        builder: EasyLoading.init(),
      ),
    );
  }
}
