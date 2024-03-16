import 'package:flutter/material.dart';

import '../../main.dart';
import '../api/crud.dart';
import '../api/links.dart';

class UsersProvider extends ChangeNotifier {
  bool loading = false;
  UsersProvider() {
    refresh();
  }

  final Crud _crud = Crud();
  String resultMessage = '';
  //Start Store selected day of booking in database
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  bool isSelectedDay = false;
  //Select Toggle Day
  void selectDayFromCalender(DateTime selected, DateTime focused) {
    selectedDay = selected;
    isSelectedDay = true;
    notifyListeners();
  }

  //Store selected Time of booking in database
  String selectedTime = '';

  //Select Toggle Time
  void toggleSelectTime(String time) {
    if (selectedTime == time) {
      selectedTime = '';
    } else {
      selectedTime = time;
    }
    notifyListeners();
  }

  TextEditingController appointmentDescription = TextEditingController();
  TextEditingController appointmentPhone = TextEditingController();

  Future<void> addAppointment(String randomIdDoctor) async {
    resultMessage = '';

    if (appointmentDescription.text.isNotEmpty &&
        appointmentPhone.text.isNotEmpty &&
        selectedTime.isNotEmpty) {
      try {
        final responseBody = await _crud.postRequest(linkAddAppointment, {
          "randomIdUser": sharedPre.getString("randomId"),
          "randomIdDoctor": randomIdDoctor,
          "selectedDay": selectedDay.toString(),
          "selectedTime": selectedTime,
          "description": appointmentDescription.text,
          "phone": appointmentPhone.text,
        });
        if (responseBody['status'] == 'success') {
          await showMyAppointments();
          await showMyNewAppointments();
          resultMessage = "تم اضافة الموعد بنجاح";
        } else if (responseBody['status'] == 'find') {
          resultMessage = "لديك موعد سابق في هذا اليوم";
        } else {
          resultMessage = "فشلت عملية الحجز يرجى اعادة المحاولة";
        }
        //Re Set Fields
        appointmentDescription.text = '';
        appointmentPhone.text = '';
        selectedDay = DateTime.now();
        focusedDay = DateTime.now();
        selectedTime = '';
      } catch (e) {
        debugPrint("======$e=====");
      }
    } else {
      resultMessage = "يجب ملئ كل الحقول";
    }
  }
  //End Store selected day of booking in database

  //Start Update My Appointment By User
  TextEditingController appointmentDescriptionUp = TextEditingController();
  TextEditingController appointmentPhoneUp = TextEditingController();
  Future<void> updateAppointment(int appointmentId, int randomIdDoctor) async {
    resultMessage = '';
    if (appointmentDescriptionUp.text.isNotEmpty &&
        appointmentPhoneUp.text.isNotEmpty &&
        selectedTime.isNotEmpty) {
      try {
        final responseBody = await _crud.postRequest(linkUpdateAppointment, {
          "randomIdUser": sharedPre.getString("randomId"),
          "randomIdDoctor": randomIdDoctor.toString(),
          "appointmentId": appointmentId.toString(),
          "selectedDay": selectedDay.toString(),
          "selectedTime": selectedTime,
          "description": appointmentDescriptionUp.text,
          "phone": appointmentPhoneUp.text,
        });

        if (responseBody['status'] == 'success') {
          await showMyAppointments();
          await showMyNewAppointments();
          resultMessage = "تم تحديث الموعد بنجاح";
        } else if (responseBody['status'] == 'find') {
          resultMessage = "لديك موعد سابق في هذا اليوم";
        } else if (responseBody['status'] == 'finch') {
          resultMessage = "لا يمكنك تعديل هذا الحجز";
        } else {
          resultMessage = "لم يحصل تغير في البيانات";
        }
      } catch (e) {
        debugPrint("======$e=====");
      }
    } else {
      resultMessage = "يجب ملئ كل الحقول";
    }
  }
  //End Update My Appointment By User

