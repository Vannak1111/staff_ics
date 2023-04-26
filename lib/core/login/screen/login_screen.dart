import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:staff_ics/configs/const/app_colors.dart';
import 'package:staff_ics/core/login/controller/login_controller.dart';

import '../../../utils/widgets/custom_buttom.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginController = Get.put(LoginController());
  final storage = GetStorage();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Obx(
            () => SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      CustomPaint(
                        size: Size(
                            100.w,
                            (100.h * 0.5)
                                .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                        painter: RPSCustomPainter(),
                      ),
                      Positioned(
                        child: Container(
                          height: 50.h,
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/image/utils/adaptive_icon_foreground.png",
                            width: SizerUtil.deviceType == DeviceType.tablet
                                ? 70.w
                                : 70.w,
                            height: 60.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(children: [
                      Container(
                        alignment: Alignment.center,
                        child: TextField(
                          autocorrect: false,
                          textInputAction: TextInputAction.next,
                          controller: loginController.emailController.value,
                          decoration: const InputDecoration(
                            labelText: "Username",
                            prefixIcon: Icon(Icons.person),
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: TextField(
                          onSubmitted: (value) {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          controller: loginController.passwordController.value,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                loginController.hidePasswork.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                loginController.hidePasswork.value =
                                    !loginController.hidePasswork.value;
                              },
                            ),
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                          obscureText: loginController.hidePasswork.value,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      CustomButtom(
                        ontap: () {
                          loginController.login();
                        },
                        title: "LOGIN",
                        isDisable: loginController.isDisableButton.value,
                        radius: 30,
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = AppColor.primaryColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    Path path0 = Path();
    path0.moveTo(0, 0);
    path0.lineTo(size.width, 0);
    path0.lineTo(size.width, size.height * 0.5740000);
    path0.lineTo(0, size.height);
    path0.lineTo(0, 0);
    path0.close();
    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
