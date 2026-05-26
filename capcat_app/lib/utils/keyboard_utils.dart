import 'dart:async';
import 'package:flutter/material.dart';

Future<void> runAfterKeyboardClosed(
  BuildContext context,
  FutureOr<void> Function() action,
) async {
  FocusScope.of(context).unfocus();
  await WidgetsBinding.instance.endOfFrame;
  await Future.delayed(const Duration(milliseconds: 100));
  await action();
}
