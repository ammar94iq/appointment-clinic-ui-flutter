import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../main.dart';
import '../api/crud.dart';
import '../api/links.dart';

class PersonalFileProvider extends ChangeNotifier {
  late PageController pageController;
  int selectedIndex = 0;
  PersonalFileProvider() {
    pageController = PageController(initialPage: selectedIndex);
    initialPersonalFile();
  }
  void changeUserInterface(int value) {
    selectedIndex = value;
    notifyListeners();
  }

  final Crud _crud = Crud();
  String resultMessage = '';

  // Start Fetch User Profile Info
  List<Map<String, dynamic>> items = [];
  bool loading = false;
  Future<void> userProfile() async {
    if (sharedPre.getString("randomId") != null) {
      try {
        loading = true;
        final responseBody = await _crud.postRequest(linkUserProfile, {
          "randomId": sharedPre.getString("randomId"),
        }).whenComplete(() => loading = false);

        if (responseBody != null && responseBody is Map<String, dynamic>) {
          if (responseBody['status'] == 'success') {
            items.clear();

            items.addAll(List<Map<String, dynamic>>.from(responseBody['data']));

            if (items.isNotEmpty) {
              name.text = items[0]['name'] ?? '';
              phone.text = items[0]['phone']?.toString() ?? '';
              email.text = items[0]['email'] ?? '';
              password.text = items[0]['password'] ?? '';
              age.text = items[0]['age']?.toString() ?? '';
              address.text = items[0]['address'] ?? '';
            } else {
              // Handle case when data is empty
              resultMessage = "No user profile data found";
            }
          } else {
            resultMessage = "حصل خطأ ما يرجى اعادة التحميل";
          }
        } else {
          resultMessage = "Unexpected response format";
        }

        notifyListeners();
      } catch (error) {
        // Handle any errors that occur during userProfile() execution
        resultMessage = "Error initializing user profile: $error";
      }
    }
  }
// End Fetch User Profile Info

  //Start Update User Profile Info
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController address = TextEditingController();
  Future<void> updateUserProfile() async {
    resultMessage = '';
    if (name.text.isNotEmpty &&
        phone.text.isNotEmpty &&
        email.text.isNotEmpty &&
        password.text.isNotEmpty &&
        age.text != "0" &&
        address.text.isNotEmpty) {
      try {
        final responseBody = await _crud.postRequest(linkUpdateUserProfile, {
          "randomId": sharedPre.getString("randomId"),
          "name": name.text,
          "phone": phone.text,
          "email": email.text,
          "password": password.text,
          "age": age.text,
          "address": address.text,
        });
        if (responseBody['status'] == 'success') {
          resultMessage = "تم تحديث بياناتك بنجاح";
          userProfile();
        } else {
          resultMessage = "لم يحصل تغير في البيانات";
        }
      } catch (e) {
        resultMessage = e.toString();
      }
    } else {
      resultMessage = "يجب ملئ كل الحقول";
    }
  }

  late File file;

  Future<void> uploadImage(int index) async {
    loading = true;
    XFile? imagepicker;
    if (index == 1) {
      imagepicker = await ImagePicker().pickImage(source: ImageSource.gallery);
    } else {
      imagepicker = await ImagePicker().pickImage(source: ImageSource.camera);
    }
    if (imagepicker != null) {
      file = File(imagepicker.path);

      try {
        final responseBody = await _crud.postRequestFiles(
          linkUpdateUserProfileImage,
          {
            "randomId": sharedPre.getString("randomId"),
          },
          file,
        );

        if (responseBody['status'] == 'success') {
          resultMessage = "تم تحديث صورة الحساب بنجاح";
          userProfile();
        } else {
          resultMessage = "لم يحصل تغير في البيانات";
        }
      } catch (e) {
        resultMessage = e.toString();
      }
    }
  }
  //End Update User Profile Info

  Future<void> initialPersonalFile() async {
    await userProfile();
  }
}
