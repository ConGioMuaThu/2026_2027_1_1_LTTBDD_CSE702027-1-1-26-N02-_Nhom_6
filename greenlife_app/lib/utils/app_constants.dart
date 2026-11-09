class AppConstants {
  AppConstants._();

  static const int titleMinLength = 3;
  static const int titleMaxLength = 40;

  static const int noteSummaryMinLength = 10;
  static const int noteSummaryMaxLength = 300;

  static const int plantNameMinLength = 2;
  static const int plantNameMaxLength = 40;
  static const int scientificNameMaxLength = 60;
  static const int plantDescriptionMaxLength = 300;

  static const int noteHistoryYears = 5;
  static const int taskMaxDaysAhead = 365;

  static const Duration splashDuration = Duration(milliseconds: 3000);
  static const Duration splashTransitionDuration = Duration(milliseconds: 650);
  static const Duration splashReverseTransitionDuration =
      Duration(milliseconds: 350);
}