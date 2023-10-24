import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class dialogsBox {
  static void showSnackbar(context, String s) {
    Get.snackbar(
      'Snackbar Title',
      'This is the Snackbar message.',
      duration: Duration(seconds: 3),
      backgroundColor: Colors.grey[800],
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static void showProgressBar() {
    Get.dialog(
      Center(
        child: LoadingAnimationWidget.hexagonDots(color: Colors.deepPurple, size: Get.width * 0.2),
      ),
      barrierDismissible: false,
    );
  }

}
