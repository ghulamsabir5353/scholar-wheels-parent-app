import 'package:intl/intl.dart';

class AppDateTimeFormatter {
  const AppDateTimeFormatter._();

  static final RegExp _timeOnlyPattern = RegExp(
    r'^(\d{1,2}):(\d{2})(?::(\d{2}))?(?:\s*([AaPp][Mm]))?\s*$',
    caseSensitive: false,
  );

  static DateTime? toLocal(DateTime? dateTime) {
    if (dateTime == null) return null;
    return dateTime.isUtc ? dateTime.toLocal() : dateTime;
  }

  static String format(
    DateTime? dateTime, {
    required String pattern,
    String fallback = 'N/A',
  }) {
    final localDateTime = toLocal(dateTime);
    if (localDateTime == null) return fallback;
    return DateFormat(pattern).format(localDateTime);
  }

  /// Parses [value] as either:
  /// - **Time only** (e.g. `15:34`, `3:30 PM`): local wall clock on
  ///   [referenceDate] (or today), formatted with [pattern] (default `h:mm a`).
  /// - **Full datetime** (e.g. ISO `2026-04-08T10:04:49.155Z`): [DateTime.parse],
  ///   then UTC values are converted to local before formatting.
  static String formatStringTime(
    String? value, {
    DateTime? referenceDate,
    String pattern = 'h:mm a',
    String fallback = 'N/A',
  }) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return fallback;

    final parsed = _parseStringToLocalDateTime(
      trimmed,
      referenceDate: referenceDate,
    );
    if (parsed == null) return fallback;

    return DateFormat(pattern).format(parsed);
  }

  static DateTime? _parseStringToLocalDateTime(
    String input, {
    DateTime? referenceDate,
  }) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;

    final timeMatch = _timeOnlyPattern.firstMatch(trimmed);
    if (timeMatch != null) {
      return _wallClockFromTimeMatch(timeMatch, referenceDate);
    }

    try {
      final parsed = DateTime.parse(trimmed);
      return toLocal(parsed);
    } catch (_) {
      return null;
    }
  }

  static DateTime? _wallClockFromTimeMatch(
    RegExpMatch match,
    DateTime? referenceDate,
  ) {
    var hour = int.tryParse(match.group(1) ?? '');
    final minute = int.tryParse(match.group(2) ?? '');
    final second = int.tryParse(match.group(3) ?? '0');
    final meridiem = match.group(4)?.toUpperCase();

    if (hour == null || minute == null || second == null) {
      return null;
    }

    if (meridiem == 'AM' && hour == 12) {
      hour = 0;
    } else if (meridiem == 'PM' && hour < 12) {
      hour += 12;
    }

    final base = referenceDate ?? DateTime.now();
    return DateTime(base.year, base.month, base.day, hour, minute, second);
  }
}
