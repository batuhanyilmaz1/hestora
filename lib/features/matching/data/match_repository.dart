import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers/app_environment_provider.dart';
import '../../../core/config/supabase_bootstrap.dart';
import '../domain/scored_customer.dart';
import '../domain/scored_property.dart';

abstract class MatchRepository {
  bool get supportsRemote;

  /// Replaces stored matches for this customer with the given scores (top-N sync).
  Future<void> replaceForCustomer(
    String customerId,
    List<ScoredProperty> scored,
  );

  Future<void> replaceForProperty(
    String propertyId,
    List<ScoredCustomer> scored,
  );
}

class StubMatchRepository implements MatchRepository {
  const StubMatchRepository();

  @override
  bool get supportsRemote => false;

  @override
  Future<void> replaceForCustomer(
    String customerId,
    List<ScoredProperty> scored,
  ) async {}

  @override
  Future<void> replaceForProperty(
    String propertyId,
    List<ScoredCustomer> scored,
  ) async {}
}

class SupabaseMatchRepository implements MatchRepository {
  SupabaseMatchRepository(this._client);

  final SupabaseClient _client;

  @override
  bool get supportsRemote => true;

  @override
  Future<void> replaceForCustomer(
    String customerId,
    List<ScoredProperty> scored,
  ) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('Not signed in');
    }
    await _client.from('matches').delete().eq('customer_id', customerId).eq('user_id', uid);
    if (scored.isEmpty) {
      return;
    }
    final rows = scored
        .map(
          (s) => {
            'user_id': uid,
            'customer_id': customerId,
            'property_id': s.property.id,
            'score': s.score,
          },
        )
        .toList();
    await _client.from('matches').insert(rows);
  }

  @override
  Future<void> replaceForProperty(
    String propertyId,
    List<ScoredCustomer> scored,
  ) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('Not signed in');
    }
    await _client.from('matches').delete().eq('property_id', propertyId).eq('user_id', uid);
    if (scored.isEmpty) {
      return;
    }
    final rows = scored
        .map(
          (s) => {
            'user_id': uid,
            'customer_id': s.customer.id,
            'property_id': propertyId,
            'score': s.score,
          },
        )
        .toList();
    await _client.from('matches').insert(rows);
  }
}

final matchRepositoryProvider = Provider<MatchRepository>((ref) {
  final env = ref.watch(appEnvironmentProvider);
  if (SupabaseBootstrap.isClientReady(env)) {
    return SupabaseMatchRepository(Supabase.instance.client);
  }
  return const StubMatchRepository();
});
