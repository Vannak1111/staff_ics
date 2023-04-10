import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:staff_ics/modules/canteen/screen/pre_order/controllers/comfirm_order.screen.dart';
import 'package:staff_ics/utils/widgets/custom_appbar.dart';
import '../controllers/pre_order_controller.dart';

class PosCart extends StatefulWidget {
  final List<Map<String, dynamic>> elements;
  final double total;

  const PosCart({Key? key, required this.elements, required this.total})
      : super(key: key);

  @override
  _PosCartState createState() => _PosCartState();
}

class _PosCartState extends State<PosCart> {
  final preOderController = Get.put(PreOrderController());
  final _confirmOrderController = Get.put(ComfirmController());
  final storage = GetStorage();
  DefaultCacheManager manager = new DefaultCacheManager();
  var f = NumberFormat("##0.00", "en_US");
  List<Map<String, dynamic>> lines = [];
  late Map<String, dynamic> value;

  @override
  void initState() {
    super.initState();
    manager.emptyCache();
    _confirmOrderController.elements.value = widget.elements;
    int i = 0;
    _confirmOrderController.elements.forEach((element) {
      i++;
      value = {
        "qty": element['amount'],
        "price_unit": element['lst_price'],
        "price_subtotal": f.format(element['amount'] * element['lst_price']),
        "price_subtotal_incl":
            f.format(element['amount'] * element['lst_price']),
        "product_id": element['id'],
        "line_id": i
      };
      _confirmOrderController.amountPaid.value = _confirmOrderController.amountPaid.value +
          double.parse(f.format(element['amount'] * element['lst_price']));
      lines.add(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: CustomAppBar(title: "Order Comfirmation",onTap: (){
        Get.back();
      },),
      body: _buildBody,
      bottomNavigationBar: _buildBottomNavigationBar,
    ));
  }

  get _buildBottomNavigationBar {
    return Container(
      height: 13.h,
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          )),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Container(
          height: 10.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total",),
                  Text("\$${f.format(widget.total)}",
                      ),
                ],
              ),
              SizedBox(
                height: 6.h,
                width: 100.w,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 8.0,
                      backgroundColor: Color(0xff1d1a56),
                    ),
                    onPressed: () {
                      if(!_confirmOrderController.timeCheck())
                        message(title: '', body: storage.read("message_pre_order_time_closed"));
                      else{
                        if (_confirmOrderController.isDisableButton.value == false) {
                  
                            _confirmOrderController.isDisableButton.value = true;
                     
                         _confirmOrderController.createOrder(lines: lines, amountPaid: _confirmOrderController.amountPaid.value, pickUp: _confirmOrderController.pickUpTime.value, comment: _confirmOrderController.textEditingController.value.text, topUpAmount: 0.0, statePreOrder: 'draft');
                        }
                      }
                    },
                    child: Text("ORDER NOW",
                       ),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  get _buildBody {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
                // physics: AlwaysScrollableScrollPhysics(),
                physics: PageScrollPhysics(),
                shrinkWrap: true,
                itemCount: _confirmOrderController.elements.length,
                itemBuilder: (context, index) => Container(
                      child: _buildItem(_confirmOrderController.elements[index], index),
                    )),
            
            Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                child: Text('Remark',style: Theme.of(context).textTheme.bodyLarge,),),
            Padding(
              padding:
                  EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
              child: TextFormField(
                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black),
                minLines: 1,
                maxLines: 5,
                controller: _confirmOrderController.textEditingController.value,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Please leave a message, if there is.',
                  hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildItem(item, index) {
    return InkWell(
      child: Card(
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
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        image: DecorationImage(
                          image: imageFromBase64String(jsonDecode(item['image'])),
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${item['name']}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                               
                              )),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "X ${item['amount']}",
                             
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Expanded(
                      flex: 0,
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                              "\$${f.format(item['lst_price'] * item['amount'])}",
                             )))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget reloadBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.back();
          Navigator.of(context).pop();
        },
        child: Text("OK"));
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
                width: 80.w,
                height: 20.h,
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('$body',
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

  static MemoryImage imageFromBase64String(String base64String) {
    return MemoryImage(base64Decode(base64String));
  }
}
