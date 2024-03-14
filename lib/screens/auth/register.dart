import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/auth/auth_provider.dart';
import '../../provider/auth/personal_file.dart';
import '../helper/animate.dart';
import '../helper/show_dialog.dart';
import '../users/user_home.dart';
import 'login.dart';

Color blueColor = const Color.fromARGB(255, 35, 107, 254);

Color whiteColor = Colors.white;
Color? greyColor = Colors.grey[300];
Color? greenColor = Colors.green;

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    AuthProvider model = Provider.of<AuthProvider>(context);
    double headerHeight = MediaQuery.of(context).size.height / 4;
    double contentHeight = MediaQuery.of(context).size.height - headerHeight;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("انشاءالحساب"),
        ),
        body: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                height: headerHeight,
                child: Image.asset("images/login_icon.gif"),
              ),
              Expanded(
                child: SizedBox(
                  height: contentHeight,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      const SizedBox(height: 15.0),
                      Name(model: model),
                      const SizedBox(height: 15.0),
                      Phone(model: model),
                      const SizedBox(height: 15.0),
                      Email(model: model),
                      const SizedBox(height: 15.0),
                      Password(model: model),
                      const SizedBox(height: 15.0),
                      UserType(model: model),
                      const SizedBox(height: 15.0),
                      CreateAccountButton(model: model),
                      const SizedBox(height: 15.0),
                      const SecondaryButton(),
                    ],
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

class Name extends StatelessWidget {
  final AuthProvider model;
  const Name({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: model.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        hintText: "الاسم",
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

class Phone extends StatelessWidget {
  final AuthProvider model;
  const Phone({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: model.phone,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.phone),
        hintText: "رقم الهاتف",
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

class Email extends StatelessWidget {
  final AuthProvider model;
  const Email({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: model.email,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email_outlined),
        hintText: "الايميل",
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
  final AuthProvider model;
  const Password({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: model.password,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: const Icon(Icons.visibility_off),
          onPressed: () {},
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

class UserType extends StatelessWidget {
  final AuthProvider model;
  const UserType({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: "",
      onChanged: (value) {
        model.selectUserType(value);
      },
      items: const [
        DropdownMenuItem(
          alignment: Alignment.centerRight,
          value: "",
          child: Text("اختر نوع الحساب"),
        ),
        DropdownMenuItem(
          alignment: Alignment.centerRight,
          value: "مستخدم",
          child: Text("مستخدم"),
        ),
        DropdownMenuItem(
          alignment: Alignment.centerRight,
          value: "طبيب",
          child: Text("طبيب"),
        ),
      ],
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person_pin),
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

class CreateAccountButton extends StatelessWidget {
  final AuthProvider model;
  const CreateAccountButton({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
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
              await model.register();
              if (model.resultMessage == "success") {
                await personalFileProvider.userProfile();
                goToUserHome();
              } else {
                showDialog();
              }
            },
            child: const Text(
              "انشاء الحساب",
            ),
          ),
        ),
      ],
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("هل لديك حساب"),
        const SizedBox(width: 10.0),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              createRoute(
                const Login(),
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
