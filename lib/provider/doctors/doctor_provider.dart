import 'package:flutter/material.dart';

import '../../main.dart';
import '../api/crud.dart';
import '../api/links.dart';

class DoctorsProvider extends ChangeNotifier {
  int currentProfileIndex = 0;
  DoctorsProvider() {
    refresh();
  }
  //setting doctor profile
  void changeSliderProfile(int index) {
    currentProfileIndex = index;
    notifyListeners();
  }

  List<Map<String, String>> weekTodays = [
    {'date': 'السبت'},
    {'date': 'الاحد'},
    {'date': 'الاثنين'},
    {'date': 'الثلاثاء'},
    {'date': 'الاربعاء'},
    {'date': 'الخميس'},
    {'date': 'الجمعة'},
  ];

  //Store selected todays in database
  List<String> selectedTodays = [];

  //Select Toggle Day
  void toggleWorkDay(String date) {
    if (selectedTodays.contains(date)) {
      selectedTodays.remove(date);
    } else {
      selectedTodays.add(date);
    }
    notifyListeners();
  }

  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();

  final Crud _crud = Crud();
  String resultMessage = '';
  //Start store  doctor Work Days in db
  Future<void> updateDoctorWorkDays() async {
    if (startTime.text.isNotEmpty &&
        endTime.text.isNotEmpty &&
        selectedTodays.isNotEmpty) {
      final responseBody = await _crud.postRequest(linkUpdateDoctorWorkDays, {
        "randomId": sharedPre.getString("randomId"),
        "workTodays": selectedTodays.join(","),
        "startTime": startTime.text,
        "endTime": endTime.text,
      });
      if (responseBody['status'] == 'success') {
        resultMessage = "تم اضافة ايام العمل بنجاح";
      } else {
        resultMessage = "لم يحصل تغير في البيانات";
      }
    } else {
      resultMessage = "يجب ملئ كل الحقول";
    }
  }
  //End store doctor Work Days in db

  //Start show doctor Work Days from db
  Future<void> showDoctorWorkDays() async {
    final responseBody = await _crud.postRequest(linkShowDoctorWorkDays, {
      "randomId": sharedPre.getString("randomId"),
    });
    if (responseBody['status'] == 'success') {
      // Initialize selectedTodays with values from workTodaysStored
      selectedTodays = responseBody['data'][0]['workTodays'].split(',');
      startTime.text = responseBody['data'][0]['startTime'].toString();
      endTime.text = responseBody['data'][0]['endTime'].toString();
      notifyListeners();
    }
  }
  //End show doctor Work Days from db

  //Start doctor services
  bool isCheckedClinic = false;
  bool isCheckedOnline = false;
  bool isCheckedHome = false;
  bool isCheckedXRays = false;
  bool isCheckedLaboratories = false;
  bool isCheckedPharmacy = false;
  void toggleCheckedServicesClinic(bool? val) {
    isCheckedClinic = val ?? false;
    notifyListeners();
  }

  void toggleCheckedServicesOnline(bool? val) {
    isCheckedOnline = val ?? false;
    notifyListeners();
  }

  void toggleCheckedServicesHome(bool? val) {
    isCheckedHome = val ?? false;
    notifyListeners();
  }

  void toggleCheckedServicesXRays(bool? val) {
    isCheckedXRays = val ?? false;
    notifyListeners();
  }

  void toggleCheckedServicesLaboratories(bool? val) {
    isCheckedLaboratories = val ?? false;
    notifyListeners();
  }

  void toggleCheckedServicesPharmacy(bool? val) {
    isCheckedPharmacy = val ?? false;
    notifyListeners();
  }

  //End doctor services

  //Start Update Doctor Information
  String doctorSpecialty = '';
  void selectDoctorSpecialty(String? value) {
    doctorSpecialty = value.toString();
    notifyListeners();
  }

