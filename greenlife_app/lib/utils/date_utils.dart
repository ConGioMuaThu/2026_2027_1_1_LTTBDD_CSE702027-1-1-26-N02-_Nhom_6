import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter/widgets.dart' show Locale;
import 'package:greenlife_app/l10n/app_localizations.dart';

class AppDateUtils {
  AppDateUtils._();

  static final DateTime epoch = DateTime.fromMillisecondsSinceEpoch(0);

  static String twoDigits(int value) => value.toString().padLeft(2, '0');

  static DateTime dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  static DateTime today() => dateOnly(DateTime.now());

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static int daysBetween(DateTime from, DateTime to) {
    final start = DateTime.utc(from.year, from.month, from.day);
    final end = DateTime.utc(to.year, to.month, to.day);
    return end.difference(start).inDays;
  }

  static bool isOverdue(DateTime dueAt, {DateTime? now}) {
    return dueAt.isBefore(now ?? DateTime.now());
  }

  static String formatDate(DateTime value) {
    return '${twoDigits(value.day)}/${twoDigits(value.month)}/${value.year}';
  }

  static String formatTime(TimeOfDay value) {
    return '${twoDigits(value.hour)}:${twoDigits(value.minute)}';
  }

  static String formatClock(DateTime value) {
    return '${twoDigits(value.hour)}:${twoDigits(value.minute)}';
  }

  static DateTime? parseDate(String value) {
    final parts = value.trim().split('/');
    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;

    final parsed = DateTime(year, month, day);
    if (parsed.year != year || parsed.month != month || parsed.day != day) {
      return null;
    }
    return parsed;
  }

  static String formatDueDate(
    DateTime dueAt, {
    required bool isEnglish,
    DateTime? now,
  }) {
    final diffDays = daysBetween(now ?? DateTime.now(), dueAt);
    final time = formatClock(dueAt);
    final strings = AppLocalizations(Locale(isEnglish ? 'en' : 'vi'));

    if (diffDays == 0) return '${strings.dueToday}, $time';
    if (diffDays == 1) return '${strings.dueTomorrow}, $time';

    if (diffDays > 1 && diffDays < 7) {
      return '${strings.weekdayName(dueAt.weekday)}, $time';
    }

    return '${formatDate(dueAt)}, $time';
  }
}