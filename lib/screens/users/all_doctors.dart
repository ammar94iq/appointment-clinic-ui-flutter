import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/api/links.dart';
import '../../provider/users/users_provider.dart';
import '../helper/animate.dart';
import 'details_doctor.dart';

Color blueColor = const Color.fromARGB(255, 35, 107, 254);

Color whiteColor = Colors.white;
Color? greyColor = Colors.grey[500];
Color? greenColor = Colors.green;
Color? amberColor = Colors.amber;

class AllDoctors extends StatelessWidget {
  const AllDoctors({super.key});

  @override
  Widget build(BuildContext context) {
    void goToDetailsDoctors(
      Map<String, dynamic> detailsDoctor,
      int happyCount,
      int smileCount,
      int angryCount,
    ) {
      Navigator.of(context).push(
        createRoute(
          DetailsDoctor(
            detailsDoctor: detailsDoctor,
            happyCount: happyCount,
            smileCount: smileCount,
            angryCount: angryCount,
          ),
        ),
      );
    }

    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[300],
            title: const Text("جميع الاطباء"),
          ),
          body: Container(
            color: Colors.grey[300],
            padding: const EdgeInsets.all(15.0),
            child: Consumer<UsersProvider>(
              builder: ((context, value, child) {
                return RefreshIndicator(
                  color: blueColor,
                  backgroundColor: whiteColor,
                  onRefresh: () async {
                    await value.showAllDoctors('');
                  },
                  child: value.loading == true
                      ? Center(
                          child: CircularProgressIndicator(
                            color: blueColor,
                          ),
                        )
                      : value.allDoctors.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Image.asset(
                                      "images/efficient.png",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(value.resultMessage),
                                  ),
                                ],
                              ),
                            )
                          : ListView(
                              physics: const BouncingScrollPhysics(),
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Image.asset(
                                          "images/efficient.png",
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Text(
                                          "عدد الاطباء : ${value.allDoctors.length}"),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: value.allDoctors.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () async {
                                        await value.detailsDoctor(value
                                            .allDoctors[index]['randomId']
                                            .toString());
                                        goToDetailsDoctors(
                                          value.detailsDoctorArray[0],
                                          value.topDoctors[index]
                                              ['happy_count'],
                                          value.topDoctors[index]
                                              ['smile_count'],
                                          value.topDoctors[index]
                                              ['angry_count'],
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: DoctorImage(
                                                  doctorIndex:
                                                      value.allDoctors[index]),
                                            ),
                                            const SizedBox(width: 5.0),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  DoctorName(
                                                      doctorIndex: value
                                                          .allDoctors[index]),
                                                  DoctorSpecialty(
                                                      doctorIndex: value
                                                          .allDoctors[index]),
                                                  const SizedBox(height: 5.0),
                                                  AppointmentDate(
                                                      doctorIndex: value
                                                          .allDoctors[index]),
                                                  const SizedBox(height: 5.0),
                                                  DoctorDescription(
                                                      doctorIndex: value
                                                          .allDoctors[index]),
                                                  const SizedBox(height: 5.0),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                        color: Colors.transparent);
                                  },
                                ),
                              ],
                            ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class DoctorImage extends StatelessWidget {
  final Map<String, dynamic> doctorIndex;

  const DoctorImage({super.key, required this.doctorIndex});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Image.network(
        "$linkServerName/users_images/${doctorIndex['url']}",
        fit: BoxFit.fill,
        height: MediaQuery.of(context).size.height / 5,
      ),
    );
  }
}

class DoctorName extends StatelessWidget {
  final Map<String, dynamic> doctorIndex;

  const DoctorName({super.key, required this.doctorIndex});

  @override
  Widget build(BuildContext context) {
    return Text(
      "${doctorIndex['name']}",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class DoctorSpecialty extends StatelessWidget {
  final Map<String, dynamic> doctorIndex;

  const DoctorSpecialty({super.key, required this.doctorIndex});

  @override
  Widget build(BuildContext context) {
    return Text(
      "${doctorIndex['doctorSpecialty']}",
      style: TextStyle(color: greyColor),
    );
  }
}

class AppointmentDate extends StatelessWidget {
  final Map<String, dynamic> doctorIndex;
  const AppointmentDate({super.key, required this.doctorIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          textDirection: TextDirection.ltr,
          "${doctorIndex['startTime']}",
          style: TextStyle(color: greenColor),
        ),
        Text(
          "  -  ",
          style: TextStyle(color: greyColor),
        ),
        Text(
          textDirection: TextDirection.ltr,
          "${doctorIndex['endTime']}",
          style: TextStyle(color: greenColor),
        ),
      ],
    );
  }
}

class DoctorDescription extends StatelessWidget {
  final Map<String, dynamic> doctorIndex;
  const DoctorDescription({super.key, required this.doctorIndex});

  @override
  Widget build(BuildContext context) {
    return Text(
      "${doctorIndex['doctorDescription']}",
      style: TextStyle(color: greyColor),
    );
  }
}
