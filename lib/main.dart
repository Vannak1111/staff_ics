import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:staff_ics/core/slash_screen/screens/slash_screen.dart';
import 'package:staff_ics/modules/canteen/controllers/fetch_pos.dart';
import 'package:staff_ics/modules/home_screen/controllers/home_screen_controller.dart';
import 'configs/route/route.dart';
import 'configs/themes/theme.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.notification!.title}");
}
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_cannel', 'high Importance Notification',
    importance: Importance.high, playSound: true);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (messaging.isAutoInitEnabled) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
      final homeController = Get.put(HomeScreenController());
      if (message.notification != null) {
        if (storage.read('notification') != null) {
          storage.write('notification', storage.read('notification') + 1);
          homeController.notification.value = storage.read('notification');
        } else {
          storage.write('notification', 1);
          homeController.notification.value = storage.read('notification');
        }
        flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification!.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            // channel.description,
            icon: '@mipmap/ic_launcher',
            // styleInformation: BigTextStyleInformation()
            // other properties...
          ),
        ));
        // showOngoingNotification(flutterLocalNotificationsPlugin,
        //     title: message.notification!.title!,
        //     body: message.notification!.body!);
      }
    });
  } else {
    print('User declined or has not accepted permission');
  }
  // final settingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  // flutterLocalNotificationsPlugin.initialize(
  //   InitializationSettings(android: settingsAndroid),
  // );
  await GetStorage.init();
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
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
