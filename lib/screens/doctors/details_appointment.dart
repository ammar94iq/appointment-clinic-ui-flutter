import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/api/links.dart';
import '../../provider/doctors/doctor_provider.dart';
import '../helper/show_dialog.dart';
import '../helper/text_form_field.dart';

Color blueColor = const Color.fromARGB(255, 35, 107, 254);

Color whiteColor = Colors.white;
Color? greyColor = Colors.grey[500];
Color? greenColor = Colors.green;
Color? amberColor = Colors.amber;

class DetailsAppointment extends StatelessWidget {
  final Map<String, dynamic> appointmentIndex;
  const DetailsAppointment({super.key, required this.appointmentIndex});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          title: const Text("تفاصيل الحجز"),
        ),
        body: Container(
          color: blueColor,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              DoctorDetailsHeader(appointmentIndex: appointmentIndex),
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Name(appointmentIndex: appointmentIndex),
                    Days(appointmentIndex: appointmentIndex),
                    Times(appointmentIndex: appointmentIndex),
                    Description(appointmentIndex: appointmentIndex),
                    Phone(appointmentIndex: appointmentIndex),
                    RecipesButton(appointmentIndex: appointmentIndex),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DoctorDetailsHeader extends StatelessWidget {
  final Map<String, dynamic> appointmentIndex;
  const DoctorDetailsHeader({super.key, required this.appointmentIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              "$linkServerName/users_images/${appointmentIndex['url']}",
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.width / 2,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }
}

class Name extends StatelessWidget {
  final Map<String, dynamic> appointmentIndex;
  const Name({super.key, required this.appointmentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: whiteColor,
      ),
      child: ListTile(
        leading: Icon(Icons.person_2_sharp, color: blueColor, size: 30.0),
        title: const Text(
          "الاسم",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${appointmentIndex['name']}"),
      ),
    );
  }
}

class Days extends StatelessWidget {
  final Map<String, dynamic> appointmentIndex;
  const Days({super.key, required this.appointmentIndex});

  @override
  Widget build(BuildContext context) {
    String selectedDay = appointmentIndex['selectedDay'].substring(0, 10);
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: whiteColor,
      ),
      child: ListTile(
        leading: Icon(Icons.date_range, color: blueColor, size: 30.0),
        title: const Text(
          "  موعد الحجز",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(selectedDay),
      ),
    );
  }
}

class Times extends StatelessWidget {
  final Map<String, dynamic> appointmentIndex;

  const Times({super.key, required this.appointmentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: whiteColor,
      ),
      child: ListTile(
        leading: Icon(Icons.timer_outlined, color: blueColor, size: 30.0),
        title: const Text(
          "  وقت الحجز",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${appointmentIndex['selectedTime']}"),
      ),
    );
  }
}

class Description extends StatelessWidget {
  final Map<String, dynamic> appointmentIndex;

  const Description({super.key, required this.appointmentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: whiteColor,
      ),
      child: ListTile(
        leading: Icon(Icons.note_alt, color: blueColor, size: 30.0),
        title: const Text(
          "الوصف",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${appointmentIndex['description']}"),
      ),
    );
  }
}

class Phone extends StatelessWidget {
  final Map<String, dynamic> appointmentIndex;

  const Phone({super.key, required this.appointmentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: whiteColor,
      ),
      child: ListTile(
        leading: Icon(Icons.phone, color: blueColor, size: 30.0),
        title: const Text(
          "الهاتف",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${appointmentIndex['phone']}"),
      ),
    );
  }
}

class RecipesButton extends StatelessWidget {
  final Map<String, dynamic> appointmentIndex;
  const RecipesButton({super.key, required this.appointmentIndex});

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<DoctorsProvider>(context, listen: true);

    void showDialog(String resultMessage) {
      DialogHelper.myDialog(context, resultMessage, 'pop');
    }

    void showLoading() {
      DialogHelper.showLoadingIndicator(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('العلاج'),
        const SizedBox(height: 5.0),
        textFormField(model.recipes, 255, 10, whiteColor, TextInputType.text),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: greenColor,
              foregroundColor: whiteColor,
            ),
            onPressed: () async {
              showLoading();
              await model.addUserRecipes(appointmentIndex['id'].toString(),
                  appointmentIndex['randomIdUser'].toString());
              showDialog(model.resultMessage);
            },
            child: const Text(
              "اضافة علاج",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
