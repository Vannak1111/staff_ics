import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import '../models/pos_db_model.dart';
import '../models/pos_order_history_db.dart';
import '../models/pos_user_db_model.dart';
import '../models/topup_history_db.dart';

final storage = GetStorage();
late PosDb posDb;
late PosUserDb posUserDb;
late PosOrderHistoryDb posOrderHistoryDb;
late TopUpHistoryDb topUpHistoryDb;

Future fetchPos({String route = "products"}) async {
  Map<String, dynamic> data = {};
  if (route == "products") {
    data = {
      "params": {"route": "products", "campus": storage.read("campus")}
    };
  } else if (route == "user") {
    data = {
      "params": {"route": "user", "student_id": "IS202323"}
    };
  } else if (route == "order_history") {
    data = {
      "params": {"route": "order_history", "student_id": storage.read('isActive')}
    };
  } else if (route == "top_up_history") {
    data = {
      "params": {"route": "top_up_history", "student_id": storage.read('isActive')}
    };
  }

  try {
    print("fetchPos");
    // String fullUrl = "http://202.62.45.129:8069/ics_canteen";
    
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Content-Type": "application/json"
    })).post("http://202.62.45.129:8069/ics_canteen", data: data);
   
    if (route == "products") {
      posDb = PosDb.fromMap(response.data);
      return posDb;
    } else if (route == "user") {
      posUserDb = PosUserDb.fromMap(response.data);
      return posUserDb;
    } else if (route == "order_history") {
      posOrderHistoryDb = PosOrderHistoryDb.fromMap(response.data);
      return posOrderHistoryDb;
    }
    else if (route == "top_up_history") {
      topUpHistoryDb = TopUpHistoryDb.fromMap(response.data);
      return topUpHistoryDb;
    }
  } on DioError catch (e) {
    debugPrint("you have been chate ");
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}


class DioExceptions implements Exception {
  DioExceptions.fromDioError(DioError dioError) {
    // print("dioError.type=${dioError.type}");
    switch (dioError.type) {
      case DioErrorType.cancel:
      
        message = "Request to API server was cancelled";
        break;
      case DioErrorType.connectTimeout:
        message = "Connection timeout with API server";
        break;
      case DioErrorType.other:
        message = "Connection to server failed due to internet connection";
        break;
      case DioErrorType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioErrorType.response:
        print("DioErrorType.response");
        message =
            _handleError(dioError.response!.statusCode, dioError.response!.data);
        break;
      case DioErrorType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  String? message;

  String _handleError(int? statusCode, dynamic error) {
    print('statusCode=$error');
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return error["message"];
      case 404:
        return error["message"];
      case 500:
        return 'Internal server error';
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message!;
}

