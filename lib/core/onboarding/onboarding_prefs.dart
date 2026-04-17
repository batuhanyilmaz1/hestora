import 'package:shared_preferences/shared_preferences.dart';

/// Persists first-run onboarding completion.
abstract final class OnboardingPrefs {
  static const String storageKey = 'onboarding_complete_v1';

  static Future<bool> isComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(storageKey) ?? false;
  }

  static Future<void> setComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(storageKey, true);
  }
}
