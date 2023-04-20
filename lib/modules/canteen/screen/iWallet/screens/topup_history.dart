import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:staff_ics/configs/const/app_colors.dart';
import 'package:staff_ics/utils/widgets/catch_dialog.dart';

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
      body: !isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: AppColor.primaryColor,
            ))
          : _buildBody,
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
        elevation: 2,
        child: Container(
          padding: EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                      height: 5.h,
                      child:
                          Image.asset('assets/image/canteen/iwallet_card.png')),
                  SizedBox(
                    width: 3.w,
                  ),
                  Container(
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
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${item.date}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.black.withOpacity(0.8)),
                        )
                      ],
                    ),
                  )
                ],
              ),
              item.statePreOrder == "draft"
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "\$${item.amountPaid}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                        ),
                        Text(
                          'On Hold',
                          textAlign: TextAlign.right,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.black),
                        )
                      ],
                    )
                  : Text(
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
          CatchDialog(
              messageError: "Something went wrong.\nPlease try again later.",
              title: 'Oops!');
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
}
