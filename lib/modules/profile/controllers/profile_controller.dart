import 'dart:async';
// import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'dart:io';

import '../../../configs/const/ulr.dart';
import '../../../core/login/models/login_model.dart';
import '../../canteen/controllers/fetch_pos.dart';
import '../models/change_password.dart';
import '../models/profile_model.dart';

class ProfileController extends GetxController {
  final storage = GetStorage();
    final isLoading = false.obs;

  final emailController = TextEditingController().obs;
    final passwordController = TextEditingController().obs;

  final currentPasswordController = TextEditingController().obs;
  final newPasswordController = TextEditingController().obs;
  final confirmPasswordController = TextEditingController().obs;
  Future fetchProfile({required String apiKey}) async {
  try {
    String fullUrl = baseUrl_school + getProfile;
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $apiKey"
    })).get(fullUrl);
    print("response.data=  ${response.data}");
    ProfileDb profileDb = ProfileDb.fromMap(response.data);
    return profileDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
   Future<File> loadNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;

    return _storeFile(url, bytes);
  }
   Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
  Dio _dio = Dio();

Future userLogin(String email, String password,String firebaseToken) async {
  // FormData formData = FormData.fromMap({
  //   'email': email,
  //   'password': password,
  //   'firebase_token': firebaseToken,
  // });

  try{
    String fullUrl = baseUrl_school + login;
    var response = await _dio.post(fullUrl, data: {
    'email': email,
    'password': password,
    'firebase_token': firebaseToken,
  });
    LoginDb loginDb = LoginDb.fromMap(response.data);
    return loginDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}

Future userChangePassword(String _oldPassword, String _newPassword) async {
 
  try{
    String fullUrl = baseUrl_school + changePassword;
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${storage.read('user_token')}",
      "connectTimeout": 10*1000, // 10 seconds
      "receiveTimeout": 10*1000
    })).post(fullUrl, data: {
    'old_password': _oldPassword,
    'new_password': _newPassword,
    'confirm_password': _newPassword,
  });
    ChangePasswordDb changePasswordDb = ChangePasswordDb.fromMap(response.data);
    return changePasswordDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}

}
