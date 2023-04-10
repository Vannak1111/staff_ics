import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';
import 'package:staff_ics/modules/canteen/screen/pre_order/screens/comfirm_order_screen.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';
import '../../../../../configs/const/app_colors.dart';
import '../../../controllers/fetch_pos.dart';
import '../controllers/pre_order_controller.dart';

class PreOrderScreen extends StatefulWidget {
  const PreOrderScreen({Key? key}) : super(key: key);

  @override
  _PreOrderScreenState createState() => _PreOrderScreenState();
}

class _PreOrderScreenState extends State<PreOrderScreen>
    with TickerProviderStateMixin {
  final _proOrderController = Get.put(PreOrderController());
  final ItemScrollController itemScrollController = ItemScrollController();
  DefaultCacheManager manager = new DefaultCacheManager();
  late TabController _tabController;
  double _fontSize = 0;

  var f = NumberFormat("##0.00", "en_US");
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: int.parse('${Get.arguments}'), vsync: this);
    _fetchPos();
    _fontSize = SizerUtil.deviceType == DeviceType.tablet ? 9.sp : 11.sp;
    _itemPositionsListener.itemPositions.addListener(() {
      _proOrderController.currentIndex.value =
          _itemPositionsListener.itemPositions.value.elementAt(0).index;
      if (_proOrderController.currentIndex.value >
              _proOrderController.shadowIndex.value ||
          _proOrderController.currentIndex.value <
              _proOrderController.shadowIndex.value) {
        _proOrderController.shadowIndex.value =
            _proOrderController.currentIndex.value;

        _tabController.index = _proOrderController.shadowIndex.value;

        print("Move to ${_proOrderController.shadowIndex.value}");
      }
    });
    manager.emptyCache();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
        appBar:  AppBar(
          backgroundColor: AppColor.primaryColor,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Platform.isIOS
                  ? Icons.arrow_back_ios_rounded
                  : Icons.arrow_back_rounded,
              color: AppColor.backgroundColor,
              size: 30,
            ),
          ),
          title: Text(
            "Order",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 19,
                ),
          ),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  info();
                },
                icon: Icon(Icons.info_outline)),
          ],
        ),
        body: !_proOrderController.isLoading.value
              ? Center(child: CircularProgressIndicator(color: AppColor.primaryColor,))
              : Column(
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints.expand(height: 6.h),
                      child: TabBar(
                        onTap: (index) async {
                          scrollTo(index);
                        },
                        controller: _tabController,
                        labelColor: Colors.blueAccent,
                        unselectedLabelColor: Colors.blueGrey,
                        indicatorColor: Colors.blueAccent,
                        isScrollable: true,
                        tabs: tabMaker(),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: ScrollablePositionedList.builder(
                            itemScrollController: itemScrollController,
                            itemPositionsListener: _itemPositionsListener,
                            itemCount: _proOrderController.recPosData.length,
                            itemBuilder: (context, index) {
                              return StickyHeader(
                                header: Container(
                                  height: 8.h,
                                  color: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${_proOrderController.recPosData[index].group}',
                                  ),
                                ),
                                content: Container(
                                  child: ListView.builder(
                                      controller: _proOrderController
                                          .scrollController.value,
                                      physics: PageScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: _proOrderController
                                          .recPosData[index].list.length,
                                      itemBuilder:
                                          (context, index2) => Container(
                                                child: InkWell(
                                                  child: Card(
                                                    color: _proOrderController
                                                                .recPosData[
                                                                    index]
                                                                .list[index2]
                                                                .amount !=
                                                            0
                                                        ? Colors.grey.shade200
                                                        : null,
                                                    elevation: 5,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(8),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: 12.h,
                                                                height: 12.h,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(
                                                                                10.0)),
                                                                        image:
                                                                            DecorationImage(
                                                                          image: imageFromBase64String(jsonDecode(_proOrderController
                                                                              .recPosData[index]
                                                                              .list[index2]
                                                                              .image)),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        )),
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  height: 12.h,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      Container(
                                                                          alignment: Alignment
                                                                              .centerLeft,
                                                                          child:
                                                                              Text(
                                                                            "${_proOrderController.recPosData[index].list[index2].name}",
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                          )),
                                                                      Align(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            Text(
                                                                          "\$${f.format(_proOrderController.recPosData[index].list[index2].lstPrice)}",
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                             _proOrderController
                                                                            .recPosData[
                                                                                index]
                                                                            .list[
                                                                                index2]
                                                                            .amount !=
                                                                        0
                                                                    ? Container(
                                                                        height:
                                                                            5.h,
                                                                        width:
                                                                            22.w,
                                                                        decoration: BoxDecoration(
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.grey.withOpacity(0.5),
                                                                                spreadRadius: 1,
                                                                                blurRadius: 7,
                                                                                offset: Offset(0, 3), // changes position of shadow
                                                                              ),
                                                                            ],
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius: BorderRadius.circular(5)),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(4.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              InkWell(
                                                                                child: Icon(
                                                                                  Icons.remove,
                                                                                  color: Colors.black,
                                                                                ),
                                                                                onTap: () {
                                                                                  _proOrderController.recPosData[index].list[index2].amount = _proOrderController.recPosData[index].list[index2].amount - 1;
                                                                                  _proOrderController.subTotal.value = _proOrderController.subTotal.value - _proOrderController.recPosData[index].list[index2].lstPrice;
                                                                                  _proOrderController.item.value--;
                                                                                },
                                                                              ),
                                                                              Text('${_proOrderController.recPosData[index].list[index2].amount}'),
                                                                              InkWell(
                                                                                child: Icon(
                                                                                  Icons.add,
                                                                                  color: Colors.blue,
                                                                                ),
                                                                                onTap: () {
                                                                                  _proOrderController.recPosData[index].list[index2].amount = _proOrderController.recPosData[index].list[index2].amount + 1;
                                                                                  _proOrderController.item.value++;
                                                                                  _proOrderController.subTotal.value = _proOrderController.subTotal.value + _proOrderController.recPosData[index].list[index2].lstPrice;
                                                                                },
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          elevation:
                                                                              8.0,
                                                                          backgroundColor:
                                                                              Colors.white,
                                                                          shape:
                                                                              CircleBorder(),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          // debugPrint(
                                                                          //     "khmer sl khmer ");
                                                                          _proOrderController
                                                                              .recPosData[index]
                                                                              .list[index2]
                                                                              .amount = 1;
                                                                          debugPrint("amount ${index} ${index2} ${_proOrderController
                                                                              .recPosData[index]
                                                                              .list[index2]
                                                                              .amount}");
                                                                          _proOrderController
                                                                              .item
                                                                              .value++;
                                                                          _proOrderController
                                                                              .subTotal
                                                                              .value = _proOrderController
                                                                                  .subTotal.value +
                                                                              _proOrderController.recPosData[index].list[index2].lstPrice;
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .add,
                                                                          color:
                                                                              Color(0xff1d1a56),
                                                                        )),
                                                              
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )),
                                ),
                              );
                            }),
                      ),
                    )
                  ],
                ),
      
        bottomNavigationBar:  _proOrderController.item.value != 0
              ? _buildButtonAddToCard()
              : SizedBox(),
        ));
  }

  _buildButtonAddToCard() {
    return Container(
      height: 10.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _proOrderController.item.value <= 1
                  ? "${_proOrderController.item.value} Item"
                  : "${_proOrderController.item.value} Items",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: AppColor.primaryColor),
            ),
            Container(
              height: 8.h,
              width: 50.w,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 8.0,
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    List<Map<String, dynamic>> _itemSelected = [];
                    _proOrderController.recPosData.forEach((element) {
                      var items = element.list
                          .where((item) => item.amount > 0)
                          .toList();
                      items.forEach((element) {
                        _itemSelected.add({
                          'id': element.id,
                          'name': element.name,
                          'lst_price': element.lstPrice,
                          'image': element.image,
                          'amount': element.amount
                        });
                      });
                    });
                    handleReturnData(itemSelected: _itemSelected);
                  },
                  child: Text(
                    "ADD TO CART : \$${f.format(_proOrderController.subTotal.value)}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  handleReturnData({required List<Map<String, dynamic>> itemSelected}) async {
    var data = await Get.to(() => PosCart(
          elements: itemSelected,
          total: _proOrderController.subTotal.value,
        ));
    if (data == true) {
      Get.back(result: true);
    }
  }

  List<Tab> tabMaker() {
    List<Tab> tabs = [];
    for (var i = 0; i < _proOrderController.recPosData.length; i++) {
      tabs.add(Tab(
        child: Text(
          _proOrderController.recPosData[i].group,
          style: TextStyle(fontSize: _fontSize),
        ),
      ));
    }
    return tabs;
  }

  get _buildBody {
    return ScrollablePositionedList.builder(
        itemScrollController: itemScrollController,
        itemPositionsListener: _itemPositionsListener,
        itemCount: _proOrderController.recPosData.length,
        itemBuilder: (context, index) {
          return StickyHeader(
            header: Container(
              height: 8.h,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                '${_proOrderController.recPosData[index].group}',
              ),
            ),
            content: Container(
              child: ListView.builder(
                  controller: _proOrderController.scrollController.value,
                  physics: PageScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _proOrderController.recPosData[index].list.length,
                  itemBuilder: (context, index2) => Container(
                        child: InkWell(
                          child: Card(
                            color: _proOrderController.recPosData[index]
                                        .list[index2].amount !=
                                    0
                                ? Colors.grey.shade200
                                : null,
                            elevation: 5,
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12.h,
                                        height: 12.h,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            image: DecorationImage(
                                              image: imageFromBase64String(
                                                  jsonDecode(_proOrderController
                                                      .recPosData[index]
                                                      .list[index2]
                                                      .image)),
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 12.h,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "${_proOrderController.recPosData[index].list[index2].name}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                  )),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "\$${f.format(_proOrderController.recPosData[index].list[index2].lstPrice)}",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      _proOrderController.recPosData[index]
                                                  .list[index2].amount !=
                                              0
                                          ? Container(
                                              height: 5.h,
                                              width: 22.w,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      spreadRadius: 1,
                                                      blurRadius: 7,
                                                      offset: Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      child: Icon(
                                                        Icons.remove,
                                                        color: Colors.black,
                                                      ),
                                                      onTap: () {
                                                        debugPrint(
                                                            "nice to meet you getx ");
                                                        _proOrderController
                                                                .recPosData[index]
                                                                .list[index2]
                                                                .amount =
                                                            _proOrderController
                                                                    .recPosData[
                                                                        index]
                                                                    .list[
                                                                        index2]
                                                                    .amount -
                                                                1;
                                                        _proOrderController
                                                                .subTotal
                                                                .value =
                                                            _proOrderController
                                                                    .subTotal
                                                                    .value -
                                                                _proOrderController
                                                                    .recPosData[
                                                                        index]
                                                                    .list[
                                                                        index2]
                                                                    .lstPrice;
                                                        _proOrderController
                                                            .item.value--;
                                                      },
                                                    ),
                                                    Text(
                                                        '${_proOrderController.recPosData[index].list[index2].amount}'),
                                                    InkWell(
                                                      child: Icon(
                                                        Icons.add,
                                                        color: Colors.blue,
                                                      ),
                                                      onTap: () {
                                                        debugPrint(
                                                            "ncie to meet you hhhhhh");
                                                        _proOrderController
                                                                .recPosData[index]
                                                                .list[index2]
                                                                .amount =
                                                            _proOrderController
                                                                    .recPosData[
                                                                        index]
                                                                    .list[
                                                                        index2]
                                                                    .amount +
                                                                1;
                                                        _proOrderController
                                                            .item.value++;
                                                        _proOrderController
                                                                .subTotal
                                                                .value =
                                                            _proOrderController
                                                                    .subTotal
                                                                    .value +
                                                                _proOrderController
                                                                    .recPosData[
                                                                        index]
                                                                    .list[
                                                                        index2]
                                                                    .lstPrice;
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                elevation: 8.0,
                                                backgroundColor: Colors.white,
                                                shape: CircleBorder(),
                                              ),
                                              onPressed: () {
                                                debugPrint("khmer sl khmer ");
                                                _proOrderController
                                                    .recPosData[index]
                                                    .list[index2]
                                                    .amount = 1;
                                                _proOrderController
                                                    .item.value++;
                                                _proOrderController.subTotal
                                                    .value = _proOrderController
                                                        .subTotal.value +
                                                    _proOrderController
                                                        .recPosData[index]
                                                        .list[index2]
                                                        .lstPrice;
                                              },
                                              child: Icon(
                                                Icons.add,
                                                color: Color(0xff1d1a56),
                                              )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
            ),
          );
        });
  }

  void scrollTo(int index) {
    itemScrollController.scrollTo(
        index: index,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOutCubic,
        alignment: 0);
  }

  void _fetchPos() {
    fetchPos().then((value) {
      try {
        _proOrderController.recPosData.addAll(value.response);
        debugPrint("data respone ${_proOrderController.recPosData[0].list}");
        _proOrderController.isLoading.value = true;
      } catch (err) {
        print("err=$err");
      }
    });
  }
  void info() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            content: SingleChildScrollView(
              child: InteractiveViewer(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  width: 85.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          height: 4.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                  child: Text(
                                'Instructions',style: Theme.of(context).textTheme.bodyMedium,
                              )),
                              GestureDetector(
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
                              )
                            ],
                          )),
                      new Divider(
                        color: Colors.grey.shade700,
                      ),
                      Container(
                        child: Html(
                          data: storage.read("pre_order_instruction"),
                          tagsList: Html.tags,
                          style: {
                            "body": Style(
                              fontSize: FontSize(
                                SizerUtil.deviceType == DeviceType.tablet
                                    ? 18.0
                                    : 14.0,
                              ),
                              // fontWeight: FontWeight.bold,
                            ),
                            'html': Style(backgroundColor: Colors.white12),
                            'table':
                                Style(backgroundColor: Colors.grey.shade200),
                            'td': Style(
                              backgroundColor: Colors.grey.shade400,
                              padding: EdgeInsets.all(10),
                            ),
                            'th': Style(
                                padding: EdgeInsets.all(10),
                                color: Colors.black),
                            'tr': Style(
                                backgroundColor: Colors.grey.shade300,
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.greenAccent))),
                          },
                          onLinkTap: (String? url,
                              RenderContext context,
                              Map<String, String> attributes,
                              dom.Element? element) {
                            customLaunch(url);
                          },
                          onImageError: (exception, stacktrace) {
                            print(exception);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command, forceSafariVC: false);
    } else {
      print(' could not launch $command');
    }
  }

  static MemoryImage imageFromBase64String(String base64String) {
    return MemoryImage(base64Decode(base64String));
  }
}
