import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_bootstrap.dart';
import 'app_environment_provider.dart';

/// Emits the signed-in Supabase user, or null when logged out / not configured.
final authSessionProvider = StreamProvider<User?>((ref) {
  final env = ref.watch(appEnvironmentProvider);
  if (!SupabaseBootstrap.isClientReady(env)) {
    return Stream<User?>.value(null);
  }
  return Supabase.instance.client.auth.onAuthStateChange.map(
    (event) => event.session?.user,
  );
});
