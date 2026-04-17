import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../app/providers/app_environment_provider.dart';
import '../../../core/config/supabase_bootstrap.dart';
import '../domain/redirect_link.dart';

abstract class RedirectRepository {
  bool get supportsRemote;

  Future<RedirectLink?> findByPropertyId(String propertyId);
  Future<RedirectLink> createOrGet({
    required String propertyId,
    required String targetUrl,
  });
}

class StubRedirectRepository implements RedirectRepository {
  const StubRedirectRepository();

  @override
  bool get supportsRemote => false;

  @override
  Future<RedirectLink?> findByPropertyId(String propertyId) async => null;

  @override
  Future<RedirectLink> createOrGet({
    required String propertyId,
    required String targetUrl,
  }) async {
    throw UnsupportedError('Supabase required');
  }
}

class SupabaseRedirectRepository implements RedirectRepository {
  SupabaseRedirectRepository(this._client);

  final SupabaseClient _client;
  static const _uuid = Uuid();

  @override
  bool get supportsRemote => true;

  @override
  Future<RedirectLink?> findByPropertyId(String propertyId) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      return null;
    }
    final row = await _client
        .from('redirect_links')
        .select()
        .eq('property_id', propertyId)
        .eq('user_id', uid)
        .maybeSingle();
    if (row == null) {
      return null;
    }
    return RedirectLink.fromJson(Map<String, dynamic>.from(row));
  }

  @override
  Future<RedirectLink> createOrGet({
    required String propertyId,
    required String targetUrl,
  }) async {
    final existing = await findByPropertyId(propertyId);
    if (existing != null) {
      return existing;
    }
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('Not signed in');
    }
    final shortCode = _uuid.v4().replaceAll('-', '').substring(0, 10);
    final row = await _client
        .from('redirect_links')
        .insert({
          'user_id': uid,
          'property_id': propertyId,
          'short_code': shortCode,
          'target_url': targetUrl,
        })
        .select()
        .single();
    return RedirectLink.fromJson(Map<String, dynamic>.from(row));
  }
}

final redirectRepositoryProvider = Provider<RedirectRepository>((ref) {
  final env = ref.watch(appEnvironmentProvider);
  if (SupabaseBootstrap.isClientReady(env)) {
    return SupabaseRedirectRepository(Supabase.instance.client);
  }
  return const StubRedirectRepository();
});
