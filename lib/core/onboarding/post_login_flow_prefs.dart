import 'package:shared_preferences/shared_preferences.dart';

/// Kayıt sonrası ilk giriş: dil/bölge/para → paket → özet akışı (cihaz yerel).
abstract final class PostLoginFlowPrefs {
  static const String _kRequired = 'post_login_setup_required_v1';
  static const String _kRegional = 'post_login_regional_done_v1';
  static const String _kBilling = 'post_login_billing_done_v1';

  static Future<bool> isSetupRequired() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kRequired) ?? false;
  }

  /// Yeni hesap kaydından sonra [LoginPage] öncesi çağrılır.
  static Future<void> startPostLoginForNewAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kRequired, true);
    await prefs.setBool(_kRegional, false);
    await prefs.setBool(_kBilling, false);
  }

  static Future<bool> isRegionalDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kRegional) ?? false;
  }

  static Future<void> setRegionalDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kRegional, true);
  }

  static Future<bool> isBillingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kBilling) ?? false;
  }

  static Future<void> setBillingDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kBilling, true);
  }

  /// Ödeme özeti tamamlandığında, akış zorunluysa tüm bayrakları kapatır.
  static Future<void> markPostLoginFullyComplete() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(_kRequired) ?? false)) {
      return;
    }
    await prefs.setBool(_kRequired, false);
    await prefs.setBool(_kRegional, true);
    await prefs.setBool(_kBilling, true);
  }
}
