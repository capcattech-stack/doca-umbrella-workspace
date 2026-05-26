import 'package:flutter/material.dart';

/// Hàm tiện dụng để push màn hình với hiệu ứng crossfade (fade giữa 2 trang)
Future<T?> customCrossFadePush<T>(BuildContext context, Widget page) {
  return Navigator.push<T>(
    context,
    PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fadeIn = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );
        final fadeOut = CurvedAnimation(
          parent: secondaryAnimation,
          curve: Curves.easeInOut,
        );

        return FadeTransition(
          opacity: fadeIn,
          child: FadeTransition(
            opacity: Tween<double>(begin: 1.0, end: 0.0).animate(fadeOut),
            child: child,
          ),
        );
      },
    ),
  );
}
