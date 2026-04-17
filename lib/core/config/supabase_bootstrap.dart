import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_environment.dart';

/// Initializes Supabase when credentials are present.
class SupabaseBootstrap {
  SupabaseBootstrap._();

  static Future<void> initIfConfigured(AppEnvironment env) async {
    final supabaseUrl = env.supabaseUrl.trim();
    final supabaseKey = env.supabaseAnonKey.trim();
    // ignore: avoid_print
    print('SUPABASE_URL: [$supabaseUrl]');
    // ignore: avoid_print
    print('SUPABASE_KEY_EMPTY: ${supabaseKey.isEmpty}');

    if (!env.hasSupabaseCredentials) {
      return;
    }

    try {
      final res = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 8));
      // ignore: avoid_print
      print('NETWORK_PROBE_GOOGLE: status=${res.statusCode}');
    } catch (e) {
      // ignore: avoid_print
      print('NETWORK_PROBE_GOOGLE_FAILED: $e');
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
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
