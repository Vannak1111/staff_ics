import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:staff_ics/configs/const/app_colors.dart';

import '../../../controllers/fetch_pos.dart';
import '../../../models/pos_order_history_db.dart';
class PosHistory extends StatefulWidget {
  const PosHistory({Key? key}) : super(key: key);

  @override
  _PosHistoryState createState() => _PosHistoryState();
}

class _PosHistoryState extends State<PosHistory> {
  late List<PosOrderHistoryData> _recPosOrderHistoryData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPosOrderHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("History")),
      body:
          !isLoading ? Center(child: CircularProgressIndicator(color: AppColor.primaryColor,)) : _buildBody,
    );
  }

  get _buildBody {
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: _recPosOrderHistoryData.length,
          itemBuilder: (context, index) => Column(
                children: [
                  Container(
                    height: 8.h,
                    color: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '${_recPosOrderHistoryData[index].receipt}',
                              // style: myTextStyleHeader[phoneSize],
                            ),
                            Text(
                              '${_recPosOrderHistoryData[index].date}',
                              // style: myTextStyleHeader[phoneSize],
                            ),
                          ],
                        ),
                        Text(
                          '\$${_recPosOrderHistoryData[index].amountPaid}',
                          // style: myTextStyleHeader[phoneSize],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _recPosOrderHistoryData[index].list.length,
                        itemBuilder: (context, index2) => Container(
                              child: _buildItem(
                                  _recPosOrderHistoryData[index].list[index2]),
                            )),
                  ),
                ],
              )),
    );
  }

  _buildItem(item) {
    return Card(
      elevation: 3,
      child: Container(
        padding: EdgeInsets.all(8),
        // height: 120,
        child: Row(
          children: [
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(
                height: 7.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "${item.name}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "X ${item.qty}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 0,
                child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "\$${item.priceSubtotal}",
                    )))
          ],
        ),
      ),
    );
  }

  
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _fetchPosOrderHistory() {
    fetchPos(route: "order_history").then((value) {
      setState(() {
        try {
     
          _recPosOrderHistoryData.addAll(value.response);
        
          isLoading = true;
        } catch (err) {
          print("err=$err");
          Get.defaultDialog(
            title: "Oops!",
            middleText: "Something went wrong.\nPlease try again later.",
            barrierDismissible: false,
            confirm: reloadBtn(),
          );
        }
      });
    });
  }

  Widget reloadBtn() {
    return ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          _fetchPosOrderHistory();
        },
        child: Text("OK"));
  }
}
