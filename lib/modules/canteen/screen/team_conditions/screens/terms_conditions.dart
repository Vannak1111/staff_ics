
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sizer/sizer.dart';
import 'package:html/dom.dart' as dom;
import 'package:staff_ics/utils/widgets/custom_appbar_asset.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/fetch_pos.dart';
class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Container(
        child: Column(
          children: [
            Container(
      padding: EdgeInsets.all(8.0),
      width: 100.w,
      color: Color(0xff1d1a56),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomAppBarAssets(title: 'Terms & Conditions', assets: 'assets/image/canteen/term_condition.png')
         ],
      ),
    ),
            _buildBodyExtend,

          ],
        ),
      ),
    );
  }
}
  get _buildBodyExtend {
    return Expanded(
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Html(
              data: storage.read("term_condition"),
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
                // print(url);
                customLaunch(url);
                //open URL in webview, or launch URL in browser, or any other logic here
              },
              onImageError: (exception, stacktrace) {
                print(exception);
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command, forceSafariVC: false);
    } else {
      print(' could not launch $command');
    }
  }

