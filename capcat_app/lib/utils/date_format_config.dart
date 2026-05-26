import 'package:intl/intl.dart';

class DateFormatConfig {
  static final _isoFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
  static final _displayShort = DateFormat('dd/MM/yyyy');
  static final _displayLong = DateFormat("dd 'tháng' MM 'năm' yyyy");
  static const int _defaultRecentDaysThreshold = 7;
  static const Duration _defaultClockSkewTolerance = Duration(minutes: 2);

  /// ISO string (from server) → "dd/MM/yyyy"
  static String isoToShortDisplay(String isoDate) {
    try {
      final date = _isoFormat.parse(isoDate, true).toLocal();
      return _displayShort.format(date);
    } catch (_) {
      return '';
    }
  }

  /// ISO string (from server) → "dd tháng MM năm yyyy"
  static String isoToLongDisplay(String isoDate) {
    try {
      final date = _isoFormat.parse(isoDate, true).toLocal();
      return _displayLong.format(date);
    } catch (_) {
      return '';
    }
  }

  /// "dd/MM/yyyy" → ISO string ("yyyy-MM-ddT00:00:00.000")
  static String shortDisplayToIso(String displayDate) {
    try {
      final date = _displayShort.parseStrict(displayDate);
      return _isoFormat.format(date.toUtc());
    } catch (_) {
      return '';
    }
  }

  /// DateTime → ISO (UTC, preserves time)
  static String dateTimeToIso(DateTime date) {
    return _isoFormat.format(date.toUtc());
  }

  /// Date-only ISO that keeps local calendar date (no UTC conversion)
  static String dateOnlyToIsoLocal(DateTime date) {
    final localMidnight = DateTime(date.year, date.month, date.day);
    return _isoFormat.format(localMidnight);
  }

  /// ISO → DateTime
  static DateTime? isoToDateTime(String isoDate) {
    try {
      return _isoFormat.parse(isoDate, true).toLocal();
    } catch (_) {
      return null;
    }
  }

  static String formatConversationTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 0) {
      return DateFormat('HH:mm').format(dateTime);
    }

    if (difference.inMinutes < 1440) {
      return DateFormat('HH:mm').format(dateTime);
    }

    if (difference.inDays < 7) {
      return DateFormat('EEE', 'vi').format(dateTime);
    }

    return DateFormat('dd/MM').format(dateTime);
  }

  static String formatMomentCreatedAt(
    DateTime createdAt, {
    DateTime? now,
    int recentDaysThreshold = _defaultRecentDaysThreshold,
    Duration clockSkewTolerance = _defaultClockSkewTolerance,
    String locale = 'vi',
  }) {
    final target = createdAt.toLocal();
    final current = (now ?? DateTime.now()).toLocal();
    final diff = current.difference(target);

    if (diff.isNegative) {
      if (target.difference(current) <= clockSkewTolerance) {
        return 'Vừa xong';
      }
      return _formatMomentAbsolute(target, current, locale);
    }

    if (diff.inSeconds < 60) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < recentDaysThreshold) return '${diff.inDays} ngày trước';

    return _formatMomentAbsolute(target, current, locale);
  }

  static String _formatMomentAbsolute(
    DateTime target,
    DateTime current,
    String locale,
  ) {
    final pattern = target.year == current.year
        ? 'dd/MM HH:mm'
        : 'dd/MM/yyyy HH:mm';
    return DateFormat(pattern, locale).format(target);
  }
}
