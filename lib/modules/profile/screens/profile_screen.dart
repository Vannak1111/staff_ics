import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:staff_ics/configs/const/app_colors.dart';
import 'package:staff_ics/modules/profile/controllers/profile_controller.dart';
import 'package:staff_ics/utils/widgets/catch_dialog.dart';
import 'package:staff_ics/utils/widgets/custom_buttom.dart';

import '../models/datum_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileController = Get.put(ProfileController());
  double _fontSize = SizerUtil.deviceType == DeviceType.tablet ? 18 : 14;
  final storage = GetStorage();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _fetchProfile(apiKey: storage.read('user_token'));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Focus.of(context).unfocus();
      },
      child: Scaffold(
          body: Obx(
        () => _buildBody,
      )),
    );
  }

  get _buildBody {
    return Container(
      color: AppColor.backgroundColor,
      child: Column(
        children: [
          _headerImage,
          _studentProfile,
        ],
      ),
    );
  }

  void _fetchProfile({required String apiKey}) {
    _profileController.fetchProfile(apiKey: apiKey).then((value) {
      try {
        print("value.data.list=${value.data}");
        for (int i = 0; i < value.data.data.length; ++i) {
          _profileController.profile.add(Datum1(
              id: value.data.data[0].id,
              name: value.data.data[0].name,
              email: value.data.data[0].email,
              phone: value.data.data[0].phone,
              classId: value.data.data[0].classId,
              className: value.data.data[0].className,
              campus: value.data.data[0].campus,
              fullImage: value.data.data[0].fullImage,
              version: value.data.data[0].version));
        }
        storage.write('isPhoto', value.data.data[0].fullImage);
        storage.write('isActive', value.data.data[0].email);
      } catch (err) {
        print("value=$value");
        CatchDialog(messageError: "$value", title: "Error");
      }
    });
  }

  get _headerImage {
    if (_profileController.profile.isEmpty) {
      _profileController.isLoading.value = false;
    } else {
      _profileController.isLoading.value = true;
    }

    return Container(
      color: AppColor.primaryColor,
      width: 100.w,
      height: 180,
      child: !_profileController.isLoading.value
          ? Center(
              child: Container(
                height: 120,
                width: 120,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
            )
          : Center(
              child: Stack(
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                  ),
                  Positioned(
                    left: 5,
                    top: 5,
                    child: Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                              _profileController.profile[0].fullImage),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  get _studentProfile {
    if (_profileController.profile.isEmpty) {
      _profileController.isLoading.value = false;
    } else {
      _profileController.isLoading.value = true;
    }
    return !_profileController.isLoading.value
        ? Center(
            child: CircularProgressIndicator(
            color: AppColor.primaryColor,
          ))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  border: TableBorder(
                      horizontalInside: BorderSide(
                          width: 1,
                          color: Colors.grey,
                          style: BorderStyle.solid)),
                  columnWidths: {
                    0: FlexColumnWidth(0.5),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(children: [
                      _tableCell('ID:', FontWeight.bold, _fontSize),
                      _tableCell('${_profileController.profile[0].email}',
                          FontWeight.normal, _fontSize),
                    ]),
                    TableRow(children: [
                      _tableCell('Full name:', FontWeight.bold, _fontSize),
                      _tableCell('${_profileController.profile[0].name}',
                          FontWeight.normal, _fontSize),
                    ]),
                    TableRow(children: [
                      _tableCell('Phone:', FontWeight.bold, _fontSize),
                      _tableCell('${_profileController.profile[0].phone}',
                          FontWeight.normal, _fontSize),
                    ]),
                    TableRow(children: [
                      _tableCell('Password:', FontWeight.bold, _fontSize),
                      InkWell(
                        onTap: () => _showChangePasswordActionSheet,
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 8.sp),
                              alignment: Alignment.centerLeft,
                              height: 6.h,
                              child: Text(
                                '**************',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Container(
                              child: Icon(Icons.arrow_forward_sharp),
                              padding: EdgeInsets.only(top: 8.sp, right: 8.sp),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              Container(
                height: 1,
                width: 100.w,
                color: Colors.grey,
                margin: EdgeInsets.only(left: 8, right: 8),
              ),
              SizedBox(
                height: 20,
              ),
              CustomButtom(
                  ontap: () {
                    storage.remove('user_token');
                    Get.toNamed("login");
                  },
                  title: "logout",
                  isDisable: false)
            ],
          );
  }

  Widget _tableCell(String exam, FontWeight fontWeight, double fontSize) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 6.h,
      child: Text(
        exam,
        style: TextStyle(
            fontWeight: fontWeight, fontSize: fontSize, color: Colors.black),
      ),
    );
  }

  void _changePassword() {
    EasyLoading.show(status: 'Loading');
    _profileController
        .userChangePassword(
            _profileController.currentPasswordController.value.text.trim(),
            _profileController.newPasswordController.value.text.trim())
        .then((value) {
      try {
        print('Success=${value.status}');

        if (value.status) {
          storage.write('isPassword',
              _profileController.newPasswordController.value.text.trim());

          _profileController.currentPasswordController.value.clear();
          _profileController.newPasswordController.value.clear();
          _profileController.confirmPasswordController.value.clear();
          Get.back();
          EasyLoading.showSuccess('Password Changed!');
          EasyLoading.dismiss();
          _profileController.isLoading.value = true;
          _profileController.isDisableButton.value = false;
        } else {
          EasyLoading.dismiss();
        }
      } catch (err) {
        EasyLoading.dismiss();

        _profileController.isDisableButton.value = false;

        value =
            value == 'Unauthorized' ? 'Username/Password is incorrect!' : value;
        CatchDialog(messageError: "$value", title: "Error");
      }
    });
  }

  get _showChangePasswordActionSheet {
    Get.bottomSheet(Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
      ),
      child: StatefulBuilder(builder: (BuildContext context,
          StateSetter setState /*You can rename this!*/) {
        return Form(
          key: formKey,
          child: Wrap(
            children: [
              Obx(() => Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(
                        horizontal: SizerUtil.deviceType == DeviceType.tablet
                            ? 30.sp
                            : 40),
                    child: TextFormField(
                      controller:
                          _profileController.currentPasswordController.value,
                      validator: (value) {
                        if (value!.isEmpty ||
                            value.trim() != storage.read('isPassword'))
                          return 'Password is incorrect';
                        else
                          return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Current password",
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _profileController.hideOldPWD.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            _profileController.hideOldPWD.value =
                                !_profileController.hideOldPWD.value;
                          },
                        ),
                      ),
                      style: TextStyle(
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 18
                              : 14,
                          color: Color(0xff1a0785)),
                      obscureText: _profileController.hideOldPWD.value,
                    ),
                  )),
              Obx(
                () => Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(
                      horizontal: SizerUtil.deviceType == DeviceType.tablet
                          ? 30.sp
                          : 40),
                  child: TextFormField(
                    controller: _profileController.newPasswordController.value,
                    validator: (value) {
                      if (value!.isEmpty || value.trim().length <= 5)
                        return 'Password must be at least 6 characters';
                      else if (value.trim() ==
                          _profileController
                              .currentPasswordController.value.text)
                        return "New password cannot be the same as current password";
                      else if (value.trim() !=
                          _profileController
                              .confirmPasswordController.value.text)
                        return 'New password and confirm new password do not match';
                      else
                        return null;
                    },
                    decoration: InputDecoration(
                      labelText: "New password",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _profileController.hideNewPWD.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          _profileController.hideNewPWD.value =
                              !_profileController.hideNewPWD.value;
                        },
                      ),
                    ),
                    style: TextStyle(
                        fontSize:
                            SizerUtil.deviceType == DeviceType.tablet ? 18 : 14,
                        color: Color(0xff1a0785)),
                    obscureText: _profileController.hideNewPWD.value,
                  ),
                ),
              ),
              Obx(() => Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(
                        horizontal: SizerUtil.deviceType == DeviceType.tablet
                            ? 30.sp
                            : 40),
                    child: TextFormField(
                      controller:
                          _profileController.confirmPasswordController.value,
                      validator: (value) {
                        if (value!.isEmpty || value.trim().length <= 5)
                          return 'Password must be at least 6 characters';
                        else
                          return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Confirm new password",
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _profileController.hideConfirmPWD.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            _profileController.hideConfirmPWD.value =
                                !_profileController.hideConfirmPWD.value;
                          },
                        ),
                      ),
                      style: TextStyle(
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 18
                              : 14,
                          color: Color(0xff1a0785)),
                      obscureText: _profileController.hideConfirmPWD.value,
                    ),
                  )),
              SizedBox(height: 3.h),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                    horizontal:
                        SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40,
                    vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      print("Validation");
                      if (_profileController.isDisableButton.value == false) {
                        _profileController.isDisableButton.value = true;

                        _changePassword();
                      }
                    }
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    )),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height:
                        SizerUtil.deviceType == DeviceType.tablet ? 60.0 : 50.0,
                    width: 60.w,
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        gradient: new LinearGradient(
                          colors: [Color(0xff1a237e), Colors.lightBlueAccent],
                        )),
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "CHANGE PASSWORD",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 18
                              : 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    ));
  }
}
