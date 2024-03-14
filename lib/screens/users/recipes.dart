import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/api/links.dart';
import '../../provider/users/users_provider.dart';
import '../helper/animate.dart';
import 'details_recipes.dart';

Color? greyColor = Colors.grey[300];
Color? amberColor = Colors.amber[500];
Color blueColor = const Color.fromARGB(255, 35, 107, 254);
Color whiteColor = Colors.white;
Color? greenColor = Colors.green;

class Recipes extends StatelessWidget {
  const Recipes({super.key});

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<UsersProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الوصفات العلاجية"),
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
              const SizedBox(height: 20.0),
              model.loading == true
                  ? Center(
                      child: CircularProgressIndicator(
                        color: blueColor,
                      ),
                    )
                  : model.userRecipes.isEmpty
                      ? Center(
                          child: Text(model.resultMessage),
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: model.userRecipes.length,
                          itemBuilder: ((context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  createRoute(
                                    DetailsRecipes(
                                        detailsRecipes:
                                            model.userRecipes[index]),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 20.0),
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                  isThreeLine: true,
                                  leading: CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width / 15,
                                    backgroundImage: NetworkImage(
                                      "$linkServerName/users_images/${model.userRecipes[index]['url']}",
                                    ),
                                  ),
                                  title: Text(
                                    "${model.userRecipes[index]['name']}",
                                    style: TextStyle(color: blueColor),
                                  ),
                                  subtitle: Text(
                                    "${model.userRecipes[index]['recipes'].length > 40 ? model.userRecipes[index]['recipes'].substring(0, 40) : model.userRecipes[index]['recipes']}",
                                  ),
                                ),
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
