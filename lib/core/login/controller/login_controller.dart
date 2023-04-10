
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_ics/core/login/models/login_model.dart';
import '../../../modules/canteen/controllers/fetch_pos.dart';

class LoginController extends GetxController{
Dio _dio = Dio();
final emailController=TextEditingController().obs;
final passwordController = TextEditingController().obs;
final isDisableButton = false.obs;
final hidePasswork =false.obs;
final isName=''.obs;
final isActive = ''.obs;
void login() {
    debugPrint("value ${storage.read('device_token')}");
    debugPrint("value ${emailController.value.text.trim()}");
    debugPrint("value ${passwordController.value.text.trim()}");
    userLogin(emailController.value.text.trim(), passwordController.value.text.trim(),
            storage.read('device_token'))
        .then((value) {
      try {
        storage.write('user_token', value.data.token);
        isActive.value=value.data.studentId;
        isName.value= value.data.name;
        Get.toNamed('canteen');
      } catch (err) {
          isDisableButton.value = false;
        value =
            value == 'Unauthorized' ? 'Username/Password is incorrect!' : value;
        Get.defaultDialog(
          title: "Error",
          titleStyle: TextStyle(color: Colors.black),
          middleText: "$value",
          barrierDismissible: false,
          confirm: reloadBtn(),
        );
      }
    });
  }
Future userLogin(String email, String password,String firebaseToken) async {
  
    // 'email': 'IS202323',
    // 'password': '123456',
  try{
    debugPrint("dfdfdfdfdf");
    String fullUrl = "http://schooldemo.ics.edu.kh:88/api/login";
    var response = await _dio.post("http://schooldemo.ics.edu.kh:88/api/login",data: {
    'email': 'IS202323',
    'password': '123456',
    'firebase_token': firebaseToken,
  });
    LoginDb loginDb = LoginDb.fromMap(response.data);
    debugPrint("token ${loginDb.data.token}");
    return loginDb;
  } on DioError catch (e) {
    debugPrint("you have been catch 4444");
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
 Widget reloadBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: const Text("OK"));
  }
}


