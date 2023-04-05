
import 'package:dio/dio.dart';
import '../../../modules/canteen/controllers/fetch_pos.dart';
import '../models/login_model.dart';

Dio _dio = Dio();

Future userLogin(String email, String password,String firebaseToken) async {
  FormData formData = FormData.fromMap({
    'email': email,
    'password': password,
    'firebase_token': firebaseToken,
  });

  try{
    String fullUrl = "http://202.62.45.129:8069/ics_canteen/""api/login";
    var response = await _dio.post(fullUrl, data: formData);
    LoginDb loginDb = LoginDb.fromMap(response.data);
    return loginDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
