import 'dart:io';

import 'package:flutter/material.dart';
import 'package:staff_ics/configs/const/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GestureTapCallback? onTap;
  final String title;
  final bool isBack;
  CustomAppBar({this.onTap, required this.title,this.isBack=true});

  @override
  Size get preferredSize => Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 40),
          height: 100,
          color: AppColor.primaryColor,
          alignment: Alignment.center,
          child: Row(
            children: [
              isBack==false? Row(
                children: [
                  SizedBox(width: 25,),
                  Text("$title",
                          style: Theme.of(context).textTheme.titleMedium),
                ],
              ):
              Row(
                children: [
                  SizedBox(width: 10,),
                  IconButton(
                    onPressed: () {
                      onTap!();
                    },
                    icon: Icon(
                      Platform.isIOS
                          ? Icons.arrow_back_ios_rounded
                          : Icons.arrow_back_rounded,
                      color: AppColor.backgroundColor,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text("$title",
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
