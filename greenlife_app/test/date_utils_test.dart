import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:greenlife_app/utils/date_utils.dart';

void main() {
  group('basic helpers', () {
    test('twoDigits pads single digits only', () {
      expect(AppDateUtils.twoDigits(0), '00');
      expect(AppDateUtils.twoDigits(7), '07');
      expect(AppDateUtils.twoDigits(12), '12');
    });

    test('dateOnly drops the time part', () {
      expect(
        AppDateUtils.dateOnly(DateTime(2026, 11, 11, 15, 45, 10)),
        DateTime(2026, 11, 11),
      );
    });

    test('isSameDay ignores time but not the date', () {
      expect(
        AppDateUtils.isSameDay(
          DateTime(2026, 11, 11, 0, 1),
          DateTime(2026, 11, 11, 23, 59),
        ),
        isTrue,
      );
      expect(
        AppDateUtils.isSameDay(DateTime(2026, 11, 11), DateTime(2026, 11, 12)),
        isFalse,
      );
      expect(
        AppDateUtils.isSameDay(DateTime(2026, 11, 11), DateTime(2025, 11, 11)),
        isFalse,
      );
    });

    test('daysBetween counts calendar days and may be negative', () {
      final base = DateTime(2026, 11, 11, 23, 0);

      expect(AppDateUtils.daysBetween(base, DateTime(2026, 11, 11, 1, 0)), 0);
      expect(AppDateUtils.daysBetween(base, DateTime(2026, 11, 12, 1, 0)), 1);
      expect(AppDateUtils.daysBetween(base, DateTime(2026, 11, 8)), -3);
      expect(
        AppDateUtils.daysBetween(DateTime(2026, 12, 30), DateTime(2027, 1, 2)),
        3,
      );
    });

    test('isOverdue compares against the supplied now', () {
      final now = DateTime(2026, 11, 11, 12, 0);

      expect(AppDateUtils.isOverdue(DateTime(2026, 11, 11, 11, 59), now: now),
          isTrue);
      expect(AppDateUtils.isOverdue(DateTime(2026, 11, 11, 12, 1), now: now),
          isFalse);
    });

    test('epoch is the Unix epoch', () {
      expect(AppDateUtils.epoch.millisecondsSinceEpoch, 0);
    });
  });

  group('formatting', () {
    test('formatDate uses dd/MM/yyyy', () {
      expect(AppDateUtils.formatDate(DateTime(2026, 3, 5)), '05/03/2026');
      expect(AppDateUtils.formatDate(DateTime(2026, 12, 31)), '31/12/2026');
    });

    test('formatTime and formatClock use HH:mm', () {
      expect(AppDateUtils.formatTime(const TimeOfDay(hour: 8, minute: 5)),
          '08:05');
      expect(AppDateUtils.formatClock(DateTime(2026, 1, 1, 17, 30)), '17:30');
    });
  });

  group('parseDate', () {
    test('parses valid dd/MM/yyyy values, including padding and spaces', () {
      expect(AppDateUtils.parseDate('05/03/2026'), DateTime(2026, 3, 5));
      expect(AppDateUtils.parseDate('5/3/2026'), DateTime(2026, 3, 5));
      expect(AppDateUtils.parseDate(' 05/03/2026 '), DateTime(2026, 3, 5));
    });

    test('accepts 29/02 only in leap years', () {
      expect(AppDateUtils.parseDate('29/02/2028'), DateTime(2028, 2, 29));
      expect(AppDateUtils.parseDate('29/02/2027'), isNull);
    });

    test('rejects malformed or impossible dates', () {
      expect(AppDateUtils.parseDate(''), isNull);
      expect(AppDateUtils.parseDate('abc'), isNull);
      expect(AppDateUtils.parseDate('1/2'), isNull);
      expect(AppDateUtils.parseDate('a/b/c'), isNull);
      expect(AppDateUtils.parseDate('31/02/2026'), isNull);
      expect(AppDateUtils.parseDate('00/10/2026'), isNull);
      expect(AppDateUtils.parseDate('10/13/2026'), isNull);
    });

    test('round-trips with formatDate', () {
      final date = DateTime(2026, 7, 9);
      expect(AppDateUtils.parseDate(AppDateUtils.formatDate(date)), date);
    });
  });

  group('formatDueDate', () {
    // 11/11/2026 is a Wednesday.
    final now = DateTime(2026, 11, 11, 9, 0);

    String format(DateTime dueAt, {required bool isEnglish}) {
      return AppDateUtils.formatDueDate(dueAt, isEnglish: isEnglish, now: now);
    }

    test('labels today, including times that already passed', () {
      expect(format(DateTime(2026, 11, 11, 8, 0), isEnglish: false),
          'Hôm nay, 08:00');
      expect(format(DateTime(2026, 11, 11, 18, 30), isEnglish: true),
          'Today, 18:30');
    });

    test('labels tomorrow', () {
      expect(format(DateTime(2026, 11, 12, 15, 30), isEnglish: false),
          'Ngày mai, 15:30');
      expect(format(DateTime(2026, 11, 12, 15, 30), isEnglish: true),
          'Tomorrow, 15:30');
    });

    test('uses weekday names for 2 to 6 days ahead', () {
      // 14/11/2026 is a Saturday, 15/11/2026 a Sunday, 16/11/2026 a Monday.
      expect(format(DateTime(2026, 11, 14, 10, 0), isEnglish: false),
          'Thứ Bảy, 10:00');
      expect(format(DateTime(2026, 11, 14, 10, 0), isEnglish: true),
          'Saturday, 10:00');
      expect(format(DateTime(2026, 11, 15, 10, 0), isEnglish: false),
          'Chủ Nhật, 10:00');
      expect(format(DateTime(2026, 11, 16, 10, 0), isEnglish: true),
          'Monday, 10:00');
    });

    test('falls back to the full date from 7 days ahead', () {
      expect(format(DateTime(2026, 11, 18, 10, 0), isEnglish: true),
          '18/11/2026, 10:00');
      expect(format(DateTime(2026, 11, 18, 10, 0), isEnglish: false),
          '18/11/2026, 10:00');
    });

    test('falls back to the full date for days in the past', () {
      expect(format(DateTime(2026, 11, 10, 10, 0), isEnglish: true),
          '10/11/2026, 10:00');
    });
  });
}
