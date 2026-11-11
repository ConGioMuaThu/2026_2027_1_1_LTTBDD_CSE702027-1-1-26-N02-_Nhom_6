import 'package:flutter_test/flutter_test.dart';
import 'package:greenlife_app/utils/validators.dart';

void main() {
  group('Validators.isBlank', () {
    test('treats null, empty and whitespace-only text as blank', () {
      expect(Validators.isBlank(null), isTrue);
      expect(Validators.isBlank(''), isTrue);
      expect(Validators.isBlank('   '), isTrue);
    });

    test('treats text with content as not blank', () {
      expect(Validators.isBlank('a'), isFalse);
      expect(Validators.isBlank('  a  '), isFalse);
    });
  });

  group('Validators.requiredField', () {
    test('returns the message for blank values', () {
      expect(Validators.requiredField(null, 'bắt buộc'), 'bắt buộc');
      expect(Validators.requiredField('  ', 'bắt buộc'), 'bắt buộc');
    });

    test('returns null for filled values', () {
      expect(Validators.requiredField('Trầu bà', 'bắt buộc'), isNull);
    });
  });

  group('Validators.minLength', () {
    test('returns the message when trimmed text is too short', () {
      expect(Validators.minLength(null, 2, 'ngắn'), 'ngắn');
      expect(Validators.minLength('a', 2, 'ngắn'), 'ngắn');
      expect(Validators.minLength(' a ', 2, 'ngắn'), 'ngắn');
    });

    test('accepts text that reaches the minimum after trimming', () {
      expect(Validators.minLength('ab', 2, 'ngắn'), isNull);
      expect(Validators.minLength(' ab ', 2, 'ngắn'), isNull);
    });
  });

  group('Validators.optionalUrl', () {
    test('accepts empty or null values because the field is optional', () {
      expect(Validators.optionalUrl(null, 'sai'), isNull);
      expect(Validators.optionalUrl('', 'sai'), isNull);
      expect(Validators.optionalUrl('   ', 'sai'), isNull);
    });

    test('accepts http and https URLs that have a host', () {
      expect(Validators.optionalUrl('https://example.com/a.png', 'sai'), isNull);
      expect(Validators.optionalUrl('http://example.com', 'sai'), isNull);
      expect(Validators.optionalUrl('  https://example.com  ', 'sai'), isNull);
    });

    test('rejects other schemes, missing schemes and missing hosts', () {
      expect(Validators.optionalUrl('ftp://example.com', 'sai'), 'sai');
      expect(Validators.optionalUrl('example.com', 'sai'), 'sai');
      expect(Validators.optionalUrl('https://', 'sai'), 'sai');
      expect(Validators.optionalUrl('khong phai url', 'sai'), 'sai');
    });
  });

  group('Validators.selection', () {
    test('returns the message when nothing is selected', () {
      expect(Validators.selection<String>(null, 'chọn'), 'chọn');
    });

    test('returns null when a value is selected', () {
      expect(Validators.selection<String>('a', 'chọn'), isNull);
      expect(Validators.selection<int>(0, 'chọn'), isNull);
    });
  });

  group('Validators.text', () {
    test('returns the empty message for null or blank input', () {
      final validator = Validators.text(emptyMessage: 'trống');

      expect(validator(null), 'trống');
      expect(validator('   '), 'trống');
    });

    test('returns the too-short message, falling back to the empty message', () {
      final withShort = Validators.text(
        emptyMessage: 'trống',
        min: 3,
        tooShortMessage: 'ngắn',
      );
      final withoutShort = Validators.text(emptyMessage: 'trống', min: 3);

      expect(withShort('ab'), 'ngắn');
      expect(withoutShort('ab'), 'trống');
    });

    test('returns the too-long message, falling back to the empty message', () {
      final withLong = Validators.text(
        emptyMessage: 'trống',
        max: 5,
        tooLongMessage: 'dài',
      );
      final withoutLong = Validators.text(emptyMessage: 'trống', max: 5);

      expect(withLong('abcdef'), 'dài');
      expect(withoutLong('abcdef'), 'trống');
    });

    test('accepts valid text and measures length after trimming', () {
      final validator = Validators.text(
        emptyMessage: 'trống',
        min: 2,
        max: 5,
        tooShortMessage: 'ngắn',
        tooLongMessage: 'dài',
      );

      expect(validator('ab'), isNull);
      expect(validator('  abcde  '), isNull);
      expect(validator(' a '), 'ngắn');
    });
  });
}
