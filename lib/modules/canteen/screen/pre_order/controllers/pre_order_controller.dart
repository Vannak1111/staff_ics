import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:staff_ics/modules/canteen/models/pos_db_model.dart';
import '../../../../../configs/const/ulr.dart';
import '../../../controllers/fetch_pos.dart';
import '../../topup/models/pos_create_order_db.dart';
class PreOrderController extends GetxController{
final storage = GetStorage();
late PosCreateOrderDb posCreateOrderDb;
final isLoading = false.obs;
final item =0.obs;
final subTotal=0.0.obs;
final recPosData = <PosData>[].obs;
final currentIndex=0.obs;
final shadowIndex=0.obs;
final scrollController  = ScrollController().obs;
Future posCreateOrder(
    {required List<Map<String, dynamic>> lines,
    required String type,
    required double amountPaid,
    required String pickUp,
    required String comment,
    required double topUpAmount,
    required String statePreOrder,
    required String imageEncode}) async {
  Map<String, dynamic> data = {};
  data = {
    "params": {
      "route": "create_order",
      "type": type,
      "student_id": storage.read('isActive'),
      "amount_paid": amountPaid,
      "lines": lines,
      "campus": storage.read("campus"),
      "pick_up": pickUp,
      "comment": comment,
      "top_up": topUpAmount,
      "state_pre_order": statePreOrder,
      "image_encode": imageEncode
    }
  };
  try {
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Content-Type": "application/json"
    })).post(baseUrl_odoo, data: data);
    posCreateOrderDb = PosCreateOrderDb.fromMap(response.data);
    return posCreateOrderDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
}

