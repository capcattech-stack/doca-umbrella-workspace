class ServiceResponse<T> {
  final bool isSuccess;
  final String? message;
  final T? data;
  final String? errorCode;

  ServiceResponse({
    required this.isSuccess,
    dynamic message,
    this.data,
    this.errorCode,
  }) : message = _normalizeMessage(message);

  static String? _normalizeMessage(dynamic raw) {
    if (raw == null) return null;
    if (raw is String) return raw;
    if (raw is List && raw.isNotEmpty) {
      final first = raw.first;
      if (first is Map<String, dynamic>) {
        final value = first['value'];
        if (value is String) {
          return value;
        }
      }
      return null;
    }
    return null;
  }
}
