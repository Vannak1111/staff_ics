import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
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
      child: Scaffold(
        body: Obx(
          () => SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Image.asset(
                      SizerUtil.deviceType == DeviceType.tablet
                          ? "assets/image/login/background.png"
                          : "assets/image/login/background.png",
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      child: Container(
                        height: 45.h,
                        alignment: Alignment.center,
                        child: Image.asset(
                            "assets/image/login/ics_International_school.png",
                            width: SizerUtil.deviceType == DeviceType.tablet
                                ? 45.w
                                : 60.w,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
                // Text('USER LOGIN', style: Theme.of(context).textTheme.titleSmall),
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
                        debugPrint("nice to meet you ");
                        loginController.login();
                      },
                      title: "LOGIN",
                      isDisable: loginController.isDisableButton.value,
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

