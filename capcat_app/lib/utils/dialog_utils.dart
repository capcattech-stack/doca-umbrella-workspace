// import 'package:flutter/material.dart';
// import 'package:flutter_chat_mock_app/theme/app_colors.dart';
// import 'package:flutter_chat_mock_app/utils/global_keys.dart';
// import 'package:flutter_chat_mock_app/utils/size_config.dart';

class DialogUtils {
  // static Future<void> showErrorDialog(
  //   BuildContext context, {
  //   required String title,
  //   required String message,
  // }) {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       backgroundColor: AppColors.background,
  //       title: Text(title),
  //       content: Text(message),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(ctx).pop(),
  //           child: const Text('OK'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // static void showToast(
  //   BuildContext context,
  //   String message, {
  //   Color? color,
  //   dynamic avoidBottom, // null, "default"/true, hoặc double
  // }) {
  //   double bottomOffset = 0;

  //   if (avoidBottom == 'default' || avoidBottom == true) {
  //     bottomOffset = SC.sh(SC.phyBotBarHeight);
  //   } else if (avoidBottom is double) {
  //     bottomOffset = SC.sh(avoidBottom);
  //   } else {
  //     bottomOffset = 0;
  //   }

  //   // ScaffoldMessenger.of(context).showSnackBar(
  //   rootScaffoldMessengerKey.currentState?.showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       backgroundColor: color ?? Colors.black87,
  //       behavior: SnackBarBehavior.floating,
  //       duration: const Duration(seconds: 2),
  //       margin: EdgeInsets.fromLTRB(SC.sw(16), 0, SC.sw(16), bottomOffset),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //     ),
  //   );
  // }
}
