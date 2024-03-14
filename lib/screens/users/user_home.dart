import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/api/links.dart';
import '../../provider/auth/personal_file.dart';
import '../../provider/users/users_provider.dart';
import '../helper/animate.dart';
import 'all_doctors.dart';
import 'details_appointment.dart';
import 'details_doctor.dart';
import 'my_appointments.dart';
import 'recipes.dart';
import 'setting.dart';
import 'specialty.dart';
import 'user_profile.dart';

Color blueColor = const Color.fromARGB(255, 35, 107, 254);

Color whiteColor = Colors.white;
Color greenColor = Colors.green;
Color? greyColor = Colors.grey[500];

class UserHome extends StatelessWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var usersProvider = Provider.of<UsersProvider>(context, listen: true);
    var model = Provider.of<PersonalFileProvider>(context, listen: true);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          color: Colors.grey[300],
          child: PageView(
            physics: const BouncingScrollPhysics(),
            controller: model.pageController,
            children: [
              RefreshIndicator(
                color: blueColor,
                backgroundColor: whiteColor,
                onRefresh: () async {
                  await usersProvider.refresh();
                },
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: const [
                    Header(),
                    Slider(),
                    AppointmentsOptions(),
                    UpcomingAppointments(),
                    TopDoctors(),
                  ],
                ),
              ),
              const MyAppointments(),
              const Recipes(),
              const UserSetting(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) async {
            if (index == 0) {
              await usersProvider.refresh();
            }
            if (index == 1) {
              await usersProvider.showMyAppointments();
            } else if (index == 2) {
              await usersProvider.showUserRecipes();
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
              label: "مواعيدي",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.note_alt),
              label: "الوصفات",
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
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    void goToUserProfile() {
      Navigator.of(context).push(
        createRoute(
          const UserProfile(),
        ),
      );
    }

    void goToAllDoctors() {
      Navigator.of(context).push(
        createRoute(
          const AllDoctors(),
        ),
      );
    }

    var usersProvider = Provider.of<UsersProvider>(context);
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
      child: Consumer<PersonalFileProvider>(
        builder: ((context, model, child) {
          if (model.loading == true) {
            return Center(
              child: CircularProgressIndicator(
                color: whiteColor,
              ),
            );
          } else {
            String fullName = model.items[0]['name'];
            List<String> nameParts = fullName.split(" ");
            String firstName = nameParts[0];
            String lastName = nameParts.length > 1 ? nameParts.last : "";

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      child: InkWell(
                        onTap: () async {
                          await model.userProfile();
                          goToUserProfile();
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
                      "مرحبا , $firstName $lastName",
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Expanded(
                  child: TextFormField(
                    controller: usersProvider.doctorName,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: whiteColor,
                      hintStyle: const TextStyle(fontSize: 16.0),
                      hintText: "البحث عن اسم الطبيب",
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          await usersProvider.showAllDoctors('');
                          usersProvider.doctorName.text = '';
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
            );
          }
        }),
      ),
    );
  }
}

class Slider extends StatelessWidget {
  const Slider({super.key});

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

    return Container(
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Consumer<UsersProvider>(
          builder: (context, value, child) {
            return PageView.builder(
              itemCount: value.topDoctors.length,
              itemBuilder: (context, index) {
                String fullName = value.topDoctors[index]['name'];
                List<String> nameParts = fullName.split(' ');
                return InkWell(
                  onTap: () async {
                    await value.detailsDoctor(
                        value.topDoctors[index]['randomId'].toString());
                    goToDetailsDoctors(
                      value.detailsDoctorArray[0],
                      value.topDoctors[index]['happy_count'],
                      value.topDoctors[index]['smile_count'],
                      value.topDoctors[index]['angry_count'],
                    );
                  },
                  child: Column(
                    children: [
                      Image.network(
                        "$linkServerName/users_images/${value.topDoctors[index]['url']}",
                        fit: BoxFit.fill,
                        height: MediaQuery.of(context).size.width / 1.5,
                        width: MediaQuery.of(context).size.width,
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${nameParts.first} ${nameParts.last}"),
                            Text(
                              "${value.topDoctors[index]['doctorSpecialty']}",
                              style: TextStyle(color: greyColor),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  '😍',
                                  style: TextStyle(fontSize: 25.0),
                                ),
                                Text(
                                    "${value.topDoctors[index]['happy_count']}"),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  '😄',
                                  style: TextStyle(fontSize: 25.0),
                                ),
                                Text(
                                    "${value.topDoctors[index]['smile_count']}"),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  '😡',
                                  style: TextStyle(fontSize: 25.0),
                                ),
                                Text(
                                    "${value.topDoctors[index]['angry_count']}"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class AppointmentsOptions extends StatelessWidget {
  const AppointmentsOptions({super.key});

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<UsersProvider>(context, listen: true);
    void goToSpecialty() {
      Navigator.of(context).push(
        createRoute(
          const Specialty(),
        ),
      );
    }

    Widget optionsWidget(
      String path,
      double height,
      String title,
      String serviceNumber,
    ) {
      return InkWell(
        onTap: () async {
          await model.showAllSpecialtyDoctors(serviceNumber);
          goToSpecialty();
        },
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                child: Image.asset(
                  path,
                  height: height,
                  width: height,
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            Text(title),
          ],
        ),
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height / 8,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          optionsWidget("images/img4.png",
              MediaQuery.of(context).size.height / 8, "موعد بالعيادة", '1'),
          const SizedBox(width: 25.0),
          optionsWidget("images/img2.png",
              MediaQuery.of(context).size.height / 8, "اون لاين", '2'),
          const SizedBox(width: 25.0),
          optionsWidget("images/img1.png",
              MediaQuery.of(context).size.height / 8, "في المنزل", '3'),
          const SizedBox(width: 25.0),
          optionsWidget("images/img5.png",
              MediaQuery.of(context).size.height / 8, "أشعة وسونار", '4'),
          const SizedBox(width: 25.0),
          optionsWidget("images/laboratory_icon.png",
              MediaQuery.of(context).size.height / 8, "مختبرات", '5'),
          const SizedBox(width: 25.0),
          optionsWidget("images/logo.png",
              MediaQuery.of(context).size.height / 8, "صيدليات", '6'),
        ],
      ),
    );
  }
}

class UpcomingAppointments extends StatelessWidget {
  const UpcomingAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    void goToMyAppointments() {
      Navigator.of(context).push(
        createRoute(
          const MyAppointments(),
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

    return Consumer<UsersProvider>(
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
                      await value.showMyAppointments();
                      goToMyAppointments();
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
                          height: MediaQuery.of(context).size.height / 3,
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
                              onTap: () {
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
                                              Text(
                                                "${data['doctorSpecialty']}",
                                                style: const TextStyle(
                                                    fontSize: 12.0),
                                              ),
                                              Text(
                                                "${selectedDay.year}-${selectedDay.month}-${selectedDay.day}",
                                                style: TextStyle(
                                                    color: greyColor,
                                                    fontSize: 12.0),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const SizedBox.shrink(),
                                              Text("${data['selectedTime']}"),
                                            ],
                                          ),
                                          const SizedBox(height: 5.0),
                                          Text(
                                            "${data['doctorDescription'].length > 60 ? data['doctorDescription'].substring(0, 60) : data['doctorDescription']}",
                                            style: TextStyle(
                                                color: greyColor,
                                                fontSize: 12.0),
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

class TopDoctors extends StatelessWidget {
  const TopDoctors({super.key});

  @override
  Widget build(BuildContext context) {
    void goToAllDoctors() {
      Navigator.of(context).push(
        createRoute(
          const AllDoctors(),
        ),
      );
    }

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

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Consumer<UsersProvider>(
        builder: ((context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("افضل الاطباء"),
                  InkWell(
                    onTap: () async {
                      await value.showAllDoctors('');
                      goToAllDoctors();
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
                  : value.topDoctors.isEmpty
                      ? Container(
                          height: MediaQuery.of(context).size.height / 3,
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
                              const Text('لا توجد تقييمات للاطباء حاليا'),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                List.generate(value.topDoctors.length, (index) {
                              String fullName = value.topDoctors[index]['name'];
                              List<String> nameParts = fullName.split(' ');
                              return InkWell(
                                onTap: () async {
                                  await value.detailsDoctor(value
                                      .topDoctors[index]['randomId']
                                      .toString());
                                  goToDetailsDoctors(
                                    value.detailsDoctorArray[0],
                                    value.topDoctors[index]['happy_count'],
                                    value.topDoctors[index]['smile_count'],
                                    value.topDoctors[index]['angry_count'],
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  height:
                                      MediaQuery.of(context).size.width / 1.5,
                                  padding: const EdgeInsets.all(10.0),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        child: Image.network(
                                          "$linkServerName/users_images/${value.topDoctors[index]['url']}",
                                          fit: BoxFit.fill,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              6,
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      Text(
                                          "${nameParts.first} ${nameParts.last}"),
                                      Text(
                                        "${value.topDoctors[index]['doctorSpecialty']}",
                                        style: TextStyle(color: greyColor),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            '😍',
                                            style: TextStyle(fontSize: 25.0),
                                          ),
                                          Text(
                                              "${value.topDoctors[index]['happy_count']}"),
                                          const Text(
                                            '😄',
                                            style: TextStyle(fontSize: 25.0),
                                          ),
                                          Text(
                                              "${value.topDoctors[index]['smile_count']}"),
                                          const Text(
                                            '😡',
                                            style: TextStyle(fontSize: 25.0),
                                          ),
                                          Text(
                                              "${value.topDoctors[index]['angry_count']}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
            ],
          );
        }),
      ),
    );
  }
}
