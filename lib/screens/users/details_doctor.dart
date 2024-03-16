import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/api/links.dart';
import '../../provider/users/users_provider.dart';
import '../helper/animate.dart';
import 'add_appointment.dart';
import 'doctor_evaluation.dart';

Color? greyColor = Colors.grey[300];
Color? amberColor = Colors.amber[500];
Color blueColor = const Color.fromARGB(255, 35, 107, 254);
Color whiteColor = Colors.white;
Color? greenColor = Colors.green;

class DetailsDoctor extends StatelessWidget {
  final Map<String, dynamic> detailsDoctor;
  final int happyCount;
  final int smileCount;
  final int angryCount;
  const DetailsDoctor(
      {super.key,
      required this.detailsDoctor,
      required this.happyCount,
      required this.smileCount,
      required this.angryCount});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            foregroundColor: whiteColor,
            backgroundColor: blueColor,
            title: const Text("تفاصيل الطبيب"),
          ),
          body: Container(
            color: blueColor,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                DoctorDetailsHeader(
                  detailsDoctor: detailsDoctor,
                  happyCount: happyCount,
                ),
                const SizedBox(height: 10.0),
                DoctorDetailsContent(
                  detailsDoctor: detailsDoctor,
                  happyCount: happyCount,
                  smileCount: smileCount,
                  angryCount: angryCount,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DoctorDetailsHeader extends StatelessWidget {
  final Map<String, dynamic> detailsDoctor;
  final int happyCount;
  const DoctorDetailsHeader(
      {super.key, required this.detailsDoctor, required this.happyCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.network(
            "$linkServerName/users_images/${detailsDoctor['url']}",
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.width / 2,
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(height: 10.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: whiteColor,
                    child: const Text(
                      '😍',
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    "$happyCount",
                    style: TextStyle(
                        color: amberColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    "التقييم",
                    style: TextStyle(color: greyColor),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: whiteColor,
                    child: const Icon(Icons.architecture),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    "${detailsDoctor['yearsExperience']} سنوات",
                    style: TextStyle(
                        color: amberColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    "الخبرة",
                    style: TextStyle(color: greyColor),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: whiteColor,
                    child: const Icon(Icons.person),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    "${detailsDoctor['usersCount']} ",
                    style: TextStyle(
                        color: amberColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    "المراجعين",
                    style: TextStyle(color: greyColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DoctorDetailsContent extends StatelessWidget {
  final Map<String, dynamic> detailsDoctor;
  final int happyCount;
  final int smileCount;
  final int angryCount;
  const DoctorDetailsContent(
      {super.key,
      required this.detailsDoctor,
      required this.happyCount,
      required this.smileCount,
      required this.angryCount});
  Widget checkboxListTile(String title, bool isChecked) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: CheckboxListTile(
        title: Text(title),
        activeColor: greenColor,
        selected: isChecked,
        controlAffinity: ListTileControlAffinity.trailing,
        value: isChecked,
        onChanged: (value) {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<UsersProvider>(context);
    void goToDoctorEvaluation() {
      Navigator.of(context).push(
        createRoute(
          DoctorEvaluation(detailsDoctor: detailsDoctor),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: greyColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
      ),
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text(
                    '😍',
                    style: TextStyle(fontSize: 25.0),
                  ),
                  Text("$happyCount"),
                ],
              ),
              Column(
                children: [
                  const Text(
                    '😄',
                    style: TextStyle(fontSize: 25.0),
                  ),
                  Text("$smileCount"),
                ],
              ),
              Column(
                children: [
                  const Text(
                    '😡',
                    style: TextStyle(fontSize: 25.0),
                  ),
                  Text("$angryCount"),
                ],
              ),
            ],
          ),
          Center(
            child: Text(
              "${detailsDoctor['name']}",
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 5.0),
          Center(
            child: Text(
              "${detailsDoctor['doctorSpecialty']}",
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          const SizedBox(height: 15.0),
          ListTile(
            isThreeLine: true,
            contentPadding: const EdgeInsets.all(5.0),
            leading: Icon(
              Icons.phone,
              color: blueColor,
            ),
            title: const Text("رقم الهاتف"),
            subtitle: Text("${detailsDoctor['phone']}"),
          ),
          ListTile(
            isThreeLine: true,
            contentPadding: const EdgeInsets.all(5.0),
            leading: Icon(
              Icons.tips_and_updates,
              color: blueColor,
            ),
            title: const Text("نبذة عن الطبيب"),
            subtitle: Text("${detailsDoctor['doctorDescription']}"),
          ),
          ListTile(
            isThreeLine: true,
            contentPadding: const EdgeInsets.all(5.0),
            leading: Icon(
              Icons.location_on_outlined,
              color: blueColor,
            ),
            title: const Text("العنوان"),
            subtitle: Text("${detailsDoctor['address']}"),
          ),
          ListTile(
            isThreeLine: true,
            contentPadding: const EdgeInsets.all(5.0),
            leading: Icon(
              Icons.date_range,
              color: blueColor,
            ),
            title: const Text("وقت العمل"),
            subtitle: Text(
                textAlign: TextAlign.end,
                textDirection: TextDirection.ltr,
                "${detailsDoctor['startTime']} - ${detailsDoctor['endTime']}"),
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(5.0),
            leading: Icon(
              Icons.medical_services_outlined,
              color: blueColor,
            ),
            title: const Text("الخدمات"),
          ),
          checkboxListTile("موعد بالعيادة",
              detailsDoctor['isCheckedClinic'] == 'true' ? true : false),
          checkboxListTile("اونلاين",
              detailsDoctor['isCheckedOnline'] == 'true' ? true : false),
          checkboxListTile("في المنزل",
              detailsDoctor['isCheckedHome'] == 'true' ? true : false),
          checkboxListTile("اشعة وسونار",
              detailsDoctor['isCheckedXRays'] == 'true' ? true : false),
          checkboxListTile("مختبرات",
              detailsDoctor['isCheckedLaboratories'] == 'true' ? true : false),
          checkboxListTile("صيدليات",
              detailsDoctor['isCheckedPharmacy'] == 'true' ? true : false),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenColor,
                  foregroundColor: whiteColor,
                ),
                onPressed: () {
                  Navigator.of(context).push(createRoute(
                      AddAppointment(detailsDoctor: detailsDoctor)));
                },
                child: const Text(
                  "حجز الموعد",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  foregroundColor: whiteColor,
                ),
                onPressed: () async {
                  model.doctorEvaluations.clear();
                  await model.showEvaluationDoctor(
                      detailsDoctor['randomId'].toString());
                  goToDoctorEvaluation();
                },
                child: const Text(
                  "تقييم الطبيب",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
