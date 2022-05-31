import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class Utility {
  /// Show loader
  static showLoaderDialog() {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // /// Close any open dialog.
  // static void closeDialog() {
  //   // if (Get.isDialogOpen ?? false) Get.back<dynamic>();
  //   debugPrint('Start: Close Dialog ${Get.isDialogOpen}');
  //   if (Get.isDialogOpen ?? true) {
  //     //   // Navigator.of(Get.context!, rootNavigator: true);
  //     Get.back<void>();
  //   }
  //   debugPrint('End: Close Dialog ${Get.isDialogOpen}');
  // }
}
