import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/api/links.dart';
import '../../provider/auth/personal_file.dart';
import '../../provider/doctors/doctor_provider.dart';
import '../helper/animate.dart';
import 'details_appointment.dart';
import 'doctor_profile.dart';
import 'settings.dart';
import 'show_user_appointments.dart';

Color blueColor = const Color.fromARGB(255, 35, 107, 254);
Color whiteColor = Colors.white;
Color? greyColor = Colors.grey[500];

class DoctorHome extends StatelessWidget {
  const DoctorHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<PersonalFileProvider>(context, listen: true);
    var doctorsProvider = Provider.of<DoctorsProvider>(context, listen: true);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          color: Colors.grey[300],
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: model.pageController,
            children: [
              RefreshIndicator(
                color: blueColor,
                backgroundColor: whiteColor,
                onRefresh: () async {
                  await doctorsProvider.refresh();
                },
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Header(model: model),
                    const UpcomingAppointments(),
                  ],
                ),
              ),
              const UsersAppointments(),
              const DoctorSettings(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) async {
            if (index == 0) {
              await doctorsProvider.refresh();
            }
            if (index == 1) {
              await doctorsProvider.showUserAppointments();
            }
            model.changeUserInterface(index);
            model.pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.linear,
            );
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: blueColor,
          currentIndex: model.selectedIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "الرئيسية",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.date_range),
              label: "المواعيد",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notes),
              label: "المزيد",
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final PersonalFileProvider model;
  const Header({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    var m = Provider.of<DoctorsProvider>(context, listen: true);
    void goToDoctorProfile() {
      Navigator.of(context).push(
        createRoute(
          const DoctorProfile(),
        ),
      );
    }

    void goToAllDoctors() {
      Navigator.of(context).push(
        createRoute(
          const UsersAppointments(),
        ),
      );
    }

    Color whiteColor = Colors.white;
    String fullName = '';
    if (model.items.isNotEmpty) {
      fullName = model.items[0]['name'];
    }
    List<String> nameParts = fullName.split(' ');

    return Container(
      height: MediaQuery.of(context).size.height / 5,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: blueColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          model.loading == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: whiteColor,
                  ),
                )
              : Row(
                  children: [
                    SizedBox(
                      child: InkWell(
                        onTap: () async {
                          m.currentProfileIndex = 0;
                          await m.showDoctorInformation();
                          await m.showDoctorServices();
                          await m.showDoctorWorkDays();
                          goToDoctorProfile();
                        },
                        child: ClipOval(
                          child: CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(
                              "$linkServerName/users_images/${model.items[0]['url']}",
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    Text(
                      "${nameParts.first} ${nameParts.last}",
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 10.0),
          Expanded(
            child: TextFormField(
              controller: m.userName,
              decoration: InputDecoration(
                filled: true,
                fillColor: whiteColor,
                hintStyle: const TextStyle(fontSize: 20.0),
                hintText: "البحث عن اسم المستخدم",
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: IconButton(
                  onPressed: () async {
                    m.myAppointments.clear();
                    await m.showUserAppointments();
                    m.userName.text = '';
                    goToAllDoctors();
                  },
                  icon: const Icon(
                    Icons.search,
                    size: 35.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UpcomingAppointments extends StatelessWidget {
  const UpcomingAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    void goToUsersAppointments() {
      Navigator.of(context).push(
        createRoute(
          const UsersAppointments(),
        ),
      );
    }

    void goToDetailsAppointment(Map<String, dynamic> appointmentIndex) {
      Navigator.of(context).push(
        createRoute(
          DetailsAppointment(appointmentIndex: appointmentIndex),
        ),
      );
    }

    return Consumer<DoctorsProvider>(
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("المواعيد القادمة"),
                  InkWell(
                    onTap: () async {
                      await value.showUserAppointments();
                      goToUsersAppointments();
                    },
                    child: Text(
                      "عرض الجميع",
                      style: TextStyle(color: blueColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              value.loading == true
                  ? Center(
                      child: CircularProgressIndicator(color: blueColor),
                    )
                  : value.myNewAppointments.isEmpty
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Image.asset(
                                  "images/TradingCalendar.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const Text("ليس لديك اي حجوزات"),
                            ],
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: value.myNewAppointments.length,
                          itemBuilder: (context, index) {
                            var data = value.myNewAppointments[index];
                            DateTime selectedDay =
                                DateTime.parse(data['selectedDay']);
                            String fullName = data['name'];
                            List<String> nameParts = fullName.split(' ');
                            return InkWell(
                              onTap: () async {
                                await value
                                    .showUserRecipes(data['id'].toString());
                                goToDetailsAppointment(
                                  data,
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
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.network(
                                          "$linkServerName/users_images/${data['url']}",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5.0),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "${nameParts.first} ${nameParts.last}"),
                                              Icon(
                                                Icons.calendar_month,
                                                color: blueColor,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("${data['selectedTime']}"),
                                              Text(
                                                "${selectedDay.year}-${selectedDay.month}-${selectedDay.day}",
                                                style:
                                                    TextStyle(color: greyColor),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5.0),
                                          Text(
                                            "${data['description'].length > 50 ? data['description'].substring(0, 50) : data['description']}",
                                            style: TextStyle(color: greyColor),
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
      },
    );
  }
}
