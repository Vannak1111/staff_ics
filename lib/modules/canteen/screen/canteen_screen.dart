// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:animated_icon/animate_icon.dart';
import 'package:animated_icon/animate_icons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:staff_ics/configs/const/app_colors.dart';
import 'package:staff_ics/modules/canteen/controllers/canteen_controller.dart';


class CanteenScreen extends StatefulWidget {
  const CanteenScreen({Key? key}) : super(key: key);

  @override
  _CanteenScreenState createState() => _CanteenScreenState();
}

class _CanteenScreenState extends State<CanteenScreen> {
  final storage = GetStorage();
  final _controller = Get.put(CanteenController());
  late String title, body;
  @override
  void initState() {
    super.initState();
    _controller.fetchPosUser();
    // phoneSize = SizerUtil.deviceType == DeviceType.tablet
    //     ? PhoneSize.ipad
    //     : PhoneSize.iphone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Obx(()=> !_controller. isLoading.value
        ? _loading()
        : SizedBox(
            height: 100.h,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  children: [_buildHeader, _buildBodyListExtend],
                ),
                _buildMainBalance,
                Positioned(
                  left: 20,
                  top: 40,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      !Platform.isAndroid ? Icons.arrow_back_ios : Icons.arrow_back,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ))
    );  
  }

  _loading() {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 30.h,
              color: const Color(0xff1d1a56),
              margin: EdgeInsets.only(bottom: 2.h),
            ),
             Center(child: CircularProgressIndicator(color: AppColor.primaryColor,)),
          ],
        ),
        Positioned(
          left: 20,
          top: 40,
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              !Platform.isAndroid  ? Icons.arrow_back_ios : Icons.arrow_back,
              size: 25,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  get _buildHeader {
    return _controller.recPosUserData[0].name != "" ? Container(
      padding: const EdgeInsets.all(8.0),
      height: 30.h,
      color: AppColor.primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildUrlImages(storage.read('isPhoto') ?? ''),
          SizedBox(
            width: 2.w,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Text(_controller.recPosUserData[0].name,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: SizerUtil.deviceType == DeviceType.tablet
                            ? 14.sp
                            : 18.sp)),
              ),
              Text('${storage.read('isActive')?? 'No'} ',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: SizerUtil.deviceType == DeviceType.tablet
                          ? 10.sp
                          : 11.sp)),
            ],
          ),
        ],
      ),
    ) : Container(padding: const EdgeInsets.all(8.0),
      height: 30.h,
      color: AppColor.primaryColor,);
  }
  get _buildBodyListExtend {
    return _controller.recPosUserData[0].cardId != ""
        ? Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _controller.menuCanteenList.length,
                      itemBuilder: (context, index) => Column(
                            children: [
                              index == 0
                                  ?  Divider(
                                      color: AppColor.primaryColor,
                                      height: 2,
                                    )
                                  : const SizedBox(),
                              _buildItem(index),
                               Divider(
                                color: AppColor.primaryColor,
                                height: 2,
                              )
                            ],
                          ),),
                ],
              ),
            ),
          )
        : const SizedBox();
  }
  _buildItem(int index) {
    return InkWell(
      child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 8, right: 8),
          height: 8.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                      height: 10.w,
                      child: const Icon(Icons.home),
                      // child: Image.asset(_controller.menuCanteenList[index].img),
                      ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_controller.menuCanteenList[index].title,
                         ),
                      SizedBox(height: 0.5.h,),
                      SizedBox(
                        width: 70.w,
                        child: AutoSizeText(_controller.menuCanteenList[index].subtitle,
                            style: TextStyle(
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.tablet
                                        ? 15
                                        : 12), minFontSize: 10, maxLines: 2,
                          overflow: TextOverflow.ellipsis,),
                      ),
                    ],
                  )
                ],
              ),
               Icon(
                Icons.arrow_forward_ios,
                color: AppColor.primaryColor),
          
            ],
          )),
      onTap: () {
        if ((_controller.recPosUserData[0].cardId != "" &&
            _controller.posSessionOrderId.value != 0 &&
            index == 0)) {
          handleReturnData(
              route: _controller.menuCanteenList[index].route, arg: _controller.productCount.value);
       
        } else if ((_controller.recPosUserData[0].cardId != "" &&
            _controller.posSessionTopUpId.value != 0 &&
            index == 1)) {
          handleReturnData(
              route: _controller.menuCanteenList[index].route, arg: _controller.productCount.value);
        } else if ((_controller.recPosUserData[0].cardId != "" &&
            (index == 2 || index == 3))) {
          handleReturnData(
              route: _controller.menuCanteenList[index].route, arg: _controller.productCount.value);
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
          handleReturnData(
              route: _controller.menuCanteenList[index].route, arg: _controller.productCount.value);
        }
      },
    );
  }

  get _buildMainBalance {
    return Positioned(
        top: 23.h,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow:  [
              BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 0.2, offset: const Offset(2, 3))
            ],
          ),
          width: 90.w,
          height: 13.h,
          child: _controller.recPosUserData[0].cardId != "" ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 10.w,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Available Balance",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 10.sp
                              : 12.sp)),
                  Text("\$${_controller.f.format(_controller.balance.value)}",
                      style: TextStyle(
                          color: const Color(0xff1d1a56),
                          fontWeight: FontWeight.bold,
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 16.sp
                              : 18.sp))
                ],
              ),
              Container(
                  alignment: Alignment.topRight,
                  width: 10.w,
                  height: 100.w,
                  child: AnimateIcon(
                    key: UniqueKey(),
                    onTap: () {
                     _controller. fetchPosUser();
                    },
                    iconType: IconType.animatedOnTap,
                    width: 8.w,
                    color: Colors.blue,
                    animateIcon: AnimateIcons.refresh,
                  )),
            ],
          ) : Container(
            alignment: Alignment.center,
            child: AutoSizeText("${storage.read("unregistered")}",
                style: TextStyle(
                    color: const Color(0xff1d1a56),
                    fontWeight: FontWeight.bold,
                    fontSize: SizerUtil.deviceType == DeviceType.tablet
                        ? 16.sp
                        : 18.sp), minFontSize: 10, maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ),
        ));
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

  _buildUrlImages(String urlImage) {
    return CachedNetworkImage(
      height: 10.h,
      width: 10.h,
      imageUrl: urlImage,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            alignment: Alignment.topCenter,
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) =>
          Image.asset("assets/icons/login_icon/logo_no_background.png"),
    );
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
                        child: Text(body,
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

