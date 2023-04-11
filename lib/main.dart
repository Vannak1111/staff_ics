import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:staff_ics/core/slash_screen/screens/slash_screen.dart';

import 'configs/route/route.dart';
import 'configs/themes/theme.dart';
import 'core/slash_screen/models/push_notification_model.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
 

  print("Handling a background message: ${message.messageId}");
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  debugPrint("notification khmer ");
  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );
     const AndroidNotificationChannel channel = AndroidNotificationChannel('nice to meet you ', 'lksdjflsdjfljsdfjsdfjs');
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
  .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  ?.createNotificationChannel(channel);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      RemoteNotification? notification = message.notification;

    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data.toString()}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification.toString()}');
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
            // icon: android?.smallIcon,
            // other properties...
          ),
        ));
    // PushNotification notification = PushNotification(
    //       title: message.notification?.title,
    //       body: message.notification?.body,
    //       dataTitle: "ifhsdhfdsf",
    //       dataBody: "4234234"
    // );
 
  });
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
