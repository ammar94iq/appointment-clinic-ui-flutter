import 'package:flutter/material.dart';

Widget textFormField(TextEditingController? controller, int maxLength,
    int maxLines, Color whiteColor, TextInputType? keyboardType) {
  return TextFormField(
    textInputAction: TextInputAction.next,
    keyboardType: keyboardType,
    controller: controller,
    maxLength: maxLength,
    maxLines: maxLines,
    minLines: 1,
    decoration: InputDecoration(
      filled: true,
      fillColor: whiteColor,
      hintStyle: const TextStyle(fontSize: 20.0),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );
}
