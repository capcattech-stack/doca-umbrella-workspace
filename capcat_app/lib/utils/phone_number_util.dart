class PhoneNumberUtil {
  static String normalizeVietnamPhone(String rawPhoneNumber) {
    final phoneNumber = rawPhoneNumber.trim();
    if (phoneNumber.startsWith('+840')) {
      return '+84${phoneNumber.substring(4)}';
    }
    return phoneNumber;
  }

  static bool isValidVietnamPhone(String rawPhoneNumber) {
    final phoneNumber = normalizeVietnamPhone(rawPhoneNumber);
    final regex = RegExp(r'^\+84(3[2-9]|5[2-9]|7[0-9]|8[1-9]|9[0-9])[0-9]{7}$');
    return regex.hasMatch(phoneNumber);
  }
}
