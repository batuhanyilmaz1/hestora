import 'package:shared_preferences/shared_preferences.dart';

/// İlk açılış: onboarding ve kayıt adımından sonra dil / bölge / para birimi.
abstract final class InitialSetupPrefs {
  static const String storageKey = 'initial_locale_setup_v1';

  static Future<bool> isComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(storageKey) ?? false;
  }

  static Future<void> setComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(storageKey, true);
  }
}
