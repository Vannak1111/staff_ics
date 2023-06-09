import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:staff_ics/modules/canteen/controllers/fetch_pos.dart';

import '../../../models/pos_db_model.dart';
import '../../../models/pos_order_history_db.dart';
import '../../../models/pos_user_db_model.dart';
import 'package:get_storage/get_storage.dart';
import '../../../models/topup_history_db.dart';

class IwalletController extends GetxController {
  final storage = GetStorage();
  late PosDb posDb;
  late PosUserDb posUserDb;
  late PosOrderHistoryDb posOrderHistoryDb;
  late TopUpHistoryDb topUpHistoryDb;

  Future fetchPos({String route = "products"}) async {
    Map<String, dynamic> data = {};
    if (route == "products")
      data = {
        "params": {"route": "products", "campus": storage.read("campus")}
      };
    else if (route == "user")
      data = {
        "params": {"route": "user", "student_id": storage.read('isActive')}
      };
    else if (route == "order_history")
      data = {
        "params": {
          "route": "order_history",
          "student_id": storage.read('isActive')
        }
      };
    else if (route == "top_up_history")
      data = {
        "params": {
          "route": "top_up_history",
          "student_id": storage.read('isActive')
        }
      };

    try {
      // print("fetchPos");
      // String fullUrl = "http://202.62.45.129:8069/ics_canteen";
      var response = await Dio(BaseOptions(headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      })).post(dotenv.get('baslurl_odoo'), data: data);
      // print("response.data=${response.data}");

      if (route == "products") {
        posDb = PosDb.fromMap(response.data);
        return posDb;
      } else if (route == "user") {
        posUserDb = PosUserDb.fromMap(response.data);
        debugPrint("ksksksksk $posUserDb");
        return posUserDb;
      } else if (route == "order_history") {
        posOrderHistoryDb = PosOrderHistoryDb.fromMap(response.data);
        return posOrderHistoryDb;
      } else if (route == "top_up_history") {
        topUpHistoryDb = TopUpHistoryDb.fromMap(response.data);
        return topUpHistoryDb;
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      return errorMessage;
    }
  }
}
