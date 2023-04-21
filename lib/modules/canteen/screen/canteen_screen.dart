// ignore_for_file: library_private_types_in_public_api

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:staff_ics/configs/const/app_colors.dart';
import 'package:staff_ics/modules/canteen/controllers/canteen_controller.dart';
import 'package:staff_ics/modules/canteen/screen/pre_order/controllers/pre_order_controller.dart';

class CanteenScreen extends StatefulWidget {
  const CanteenScreen({Key? key}) : super(key: key);

  @override
  _CanteenScreenState createState() => _CanteenScreenState();
}

class _CanteenScreenState extends State<CanteenScreen> {
  final storage = GetStorage();
  final _controller = Get.put(CanteenController());
  final _proOrderController = Get.put(PreOrderController());

  late String title, body;
  @override
  void initState() {
    super.initState();
    _controller.fetchPosUser().then((value) {
      debugPrint("data from api ${_controller.recPosUserData[0].cardId}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        body: !_controller.isLoading.value
            ? _loading()
            : Container(
                color: Color(0xff219ebc).withOpacity(0.06),
                height: double.infinity,
                child: Column(
                  children: [
                    _buildMainBalance,
                    _controller.recPosUserData[0].cardId != ""
                        ? Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                // Container(
                                //     child: Column(
                                //         children: _controller.menuCanteenList
                                //             .asMap()
                                //             .entries
                                //             .map((e) {
                                //   return Container(
                                //     child: _buildItem(e.key),
                                //   );
                                // }).toList())
                                ListView.builder(
                                  // physics: const Neve  rScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _controller.menuCanteenList.length,
                                  itemBuilder: (context, index) => Column(
                                    children: [
                                      _buildItem(index),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              )));
  }

  _loading() {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 15.h,
              color: AppColor.primaryColor.withOpacity(1),
              margin: EdgeInsets.only(bottom: 2.h),
            ),
            Center(
                child: CircularProgressIndicator(
              color: AppColor.primaryColor,
            )),
          ],
        ),
      ],
    );
  }

  _buildItem(int index) {
    return GestureDetector(
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppColor.backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.withOpacity(0.8))),
          margin: const EdgeInsets.only(left: 7, right: 7, bottom: 9),
          padding: EdgeInsets.only(left: 15),
          height: 8.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 9.w,
                    child: Image.asset(_controller.menuCanteenList[index].img),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _controller.menuCanteenList[index].title,
                      ),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      SizedBox(
                        width: 70.w,
                        child: AutoSizeText(
                          _controller.menuCanteenList[index].subtitle,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.grey),
                          minFontSize: 10,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          )),
      onTap: () {
        debugPrint("nice to meet you ");
        if ((_controller.recPosUserData[0].cardId != "" &&
            _controller.posSessionOrderId.value != 0 &&
            index == 0)) {
          _proOrderController.item.value = 0;
          _proOrderController.isLoading.value = false;
          _proOrderController.recPosData.value = [];
          _proOrderController.subTotal.value = 0;
          Get.toNamed('pre-order', arguments: _controller.productCount.value);
        } else if ((_controller.recPosUserData[0].cardId != "" &&
            _controller.posSessionTopUpId.value != 0 &&
            index == 1)) {
          Get.toNamed('top-up');
        } else if ((_controller.recPosUserData[0].cardId != "" &&
            (index == 2))) {
          Get.toNamed('iwallet', arguments: 0);
        } else if ((_controller.recPosUserData[0].cardId != "" &&
            (index == 3))) {
          Get.toNamed('purchase-limit');
        } else if (_controller.recPosUserData[0].cardId == "") {
          title = 'CARD';
          body = 'UNREGISTER';
          message(title: title, body: body);
        } else if (_controller.posSessionOrderId.value == 0 && (index == 0)) {
          title = '';
          body = storage.read("message_pre_order_closed");
          message(title: title, body: body);
        } else if (_controller.posSessionTopUpId.value == 0 && index == 1) {
          title = 'Top Up';
          body = storage.read("message_top_up_closed");
          message(title: title, body: body);
        } else if (index == 4) {
          Get.toNamed('terms-conditlions');
        }
      },
    );
  }

  get _buildMainBalance {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColor.primaryColor.withOpacity(1),
          border: Border.all(color: AppColor.primaryColor, width: 0.8)),
      height: 15.h,
      child: _controller.recPosUserData[0].cardId != ""
          ? Column(
              children: [
                Spacer(),
                Text("Available Balance",
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Colors.grey.withOpacity(0.6),
                        fontSize: SizerUtil.deviceType == DeviceType.tablet
                            ? 10.sp
                            : 12.sp)),
                SizedBox(
                  height: 5,
                ),
                Text("\$${_controller.f.format(_controller.balance.value)}",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: SizerUtil.deviceType == DeviceType.tablet
                            ? 16.sp
                            : 18.sp)),
                Spacer(),
              ],
            )
          : Container(
              alignment: Alignment.center,
              child: AutoSizeText("${storage.read("unregistered")}",
                  style: TextStyle(
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: SizerUtil.deviceType == DeviceType.tablet
                          ? 16.sp
                          : 18.sp),
                  minFontSize: 10,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
    );
  }

  handleReturnData({required String route, required int arg}) async {
    var data = await Get.toNamed(route, arguments: arg);
    // print("data-canteen=$data");
    if (data == true) {
      setState(() {
        _controller.fetchPosUser();
      });
    }
  }

  bool timeCheck() {
    bool diff = true;
    DateTime now = DateTime.now();
    String formattedDateTimeNow = DateFormat('y-MM-d kk:mm').format(now);
    String formattedDateNow = DateFormat('y-MM-d').format(now);
    DateTime dt = DateTime.parse(formattedDateTimeNow);
    DateTime dtFrom = DateTime.parse(
        "$formattedDateNow ${storage.read("pre_order_time_from")}");
    DateTime dtTo = DateTime.parse(
        "$formattedDateNow ${storage.read("pre_order_time_to")}");
    // print("dt1=$dt1");
    // print("dt2=$dt2");
    bool diffBefore = dt.isBefore(dtFrom);
    bool diffAfter = dt.isAfter(dtTo);

    // print("diffBefore=$diffBefore");
    // print("diffAfter=$diffAfter");
    if (!diffBefore && !diffAfter) {
      diff = false;
    }
    return diff;
  }

  Widget reloadBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.back();
          Navigator.of(context).pop();
          // _fetchPos();
        },
        child: const Text("OK"));
  }

  void message({required String title, required String body}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            // clipBehavior: Clip.antiAliasWithSaveLayer,
            content: InteractiveViewer(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                width: 80.w,
                height: 20.h,
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          body,
                          style: TextStyle(
                              color: AppColor.errorColor, fontSize: 18),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -5,
                      top: -5,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            key: Key('closeIconKey'),
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.close,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
