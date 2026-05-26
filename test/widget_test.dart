import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:picksy_flutter/core/theme/app_design_system.dart';
import 'package:picksy_flutter/features/onboarding/screens/nickname_avatar_screen.dart';
import 'package:picksy_flutter/features/welcome/screens/welcome_screen.dart';

void main() {
  void usePhoneViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('renders Picksy welcome screen', (WidgetTester tester) async {
    usePhoneViewport(tester);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(theme: AppTheme.dark, home: const WelcomeScreen()),
      ),
    );
    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });

  testWidgets('renders nickname and avatar screen', (
    WidgetTester tester,
  ) async {
    usePhoneViewport(tester);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const NicknameAvatarScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(NicknameAvatarScreen), findsOneWidget);
    expect(find.text("What's your\nvibe name? 😎"), findsOneWidget);
    expect(find.text("Let's Go"), findsOneWidget);
  });
}
