import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:staff_ics/configs/const/app_colors.dart';
import 'package:staff_ics/modules/canteen/controllers/canteen_controller.dart';
import 'package:staff_ics/modules/canteen/screen/iWallet/screens/topup_history.dart';

import 'order_history.dart';

class IWalletScreen extends StatefulWidget {
  final int index;
  const IWalletScreen({Key? key, this.index = 0}) : super(key: key);
  @override
  _IWalletScreenState createState() => _IWalletScreenState();
}

class _IWalletScreenState extends State<IWalletScreen>
    with TickerProviderStateMixin {
  final _canteenController = Get.put(CanteenController());
  final storage = GetStorage();
  double _fontSize = 0;
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.animateTo(0);
    _tabController = TabController(length: 2, vsync: this);
    _fontSize = SizerUtil.deviceType == DeviceType.tablet ? 9.sp : 11.sp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                leadingWidth: 100.w,
                backgroundColor: AppColor.primaryColor,
                expandedHeight: 30.h,
                leading: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
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
                    SizedBox(
                      width: 10,
                    ),
                    // Text("iWallet history",
                    //     style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 19,),),
                  ],
                ),
                floating: false,
                pinned: true,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return FlexibleSpaceBar(
                      centerTitle: true,
                      background: _buildBalanceCard,
                    );
                  },
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    unselectedLabelColor: Color(0xff1d1a56),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Color(0xff1d1a56),
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xff1d1a56))),
                    tabs: [
                      Tab(
                        child: Text(
                          'Top Ups',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: _fontSize),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Orders',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: _fontSize),
                        ),
                      ),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          // body: Container(height: double.infinity,color: Colors.pink,),
          body: TabBarView(
            controller: _tabController,
            children: [
              tabTopUp,
              tabOrder,
            ],
          ),
        ),
      ),
    );
  }

  get _buildBalanceCard {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage("assets/image/canteen/iWallet.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: Text("${_canteenController.cardNo.value}",
                style: TextStyle(
                    color: Color(0xff1d1a56),
                    fontWeight: FontWeight.w700,
                    fontSize: SizerUtil.deviceType == DeviceType.tablet
                        ? 12.sp
                        : 13.sp)),
            alignment: Alignment.centerRight,
            width: 100.w,
          ),
          Container(
            alignment: Alignment.center,
            child: Text("iWallet History",
                style: TextStyle(
                  color: Color(0xff1d1a56),
                  fontWeight: FontWeight.w900,
                  fontSize:
                      SizerUtil.deviceType == DeviceType.tablet ? 20.sp : 22.sp,
                  fontStyle: FontStyle.italic,
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${storage.read('isName')}",
                      style: TextStyle(
                          color: Color(0xff1d1a56),
                          fontWeight: FontWeight.bold,
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 12.sp
                              : 13.sp)),
                  Text("${storage.read('isActive')}",
                      style: TextStyle(
                          color: Color(0xff1d1a56),
                          fontWeight: FontWeight.w600,
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 11.sp
                              : 12.sp)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Available Balance",
                      style: TextStyle(
                          color: Color(0xff1d1a56),
                          fontWeight: FontWeight.w700,
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 12.sp
                              : 13.sp)),
                  Text("\$${_canteenController.availableBalance.value}",
                      style: TextStyle(
                          color: Colors.deepOrangeAccent,
                          fontWeight: FontWeight.w900,
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 15.sp
                              : 16.sp)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  get tabTopUp {
    return TopUpHistory();
  }

  get tabOrder {
    return PosHistory();
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      elevation: 2,
      child: new Container(
        color: Colors.white,
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
