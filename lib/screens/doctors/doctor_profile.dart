import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/api/links.dart';
import '../../provider/auth/personal_file.dart';
import '../../provider/doctors/doctor_provider.dart';
import '../helper/show_dialog.dart';
import '../helper/text_form_field.dart';

Color blueColor = const Color.fromARGB(255, 35, 107, 254);

Color whiteColor = Colors.white;
Color? greyColor = Colors.grey[500];
Color? greenColor = Colors.green;
Color? amberColor = Colors.amber;

class DoctorProfile extends StatelessWidget {
  const DoctorProfile({super.key});

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<DoctorsProvider>(context, listen: true);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: whiteColor,
          backgroundColor: blueColor,
          title: const Text("الملف الشخصي"),
        ),
        body: Container(
          color: blueColor,
          child: Column(
            children: [
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 4; i++)
                      Container(
                        margin: const EdgeInsets.all(8.0),
                        width: 15.0,
                        height: 15.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: model.currentProfileIndex == i
                              ? blueColor
                              : greyColor,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: PageView(
                  onPageChanged: (index) {
                    model.changeSliderProfile(index);
                  },
                  children: [
                    ListView(
                      physics: const BouncingScrollPhysics(),
                      children: const [
                        UserProfileHeader(),
                        SizedBox(height: 20.0),
                        UserProfileContent(),
                      ],
                    ),
                    DoctorInformation(model: model),
                    DoctorServices(model: model),
                    WeekDays(model: model),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PersonalFileProvider>(
      builder: (BuildContext context, model, Widget? child) {
        return Container(
          width: MediaQuery.of(context).size.width / 2.5,
          height: MediaQuery.of(context).size.width / 2.3,
          margin: const EdgeInsets.only(bottom: 20.0),
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (builder) {
                  return Center(
                    child: UploadUserImage(model: model),
                  );
                },
              );
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                "$linkServerName/users_images/${model.items[0]['url']}",
              ),
            ),
          ),
        );
      },
    );
  }
}

class UploadUserImage extends StatelessWidget {
  final PersonalFileProvider model;
  const UploadUserImage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    void showLoading() {
      DialogHelper.showLoadingIndicator(context);
    }

    void showDialog() {
      DialogHelper.myDialog(context, model.resultMessage, 'pop');
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            "images/upload_icon.png",
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.width / 3,
          ),
          const Text(
            "يرجى اختيار صورة",
            style: TextStyle(fontSize: 25.0),
          ),
          InkWell(
            onTap: () async {
              showLoading();
              await model.uploadImage(1);
              showDialog();
            },
            child: const ListTile(
              leading: Icon(Icons.photo),
              title: Text("اختيار صورة من الاستوديو"),
            ),
          ),
          InkWell(
            onTap: () async {
              showLoading();
              await model.uploadImage(2);
              showDialog();
            },
            child: const ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("اختيار صورة من الكاميرا"),
            ),
          ),
        ],
      ),
    );
  }
}

class UserProfileContent extends StatelessWidget {
  const UserProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    void showDialog(String resultMessage) {
      DialogHelper.myDialog(context, resultMessage, 'pop');
    }

    void showLoading() {
      DialogHelper.showLoadingIndicator(context);
    }

