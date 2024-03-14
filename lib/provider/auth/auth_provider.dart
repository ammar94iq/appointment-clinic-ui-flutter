import 'package:flutter/material.dart';

import '../../main.dart';
import '../api/crud.dart';
import '../api/links.dart';

class AuthProvider extends ChangeNotifier {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String? userType;
  void selectUserType(String? value) {
    userType = value;
  }

  final Crud _crud = Crud();
  String resultMessage = '';
  Future<void> register() async {
    if (name.text.isNotEmpty &&
        phone.text.isNotEmpty &&
        email.text.isNotEmpty &&
        password.text.isNotEmpty &&
        userType != null) {
      final responseBody = await _crud.postRequest(linkRegister, {
        "name": name.text,
        "phone": phone.text,
        "email": email.text,
        "password": password.text,
        "userType": userType,
      });
      if (responseBody['status'] == 'success') {
        if (userType == "مستخدم") {
          await sharedPre.setString(
              "randomId", responseBody['randomId'].toString());
          await sharedPre.setString("userType", userType.toString());
          resultMessage = "success";
        } else {
          resultMessage =
              "تم انشاء حسابك بنجاح ولكن لايزال بانتظار موافقة الادمن";
        }
      } else if (responseBody['status'] == 'find') {
        resultMessage =
            "هذا الايميل او رقم الهاتف مرتبط بحساب حالي ولا يمكن اضافته مرة اخرى";
      } else {
        resultMessage = "فشل انشاء حسابك يرجى اعادة المحاولة";
      }
    } else {
      resultMessage = "يجب ملئ كل الحقول";
    }
  }

  bool obscureText = true;
  void togglePassword() {
    obscureText = !obscureText;
    notifyListeners();
  }

  Future<void> logIn() async {
    if ((phone.text.isNotEmpty || email.text.isNotEmpty) &&
        password.text.isNotEmpty) {
      final responseBody = await _crud.postRequest(linkLogin, {
        "phone": phone.text,
        "email": email.text,
        "password": password.text,
      });

      if (responseBody['status'] == 'success') {
        var data = responseBody['data'][0];
        if (data['userType'] == "مستخدم") {
          await sharedPre.setString("randomId", data['randomId'].toString());
          await sharedPre.setString("userType", data['userType']);
          resultMessage = "user success";
        } else if (data['userType'] == "طبيب" &&
            data['userStatus'] == "انتظار") {
          resultMessage =
              "تم انشاء حسابك بنجاح ولكن لايزال بانتظار موافقة الادمن";
        } else if (data['userType'] == "طبيب" &&
            data['userStatus'] == "مقبول") {
          await sharedPre.setString("randomId", data['randomId'].toString());
          await sharedPre.setString("userType", data['userType']);
          resultMessage = "doctor success";
        } else {
          resultMessage = "تم رفض حسابك من قبل الادارة";
        }
      } else {
        resultMessage = "فشل تسجيل الدخول يرجى ادخال بيانات صحيحة";
      }
    } else {
      resultMessage = "يجب ملئ كل الحقول";
    }
  }
}
