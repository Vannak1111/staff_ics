import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../controllers/fetch_pos.dart';
import '../models/purchase_limitDb_model.dart';

class PurchaseContrller extends GetxController {
  final storage = GetStorage();
  late PurchaseLimitDb purchaseLimitDb;
  final textEditingController = TextEditingController().obs;
  final isDisableButton = true.obs;
  final newLimitPurchase = 0.0.obs;
  Future posPurchaseLimit({required double purchaseLimit}) async {
    Map<String, dynamic> data = {};
    data = {
      "params": {
        "route": "purchase_limit",
        "student_id": storage.read('isActive'),
        "purchase_limit": purchaseLimit
      }
    };

    try {
      // print("fetchPos");
      // String fullUrl = "http://202.62.45.129:8069/ics_canteen";
      var response = await Dio(BaseOptions(headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      })).post(dotenv.get('baslurl_odoo'), data: data);
      purchaseLimitDb = PurchaseLimitDb.fromMap(response.data);
      return purchaseLimitDb;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      return errorMessage;
    }
  }
}
