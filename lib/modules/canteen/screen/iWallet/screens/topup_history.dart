import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../controllers/fetch_pos.dart';
import '../../../models/topup_history_db.dart';

class TopUpHistory extends StatefulWidget {
  const TopUpHistory({Key? key}) : super(key: key);

  @override
  _TopUpHistoryState createState() => _TopUpHistoryState();
}

class _TopUpHistoryState extends State<TopUpHistory> {
  late List<TopUpHistoryData> _recTopUpHistoryData = [];
  bool isLoading = false;

  @override
  void initState() {
    
    super.initState();
   

    _fetchTopUpHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: Text("History")),
      body: !isLoading ? Center(child: CircularProgressIndicator()) : _buildBody,
    );
  }

  get _buildBody {
    return Container(
      // height: 50,
      child: ListView.builder(
          physics: PageScrollPhysics(),
          shrinkWrap: true,
          itemCount: _recTopUpHistoryData.length,
          itemBuilder: (context, index) => Container(
            child: _buildItem(_recTopUpHistoryData[index]),
          )),
    );
  }

  _buildItem(item) {
    return InkWell(
      child: Card(
        elevation: 3,
        child: Container(
          padding: EdgeInsets.all(8),
          // height: 10.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(height: 5.h, child: Image.asset('assets/image/canteen/iwallet_card.png')),
                  SizedBox(width: 3.w,),
                  Container(
                    // width: 300,
                    // color: Colors.red,
                    height: 7.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "${item.posReference}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                         
                        ),
                        Text(
                          "${item.date}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        
                        )
                      ],
                    ),
                  )
                ],
              ),
              item.statePreOrder == "draft" ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "\$${item.amountPaid}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold,color: Colors.black),
                  ),
                  Text('On Hold',
                      textAlign: TextAlign.right,
                    )
                ],
              ) : Text(
                "\$${item.amountPaid}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
               
              )
            ],
          ),
        ),
      ),
     
    );
  }

  

  void _fetchTopUpHistory() {
    fetchPos(route: "top_up_history").then((value) {
      setState(() {
        try {
          _recTopUpHistoryData.addAll(value.response);
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

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget reloadBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.back();
          Navigator.of(context).pop();
          // _fetchPos();
        },
        child: Text("OK"));
  }
}