  TextEditingController doctorDescription = TextEditingController();
  TextEditingController yearsExperience = TextEditingController();
  //TextEditingController doctorSpecialty = TextEditingController();
  Future<void> updateDoctorInformation() async {
    if (doctorSpecialty.isNotEmpty &&
        doctorDescription.text.isNotEmpty &&
        yearsExperience.text.isNotEmpty) {
      final responseBody =
          await _crud.postRequest(linkUpdateDoctorInformation, {
        "randomId": sharedPre.getString("randomId"),
        "doctorSpecialty": doctorSpecialty,
        "doctorDescription": doctorDescription.text,
        "yearsExperience": yearsExperience.text,
      });
      if (responseBody['status'] == 'success') {
        resultMessage = "تم تحديث البيانات بنجاح";
      } else {
        resultMessage = "لم يحصل تغير في البيانات";
      }
    } else {
      resultMessage = "يجب ملئ كل الحقول";
    }
  }
  //End Update Doctor Information

  //Start Update Doctor Services

  Future<void> updateDoctorServices() async {
    final responseBody = await _crud.postRequest(linkUpdateDoctorServices, {
      "randomId": sharedPre.getString("randomId"),
      "isCheckedClinic": isCheckedClinic.toString(),
      "isCheckedOnline": isCheckedOnline.toString(),
      "isCheckedHome": isCheckedHome.toString(),
      "isCheckedXRays": isCheckedXRays.toString(),
      "isCheckedLaboratories": isCheckedLaboratories.toString(),
      "isCheckedPharmacy": isCheckedPharmacy.toString(),
    });
    if (responseBody['status'] == 'success') {
      resultMessage = "تم تحديث البيانات بنجاح";
    } else {
      resultMessage = "لم يحصل تغير في البيانات";
    }
  }
  //End Update Doctor Services

  //Start show Doctor Information from db
  Future<void> showDoctorInformation() async {
    final responseBody = await _crud.postRequest(linkShowDoctorInformation, {
      "randomId": sharedPre.getString("randomId"),
    });
    if (responseBody['status'] == 'success') {
      //Set Doctor Information Data
      doctorSpecialty = responseBody['data'][0]['doctorSpecialty'] ?? '';
      doctorDescription.text = responseBody['data'][0]['doctorDescription'];
      yearsExperience.text =
          responseBody['data'][0]['yearsExperience'].toString();

      notifyListeners();
    }
  }
  //End show Doctor Information from db

  //Start show Doctor Services from db
  Future<void> showDoctorServices() async {
    final responseBody = await _crud.postRequest(linkShowDoctorServices, {
      "randomId": sharedPre.getString("randomId"),
    });
    if (responseBody['status'] == 'success') {
      //Set Doctor Services Data
      responseBody['data'][0]['isCheckedClinic'] == 'true'
          ? isCheckedClinic = true
          : isCheckedClinic = false;
      responseBody['data'][0]['isCheckedOnline'] == 'true'
          ? isCheckedOnline = true
          : isCheckedOnline = false;

      responseBody['data'][0]['isCheckedHome'] == 'true'
          ? isCheckedHome = true
          : isCheckedHome = false;
      responseBody['data'][0]['isCheckedXRays'] == 'true'
          ? isCheckedXRays = true
          : isCheckedXRays = false;
      responseBody['data'][0]['isCheckedLaboratories'] == 'true'
          ? isCheckedLaboratories = true
          : isCheckedLaboratories = false;

      responseBody['data'][0]['isCheckedPharmacy'] == 'true'
          ? isCheckedPharmacy = true
          : isCheckedPharmacy = false;

      notifyListeners();
    }
  }
  //End show Doctor Services from db

  //Start Show User Appointments
  List<Map<String, dynamic>> myAppointments = [];
  bool loading = false;
  TextEditingController userName = TextEditingController();

