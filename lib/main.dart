import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/hestora_app.dart';
import 'app/providers/app_environment_provider.dart';
import 'core/auth/auth_initial_session.dart';
import 'core/config/app_environment.dart';
import 'core/config/env_bootstrap.dart';
import 'core/config/supabase_bootstrap.dart';
import 'core/utils/app_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await loadAppDotEnv();
  } catch (e, st) {
    appLog('dotenv load failed (.env asset missing or invalid)', e, st);
  }

  final env = AppEnvironment.fromEnv();
  try {
    await SupabaseBootstrap.initIfConfigured(env);
  } catch (e, st) {
    appLog('Supabase init failed', e, st);
  }
  try {
    await AuthInitialSession.consumeLaunchUriIfAny();
  } catch (e, st) {
    appLog('auth initial uri consume failed', e, st);
  }

  runApp(
    ProviderScope(
      overrides: [
        appEnvironmentProvider.overrideWithValue(env),
      ],
      child: const HestoraApp(),
    ),
  );
}
