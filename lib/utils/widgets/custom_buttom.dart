import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:staff_ics/configs/const/app_colors.dart';

class CustomButtom extends StatelessWidget {
  final GestureTapCallback ontap;
  final String title;
  final bool isDisable;
  const CustomButtom(
      {super.key,
      required this.ontap,
      required this.title,
      required this.isDisable});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          if (isDisable == false) {
            ontap();
          }
        },
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          padding:
              MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(0)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            // side: BorderSide(color: Colors.red)
          )),
        ),
        child: Container(
          alignment: Alignment.center,
          height: SizerUtil.deviceType == DeviceType.tablet ? 60.0 : 50.0,
          width: 100.w,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(15.0),
            color: AppColor.primaryColor
            // gradient: LinearGradient(
            //   colors: [AppColor.primaryColor, Colors.lightBlueAccent],
            // ),
          ),
          padding: const EdgeInsets.all(0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: SizerUtil.deviceType == DeviceType.tablet ? 18 : 14),
          ),
        ),
      ),
    );
  }
}