  Future<void> showUserAppointments() async {
    resultMessage = '';
    loading = true;

    final responseBody = await _crud.postRequest(linkShowUsersAppointments, {
      "randomId": sharedPre.getString("randomId"),
      "newAppointment": 'all',
      "userName": userName.text,
    }).whenComplete(() => loading = false);
    if (responseBody['status'] == 'success') {
      myAppointments.clear();
      myAppointments
          .addAll(List<Map<String, dynamic>>.from(responseBody['data']));
      notifyListeners();
    } else {
      resultMessage = "لا توجد بيانات في هذه الصفحة";
    }
  }
  //End Show User Appointments

  //Start Show User New Appointments
  List<Map<String, dynamic>> myNewAppointments = [];

  Future<void> showUsersNewAppointments() async {
    resultMessage = '';
    loading = true;

    final responseBody = await _crud.postRequest(linkShowUsersAppointments, {
      "randomId": sharedPre.getString("randomId"),
      "newAppointment": 'new appointment',
    }).whenComplete(() => loading = false);

    if (responseBody['status'] == 'success') {
      myNewAppointments.clear();
      myNewAppointments
          .addAll(List<Map<String, dynamic>>.from(responseBody['data']));
      notifyListeners();
    } else {
      resultMessage = "لا توجد بيانات في هذه الصفحة";
    }
  }
  //End Show User New Appointments

  //Start Show Evaluation Of User For Doctor
  List<Map<String, dynamic>> usersEvaluations = [];
  Future<void> showEvaluationUsers() async {
    try {
      final responseBody = await _crud.postRequest(linkShowEvaluationsUser, {
        "randomId": sharedPre.getString("randomId"),
      });
      if (responseBody['status'] == 'success') {
        usersEvaluations.clear();
        usersEvaluations
            .addAll(List<Map<String, dynamic>>.from(responseBody['data']));
        notifyListeners();
      } else {
        resultMessage = "لا توجد بيانات في هذه الصفحة";
      }
    } catch (error) {
      resultMessage = '$error';
    }
  }
  //End Show Evaluation Of User For Doctor

  //Start Add Recipes For User
  TextEditingController recipes = TextEditingController();
  Future<void> addUserRecipes(
      String userAppointmentsId, String randomIdUser) async {
    if (recipes.text.isNotEmpty) {
      resultMessage = '';
      loading = true;

      final responseBody = await _crud.postRequest(linkAddRecipes, {
        "recipes": recipes.text,
        "userAppointmentsId": userAppointmentsId,
        "randomIdUser": randomIdUser,
        "randomIdDoctor": sharedPre.getString("randomId"),
      }).whenComplete(() => loading = false);
      if (responseBody['status'] == 'success') {
        resultMessage = "تم اضافة العلاج بنجاح";
      } else {
        resultMessage = "لم يحصل تغيير في البيانات";
      }
    } else {
      resultMessage = 'لم تقم بكتابة العلاج';
    }
  }
  //End Add Recipes For User

  //Start Show Recipes Of User
  Future<void> showUserRecipes(String userAppointmentsId) async {
    resultMessage = '';
    loading = true;

    final responseBody = await _crud.postRequest(linkShowRecipes, {
      "userAppointmentsId": userAppointmentsId,
    }).whenComplete(() => loading = false);

    if (responseBody['status'] == 'success') {
      recipes.text = responseBody['data'][0]['recipes'];
      notifyListeners();
    } else {
      resultMessage = "لم يحصل تغيير في البيانات";
    }
  }
  //End Show Recipes Of User

  void doctorProfileReset() {
    doctorSpecialty = '';
    doctorDescription.text = '';
    yearsExperience.text = '0';
    isCheckedClinic = false;
    isCheckedOnline = false;
    isCheckedHome = false;
    isCheckedXRays = false;
    isCheckedLaboratories = false;
    isCheckedPharmacy = false;
    startTime.text = '';
    endTime.text = '';
    selectedTodays.clear();
  }

  Future<void> refresh() async {
    await showUsersNewAppointments();
  }
}
