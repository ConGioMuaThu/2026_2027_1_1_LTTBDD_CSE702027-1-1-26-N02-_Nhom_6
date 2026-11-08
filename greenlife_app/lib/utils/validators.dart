import 'package:flutter/widgets.dart';

class Validators {
  Validators._();

  static bool isBlank(String? value) => value == null || value.trim().isEmpty;

  static String? requiredField(String? value, String message) {
    return isBlank(value) ? message : null;
  }

  static String? minLength(String? value, int min, String message) {
    final text = value?.trim() ?? '';
    return text.length < min ? message : null;
  }

  static String? selection<T>(T? value, String message) {
    return value == null ? message : null;
  }

  static FormFieldValidator<String> text({
    required String emptyMessage,
    int min = 1,
    String? tooShortMessage,
    int? max,
    String? tooLongMessage,
  }) {
    return (value) {
      final text = value?.trim() ?? '';
      if (text.isEmpty) return emptyMessage;
      if (text.length < min) return tooShortMessage ?? emptyMessage;
      if (max != null && text.length > max) {
        return tooLongMessage ?? emptyMessage;
      }
      return null;
    };
  }
}