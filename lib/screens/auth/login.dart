import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/auth/auth_provider.dart';
import '../../provider/auth/personal_file.dart';
import '../../provider/doctors/doctor_provider.dart';
import '../doctors/doctor_home.dart';
import '../helper/animate.dart';
import '../helper/show_dialog.dart';
import '../users/user_home.dart';
import 'register.dart';

Color blueColor = const Color.fromARGB(255, 35, 107, 254);

Color whiteColor = Colors.white;
Color? greyColor = Colors.grey[300];
Color? greenColor = Colors.green;

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    double headerHeight = MediaQuery.of(context).size.height / 3;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("تسجيل الدخول"),
        ),
        body: Container(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              SizedBox(
                height: headerHeight,
                child: Image.asset("images/login_icon.gif"),
              ),
              const SizedBox(height: 15.0),
              const Email(),
              const SizedBox(height: 15.0),
              const Password(),
              const SizedBox(height: 20.0),
              const ForgetPassword(),
              const SizedBox(height: 15.0),
              const LoginButton(),
              const SizedBox(height: 15.0),
              const HaveNotAccount(),
            ],
          ),
        ),
      ),
    );
  }
}

class Email extends StatelessWidget {
  const Email({super.key});

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AuthProvider>(context);

    return TextFormField(
      controller: model.email,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email_outlined),
        hintText: "الايميل او رقم الهاتف",
        hintStyle: const TextStyle(fontSize: 20.0),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        fillColor: greyColor,
        filled: true,
      ),
    );
  }
}

class Password extends StatelessWidget {
  const Password({super.key});

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AuthProvider>(context);

    return TextFormField(
      controller: model.password,
      obscureText: model.obscureText,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(model.obscureText == true
              ? Icons.visibility
              : Icons.visibility_off),
          onPressed: () {
            model.togglePassword();
          },
        ),
        hintText: "كلمة السر",
        hintStyle: const TextStyle(fontSize: 20.0),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        fillColor: greyColor,
        filled: true,
      ),
    );
  }
}

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("هل نسيت كلمة السر"),
        const SizedBox(width: 10.0),
        InkWell(
          child: Text(
            "اضغط هنا",
            style: TextStyle(color: blueColor),
          ),
        ),
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AuthProvider>(context);
    var doctorProvider = Provider.of<DoctorsProvider>(context);

    var personalFileProvider = Provider.of<PersonalFileProvider>(context);

    void showDialog() {
      DialogHelper.myDialog(context, model.resultMessage, 'pop');
    }

    void showLoading() {
      DialogHelper.showLoadingIndicator(context);
    }

    void goToUserHome() {
      Navigator.of(context).pushReplacement(
        createRoute(
          const UserHome(),
        ),
      );
    }

    void goToDoctorHome() {
      Navigator.of(context).pushReplacement(
        createRoute(
          const DoctorHome(),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: greenColor,
              foregroundColor: whiteColor,
            ),
            onPressed: () async {
              showLoading();
              await model.logIn();
              if (model.resultMessage == "user success") {
                await personalFileProvider.userProfile();
                goToUserHome();
              } else if (model.resultMessage == "doctor success") {
                await personalFileProvider.userProfile();
                await doctorProvider.refresh();
                goToDoctorHome();
              } else {
                showDialog();
              }
            },
            child: const Text(
              "تسجيل الدخول",
            ),
          ),
        ),
      ],
    );
  }
}

class HaveNotAccount extends StatelessWidget {
  const HaveNotAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "ليس لديك حساب",
        ),
        const SizedBox(width: 10.0),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              createRoute(
                const Register(),
              ),
            );
          },
          child: Text(
            "اضغط هنا",
            style: TextStyle(color: blueColor),
          ),
        ),
      ],
    );
  }
}
