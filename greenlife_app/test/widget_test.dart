import 'package:flutter_test/flutter_test.dart';
import 'package:greenlife_app/app.dart';

void main() {
  testWidgets('GreenLife app loads with home screen content', (tester) async {
    await tester.pumpWidget(const GreenLifeApp());
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    expect(find.text('GreenLife'), findsWidgets);
    expect(find.text('Plant Care Assistant'), findsOneWidget);
  });
}