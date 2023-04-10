
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_ics/core/login/models/login_model.dart';
import 'package:staff_ics/utils/widgets/catch_dialog.dart';
import '../../../modules/canteen/controllers/fetch_pos.dart';
import '../../../modules/home_screen/controllers/home_screen_controller.dart';

class LoginController extends GetxController{
      final homeController = Get.put(HomeScreenController());

Dio _dio = Dio();
final emailController=TextEditingController().obs;
final passwordController = TextEditingController().obs;
final isDisableButton = false.obs;
final hidePasswork =false.obs;
final isName=''.obs;
final isActive = ''.obs;
void login() {
    debugPrint("value device token ${storage.read('device_token')}");
    debugPrint("value ${emailController.value.text.trim()}");
    debugPrint("value ${passwordController.value.text.trim()}");
    userLogin(emailController.value.text.trim(), passwordController.value.text.trim(),
            storage.read('device_token'))
        .then((value) {
      try {
        storage.write('user_token', value.data.token);
        debugPrint("password ${passwordController.value.text.trim()}");
        storage.write('isPassword',"${passwordController.value.text.trim()}");
        storage.write('isActive', value.data.studentId);

        isActive.value=value.data.studentId;
        homeController.currentIndex.value=0;
        emailController.value.text='';
        passwordController.value.text='';
        // isName.value= value.data.name;
        Get.toNamed('home');

      } catch (err) {

        debugPrint("you have been catch ");
          isDisableButton.value = false;
        value =
            value == 'Unauthorized' ? 'Username/Password is incorrect!' : value;
            CatchDialog( messageError: '${value}', title: 'Error');
      }
    });
  }
Future userLogin(String email, String password,String firebaseToken) async {
  
    // 'email': 'IS202323',
    // 'password': '111111',
  try{
    var response = await _dio.post("http://schooldemo.ics.edu.kh:88/api/login",data: {
    'email': '${email}',
    'password': '${password}',
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
}