  //Start Cancel My Appointment By User
  Future<void> cancelAppointment(int appointmentId) async {
    resultMessage = '';
    try {
      final responseBody = await _crud.postRequest(linkCancelAppointment, {
        "appointmentId": appointmentId.toString(),
      });

      if (responseBody['status'] == 'success') {
        await showMyAppointments();
        await showMyNewAppointments();
        resultMessage = "تم الغاء الحجز بنجاح";
      } else {
        resultMessage = "حصل فشل في عملية الغاء الحجز";
      }
    } catch (e) {
      debugPrint("======$e=====");
    }
  }
  //End Cancel My Appointment By User

  //Start Show My Appointments
  List<Map<String, dynamic>> myAppointments = [];

  Future<void> showMyAppointments() async {
    resultMessage = '';
    loading = true;

    final responseBody = await _crud.postRequest(linkShowMyAppointments, {
      "randomId": sharedPre.getString("randomId"),
      "newAppointment": 'all',
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
  //End Show My Appointments

  //Start Show My New Appointments
  List<Map<String, dynamic>> myNewAppointments = [];

  Future<void> showMyNewAppointments() async {
    resultMessage = '';
    loading = true;

    final responseBody = await _crud.postRequest(linkShowMyAppointments, {
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
  //End Show My New Appointments

  //Start Show All Specialty For Doctors
  List<Map<String, dynamic>> allSpecialtyDoctors = [];
  Future<void> showAllSpecialtyDoctors(String serviceNumber) async {
    loading = true;

    final responseBody = await _crud.postRequest(linkShowAllSpecialtyDoctors, {
      "serviceNumber": serviceNumber,
    }).whenComplete(() => loading = false);

    if (responseBody['status'] == 'success') {
      allSpecialtyDoctors.clear();
      for (var doctorData in responseBody['data']) {
        // Adding serviceNumber to each doctor's data
        doctorData['serviceNumber'] = serviceNumber;
        allSpecialtyDoctors.add(doctorData);
      }
    } else {
      allSpecialtyDoctors.clear();
      resultMessage = "لا توجد بيانات في هذه الصفحة";
    }
  }
  //End Show All Specialty For Doctors

  //Start Show All Doctors
  List<Map<String, dynamic>> allDoctors = [];
  TextEditingController doctorName = TextEditingController();

  Future<void> showAllDoctors(String doctorSpecialty) async {
    loading = true;
    if (doctorSpecialty.isNotEmpty) {
      doctorName.text = '';
    }
    final responseBody = await _crud.postRequest(linkShowAllDoctors, {
      "doctorName": doctorName.text,
      "doctorSpecialty": doctorSpecialty,
    }).whenComplete(() => loading = false);

    if (responseBody['status'] == 'success') {
      allDoctors.clear();
      allDoctors.addAll(List<Map<String, dynamic>>.from(responseBody['data']));
    } else {
      allDoctors.clear();
      resultMessage = "لا توجد بيانات في هذه الصفحة";
    }
  }
  //End Show All Doctors

  //Start Show All Doctors for Specialty and Services
  List<Map<String, dynamic>> allSpecialtyServicesDoctors = [];

  Future<void> showAllSpecialtyServicesDoctors(
      String doctorSpecialty, String serviceNumber) async {
    loading = true;

    final responseBody =
        await _crud.postRequest(linkShowAllSpecialtyServicesDoctors, {
      "doctorSpecialty": doctorSpecialty,
      "serviceNumber": serviceNumber,
    }).whenComplete(() => loading = false);

    if (responseBody['status'] == 'success') {
      allDoctors.clear();
      allDoctors.addAll(List<Map<String, dynamic>>.from(responseBody['data']));
    } else {
      allDoctors.clear();
      resultMessage = "لا توجد بيانات في هذه الصفحة";
    }
  }
  //End Show All Doctors r Specialty and Services

  //Start Show Top Doctors
  List<Map<String, dynamic>> topDoctors = [];
  Future<void> showTopDoctors() async {
    try {
      loading = true;
      final responseBody = await _crud.postRequest(linkShowAllDoctors, {
        "doctorEvaluation": "top evaluation",
      }).whenComplete(() => loading = false);

      if (responseBody['status'] == 'success') {
        topDoctors.clear();
        topDoctors
            .addAll(List<Map<String, dynamic>>.from(responseBody['data']));
      } else {
        resultMessage = "لا توجد بيانات في هذه الصفحة";
      }
      notifyListeners();
    } catch (error) {
      resultMessage = '$error';
    }
  }
  //End Show Top Doctors

  //Start Show Details Doctor
  List<Map<String, dynamic>> detailsDoctorArray = [];
  Future<void> detailsDoctor(String doctorRandomId) async {
    try {
      loading = true;
      final responseBody = await _crud.postRequest(linkDetailsDoctor, {
        "randomId": doctorRandomId,
      }).whenComplete(() => loading = false);
      if (responseBody['status'] == 'success') {
        detailsDoctorArray.clear();
        detailsDoctorArray
            .addAll(List<Map<String, dynamic>>.from(responseBody['data']));
        notifyListeners();
      } else {
        resultMessage = "لا توجد بيانات في هذه الصفحة";
      }
    } catch (error) {
      resultMessage = '$error';
    }
  }
  //End Show Details Doctor

  TextEditingController commentEvaluation = TextEditingController();
  int starNumber = 0;
  void toggleAddStar(int starValue) {
    if (starNumber == starValue) {
      starNumber = 0;
    } else {
      starNumber = starValue;
    }
    notifyListeners();
  }

  //Start Add Evaluation For Doctor
  Future<void> addEvaluationDoctor(String doctorRandomId) async {
    if (commentEvaluation.text.isNotEmpty && starNumber != 0) {
      try {
        final responseBody = await _crud.postRequest(linkAddEvaluationDoctor, {
          "randomIdDoctor": doctorRandomId,
          "randomIdUser": sharedPre.getString("randomId"),
          "comment": commentEvaluation.text,
          "starNumber": starNumber.toString(),
        });
        if (responseBody['status'] == 'success') {
          await showEvaluationDoctor(doctorRandomId);
          resultMessage = "تم اضافة تقيمك بنجاح";
          commentEvaluation.text = '';
          starNumber = 0;

          notifyListeners();
        } else {
          resultMessage = "لم تقم بتغيير التقييم";
        }
      } catch (error) {
        resultMessage = '$error';
      }
    } else {
      resultMessage = 'لم تقم بتقييم الطبيب';
    }
  }
  //End Add Evaluation For Doctor

  //Start Show Evaluation Of Doctor For User
  List<Map<String, dynamic>> doctorEvaluations = [];
  Future<void> showEvaluationDoctor(String doctorRandomId) async {
    try {
      final responseBody = await _crud.postRequest(linkShowEvaluationsDoctor, {
        "randomIdDoctor": doctorRandomId,
        "randomIdUser": sharedPre.getString("randomId"),
      });
      if (responseBody['status'] == 'success') {
        doctorEvaluations.clear();
        doctorEvaluations
            .addAll(List<Map<String, dynamic>>.from(responseBody['data']));
        notifyListeners();
      } else {
        resultMessage = "لا توجد بيانات في هذه الصفحة";
      }
    } catch (error) {
      resultMessage = '$error';
    }
  }
  //End Show Evaluation Of Doctor For User

  //Start Show Recipes For User

  List<Map<String, dynamic>> userRecipes = [];

  Future<void> showUserRecipes() async {
    resultMessage = '';
    loading = true;

    final responseBody = await _crud.postRequest(linkShowRecipes, {
      "randomIdUser": sharedPre.getString("randomId"),
    }).whenComplete(() => loading = false);
    if (responseBody['status'] == 'success') {
      userRecipes.clear();
      userRecipes.addAll(List<Map<String, dynamic>>.from(responseBody['data']));
      notifyListeners();
    } else {
      resultMessage = "لا توجد بيانات في هذه الصفحة";
    }
  }
  //End Show Recipes For User

  Future<void> refresh() async {
    isSelectedDay = false;
    await showMyNewAppointments();
    await showTopDoctors();
  }
}
