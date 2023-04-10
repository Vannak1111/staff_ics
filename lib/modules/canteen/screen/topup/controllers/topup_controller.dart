import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:staff_ics/utils/widgets/catch_dialog.dart';
import '../../../../../configs/const/ulr.dart';
import '../../../controllers/fetch_pos.dart';
import '../models/aba_qr_db.dart';
import '../models/pos_create_order_db.dart';

class TopUpController extends GetxController {
  final isSelect = false.obs;
  final recAbaData = <ABA>[].obs;
  final isDisableButton = false.obs;
  final validate = false.obs;
  File? file;
  TabController? tabController;
  final lines =[].obs;
  final textEditingController = TextEditingController().obs;
  final storage = GetStorage();
  late PosCreateOrderDb posCreateOrderDb;
  Future<void> fetchABA() async {
    await fetchDataToPayABA().then((value) {
      debugPrint("value respone ${value}");

      try {
        recAbaData.clear();
        for (int i = 0; i < value.data.length; ++i) {
          recAbaData.add(ABA(
              amount: value.data[i].amount,
              image: value.data[i].image,
              link: value.data[i].link));
        }
      } catch (err) {
        print("err=$err");
        CatchDialog(messageError: "Something went wrong.\nPlease try again later.", title: "Oops!");
       
      }
    });
  }

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
      print("response.data=${response.data}");
      posCreateOrderDb = PosCreateOrderDb.fromMap(response.data);
      return posCreateOrderDb;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      return errorMessage;
    }
  }

  void createOrder(
      {required List<Map<String, dynamic>> lines,
      required double amountPaid,
      required String pickUp,
      required String comment,
      required double topUpAmount,
      required String statePreOrder,
      required String imageEncode}) async {
    if (textEditingController.value.text.isEmpty) isDisableButton.value = false;
    if (textEditingController.value.text.isNotEmpty) {
      EasyLoading.show(status: 'Loading');
      await posCreateOrder(
              lines: lines,
              amountPaid: amountPaid,
              pickUp: pickUp,
              comment: comment,
              topUpAmount: topUpAmount,
              statePreOrder: statePreOrder,
              imageEncode: imageEncode,
              type: 'top_up')
          .then((value) {
        try {
          print('value-message=${value.message}');
          if (value.message == "Success") {
            EasyLoading.showSuccess('${value.description}',
                duration: Duration(seconds: 5));
            Get.back(result: true);
          } else if (value.message == "Session Closed") {
            EasyLoading.showInfo('${value.description}',
                duration: Duration(seconds: 5));
          } else if (value.message == "Balance") {
            EasyLoading.showInfo('${value.description}',
                duration: Duration(seconds: 5));
          } else {
            EasyLoading.showInfo(
                'Your Order is not complete.\nPlease Try again!!!',
                duration: Duration(seconds: 5));
          }

          isDisableButton.value = false;

          EasyLoading.dismiss();
        } catch (err) {
          isDisableButton.value = false;

          EasyLoading.dismiss();
          CatchDialog(messageError: "$value", title: "Error");
         
        }
      });
    }
  }

  Future fetchDataToPayABA() async {
    debugPrint("nice to meet you ");
    try {
      String fullUrl = baseUrl_school + getAbaList;
      debugPrint("token ${storage.read('user_token')}");
      var response = await Dio(BaseOptions(headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${storage.read('user_token')}"
      })).get(fullUrl);

      AbaQrDb abaDb = AbaQrDb.fromMap(response.data);
      return abaDb;
    } on DioError catch (e) {
      debugPrint("You have been catch ");
      final errorMessage = DioExceptions.fromDioError(e).toString();
      return errorMessage;
    }
  }
}
