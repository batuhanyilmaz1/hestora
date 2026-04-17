import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Runtime configuration from the project root `.env` file (bundled as a Flutter asset).
/// [loadAppDotEnv] must run before reading; [main] loads dotenv then builds [AppEnvironment.fromEnv].
enum AppFlavor {
  development,
  production,
}

class AppEnvironment {
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
    return AppEnvironment(
      flavor: flavor,
      supabaseUrl: _read('SUPABASE_URL'),
      supabaseAnonKey: _read('SUPABASE_ANON_KEY'),
      openAiApiKey: _read('OPENAI_API_KEY'),
    );
  }
}
