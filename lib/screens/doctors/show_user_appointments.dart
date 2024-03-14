import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/api/links.dart';
import '../../provider/doctors/doctor_provider.dart';
import '../helper/animate.dart';
import 'details_appointment.dart';

Color blueColor = const Color.fromARGB(255, 35, 107, 254);
Color whiteColor = Colors.white;
Color? greyColor = Colors.grey[500];
Color? greenColor = Colors.green;
Color? amberColor = Colors.amber;

class UsersAppointments extends StatelessWidget {
  const UsersAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    void goToDetailsAppointment(Map<String, dynamic> appointmentIndex) {
      Navigator.of(context).push(
        createRoute(
          DetailsAppointment(appointmentIndex: appointmentIndex),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          title: const Text("جميع المواعيد"),
        ),
        body: Container(
          color: Colors.grey[300],
          padding: const EdgeInsets.all(15.0),
          child: Consumer<DoctorsProvider>(
            builder: ((context, value, child) {
              return RefreshIndicator(
                color: blueColor,
                backgroundColor: whiteColor,
                onRefresh: () async {
                  await value.showUserAppointments();
                },
                child: value.loading == true
                    ? Center(
                        child: CircularProgressIndicator(
                          color: blueColor,
                        ),
                      )
                    : ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 3,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    "images/efficient.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Text(
                                    "عدد المواعيد : ${value.myAppointments.length}"),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: value.myAppointments.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () async {
                                  await value.showUserRecipes(value
                                      .myAppointments[index]['id']
                                      .toString());
                                  goToDetailsAppointment(
                                    value.myAppointments[index],
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: DoctorImage(
                                            appointmentIndex:
                                                value.myAppointments[index]),
                                      ),
                                      const SizedBox(width: 5.0),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            DoctorName(
                                              appointmentIndex:
                                                  value.myAppointments[index],
                                            ),
                                            const SizedBox(height: 5.0),
                                            AppointmentDate(
                                              appointmentIndex:
                                                  value.myAppointments[index],
                                            ),
                                            const SizedBox(height: 5.0),
                                            UserDescription(
                                              appointmentIndex:
                                                  value.myAppointments[index],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(color: Colors.transparent);
                            },
                          ),
                        ],
                      ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class DoctorImage extends StatelessWidget {
  final Map<String, dynamic> appointmentIndex;

  const DoctorImage({super.key, required this.appointmentIndex});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Image.network(
        "$linkServerName/users_images/${appointmentIndex['url']}",
        fit: BoxFit.fill,
        height: MediaQuery.of(context).size.height / 5,
      ),
    );
  }
}

class DoctorName extends StatelessWidget {
  final Map<String, dynamic> appointmentIndex;

  const DoctorName({super.key, required this.appointmentIndex});

  @override
  Widget build(BuildContext context) {
    String fullName = appointmentIndex['name'];
    List<String> nameParts = fullName.split(' ');
    return Text(
      "${nameParts.first} ${nameParts.last}",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class AppointmentDate extends StatelessWidget {
  final Map<String, dynamic> appointmentIndex;
  const AppointmentDate({super.key, required this.appointmentIndex});

  @override
  Widget build(BuildContext context) {
    DateTime selectedDay = DateTime.parse(appointmentIndex['selectedDay']);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          textDirection: TextDirection.ltr,
          "${selectedDay.year}-${selectedDay.month}-${selectedDay.day}",
          style: TextStyle(color: greenColor),
        ),
        Text(
          textDirection: TextDirection.ltr,
          "${appointmentIndex['selectedTime']}",
          style: TextStyle(color: greenColor),
        ),
      ],
    );
  }
}

class UserDescription extends StatelessWidget {
  final Map<String, dynamic> appointmentIndex;

  const UserDescription({super.key, required this.appointmentIndex});

  @override
  Widget build(BuildContext context) {
    return Text(
      "${appointmentIndex['description'].length > 50 ? appointmentIndex['description'].substring(0, 50) : appointmentIndex['description']}",
      style: TextStyle(color: greyColor),
    );
  }
}