    return Container(
      padding: const EdgeInsets.all(5.0),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
      ),
      child: Consumer<PersonalFileProvider>(
        builder: (BuildContext context, model, Widget? child) {
          return Center(
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                Center(
                  child: Image.asset(
                    "images/info_icon.png",
                    width: MediaQuery.of(context).size.height / 8,
                  ),
                ),
                const SizedBox(height: 10.0),
                ListTile(
                    isThreeLine: true,
                    contentPadding: const EdgeInsets.all(5.0),
                    leading: Icon(
                      Icons.person,
                      color: blueColor,
                    ),
                    title: const Text("الاسم"),
                    subtitle: textFormField(
                        model.name, 100, 2, whiteColor, TextInputType.name)),
                ListTile(
                  isThreeLine: true,
                  contentPadding: const EdgeInsets.all(5.0),
                  leading: Icon(
                    Icons.phone,
                    color: blueColor,
                  ),
                  title: const Text("الهاتف"),
                  subtitle: textFormField(
                      model.phone, 13, 1, whiteColor, TextInputType.phone),
                ),
                ListTile(
                  isThreeLine: true,
                  contentPadding: const EdgeInsets.all(5.0),
                  leading: Icon(
                    Icons.email_outlined,
                    color: blueColor,
                  ),
                  title: const Text("الايميل"),
                  subtitle: textFormField(model.email, 100, 1, whiteColor,
                      TextInputType.emailAddress),
                ),
                ListTile(
                  isThreeLine: true,
                  contentPadding: const EdgeInsets.all(5.0),
                  leading: Icon(
                    Icons.password,
                    color: blueColor,
                  ),
                  title: const Text("كلمة السر"),
                  subtitle: textFormField(model.password, 8, 1, whiteColor,
                      TextInputType.visiblePassword),
                ),
                ListTile(
                  isThreeLine: true,
                  contentPadding: const EdgeInsets.all(5.0),
                  leading: Icon(
                    Icons.view_timeline_rounded,
                    color: blueColor,
                  ),
                  title: const Text("العمر"),
                  subtitle: textFormField(
                      model.age, 3, 1, whiteColor, TextInputType.number),
                ),
                ListTile(
                  isThreeLine: true,
                  contentPadding: const EdgeInsets.all(5.0),
                  leading: Icon(
                    Icons.location_on_outlined,
                    color: blueColor,
                  ),
                  title: const Text("العنوان"),
                  subtitle: textFormField(
                      model.address, 100, 5, whiteColor, TextInputType.text),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blueColor,
                    foregroundColor: whiteColor,
                  ),
                  onPressed: () async {
                    showLoading();

                    await model.updateUserProfile();
                    if (model.resultMessage.isNotEmpty) {
                      showDialog(model.resultMessage);
                    }
                  },
                  child: const Text(
                    "تعديل",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class WeekDays extends StatelessWidget {
  final DoctorsProvider model;
  const WeekDays({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    void showDialog(String resultMessage) {
      DialogHelper.myDialog(context, resultMessage, 'pop');
    }

    void showLoading() {
      DialogHelper.showLoadingIndicator(context);
    }

    return Container(
      color: Colors.grey[300],
      padding: const EdgeInsets.all(15.0),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const Text("ايام العمل"),
          const SizedBox(height: 30.0),
          SizedBox(
            height: MediaQuery.of(context).size.width / 6,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: model.weekTodays.length,
              itemBuilder: (BuildContext context, int index) {
                final date = model.weekTodays[index]['date'].toString();
                final isSelected = model.selectedTodays.contains(date);

                return InkWell(
                  onTap: () {
                    model.toggleWorkDay(date);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? blueColor : whiteColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                    width: MediaQuery.of(context).size.width / 4,
                    child: Text(
                      "${model.weekTodays[index]['date']}",
                      style: TextStyle(
                        color: isSelected ? whiteColor : greyColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30.0),
          const SizedBox(height: 30.0),
          const Text(
            "وقت البدء",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          SelectStartTime(model: model),
          const SizedBox(height: 30.0),
          const Text(
            "وقت النهاية",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          SelectEndTime(model: model),
          const SizedBox(height: 30.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: blueColor,
              foregroundColor: whiteColor,
            ),
            onPressed: () async {
              showLoading();
              await model.updateDoctorWorkDays();
              showDialog(model.resultMessage);
            },
            child: const Text(
              "تحديث",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectStartTime extends StatelessWidget {
  final DoctorsProvider model;
  const SelectStartTime({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> getDropdownTimes() {
      List<DropdownMenuItem<String>> items = [];
      for (int hour = 1; hour <= 12; hour++) {
        items.add(
          DropdownMenuItem(
            alignment: AlignmentDirectional.centerEnd,
            value: hour.toString(),
            child: Text(
              "$hour : 00",
              style: TextStyle(color: blueColor),
            ),
          ),
        );
      }
      return items;
    }

    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton(
              padding: const EdgeInsets.all(10.0),
              value: model.doctorPeriodStartTime.isEmpty
                  ? null
                  : model.doctorPeriodStartTime,
              items: [
                DropdownMenuItem(
                  alignment: AlignmentDirectional.centerEnd,
                  value: 'AM',
                  child: Text("AM", style: TextStyle(color: blueColor)),
                ),
                DropdownMenuItem(
                  alignment: AlignmentDirectional.centerEnd,
                  value: 'PM',
                  child: Text("PM", style: TextStyle(color: blueColor)),
                ),
              ],
              onChanged: (value) {
                model.selectDoctorPeriodStartTime(value.toString());
              },
              underline: Container(),
            ),
            DropdownButton(
              style: TextStyle(color: whiteColor, fontSize: 20.0),
              padding: const EdgeInsets.all(10.0),
              value:
                  model.doctorStartTime.isEmpty ? null : model.doctorStartTime,
              items: getDropdownTimes(),
              onChanged: (value) {
                model.selectDoctorStartTime(value.toString());
              },
              underline: Container(),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectEndTime extends StatelessWidget {
  final DoctorsProvider model;
  const SelectEndTime({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> getDropdownTimes() {
      List<DropdownMenuItem<String>> items = [];
      for (int hour = 1; hour <= 12; hour++) {
        items.add(
          DropdownMenuItem(
            alignment: AlignmentDirectional.centerEnd,
            value: hour.toString(),
            child: Text(
              "$hour : 00",
              style: TextStyle(color: blueColor),
            ),
          ),
        );
      }
      return items;
    }

    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton(
              padding: const EdgeInsets.all(10.0),
              value: model.doctorPeriodEndTime.isEmpty
                  ? null
                  : model.doctorPeriodEndTime,
              items: [
                DropdownMenuItem(
                  alignment: AlignmentDirectional.centerEnd,
                  value: 'AM',
                  child: Text("AM", style: TextStyle(color: blueColor)),
                ),
                DropdownMenuItem(
                  alignment: AlignmentDirectional.centerEnd,
                  value: 'PM',
                  child: Text("PM", style: TextStyle(color: blueColor)),
                ),
              ],
              onChanged: (value) {
                model.selectDoctorPeriodEndTime(value.toString());
              },
              underline: Container(),
            ),
            DropdownButton(
              style: TextStyle(color: whiteColor, fontSize: 20.0),
              padding: const EdgeInsets.all(10.0),
              value: model.doctorEndTime.isEmpty ? null : model.doctorEndTime,
              items: getDropdownTimes(),
              onChanged: (value) {
                model.selectDoctorEndTime(value.toString());
              },
              underline: Container(),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorInformation extends StatelessWidget {
  final DoctorsProvider model;
  const DoctorInformation({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    void showDialog(String resultMessage) {
      DialogHelper.myDialog(context, resultMessage, 'pop');
    }

    void showLoading() {
      DialogHelper.showLoadingIndicator(context);
    }

    return Container(
      color: Colors.grey[300],
      padding: const EdgeInsets.all(15.0),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ListTile(
            isThreeLine: true,
            contentPadding: const EdgeInsets.all(5.0),
            leading: Icon(
              Icons.folder_special_rounded,
              color: blueColor,
            ),
            title: const Text("التخصص"),
            subtitle: SpecialtyDropDown(model: model),
          ),
          ListTile(
            isThreeLine: true,
            contentPadding: const EdgeInsets.all(5.0),
            leading: Icon(
              Icons.description,
              color: blueColor,
            ),
            title: const Text("نبذة عن الطبيب"),
            subtitle: textFormField(model.doctorDescription, 200, 5, whiteColor,
                TextInputType.text),
          ),
          ListTile(
            isThreeLine: true,
            contentPadding: const EdgeInsets.all(5.0),
            leading: Icon(
              Icons.yard_rounded,
              color: blueColor,
            ),
            title: const Text("سنوات الخبرة"),
            subtitle: textFormField(
                model.yearsExperience, 3, 1, whiteColor, TextInputType.number),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: blueColor,
              foregroundColor: whiteColor,
            ),
            onPressed: () async {
              showLoading();
              await model.updateDoctorInformation();
              if (model.resultMessage.isNotEmpty) {
                showDialog(model.resultMessage);
              }
            },
            child: const Text(
              "تعديل",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}

//Start Show DropDown For Select Department
class SpecialtyDropDown extends StatelessWidget {
  final DoctorsProvider model;
  const SpecialtyDropDown({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: DropdownButton(
          style: TextStyle(color: whiteColor, fontSize: 20.0),
          isExpanded: true,
          padding: const EdgeInsets.all(10.0),
          value: model.doctorSpecialty.isEmpty ? null : model.doctorSpecialty,
          items: [
            DropdownMenuItem(
              alignment: AlignmentDirectional.centerEnd,
              value: 'اطباء الاسنان',
              child: Text('اطباء الاسنان', style: TextStyle(color: blueColor)),
            ),
            DropdownMenuItem(
              alignment: AlignmentDirectional.centerEnd,
              value: 'اطباء القلب',
              child: Text('اطباء القلب', style: TextStyle(color: blueColor)),
            ),
            DropdownMenuItem(
              alignment: AlignmentDirectional.centerEnd,
              value: 'اطباء الجلدية',
              child: Text('اطباء الجلدية', style: TextStyle(color: blueColor)),
            ),
            DropdownMenuItem(
              alignment: AlignmentDirectional.centerEnd,
              value: 'اطباء العيون',
              child: Text('اطباء العيون', style: TextStyle(color: blueColor)),
            ),
            DropdownMenuItem(
              alignment: AlignmentDirectional.centerEnd,
              value: 'تقويم العظام',
              child: Text('تقويم العظام', style: TextStyle(color: blueColor)),
            ),
            DropdownMenuItem(
              alignment: AlignmentDirectional.centerEnd,
              value: 'اطباء المسالك البولية',
              child: Text('اطباء المسالك البولية',
                  style: TextStyle(color: blueColor)),
            ),
            DropdownMenuItem(
              alignment: AlignmentDirectional.centerEnd,
              value: 'اطباء الامراض النسائية',
              child: Text('اطباء الامراض النسائية',
                  style: TextStyle(color: blueColor)),
            ),
          ],
          onChanged: (value) {
            model.selectDoctorSpecialty(value);
          },
          underline: Container(),
        ),
      ),
    );
  }
}

//End Show DropDown For Select Department
class DoctorServices extends StatelessWidget {
  final DoctorsProvider model;
  const DoctorServices({super.key, required this.model});
  Widget checkboxListTile(
      String title, bool isChecked, Function(bool?) onChanged) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: CheckboxListTile(
        title: Text(title),
        activeColor: greenColor,
        controlAffinity: ListTileControlAffinity.trailing,
        value: isChecked,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void showDialog(String resultMessage) {
      DialogHelper.myDialog(context, resultMessage, 'pop');
    }

    void showLoading() {
      DialogHelper.showLoadingIndicator(context);
    }

    return Container(
      color: Colors.grey[300],
      padding: const EdgeInsets.all(15.0),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(5.0),
            leading: Icon(
              Icons.room_service,
              color: blueColor,
            ),
            title: const Text("الخدمات التي تقدمها"),
          ),
          checkboxListTile("موعد بالعيادة", model.isCheckedClinic, (newValue) {
            model.toggleCheckedServicesClinic(newValue);
          }),
          checkboxListTile("اونلاين", model.isCheckedOnline, (newValue) {
            model.toggleCheckedServicesOnline(newValue);
          }),
          checkboxListTile("في المنزل", model.isCheckedHome, (newValue) {
            model.toggleCheckedServicesHome(newValue);
          }),
          checkboxListTile("اشعة وسونار", model.isCheckedXRays, (newValue) {
            model.toggleCheckedServicesXRays(newValue);
          }),
          checkboxListTile("مختبرات", model.isCheckedLaboratories, (newValue) {
            model.toggleCheckedServicesLaboratories(newValue);
          }),
          checkboxListTile("صيدليات", model.isCheckedPharmacy, (newValue) {
            model.toggleCheckedServicesPharmacy(newValue);
          }),
          const SizedBox(height: 20.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: blueColor,
              foregroundColor: whiteColor,
            ),
            onPressed: () async {
              showLoading();
              await model.updateDoctorServices();
              if (model.resultMessage.isNotEmpty) {
                showDialog(model.resultMessage);
              }
            },
            child: const Text(
              "تعديل",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
