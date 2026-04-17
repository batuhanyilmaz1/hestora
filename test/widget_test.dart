import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hestora/app/hestora_app.dart';
import 'package:hestora/core/onboarding/onboarding_prefs.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('HestoraApp boots with router', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      OnboardingPrefs.storageKey: true,
    });

    await tester.pumpWidget(const ProviderScope(child: HestoraApp()));
    await tester.pump();
    await tester.pump(const Duration(seconds: 5));

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
