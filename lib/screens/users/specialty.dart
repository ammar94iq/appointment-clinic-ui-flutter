import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/users/users_provider.dart';
import '../helper/animate.dart';
import 'all_doctors.dart';

Color blueColor = const Color.fromARGB(255, 35, 107, 254);

Color whiteColor = Colors.white;
Color? greyColor = Colors.grey[500];
Color? greenColor = Colors.green;
Color? amberColor = Colors.amber;
List<Map<String, String>> specialtyDoctors = [
  {
    'url': 'images/specialty1.png',
    'specialty': 'اطباء الاسنان',
  },
  {
    'url': 'images/specialty2.png',
    'specialty': 'اطباء القلب',
  },
  {
    'url': 'images/specialty3.png',
    'specialty': 'اطباء الجلدية',
  },
  {
    'url': 'images/specialty4.png',
    'specialty': 'اطباء العيون',
  },
  {
    'url': 'images/specialty5.png',
    'specialty': 'تقويم العظام',
  },
  {
    'url': 'images/specialty6.png',
    'specialty': 'اطباء المسالك البولية',
  },
  {
    'url': 'images/specialty7.png',
    'specialty': 'اطباء الامراض النسائية',
  },
];

class Specialty extends StatelessWidget {
  final String serviceNumber;
  const Specialty({super.key, required this.serviceNumber});

  @override
  Widget build(BuildContext context) {
    void goToAllDoctors() {
      Navigator.of(context).push(
        createRoute(
          const AllDoctors(),
        ),
      );
    }

    String pageTitle = '';
    if (serviceNumber == '1') {
      pageTitle = 'موعد بالعيادة';
    } else if (serviceNumber == '2') {
      pageTitle = 'اون لاين';
    } else if (serviceNumber == '3') {
      pageTitle = 'في المنزل';
    } else if (serviceNumber == '4') {
      pageTitle = 'اشعة وسونار';
    } else if (serviceNumber == '5') {
      pageTitle = 'مختبرات';
    } else if (serviceNumber == '6') {
      pageTitle = 'صيدليات';
    } else {
      pageTitle = 'جميع التخصصات';
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          title: Text(pageTitle),
        ),
        body: Consumer<UsersProvider>(builder: (context, value, child) {
          return Container(
            color: Colors.grey[300],
            padding: const EdgeInsets.all(15.0),
            child: value.loading == true
                ? Center(
                    child: CircularProgressIndicator(
                      color: blueColor,
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: specialtyDoctors.length,
                    itemBuilder: (context, index) {
                      // Get the current specialty from the list
                      var specialty = specialtyDoctors[index]['specialty'];
                      // Check if the specialty exists in the database specialties
                      var doctorSpecialty = value.allSpecialtyDoctors
                          .firstWhere(
                              (element) =>
                                  element['doctorSpecialty'] == specialty,
                              orElse: () => <String, dynamic>{});
                      return Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: blueColor,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.asset(
                                      "${specialtyDoctors[index]['url']}",
                                      fit: BoxFit.fill,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              6,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${specialtyDoctors[index]['specialty']}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: whiteColor,
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    "عدد الاطباء : ${doctorSpecialty['doctorCount'] ?? 0}",
                                    style: TextStyle(color: whiteColor),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: amberColor),
                                      onPressed: () async {
                                        if (doctorSpecialty['serviceNumber'] !=
                                            '') {
                                          await value
                                              .showAllSpecialtyServicesDoctors(
                                            specialtyDoctors[index]['specialty']
                                                .toString(),
                                            doctorSpecialty['serviceNumber']
                                                .toString(),
                                          );
                                        } else {
                                          await value.showAllDoctors(
                                            specialtyDoctors[index]['specialty']
                                                .toString(),
                                          );
                                        }
                                        goToAllDoctors();
                                      },
                                      child: Text(
                                        "عرض الاطباء",
                                        style: TextStyle(
                                            color: blueColor, fontSize: 18.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(color: Colors.transparent);
                    },
                  ),
          );
        }),
      ),
    );
  }
}
