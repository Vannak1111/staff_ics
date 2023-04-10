import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:staff_ics/configs/const/app_colors.dart';
import 'package:staff_ics/modules/profile/controllers/profile_controller.dart';
import 'package:staff_ics/modules/profile/screens/pdf_view_screen.dart';
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
  bool _hide = true,
      _hideOldPWD = true,
      _hideNewPWD = true,
      _hideConfirmPWD = true;
  final picker = ImagePicker();
  final storage = GetStorage();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  late List<Datum1> _profile = [];
  bool isLoading = false;
  late bool _isDisableButton;
  late Map<String, dynamic> _mapUser, _mapAllUser;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _isDisableButton = false;
    if (storage.read('user_token') != null) {
      _fetchProfile(apiKey: storage.read('user_token'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Focus.of(context).unfocus();
      },
      child: Scaffold(
        body: storage.read('user_token') != null ? _buildBody : _loginPage,
      ),
    );
  }

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
      );

  get _buildBody {
    return Container(
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
      setState(() {
        try {
          print("value.data.list=${value.data}");
          for (int i = 0; i < value.data.data.length; ++i) {
            _profile.add(Datum1(
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
    });
  }

  get _headerImage {
    if (_profile.isEmpty) {
      isLoading = false;
    } else {
      isLoading = true;
    }

    return Container(
      color: AppColor.primaryColor,
      width: 100.w,
      height: 180,
      child: !isLoading
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
                          image: NetworkImage(_profile[0].fullImage),
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
    if (_profile.isEmpty) {
      isLoading = false;
    } else {
      isLoading = true;
    }
    return !isLoading
        ? Center(child: CircularProgressIndicator(color: AppColor.primaryColor,))
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
                      _tableCell('Student ID:', FontWeight.bold, _fontSize),
                      _tableCell(
                          '${_profile[0].email}', FontWeight.normal, _fontSize),
                    ]),
                    TableRow(children: [
                      _tableCell('Full name:', FontWeight.bold, _fontSize),
                      _tableCell(
                          '${_profile[0].name}', FontWeight.normal, _fontSize),
                    ]),
                    TableRow(children: [
                      _tableCell('Class:', FontWeight.bold, _fontSize),
                      _tableCell('${_profile[0].className}', FontWeight.normal,
                          _fontSize),
                    ]),
                    TableRow(children: [
                      _tableCell('Phone Number:', FontWeight.bold, _fontSize),
                      _tableCell(
                          '${_profile[0].phone}', FontWeight.normal, _fontSize),
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
             SizedBox(height: 20,),
                  CustomButtom(ontap: (){
              storage.remove('user_token');
              Get.toNamed("login");
            }, title: "logout", isDisable: false)
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

  get _loginPage {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Image.asset(
                        SizerUtil.deviceType == DeviceType.tablet
                            ? "assets/icons/login_icon/iPad.png"
                            : "assets/icons/login_icon/iPhone.png",
                        width: double.infinity,
                        fit: BoxFit.cover),
                    Positioned(
                      child: Container(
                        height: 50.h,
                        alignment: Alignment.center,
                        child: Image.asset(
                            "assets/icons/home_screen_icon_one_color/ICS_International_School.png",
                            width: SizerUtil.deviceType == DeviceType.tablet
                                ? 45.w
                                : 60.w,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Text(
                  'USER LOGIN',
                  style: TextStyle(
                      fontSize: SizerUtil.deviceType == DeviceType.tablet
                          ? 14.sp
                          : 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1a0785)),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                    horizontal:
                        SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40),
                child: TextField(
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  controller: emailController,
                  decoration: InputDecoration(
                      labelText: "Username", prefixIcon: Icon(Icons.person)),
                  style: TextStyle(
                      fontSize:
                          SizerUtil.deviceType == DeviceType.tablet ? 18 : 14,
                      color: Color(0xff1a0785)),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                    horizontal:
                        SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40),
                child: TextField(
                  onSubmitted: (value) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hide ? Icons.visibility : Icons.visibility_off,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          _hide = !_hide;
                        });
                      },
                    ),
                  ),
                  style: TextStyle(
                      fontSize:
                          SizerUtil.deviceType == DeviceType.tablet ? 18 : 14,
                      color: Color(0xff1a0785)),
                  obscureText: _hide,
                ),
              ),
              SizedBox(height: 3.h),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(
                    horizontal:
                        SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40,
                    vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    if (_isDisableButton == false) {
                      setState(() {
                        _isDisableButton = true;
                      });
                      _login();
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
                      // side: BorderSide(color: Colors.red)
                    )),
                  ),
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(15.0)),
                  // textColor: Colors.white,
                  // padding: const EdgeInsets.all(0),
                  child: Container(
                    alignment: Alignment.center,
                    height:
                        SizerUtil.deviceType == DeviceType.tablet ? 60.0 : 50.0,
                    width: 100.w,
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        gradient: new LinearGradient(
                          colors: [Color(0xff1a237e), Colors.lightBlueAccent],
                        )),
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "LOGIN",
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
        ),
      ),
    );
  }

  void _login() {
    EasyLoading.show(status: 'Loading');
    _profileController
        .userLogin(emailController.text.trim(), passwordController.text.trim(),
            storage.read('device_token'))
        .then((value) {
      try {
        print('Success=${value.status}');
        EasyLoading.showSuccess('Logged in successfully!');
        EasyLoading.dismiss();
        setState(() {
          //storage.write('isUsername', emailController.text.trim());
          storage.write('isPassword', passwordController.text.trim());
          storage.write('user_token', value.data.token);
          _fetchProfile(apiKey: value.data.token);
          isLoading = true;
        });
      } catch (err) {
        EasyLoading.dismiss();
        setState(() {
          _isDisableButton = false;
        });
        value =
            value == 'Unauthorized' ? 'Username/Password is incorrect!' : value;
          CatchDialog(messageError: "$value", title: "Error");
      }
    });
  }

  void _changePassword() {
    EasyLoading.show(status: 'Loading');
    _profileController
        .userChangePassword(currentPasswordController.text.trim(),
            newPasswordController.text.trim())
        .then((value) {
      try {
        print('Success=${value.status}');

        if (value.status) {
          setState(() {
            // _mapUser[storage.read('isActive')]['password'] =
            //     newPasswordController.text.trim();
                  storage.write('isPassword', newPasswordController.text.trim());
            // for (dynamic type in _mapAllUser.keys) {
            //   if (type == storage.read('isActive')) {
              
            //     break;
            //   }
            // }
            currentPasswordController.clear();
            newPasswordController.clear();
            confirmPasswordController.clear();
            Get.back();
            EasyLoading.showSuccess('Password Changed!');
            EasyLoading.dismiss();
            isLoading = true;
            _isDisableButton = false;
          });
        } else {
          EasyLoading.dismiss();
        }
      } catch (err) {
        EasyLoading.dismiss();
        setState(() {
          _isDisableButton = false;
        });
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
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                    horizontal:
                        SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40),
                child: TextFormField(
                  controller: currentPasswordController,
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
                        _hideOldPWD ? Icons.visibility : Icons.visibility_off,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          _hideOldPWD = !_hideOldPWD;
                        });
                      },
                    ),
                  ),
                  style: TextStyle(
                      fontSize:
                          SizerUtil.deviceType == DeviceType.tablet ? 18 : 14,
                      color: Color(0xff1a0785)),
                  obscureText: _hideOldPWD,
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                    horizontal:
                        SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40),
                child: TextFormField(
                  controller: newPasswordController,
                  validator: (value) {
                    if (value!.isEmpty || value.trim().length <= 5)
                      return 'Password must be at least 6 characters';
                    else if (value.trim() == currentPasswordController.text)
                      return "New password cannot be the same as current password";
                    else if (value.trim() != confirmPasswordController.text)
                      return 'New password and confirm new password do not match';
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                    labelText: "New password",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hideNewPWD ? Icons.visibility : Icons.visibility_off,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          _hideNewPWD = !_hideNewPWD;
                        });
                      },
                    ),
                  ),
                  style: TextStyle(
                      fontSize:
                          SizerUtil.deviceType == DeviceType.tablet ? 18 : 14,
                      color: Color(0xff1a0785)),
                  obscureText: _hideNewPWD,
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                    horizontal:
                        SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40),
                child: TextFormField(
                  controller: confirmPasswordController,
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
                        _hideConfirmPWD
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          _hideConfirmPWD = !_hideConfirmPWD;
                        });
                      },
                    ),
                  ),
                  style: TextStyle(
                      fontSize:
                          SizerUtil.deviceType == DeviceType.tablet ? 18 : 14,
                      color: Color(0xff1a0785)),
                  obscureText: _hideConfirmPWD,
                ),
              ),
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
                      if (_isDisableButton == false) {
                        setState(() {
                          _isDisableButton = true;
                        });
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
                      // side: BorderSide(color: Colors.red)
                    )),
                  ),
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(15.0)),
                  // textColor: Colors.white,
                  // padding: const EdgeInsets.all(0),
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

  Widget reloadBtn(String message) {
    return ElevatedButton(
        onPressed: () {
          if (message == 'Unauthenticated.') {
            _removeUser;
            // Get.offAll(() => SwitchAccountPage(), arguments: 'Unauthenticated.');
          } else {
            Get.back();
          }
        },
        child: Text("OK"));
  }

  get _removeUser {
    _mapUser = storage.read('mapUser');
    // print("_mapUser.length=${_mapUser.length}");
    if (_mapUser.length >= 1) {
      for (dynamic type in _mapUser.keys) {
        if (type == storage.read('isActive')) {
          setState(() {
            _mapUser.remove(type);
            storage.write('mapUser', _mapUser);
          });
          break;
        }
      }
    }
    storage.remove('exam_schedule_badge');
    storage.remove('notification_badge');
    storage.remove('user_token');
    storage.remove('isActive');
    storage.remove('isName');
    storage.remove('isClassId');
    storage.remove('isUserId');
    storage.remove('isGradeLevel');
    storage.remove('isPassword');
    storage.remove('user_token');
    storage.remove('isActive');
    storage.remove('assignment_badge');
    storage.remove('isPhoto');
    // print("_mapUser.length=${_mapUser.length}");
  }
}
