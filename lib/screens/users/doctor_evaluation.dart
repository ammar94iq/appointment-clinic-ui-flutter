import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/api/links.dart';
import '../../provider/users/users_provider.dart';
import '../helper/show_dialog.dart';
import '../helper/text_form_field.dart';

Color? greyColor = Colors.grey[300];
Color? amberColor = Colors.amber[500];
Color blueColor = const Color.fromARGB(255, 35, 107, 254);
Color whiteColor = Colors.white;
Color? greenColor = Colors.green;

class DoctorEvaluation extends StatelessWidget {
  final Map<String, dynamic> detailsDoctor;
  const DoctorEvaluation({super.key, required this.detailsDoctor});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            foregroundColor: whiteColor,
            backgroundColor: blueColor,
            title: const Text("تقييم الطبيب"),
          ),
          body: Container(
            color: blueColor,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                DoctorEvaluationHeader(detailsDoctor: detailsDoctor),
                const SizedBox(height: 10.0),
                DoctorEvaluationContent(detailsDoctor: detailsDoctor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DoctorEvaluationHeader extends StatelessWidget {
  final Map<String, dynamic> detailsDoctor;
  const DoctorEvaluationHeader({super.key, required this.detailsDoctor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: MediaQuery.of(context).size.width / 5,
          backgroundImage: NetworkImage(
            "$linkServerName/users_images/${detailsDoctor['url']}",
          ),
        ),
        const SizedBox(height: 10.0),
        Center(
          child: Text(
            "${detailsDoctor['name']}",
            style: TextStyle(
              color: whiteColor,
              fontSize: 25.0,
            ),
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}

class DoctorEvaluationContent extends StatelessWidget {
  final Map<String, dynamic> detailsDoctor;
  const DoctorEvaluationContent({super.key, required this.detailsDoctor});

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<UsersProvider>(context);
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: greyColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20.0),
          AddEvaluation(model: model, detailsDoctor: detailsDoctor),
          const SizedBox(height: 20.0),
          ShowEvaluation(model: model),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}

class ShowEvaluation extends StatelessWidget {
  final UsersProvider model;

  const ShowEvaluation({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: model.doctorEvaluations.length,
      itemBuilder: ((context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              ListTile(
                isThreeLine: true,
                leading: CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 15,
                  backgroundImage: NetworkImage(
                    "$linkServerName/users_images/${model.doctorEvaluations[index]['url']}",
                  ),
                ),
                title: Text(
                  "${model.doctorEvaluations[index]['name']}",
                  style: TextStyle(color: blueColor),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${model.doctorEvaluations[index]['comment']}"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (model.doctorEvaluations[index]['starNumber'] == 1)
                          const Text(
                            '😡',
                            style: TextStyle(fontSize: 25.0),
                          ),
                        if (model.doctorEvaluations[index]['starNumber'] == 2)
                          const Text(
                            '😄',
                            style: TextStyle(fontSize: 25.0),
                          ),
                        if (model.doctorEvaluations[index]['starNumber'] == 3)
                          const Text(
                            '😍',
                            style: TextStyle(fontSize: 25.0),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class AddEvaluation extends StatelessWidget {
  final UsersProvider model;
  final Map<String, dynamic> detailsDoctor;
  const AddEvaluation(
      {super.key, required this.model, required this.detailsDoctor});

  @override
  Widget build(BuildContext context) {
    void showDialog(String resultMessage) {
      DialogHelper.myDialog(context, resultMessage, 'pop');
    }

    void showLoading() {
      DialogHelper.showLoadingIndicator(context);
    }

    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    model.toggleAddStar(1);
                  },
                  child: AnimatedDefaultTextStyle(
                    curve: Curves.easeInOutBack,
                    style: TextStyle(
                        fontSize: model.starNumber == 1 ? 35.0 : 24.0),
                    duration: const Duration(milliseconds: 900),
                    child: const Text('😡'),
                  ),
                ),
                InkWell(
                  onTap: () {
                    model.toggleAddStar(2);
                  },
                  child: AnimatedDefaultTextStyle(
                    curve: Curves.easeInOutBack,
                    style: TextStyle(
                        fontSize: model.starNumber == 2 ? 35.0 : 24.0),
                    duration: const Duration(milliseconds: 900),
                    child: const Text('😄'),
                  ),
                ),
                InkWell(
                  onTap: () {
                    model.toggleAddStar(3);
                  },
                  child: AnimatedDefaultTextStyle(
                    curve: Curves.easeInOutBack,
                    style: TextStyle(
                        fontSize: model.starNumber == 3 ? 35.0 : 24.0),
                    duration: const Duration(milliseconds: 900),
                    child: const Text('😍'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5.0),
          const Text("تعليقك"),
          const SizedBox(height: 5.0),
          textFormField(
              model.commentEvaluation, 100, 5, whiteColor, TextInputType.text),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: blueColor,
              foregroundColor: whiteColor,
            ),
            onPressed: () async {
              showLoading();
              await model
                  .addEvaluationDoctor(detailsDoctor['randomId'].toString());
              showDialog(model.resultMessage);
              await model.showTopDoctors();
            },
            child: const Text(
              "تقييم",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
