import 'dart:ui' show Locale;

class AppConfig {
  AppConfig._();

  static const String appName = 'GreenLife';
  static const bool showDebugBanner = false;

  static const String defaultLanguageCode = 'vi';
  static const Locale defaultLocale = Locale(defaultLanguageCode);

  static const String tasksStorageKey = 'care_tasks';
  static const String plantsStorageKey = 'plants';
  static const String notesStorageKey = 'growth_notes';
  static const String localeStorageKey = 'locale_code';

  static const String reminderChannelId = 'care_reminders';
  static const String reminderChannelName = 'Care reminders';
  static const String reminderChannelDescription =
      'Reminders for plant care tasks';
}