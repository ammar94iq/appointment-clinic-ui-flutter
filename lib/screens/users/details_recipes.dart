import 'package:flutter/material.dart';

import '../../provider/api/links.dart';

Color? greyColor = Colors.grey[300];
Color? amberColor = Colors.amber[500];
Color blueColor = const Color.fromARGB(255, 35, 107, 254);
Color whiteColor = Colors.white;
Color? greenColor = Colors.green;

class DetailsRecipes extends StatelessWidget {
  final Map<String, dynamic> detailsRecipes;
  const DetailsRecipes({super.key, required this.detailsRecipes});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            color: blueColor,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 20.0),
                Photo(detailsRecipes: detailsRecipes),
                const SizedBox(height: 20.0),
                Container(
                  color: Colors.grey[300],
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20.0),
                      Name(detailsRecipes: detailsRecipes),
                      const SizedBox(height: 20.0),
                      Day(detailsRecipes: detailsRecipes),
                      const SizedBox(height: 20.0),
                      Time(detailsRecipes: detailsRecipes),
                      const SizedBox(height: 20.0),
                      Description(detailsRecipes: detailsRecipes),
                      const SizedBox(height: 20.0),
                      Recipes(detailsRecipes: detailsRecipes),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Photo extends StatelessWidget {
  final Map<String, dynamic> detailsRecipes;
  const Photo({super.key, required this.detailsRecipes});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
          child: Image.network(
            "$linkServerName/users_images/${detailsRecipes['url']}",
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.width / 2,
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }
}

class Name extends StatelessWidget {
  final Map<String, dynamic> detailsRecipes;
  const Name({super.key, required this.detailsRecipes});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        isThreeLine: true,
        leading: Icon(
          Icons.person_2,
          color: blueColor,
          size: 30.0,
        ),
        title: const Text("اسم الطبيب"),
        subtitle: Text("${detailsRecipes['name']}"),
      ),
    );
  }
}

class Day extends StatelessWidget {
  final Map<String, dynamic> detailsRecipes;
  const Day({super.key, required this.detailsRecipes});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        isThreeLine: true,
        leading: Icon(
          Icons.date_range,
          color: blueColor,
          size: 30.0,
        ),
        title: const Text("تاريخ الحجز"),
        subtitle: Text("${detailsRecipes['selectedDay']}"),
      ),
    );
  }
}

class Time extends StatelessWidget {
  final Map<String, dynamic> detailsRecipes;
  const Time({super.key, required this.detailsRecipes});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        isThreeLine: true,
        leading: Icon(
          Icons.timelapse_sharp,
          color: blueColor,
          size: 30.0,
        ),
        title: const Text("وقت الحجز"),
        subtitle: Text("${detailsRecipes['selectedTime']}"),
      ),
    );
  }
}

class Description extends StatelessWidget {
  final Map<String, dynamic> detailsRecipes;
  const Description({super.key, required this.detailsRecipes});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        isThreeLine: true,
        leading: Icon(
          Icons.note_alt_rounded,
          color: blueColor,
          size: 30.0,
        ),
        title: const Text("وصف المريض"),
        subtitle: Text("${detailsRecipes['description']}"),
      ),
    );
  }
}

class Recipes extends StatelessWidget {
  final Map<String, dynamic> detailsRecipes;
  const Recipes({super.key, required this.detailsRecipes});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        isThreeLine: true,
        leading: Icon(
          Icons.health_and_safety_outlined,
          color: blueColor,
          size: 30.0,
        ),
        title: const Text("الوصفة او العلاج"),
        subtitle: Text("${detailsRecipes['recipes']}"),
      ),
    );
  }
}
