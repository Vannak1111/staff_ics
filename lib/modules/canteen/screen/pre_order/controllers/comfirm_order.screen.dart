import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:staff_ics/modules/canteen/screen/pre_order/controllers/pre_order_controller.dart';

import '../../../controllers/fetch_pos.dart';

class ComfirmController extends GetxController{
  final preOderController= Get.put(PreOrderController());
  final amountPaid = 0.0.obs;
  final textEditingController = TextEditingController().obs;
  final pickUpTime = ''.obs;
  final isDisableButton=false.obs;
  final elements =[].obs;
  final lines =[].obs;

 void createOrder(
      {required List<Map<String, dynamic>> lines,
      required double amountPaid,
        required String pickUp,
        required String comment,
        required double topUpAmount,
        required String statePreOrder}) async {
    EasyLoading.show(status: 'Loading');
    await preOderController.posCreateOrder(
            lines: lines,
            amountPaid: amountPaid,
            pickUp: pickUp,
            comment: comment,
            topUpAmount: topUpAmount,
            statePreOrder: statePreOrder, imageEncode: '', type: 'prepaid')
        .then((value) {
      try {
        print('value-message=${value.message}');
        if (value.message == "Success") {
          EasyLoading.showSuccess('${value.description}', duration: Duration(seconds: 5));
          Get.back(result: true);
        } else if (value.message == "Session Closed") {
          EasyLoading.showInfo('${value.description}',
              duration: Duration(seconds: 5));
        } else if (value.message == "Balance") {
          EasyLoading.showInfo('${value.description}',
              duration: Duration(seconds: 5));
        }else if (value.message == "Purchase Limit") {
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
        Get.defaultDialog(
          title: "Error",
          middleText: "$value",
          barrierDismissible: true,
          confirm: ElevatedButton(
        onPressed: () {
          Get.back();
        
        },
        child: Text("OK",style: TextStyle(color: Colors.black))),
        );
      }
    });
  }
  bool timeCheck() {
    bool diff = true;
    DateTime now = new DateTime.now();
    String formattedDateTimeNow = DateFormat('y-MM-d kk:mm').format(now);
    String formattedDateNow = DateFormat('y-MM-d').format(now);
    DateTime dt = DateTime.parse(formattedDateTimeNow);
    DateTime dtFrom = DateTime.parse("$formattedDateNow ${storage.read("pre_order_time_from")}");
    DateTime dtTo = DateTime.parse("$formattedDateNow ${storage.read("pre_order_time_to")}");
    bool diffBefore = dt.isBefore(dtFrom);
    bool diffAfter = dt.isAfter(dtTo);
    if(!diffBefore && !diffAfter) // Ex: can order from 10:00 to 12:00
      diff = false;
    return diff;
  }
}