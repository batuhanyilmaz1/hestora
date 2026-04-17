import 'package:shared_preferences/shared_preferences.dart';

/// Local notification toggles (product: later wire to FCM / Supabase).
abstract final class NotificationPrefs {
  static const _matches = 'profile_notify_matches';
  static const _tasks = 'profile_notify_tasks';
  static const _marketing = 'profile_notify_marketing';

  static Future<bool> getMatches() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_matches) ?? true;
  }

  static Future<void> setMatches(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_matches, v);
  }

  static Future<bool> getTasks() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_tasks) ?? true;
  }

  static Future<void> setTasks(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_tasks, v);
  }

  static Future<bool> getMarketing() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_marketing) ?? false;
  }

  static Future<void> setMarketing(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_marketing, v);
  }
}
