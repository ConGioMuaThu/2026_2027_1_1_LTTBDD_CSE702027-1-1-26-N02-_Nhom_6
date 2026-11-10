import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenlife_app/data/care_tips_data.dart';

void main() {
  test('all tips have a supported category', () {
    final tips = greenTipsFor(const Locale('vi'));

    expect(tips, isNotEmpty);
    expect(
      tips.every((tip) =>
          tip['category'] == 'care' || tip['category'] == 'green'),
      isTrue,
    );
  });

  test('tips can be separated into care and green living groups', () {
    final tips = greenTipsFor(const Locale('vi'));
    final careTips = tips.where((tip) => tip['category'] == 'care');
    final greenTips = tips.where((tip) => tip['category'] == 'green');

    expect(careTips, isNotEmpty);
    expect(greenTips, isNotEmpty);
    expect(careTips.length + greenTips.length, tips.length);
  });
}
