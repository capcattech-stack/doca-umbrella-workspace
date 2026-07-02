import 'package:flutter/material.dart';
import 'package:capcat_doca/enums/splash_action_sheet.dart';

class FinalActionSheet extends StatelessWidget {
  final void Function(SplashActionSheet nextSheet) changeSheet;
  const FinalActionSheet({super.key, required this.changeSheet});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Final Action Sheet"));
  }
}
