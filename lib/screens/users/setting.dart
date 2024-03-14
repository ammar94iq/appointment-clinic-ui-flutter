import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../provider/api/links.dart';
import '../../provider/auth/personal_file.dart';
import '../../provider/doctors/doctor_provider.dart';
import '../../provider/users/users_provider.dart';
import '../auth/login.dart';
import '../doctors/doctor_profile.dart';
import '../helper/animate.dart';
import 'specialty.dart';
import 'user_profile.dart';

class UserSetting extends StatelessWidget {
  const UserSetting({super.key});

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<PersonalFileProvider>(context, listen: true);

    var usersProvider = Provider.of<UsersProvider>(context, listen: true);
    var m = Provider.of<DoctorsProvider>(context, listen: true);
    void goToDoctorProfile() {
      Navigator.of(context).push(
        createRoute(
          const DoctorProfile(),
        ),
      );
    }

    void goToAllSpecialtyDoctor() {
      Navigator.of(context).push(
        createRoute(
          const Specialty(),
        ),
      );
    }

    void goToLoginPage() {
      Navigator.of(context).pushReplacement(
        createRoute(
          const Login(),
        ),
      );
    }

    String fullName = model.items[0]['name'];
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0];
    String lastName = nameParts.length > 1 ? nameParts.last : "";

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          color: Colors.grey[300],
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const ListTile(
                leading: Icon(Icons.notes),
                title: Text("المزيد"),
              ),
              const SizedBox(height: 10.0),
              TextButton(
                onPressed: () async {
                  if (sharedPre.getString("userType") == "مستخدم") {
                    Navigator.of(context).push(
                      createRoute(
                        const UserProfile(),
                      ),
                    );
                  } else {
                    m.currentProfileIndex = 0;
                    await m.showDoctorInformation();
                    await m.showDoctorWorkDays();
                    goToDoctorProfile();
                  }
                },
                child: ListTile(
                  leading: ClipOval(
                    child: Image.network(
                        "$linkServerName/users_images/${model.items[0]['url']}"),
                  ),
                  title: Text("$firstName $lastName"),
                  subtitle: Text("${model.items[0]['email']}"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
              sharedPre.getString("userType") == "مستخدم"
                  ? TextButton(
                      onPressed: () async {
                        await usersProvider.showAllSpecialtyDoctors('');
                        goToAllSpecialtyDoctor();
                      },
                      child: const ListTile(
                        leading: Icon(Icons.all_inbox_rounded),
                        title: Text("جميع التخصصات"),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    )
                  : const SizedBox.shrink(),
              TextButton(
                onPressed: () {},
                child: const ListTile(
                  leading: Icon(Icons.description),
                  title: Text("حول التطبيق"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const ListTile(
                  leading: Icon(Icons.note_alt),
                  title: Text("الشروط والاحكام"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const ListTile(
                  leading: Icon(Icons.help_center),
                  title: Text("مركز المساعدة"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              TextButton(
                onPressed: () async {
                  model.selectedIndex = 0;
                  await sharedPre.clear();
                  goToLoginPage();
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: Text(
                    "تسجيل الخروج",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
