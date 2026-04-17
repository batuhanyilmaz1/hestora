import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Runtime configuration from the project root `.env` file (bundled as a Flutter asset).
/// [loadAppDotEnv] must run before reading; [main] loads dotenv then builds [AppEnvironment.fromEnv].
enum AppFlavor {
  development,
  production,
}

class AppEnvironment {
  /// Used when `.env` / merge did not supply credentials (common release pitfall:
  /// empty `Platform.environment` entries shadowing `.env` — see [env_merge_io]).
  static const String fallbackSupabaseUrl = 'https://czrqokugjafpchiwqlys.supabase.co';
  static const String fallbackSupabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN6cnFva3VnamFmcGNoaXdxbHlzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzYyNjU3MTgsImV4cCI6MjA5MTg0MTcxOH0.qZ5Xe1gbKXeAgvSgKJMKE8ra9RDbKlSzRBlFcAtqbKU';

  AppEnvironment({
    required this.flavor,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    this.openAiApiKey = '',
  });

  final AppFlavor flavor;
  final String supabaseUrl;
  final String supabaseAnonKey;

  /// From `.env` key `OPENAI_API_KEY` (optional).
  final String openAiApiKey;

  bool get isDevelopment => flavor == AppFlavor.development;

  bool get hasOpenAiCredentials => openAiApiKey.trim().isNotEmpty;

  bool get hasSupabaseCredentials =>
      supabaseUrl.trim().isNotEmpty && supabaseAnonKey.trim().isNotEmpty;

  /// Base URL for Supabase Edge Functions (e.g. `https://xxxx.supabase.co/functions/v1`).
  String? get supabaseFunctionsV1Base {
    if (!hasSupabaseCredentials) {
      return null;
    }
    final u = Uri.parse(supabaseUrl.trim());
    return '${u.scheme}://${u.host}/functions/v1';
  }

  static String _read(String key, {String defaultValue = ''}) {
    try {
      final v = dotenv.env[key]?.trim();
      if (v != null && v.isNotEmpty) {
        return v;
      }
    } catch (_) {
      // dotenv not initialized
    }
    return defaultValue;
  }

  /// Reads keys from loaded dotenv: `APP_FLAVOR`, `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `OPENAI_API_KEY`.
  static AppEnvironment fromEnv() {
    final flavorRaw = _read('APP_FLAVOR', defaultValue: 'development');
    final flavor = flavorRaw == 'production'
        ? AppFlavor.production
        : AppFlavor.development;
    var supabaseUrl = _read('SUPABASE_URL');
    var supabaseAnonKey = _read('SUPABASE_ANON_KEY');
    final urlOk = _isPlausibleSupabaseUrl(supabaseUrl);
    if (supabaseUrl.trim().isEmpty || !urlOk) {
      supabaseUrl = fallbackSupabaseUrl;
    }
    if (supabaseAnonKey.trim().isEmpty) {
      supabaseAnonKey = fallbackSupabaseAnonKey;
    }
    return AppEnvironment(
      flavor: flavor,
      supabaseUrl: supabaseUrl,
      supabaseAnonKey: supabaseAnonKey,
      openAiApiKey: _read('OPENAI_API_KEY'),
    );
  }

  static bool _isPlausibleSupabaseUrl(String raw) {
    final u = Uri.tryParse(raw.trim());
    if (u == null || !u.hasScheme || u.host.isEmpty) {
      return false;
    }
    return u.host.contains('.') && (u.isScheme('https') || u.isScheme('http'));
  }
}
