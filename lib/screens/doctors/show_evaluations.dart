import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/doctors/doctor_provider.dart';

Color? greyColor = Colors.grey[300];
Color? amberColor = Colors.amber[500];
Color blueColor = const Color.fromARGB(255, 35, 107, 254);
Color whiteColor = Colors.white;
Color? greenColor = Colors.green;

class ShowEvaluations extends StatelessWidget {
  const ShowEvaluations({super.key});

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<DoctorsProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تقييمات المستخدمين"),
        ),
        body: Container(
          color: Colors.grey[300],
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Image.asset(
                "images/efficient.png",
                fit: BoxFit.contain,
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: model.usersEvaluations.length,
                itemBuilder: ((context, index) {
                  var data = model.usersEvaluations[index];

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
                            backgroundColor: greyColor,
                            radius: MediaQuery.of(context).size.width / 15,
                            child: const Text('?'),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${data['comment']}"),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (data['starNumber'] == 1)
                                    const Text(
                                      '😡',
                                      style: TextStyle(fontSize: 25.0),
                                    ),
                                  if (data['starNumber'] == 2)
                                    const Text(
                                      '😄',
                                      style: TextStyle(fontSize: 25.0),
                                    ),
                                  if (data['starNumber'] == 3)
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
