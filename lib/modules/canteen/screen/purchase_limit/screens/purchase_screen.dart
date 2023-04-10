import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:staff_ics/configs/const/app_colors.dart';
import 'package:staff_ics/modules/canteen/controllers/canteen_controller.dart';
import 'package:staff_ics/modules/canteen/screen/purchase_limit/controllers/purchase_controller.dart';
import 'package:staff_ics/utils/widgets/custom_appbar.dart';
import 'package:staff_ics/utils/widgets/custom_buttom.dart';

class PurchaseLimitScreen extends StatefulWidget {
  const PurchaseLimitScreen({Key? key}) : super(key: key);

  @override
  _PurchaseLimitScreenState createState() => _PurchaseLimitScreenState();
}

class _PurchaseLimitScreenState extends State<PurchaseLimitScreen> {
  final _purchaseController = Get.put(PurchaseContrller());
  final _canteenController = Get.put(CanteenController());

  @override
  void initState() {
    super.initState();
    if (_canteenController.purchaseLimit.value == 0.0)
      _purchaseController.textEditingController.value.text = "";
    else
      _purchaseController.textEditingController.value.text =
          "${NumberFormat("##0.00", "en_US").format(_canteenController.purchaseLimit.value)}";
    debugPrint(
        "old value ${_purchaseController.textEditingController.value.text}/");
    _purchaseController.newLimitPurchase.value =
        double.parse(_purchaseController.textEditingController.value.text);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: CustomAppBar(
              title: 'Daily Purchase Limit',
              onTap: () {
                Get.back();
              },
            ),
            body: Container(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        width: 100.w,
                        height: 30.h,
                        color: Color(0xff1d1a56),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/image/canteen/limit_purchase.png',
                              height: 15.h,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      _buildBodyExtend,
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  get _buildBodyExtend {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0),
            color: Colors.white,
            child: TextFormField(
              onChanged: (value) {
                debugPrint("value of bottom   ${value}");
                if (value == '') {
                  _purchaseController.isDisableButton.value = true;
                } else {
                  if (_purchaseController.newLimitPurchase.value ==
                          double.parse(value)) {
                    _purchaseController.isDisableButton.value = true;
                  } else {
                    _purchaseController.isDisableButton.value = false;
                  }
                }
              },
              style: Theme.of(context).textTheme.bodyLarge!,
              controller: _purchaseController.textEditingController.value,
              enableInteractiveSelection: false,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                TextInputFormatter.withFunction(
                  (oldValue, newValue) => newValue.copyWith(
                    text: newValue.text.replaceAll(',', '.'),
                  ),
                ),
              ],
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: AppColor.primaryColor,
                  ),
                ),
                labelText:
                    _purchaseController.textEditingController.value.text.isEmpty
                        ? 'Unlimited'
                        : 'Maximum purchase amount limit',
                hintText: '',
                focusColor: Color(0xff1d1a56),
                prefixIcon: Icon(Icons.currency_exchange_sharp),
              ),
            ),
          ),
          CustomButtom(
              ontap: () {
                var value = _purchaseController
                        .textEditingController.value.text.isNotEmpty
                    ? double.parse(
                        _purchaseController.textEditingController.value.text)
                    : 0.0;
                if (!_purchaseController.isDisableButton.value)
                  _setPurchaseLimit(purchaseLimit: value);
              },
              title: 'SAVE',
              isDisable: _purchaseController.isDisableButton.value),
        ],
      ),
    );
  }

  void _setPurchaseLimit({required double purchaseLimit}) async {
    _purchaseController.isDisableButton.value = true;
    EasyLoading.show(status: 'Loading');
    await _purchaseController
        .posPurchaseLimit(purchaseLimit: purchaseLimit)
        .then((value) {
      try {
        print('value-message=${value.message}');
        if (value.message == true) {
          EasyLoading.showSuccess('Saved');
          Get.back(result: true);
        }
        _purchaseController.isDisableButton.value = false;
        EasyLoading.dismiss();
      } catch (err) {
        _purchaseController.isDisableButton.value = false;

        EasyLoading.dismiss();
        Get.defaultDialog(
          title: "Error",
          middleText: "$value",
          barrierDismissible: true,
          confirm: reloadBtn(),
        );
      }
    });
  }

  Widget reloadBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text("OK"));
  }
}
