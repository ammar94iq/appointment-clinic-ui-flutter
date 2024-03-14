import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static void myDialog(
      BuildContext context, String resultMessage, String action) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.bottomSlide,
      dismissOnTouchOutside: false,
      body: SizedBox(
        height: 150.0,
        child: Center(
          child: Text(
            textAlign: TextAlign.center,
            resultMessage,
          ),
        ),
      ),
      transitionAnimationDuration: const Duration(milliseconds: 300),
      btnOkText: "حسنا",
      btnOkOnPress: () {
        if (action == 'pop') {
          Navigator.of(context).pop();
        } else {
          return;
        }
      },
    ).show();
  }

  static void showLoadingIndicator(BuildContext context) {
    AwesomeDialog(
      context: context,
      //dismissOnTouchOutside: false,
      dialogType: DialogType.noHeader,
      animType: AnimType.topSlide,
      body: const SizedBox(
        height: 150.0,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.green,
              ),
              SizedBox(height: 20.0),
              Text("جاري التحميل"),
            ],
          ),
        ),
      ),
      transitionAnimationDuration: const Duration(milliseconds: 300),
    ).show();
  }
}
