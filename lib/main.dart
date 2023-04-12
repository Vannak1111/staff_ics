import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:staff_ics/core/slash_screen/screens/slash_screen.dart';
import 'package:staff_ics/utils/local_notification.dart';

import 'configs/route/route.dart';
import 'configs/themes/theme.dart';
import 'core/slash_screen/models/push_notification_model.dart';

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
  FirebaseMessaging messaging = FirebaseMessaging.instance;
    PushNotification? _notificationInfo;
    


  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //     alert: true, badge: true, sound: true);
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //   RemoteNotification? notification = message.notification;
  //   PushNotification notification11 = PushNotification(
  //         title: message.notification?.title,
  //         body: message.notification?.body,
  //         dataTitle: message.data['title'],
  //         dataBody: message.data['body'],
  //       );
  //   _notificationInfo = notification11;
  //   AndroidNotification? android = message.notification?.android;

  //   debugPrint(
  //       'Got a message whilst in the foreground! ${message.notification!.title} ${message.notification!.body}');
  //   if (message.notification != null && android != null) {
  //     debugPrint('Message also contained a notification:');
  //       // showOngoingNotification(flutterLocalNotificationsPlugin,
  //       //       title: _notificationInfo!.title!, body: _notificationInfo!.body!);
  //    await flutterLocalNotificationsPlugin.show(
  //       notification.hashCode,
  //       notification!.title,
  //       notification.body,
  //       NotificationDetails(
  //         android: AndroidNotificationDetails(
  //                   priority: Priority.high,
  //           channel.id,
  //           channel.name,
  //           channelDescription: channel.description,
  //           playSound: true,
  //           color: Colors.green,
  //           autoCancel: true,
  //           icon: '@mipmap/ic_launcher',
  //         ),
  //       ),
  //     );
  //     await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    
    // }
  // });  
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
  late final FirebaseMessaging _messaging;
  late String _notificationRoute;
  late String _notificationId;
  late String? _notificationUserId;
    PushNotification? _notificationInfo;

void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
   
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
        // Parse the message received
        if(message.data['route'] != null) {
          _notificationRoute = message.data['route'];
          _notificationId = message.data['id'];
          _notificationUserId = message.data['user_id'];
        }
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );
          print("notification=$notification");
          _notificationInfo = notification;
      
        if (_notificationInfo != null) {
          // _fetchNotificationCount();
          // _fetchAssignment();
          print("For displaying the notification as an overlay");
          showOngoingNotification(flutterLocalNotificationsPlugin,
              title: _notificationInfo!.title!, body: _notificationInfo!.body!);
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }

    final settingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    // final settingsIOS = IOSInitializationSettings(
    //     onDidReceiveLocalNotification: (id, title, body, payload) =>
    //         onSelectNotification(payload!));

    flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(android: settingsAndroid),
        );
    debugPrint("nice to meet you23232323 ");
  }
class _MyAppState extends State<MyApp> {
  
  @override
  void initState() {
    registerNotification();
    // TODO: implement initState
    super.initState();
  }
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
