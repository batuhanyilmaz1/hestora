import 'package:shared_preferences/shared_preferences.dart';

/// İlk açılış sırası: onboarding → kayıt ekranı → dil/bölge.
/// "Kayıt adımı" geçildi (kayıt başarılı veya girişe geçildi) olarak işaretlenir.
abstract final class FirstRunRegisterGatePrefs {
  static const String _k = 'first_run_register_gate_v1';

  static Future<bool> isPassed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_k) ?? false;
  }

  static Future<void> setPassed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_k, true);
  }
}
