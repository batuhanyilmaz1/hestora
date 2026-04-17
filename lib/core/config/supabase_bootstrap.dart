import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_environment.dart';

/// Initializes Supabase when credentials are present.
class SupabaseBootstrap {
  SupabaseBootstrap._();

  static Future<void> initIfConfigured(AppEnvironment env) async {
    if (!env.hasSupabaseCredentials) {
      return;
    }
    await Supabase.initialize(
      url: env.supabaseUrl.trim(),
      anonKey: env.supabaseAnonKey.trim(),
    );
  }

  static bool isClientReady(AppEnvironment env) {
    if (!env.hasSupabaseCredentials) {
      return false;
    }
    try {
      Supabase.instance.client;
      return true;
    } catch (_) {
      return false;
    }
  }
}
