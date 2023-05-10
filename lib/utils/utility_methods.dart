import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class Utils {
  static void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void flushBarErrorMessages(String message, BuildContext context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          title: "Error",
          message: message,
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          forwardAnimationCurve: Curves.decelerate,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: const EdgeInsets.all(15),
          borderRadius: BorderRadius.circular(10),
          flushbarPosition: FlushbarPosition.BOTTOM,
          positionOffset: 69,
          icon: const Icon(
            Icons.error,
            color: Colors.white,
            size: 30,
          ),
        )..show(context));
  }

  static snackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.blueAccent,
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static OutlineInputBorder outlineEnabledBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(color: Colors.black.withOpacity(0.4)),
    );
  }

  //height
  static double scHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

//width
  static double scWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
