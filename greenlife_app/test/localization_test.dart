import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';

void main() {
  const vi = Locale('vi');
  const en = Locale('en');

  final viStrings = AppLocalizations(vi);
  final enStrings = AppLocalizations(en);

  test('repeat options are translated in both languages', () {
    expect(viStrings.repeatLabel, 'Lặp lại');
    expect(enStrings.repeatLabel, 'Repeat');
    expect(viStrings.repeatFrequency, 'Chu kỳ lặp lại');
    expect(enStrings.repeatFrequency, 'Repeat frequency');
    expect(viStrings.repeatNever, 'Không lặp lại');
    expect(enStrings.repeatNever, 'Never');
    expect(viStrings.repeatDaily, 'Mỗi ngày');
    expect(enStrings.repeatDaily, 'Every day');
    expect(viStrings.repeatEveryThreeDays, 'Mỗi 3 ngày');
    expect(enStrings.repeatEveryThreeDays, 'Every 3 days');
    expect(viStrings.repeatWeekly, 'Mỗi tuần');
    expect(enStrings.repeatWeekly, 'Every week');
    expect(viStrings.repeatMonthly, 'Mỗi tháng');
    expect(enStrings.repeatMonthly, 'Every month');
  });

  test('taskTypeLabel returns a label per task type and falls back to other',
      () {
    expect(viStrings.taskTypeLabel('watering'), 'Tưới nước');
    expect(enStrings.taskTypeLabel('watering'), 'Watering');
    expect(viStrings.taskTypeLabel('fertilize'), 'Bón phân');
    expect(enStrings.taskTypeLabel('fertilize'), 'Fertilize');
    expect(viStrings.taskTypeLabel('inspection'), 'Kiểm tra lá');
    expect(enStrings.taskTypeLabel('inspection'), 'Check leaves');
    expect(viStrings.taskTypeLabel('prune'), 'Tỉa cành');
    expect(enStrings.taskTypeLabel('prune'), 'Prune stems');
    expect(viStrings.taskTypeLabel('other'), 'Khác');
    expect(enStrings.taskTypeLabel('anything-else'), 'Other');
    expect(viStrings.taskTypeLabel(''), 'Khác');
  });

  test('weekdayName covers Monday to Sunday in both languages', () {
    const viNames = [
      'Thứ Hai',
      'Thứ Ba',
      'Thứ Tư',
      'Thứ Năm',
      'Thứ Sáu',
      'Thứ Bảy',
      'Chủ Nhật',
    ];
    const enNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    for (var weekday = DateTime.monday;
        weekday <= DateTime.sunday;
        weekday++) {
      expect(viStrings.weekdayName(weekday), viNames[weekday - 1]);
      expect(enStrings.weekdayName(weekday), enNames[weekday - 1]);
    }
  });

  test('today and tomorrow labels are translated', () {
    expect(viStrings.dueToday, 'Hôm nay');
    expect(enStrings.dueToday, 'Today');
    expect(viStrings.dueTomorrow, 'Ngày mai');
    expect(enStrings.dueTomorrow, 'Tomorrow');
  });

  test('unsupported languages fall back to Vietnamese', () {
    expect(AppLocalizations(const Locale('fr')).dueToday, 'Hôm nay');
  });
}
