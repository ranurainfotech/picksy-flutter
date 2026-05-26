import 'package:flutter_test/flutter_test.dart';
import 'package:picksy_flutter/features/splash/screens/splash_screen.dart';

import 'package:picksy_flutter/main.dart';

void main() {
  testWidgets('renders Picksy splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const PicksyApp());
    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
