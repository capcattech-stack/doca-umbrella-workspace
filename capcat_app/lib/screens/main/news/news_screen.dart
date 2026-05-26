import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'News Screen',
        style: TextStyle(fontSize: 48, color: AppColors.greenStrong1),
      ),
    );
  }
}
