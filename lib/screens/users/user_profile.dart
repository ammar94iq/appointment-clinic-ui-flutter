import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/api/links.dart';
import '../../provider/auth/personal_file.dart';
import '../helper/show_dialog.dart';
import '../helper/text_form_field.dart';

Color blueColor = const Color.fromARGB(255, 35, 107, 254);

Color whiteColor = Colors.white;
Color? greyColor = Colors.grey[500];
Color? greenColor = Colors.green;
Color? amberColor = Colors.amber;

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: const [
              UserProfileHeader(),
              UserProfileContent(),
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
            child: Column(
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
                      model.phone, 11, 1, whiteColor, TextInputType.phone),
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
                  subtitle: textFormField(model.address, 100, 5, whiteColor,
                      TextInputType.streetAddress),
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
