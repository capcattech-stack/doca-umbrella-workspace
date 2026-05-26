enum SplashActionSheet {
  intro,
  signInUp,
  forgotPasswordEnterPhone,
  forgotPasswordEnterOtp,
  forgotPasswordEnterNewPassword,
  phoneRegisterEnterOtp,
  socialRegisterEnterPhone,
  socialRegisterEnterOtp,
  finalStep,
}

extension SplashActionSheetExtension on SplashActionSheet {
  int get logicalIndex {
    switch (this) {
      case SplashActionSheet.intro:
        return 0;
      case SplashActionSheet.signInUp:
        return 1;
      case SplashActionSheet.forgotPasswordEnterPhone:
        return 10;
      case SplashActionSheet.forgotPasswordEnterOtp:
        return 11;
      case SplashActionSheet.forgotPasswordEnterNewPassword:
        return 12;
      case SplashActionSheet.phoneRegisterEnterOtp:
        return 20;
      case SplashActionSheet.socialRegisterEnterPhone:
        return 30;
      case SplashActionSheet.socialRegisterEnterOtp:
        return 31;
      case SplashActionSheet.finalStep:
        return 99;
    }
  }
}
