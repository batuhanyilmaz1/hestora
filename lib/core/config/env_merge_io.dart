import 'dart:io';

/// Keys merged from [Platform.environment] are parsed **before** `.env` in
/// `flutter_dotenv`, and the parser keeps the **first** value per key (`putIfAbsent`).
/// So any platform entry for the same key would **prevent** `.env` from applying.
/// We drop empty values (common CI noise) and omit app secrets so `.env` stays authoritative.
const _keysExcludedFromPlatformMerge = {
  'SUPABASE_URL',
  'SUPABASE_ANON_KEY',
  'OPENAI_API_KEY',
};

Map<String, String> platformEnvironmentForDotenv() {
  final out = <String, String>{};
  for (final e in Platform.environment.entries) {
    if (e.value.trim().isEmpty) {
      continue;
    }
    if (_keysExcludedFromPlatformMerge.contains(e.key)) {
      continue;
    }
    out[e.key] = e.value;
  }
  return out;
}
