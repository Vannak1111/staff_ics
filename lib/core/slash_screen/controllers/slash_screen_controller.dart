
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
import '../models/register_device_token_db_model.dart';

class SlashScreenController extends GetxController{
  Dio _dio = Dio();
  final notificationRoute=''.obs;
  final notificationId=''.obs;
  final notificationUserId=''.obs;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
    static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  Map<String, dynamic> _deviceData = <String, dynamic>{};


  void registerNotification() async {
    debugPrint("vannak vannak ");
    await initPlatformState();
    await Firebase.initializeApp();
      String? token = await FirebaseMessaging.instance.getToken();
    storage.write('device_token', token);
    debugPrint(" your get token ${storage.read('device_token')}");
    fetchRegisterDeviceToken(token!, _deviceData['id'] ?? _deviceData['utsname.machine:'], _deviceData['brand'] ?? _deviceData['systemName']).then((value) {
      try {
        print('Success=${value.status}');
      } catch (error) {
        print("you have been catch 02=$error");
        
      }
    });

  
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
  final storage = GetStorage();
 String getNotificationList = 'api/getnotificationlist';



}