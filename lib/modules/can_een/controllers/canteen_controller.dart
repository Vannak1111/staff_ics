import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:staff_ics/modules/can_een/models/canteen_model.dart';
import 'package:staff_ics/modules/can_een/models/pos_user_model.dart';
import 'fetch_pos.dart';
class CanteenController extends GetxController{
  List<Canteen> menuCanteenList = [
  Canteen(img: 'assets/icons/canteen/foods_drinks.png', title: 'Pre-Order (For Lunch Only)', subtitle: 'Please make pre-orders before 10:00AM', route: 'pos_order'),
  Canteen(img: 'assets/icons/canteen/top_up.png', title: 'Top Up', subtitle: 'The amount will be transferred to your iWallet within 1 working day', route: 'top_up'),
  Canteen(img: 'assets/icons/canteen/iwallet_card.png', title: 'iWallet', subtitle: 'History of pre-oders and top ups', route: 'i_wallet'),
  Canteen(img: 'assets/icons/canteen/limit_purchase.png', title: 'Purchase Limit', subtitle: 'Set a daily purchase limit', route: 'limit_purchase'),
  Canteen(img: 'assets/icons/canteen/term_condition.png', title: 'Terms & Conditions', subtitle: 'Rules and Guidelines', route: 'terms_conditions'),
];
  final recPosUserData = <PosUserData>[].obs;
  final recCanteenMenu =<CanteenMenu>[].obs;
  final isFirstLoading =false.obs;
  final isLoading= false.obs;
  final posSessionOrderId=0.obs;
  final posSessionTopUpId=0.obs;
  final posMessage=false.obs;
  final posUserMessage=false.obs;
  final balance = 0.0.obs;
  final productCount=0.obs;
  var f = NumberFormat("##0.00", "en_US");
Future<void> fetchPosUser() async {
    await fetchPos(route: "user").then((value) {
      try {
        if(isFirstLoading.value){
            for(int i=0;i<value.canteenMenu.length;++i){
                recCanteenMenu.add(CanteenMenu(title: value.canteenMenu[i].title, subtitle:value.canteenMenu[i].subtitle));
            }
            recCanteenMenu.asMap().entries.map((e) {
              menuCanteenList[e.key].title = e.value.title;
              menuCanteenList[e.key].subtitle = e.value.subtitle;
              storage.write("unregistered", value.unregistered);
            });
            isFirstLoading.value = true;
          }
          posSessionOrderId.value = value.posSessionOrderId;
          posSessionTopUpId.value = value.posSessionTopUpId;
          posUserMessage.value = value.message;  
          for(int i=0;i<value.response.length;++i){
                recPosUserData.add(PosUserData(balanceCard: value.response[i].balanceCard, campus: value.response[i].campus, cardId: value.response[i].cardId, cardNo: "1", id: value.response[i].id, name: value.response[i].name, purchaseLimit: value.response[i].purchaseLimit));
            }
          balance.value = value.response[0].balanceCard;
          storage.write("campus", value.response[0].campus);
          storage.write("available_balance", f.format(balance.value));
          storage.write("term_condition", value.termCondition);
          storage.write("instruction", value.instruction);
          storage.write("pre_order_instruction", value.preOrderInstruction);
          storage.write("purchase_limit", value.response[0].purchaseLimit);
          storage.write("card_no", value.response[0].cardNo);
          storage.write("pick_up", value.pickUp);
          storage.write("product_id", value.productId);
          storage.write(
              "message_pre_order_closed", value.messagePreOrderClosed);
          storage.write("message_top_up_closed", value.messageTopUpClosed);
          storage.write(
              "message_pre_order_time_closed", value.messagePreOrderTimeClosed);
          storage.write("pre_order_time_from", value.preOrderTimeFrom);
          storage.write("pre_order_time_to", value.preOrderTimeTo);
          productCount.value = value.productsCount;
          isLoading.value = true;
      
      } catch (err) {
        debugPrint("you have been catched ");
        Get.defaultDialog(
          title: "Oops!",
          middleText: "Something went wrong.\nPlease try again later.",
          barrierDismissible: false,
          // confirm: reloadBtn(),
        );
      }
    });
  }
}


class Canteen {
  String img, title, subtitle, route;
  Canteen({required this.img, required this.title, required this.subtitle, required this.route});
}
