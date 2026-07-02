import 'package:flutter/material.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/widgets/layout/custom_scaffold.dart';
import '../services/auth_service.dart';
import 'main/main_screen.dart';
import '../utils/size_config.dart';

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    // Khởi chạy sau khi build hoàn tất, đảm bảo context hợp lệ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthStatus();
    });
  }

  Future<void> _checkAuthStatus() async {
    final token = await AuthService.getToken();

    await Future.delayed(const Duration(seconds: 1)); // hiệu ứng splash nhẹ

    if (!mounted) return;
    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (_) => const LoginScreen()),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: AC.greenStrong1,
        ), // Hoặc logo app của bạn
      ),
    );
  }
}
