import 'package:shared_preferences/shared_preferences.dart';

/// Yerel bildirim tercihleri (ileride FCM / backend ile eşlenebilir).
abstract final class NotificationPrefs {
  static const _master = 'profile_notify_master';
  static const _matches = 'profile_notify_matches';
  static const _tasks = 'profile_notify_tasks';
  static const _reminders = 'profile_notify_reminders';
  static const _system = 'profile_notify_system';
  static const _marketing = 'profile_notify_marketing';

  static Future<bool> getMaster() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_master) ?? true;
  }

  static Future<void> setMaster(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_master, v);
  }

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

  static Future<bool> getReminders() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_reminders) ?? true;
  }

  static Future<void> setReminders(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_reminders, v);
  }

  static Future<bool> getSystem() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_system) ?? true;
  }

  static Future<void> setSystem(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_system, v);
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
