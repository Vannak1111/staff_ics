
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../modules/canteen/controllers/fetch_pos.dart';
import '../models/notification_list_db.dart';
import '../models/register_device_token_db_model.dart';

class SlashScreenController extends GetxController{
  Dio _dio = Dio();
  final notificationRoute=''.obs;
  final notificationId=''.obs;
  final notificationUserId=''.obs;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
    static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  late final FirebaseMessaging _messaging;

  Map<String, dynamic> _deviceData = <String, dynamic>{};

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  } 

  void registerNotification() async {
    await initPlatformState();
    await Firebase.initializeApp();
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // NotificationSettings settings = await _messaging.requestPermission(
    //   alert: true,
    //   badge: true,
    //   provisional: false,
    //   sound: true,
    // );
    String? token = await FirebaseMessaging.instance.getToken();
    // print("token= $token");
    storage.write('device_token', token);
    debugPrint(" your get token ${storage.read('device_token')}");
    fetchRegisterDeviceToken(token!, _deviceData['id'] ?? _deviceData['utsname.machine:'], _deviceData['brand'] ?? _deviceData['systemName']).then((value) {
      try {
        print('Success=${value.status}');
      } catch (error) {
        print("you have been catch 02=$error");
        
      }
    });

  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print('User granted permission');
  //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //       print('Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
  //       // Parse the message received
  //       if(message.data['route'] != null) {
  //         notificationRoute.value = message.data['route'];
  //         notificationId.value = message.data['id'];
  //         notificationUserId.value = message.data['user_id'];
  //       }
  //       PushNotification notification = PushNotification(
  //         title: message.notification?.title,
  //         body: message.notification?.body,
  //         dataTitle: message.data['title'],
  //         dataBody: message.data['body'],
  //       );

      
  //         print("notification=$notification");
  //         _notificationInfo = notification;
      

  //       if (_notificationInfo != null) {
  //         _fetchNotificationCount();
  //         // _fetchAssignment();
  //         print("For displaying the notification as an overlay");
  //         showOngoingNotification(flutterLocalNotificationsPlugin,
  //             title: _notificationInfo!.title!, body: _notificationInfo!.body!);
  //       }
  //     });
  //   } else {
  //     print('User declined or has not accepted permission');
  //   }

  //   final settingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  //   final settingsIOS = DarwinInitializationSettings(
  //       onDidReceiveLocalNotification: (id, title, body, payload) =>
  //           onSelectNotification(payload!));

  //   flutterLocalNotificationsPlugin.initialize(
  //       InitializationSettings(android: settingsAndroid, iOS: settingsIOS),
  //       // onSelectNotification: onSelectNotification,
  //       );
  }

 Future onSelectNotification(String? payload) async {
    // 5_routes(route: _notificationRoute, page: _notificationId, userId: _notificationUserId);
  }
 String registerFirebase = 'api/register_firebasetoken';
 String baseUrl_school = 'http://schooldemo.ics.edu.kh:88/';

Future fetchRegisterDeviceToken(String firebaseToken, String model,String osType) async {
  Map<String, String> parameters = {
    'firebase_token': firebaseToken,
    'model': model,
    'os_type': osType,
  };
  try{
    String fullUrl = baseUrl_school + registerFirebase;
    var response = await _dio.get(fullUrl, queryParameters: parameters);
    RegisterDeviceTokenDb registerDeviceTokenDb = RegisterDeviceTokenDb.fromMap(response.data);
    debugPrint("data respones ${registerDeviceTokenDb.message}");
    return registerDeviceTokenDb;
  } on DioError catch (e) {
    debugPrint("you have been catch ");
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
 Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};
    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
      _deviceData = deviceData;
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'brand': build.brand,
      'device': build.device,
      'id': build.id,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'utsname.machine:': data.utsname.machine,
    };
  }
  // void _fetchNotificationCount() {
  //   fetchNotification(read: '2').then((value) {
  //     try {
       
  //         storage.write('notification_badge', value.data.total);
        
  //     } catch (err) {
  //       print("err=$err");
  //     }
  //   });
  // }
  final storage = GetStorage();
 String getNotificationList = 'api/getnotificationlist';

Future fetchNotification({String pageNo = '1', String read = '1'}) async {
  Map<String, String> parameters = {
    'read': read,
    'page': pageNo,
    'firebasekey': storage.read('device_token'),
  };

  try{
    String fullUrl = baseUrl_school + getNotificationList;
    var response = await Dio(BaseOptions(headers: {"Accept":
    "application/json", "Authorization" : "Bearer ${storage.read('user_token')}"}))
        .get(fullUrl, queryParameters: parameters);
    NotificationListDb notificationListDb = NotificationListDb.fromMap(response.data);
    return notificationListDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
NotificationDetails get _ongoing {
  final androidChannelSpecifics = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    importance: Importance.max,
    priority: Priority.high,
    ongoing: false,
    autoCancel: true,
  );
  var iOSChannelSpecifics = DarwinNotificationDetails();
  return NotificationDetails(android: androidChannelSpecifics, iOS: iOSChannelSpecifics);
}
Future showOngoingNotification(
  FlutterLocalNotificationsPlugin notifications, {
  required String title,
  required String body,
  int id = 0,
}) =>
    _showNotification(notifications,
        title: title, body: body, id: id, type: _ongoing);
Future _showNotification(
  FlutterLocalNotificationsPlugin notifications, {
  required String title,
  required String body,
  required NotificationDetails type,
  int id = 0,
}) =>
    notifications.show(id, title, body, type);
}