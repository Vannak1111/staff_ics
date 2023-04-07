// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:staff_ics/modules/canteen/screen/topup/controllers/topup_controller.dart';
import 'package:staff_ics/utils/helpers/get_image_network.dart';
import 'package:staff_ics/utils/widgets/custom_appbar.dart';
import 'package:staff_ics/utils/widgets/custom_buttom.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;

import '../../../../../utils/helpers/compress_image_to_file.dart';
import '../models/abs.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({Key? key}) : super(key: key);

  @override
  _TopUpScreenState createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen>
    with TickerProviderStateMixin {
  final controller = Get.put(TopUpController());
  final storage = GetStorage();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> menu = [];
  DefaultCacheManager manager = new DefaultCacheManager();
  List<Map<String, dynamic>> lines = [];

  @override
  void initState() {
    super.initState();
    controller.fetchABA();
    controller.tabController = TabController(length: 2, vsync: this);
    manager.emptyCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Top Up',
        onTap: () {
          Get.back();
        },
      ),
      body:  Obx(() => Container(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                Container(
                  width: 100.w,
                  height: 20.h,
                  color: Color(0xff1d1a56),
                  child: Center(
                    child: Image.asset(
                      'assets/image/canteen/top_up.png',
                      height: 15.h,
                      color: Colors.white,
                    ),
                  ),
                ),
                   _buildBodyExtend,

              ],
            ),
            
          ],
        ),
      ),
    ));
  }

  get _buildBodyExtend {
    return Expanded(
      child: Column(
        children: [
          Material(
            elevation: 3,
            child: Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: TabBar(
                controller: controller.tabController,
                unselectedLabelColor: Color(0xff1d1a56),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Color(0xff1d1a56),
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xff1d1a56))),
                tabs: [
                  Tab(
                    child: Text(
                      'Top Up',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Instructions',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
            
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [tabTopUp, tabInfo],
          ),),
        ],
      ),
    );
  }

  get tabInfo {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Html(
            data: storage.read("instruction"),
            tagsList: Html.tags,
            style: {
              "body": Style(
                fontSize: FontSize(
                  SizerUtil.deviceType == DeviceType.tablet ? 18.0 : 14.0,
                ),
                // fontWeight: FontWeight.bold,
              ),
              'html': Style(backgroundColor: Colors.white12),
              'table': Style(backgroundColor: Colors.grey.shade200),
              'td': Style(
                backgroundColor: Colors.grey.shade400,
                padding: EdgeInsets.all(10),
              ),
              'th': Style(padding: EdgeInsets.all(10), color: Colors.black),
              'tr': Style(
                  backgroundColor: Colors.grey.shade300,
                  border:
                      Border(bottom: BorderSide(color: Colors.greenAccent))),
            },
            onLinkTap: (String? url, RenderContext context,
                Map<String, String> attributes, dom.Element? element) {
              customLaunch(url);
            },
            onImageError: (exception, stacktrace) {
              print(exception);
            },
          ),
        ),
      ),
    );
  }

  get tabTopUp {
    return    Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
     
         Expanded(
            child:     ListView.builder(
                controller: _scrollController,
                physics: PageScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.recAbaData.length,
                itemBuilder: (context, index) => Container(
                  // child: Container(height: 30,color: Colors.red,),
                      child: _buildItem(
                        ABA(
                            amount: controller.recAbaData[index].amount,
                            image: controller.recAbaData[index].image,
                            link: controller.recAbaData[index].link),
                      ),
                    
          ))),
          controller.file != null
              ? _buildButtonSubmit()
              : CustomButtom(
                  ontap: () {
                    _showImageSourceActionSheet;
                  },
                  title: 'UPLOAD YOUR RECEIPT',
                  isDisable: false,
                ),
        ],
      ),
    );
  }

  _buildButtonSubmit() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: EdgeInsets.only(top: 20.0),
          child: TextField(
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
            enabled: false,
            controller: controller.textEditingController.value,
            enableInteractiveSelection: false,
            maxLength: 5,
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
              labelText: 'Amount',
              hintText: '',
              hintStyle: Theme.of(context).textTheme.bodyMedium,
              labelStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.grey),
              errorText:
                  controller.validate.value ? 'Message Can\'t Be Empty' : null,
              prefixIcon: Icon(Icons.currency_exchange_sharp),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(5),
          alignment: Alignment.center,
          height: 5.h,
          child: Card(
            child: Row(
              children: [
                InkWell(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: 85.w,
                    child: Text(
                      '${controller.file != null ? controller.file!.path.split("/").last : ''}',
                      style: TextStyle(
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 15.0
                              : 12.0,
                          decoration: TextDecoration.underline,
                          color: Colors.blueAccent),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  onTap: () {
                    debugPrint("nice to meet sister ");
                    setState(() {
                      controller.file = null;
                    });
                    if (controller.file != null) viewImage();
                  },
                ),
                 Expanded(
                    child: InkWell(
                  child: Container(
                    child: Icon(Icons.close),
                    height: 100.h,
                  ),
                  onTap: () {
                    setState(() {
                         controller.file = null;
                    });
                 
                  
                    controller.isSelect.value = false;
                  },
                )),
              ],
            ),
          ),
        ),
      CustomButtom(
          ontap: () async {
            controller.textEditingController.value.text.isEmpty
                ? controller.validate.value = true
                : controller.validate.value = false;

            if (controller.textEditingController.value.text.isNotEmpty) {
              lines.add({
                "qty": 1,
                "price_unit": controller.textEditingController.value.text,
                "price_subtotal": controller.textEditingController.value.text,
                "price_subtotal_incl": controller.textEditingController.value.text,
                "product_id": storage.read("product_id"),
                "line_id": 1
              });
              String image = await compressAndGetFile(controller.file!);
              controller.createOrder(
                  lines: lines,
                  amountPaid: double.parse(controller.textEditingController.value.text),
                  pickUp: "",
                  comment: "Top Up",
                  topUpAmount: double.parse(controller.textEditingController.value.text),
                  statePreOrder: "draft",
                  imageEncode: image);
            } else {
              message(title: "", body: "Please select amount");
            }
          },
          isDisable: false,
          title: 'SUBMIT',
        ),
      ],
    );
  }

  void viewImageLink({required String urlImage, required String link}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return Dialog(
            child: Container(
              color: Color(0xffdf1f25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 80.w,
                    child: FadeInImage(
                      image: NetworkImage(urlImage),
                      placeholder: AssetImage(
                        "assets/image/canteen/red_color.png",
                      ),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/image/canteen/red_color.png',
                          fit: BoxFit.fitWidth,
                          color: Color(0xffdf1f25),
                        );
                      },
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  InkWell(
                    onTap: () => customLaunch(link),
                    child: Container(
                      alignment: Alignment.center,
                      height: 7.h,
                      width: 80.w,
                      color: Color(0xffdf1f25),
                      child: Text('Link to ABA',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize:
                                  SizerUtil.deviceType == DeviceType.tablet
                                      ? 9.sp
                                      : 11.sp)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command, forceSafariVC: false);
    } else {
      print(' could not launch $command');
    }
  }

  void viewImage() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
              width: 80.w,
              child: Image.file(
                controller.file!,
              )),
        );
      },
    );
  }

  get _showImageSourceActionSheet {
    Get.bottomSheet(Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
      ),
      child: Wrap(
        alignment: WrapAlignment.end,
        children: [
          ListTile(
            minLeadingWidth: 10,
            leading: Icon(Icons.camera_alt),
            title: Text(
              'Use camera',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () async {
              Get.back();
              File? file =
                  await getImageNetwork(imageSource: ImageSource.camera);
              if (file != null) {
                setState(() {
                  controller.file = file;
                });
              }
            },
          ),
          ListTile(
            minLeadingWidth: 10,
            leading: Icon(Icons.image_rounded),
            title: Text(
              'Select photo',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () async {
              Get.back();
              File? file = await getImageNetwork();
              if (file != null) {
                setState(() {
                    controller.file = file;
              
                });
                  controller.isSelect.value = true;
              
              }
            },
          ),
        ],
      ),
    ));
  }

  _buildItem(ABA menu) {
    return InkWell(
      onTap: () {
        if (!controller.isSelect.value)
          controller.textEditingController.value.text = "${menu.amount}";
        viewImageLink(urlImage: menu.image, link: menu.link);
        controller.textEditingController.value.text = "${menu.amount}";
      },
      child: Card(
        elevation: 5,
        child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(8),
            height: 8.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.currency_exchange,
                      color: Color(0xff1d1a56),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      '${menu.amount}',
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xff1d1a56),
                )
              ],
            )),
      ),
    );
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
                padding: EdgeInsets.all(8.0),
                width: 70.w,
                height: 15.h,
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '$body',
                          style: Theme.of(context).textTheme.bodyMedium,
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
                        child: Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            key: const Key('closeIconKey'),
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
