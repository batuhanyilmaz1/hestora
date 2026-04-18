import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers/app_environment_provider.dart';
import '../../../app/providers/auth_session_provider.dart';
import '../../../core/config/supabase_bootstrap.dart';
import '../domain/customer_activity.dart';

abstract class CustomerActivityRepository {
  bool get supportsRemote;

  Future<List<CustomerActivity>> listForCustomer(String customerId);
  Future<void> insert({
    required String customerId,
    required CustomerActivityType type,
    String? body,
    String? relatedTaskId,
    String? relatedPropertyId,
    Map<String, dynamic>? metadata,
  });

  Future<Set<String>> findRelatedPropertyIds({
    required String customerId,
    required CustomerActivityType type,
    required Iterable<String> propertyIds,
  });
}

class StubCustomerActivityRepository implements CustomerActivityRepository {
  const StubCustomerActivityRepository();

  @override
  bool get supportsRemote => false;

  @override
  Future<Set<String>> findRelatedPropertyIds({
    required String customerId,
    required CustomerActivityType type,
    required Iterable<String> propertyIds,
  }) async => <String>{};

  @override
  Future<void> insert({
    required String customerId,
    required CustomerActivityType type,
    String? body,
    String? relatedTaskId,
    String? relatedPropertyId,
    Map<String, dynamic>? metadata,
  }) async {}

  @override
  Future<List<CustomerActivity>> listForCustomer(String customerId) async => const [];
}

class SupabaseCustomerActivityRepository implements CustomerActivityRepository {
  SupabaseCustomerActivityRepository(this._client);

  final SupabaseClient _client;

  @override
  bool get supportsRemote => true;

  @override
  Future<List<CustomerActivity>> listForCustomer(String customerId) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      return const [];
    }

    final rows = await _client
        .from('customer_activities')
        .select()
        .eq('customer_id', customerId)
        .eq('user_id', uid)
        .order('created_at', ascending: false);

    return (rows as List<dynamic>)
        .map((row) => CustomerActivity.fromJson(Map<String, dynamic>.from(row as Map)))
        .toList();
  }

  @override
  Future<void> insert({
    required String customerId,
    required CustomerActivityType type,
    String? body,
    String? relatedTaskId,
    String? relatedPropertyId,
    Map<String, dynamic>? metadata,
  }) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('Not signed in');
    }

    await _client.from('customer_activities').insert({
      'customer_id': customerId,
      'user_id': uid,
      'type': type.value,
      if (body != null && body.trim().isNotEmpty) 'body': body.trim(),
      if (relatedTaskId != null && relatedTaskId.isNotEmpty) 'related_task_id': relatedTaskId,
      if (relatedPropertyId != null && relatedPropertyId.isNotEmpty)
        'related_property_id': relatedPropertyId,
      if (metadata != null && metadata.isNotEmpty) 'metadata': metadata,
    });
  }

  @override
  Future<Set<String>> findRelatedPropertyIds({
    required String customerId,
    required CustomerActivityType type,
    required Iterable<String> propertyIds,
  }) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      return <String>{};
    }

    final ids = propertyIds.where((id) => id.trim().isNotEmpty).toSet();
    if (ids.isEmpty) {
      return <String>{};
    }

    final rows = await _client
        .from('customer_activities')
        .select('related_property_id')
        .eq('customer_id', customerId)
        .eq('user_id', uid)
        .eq('type', type.value)
        .inFilter('related_property_id', ids.toList());

    return (rows as List<dynamic>)
        .map((row) => Map<String, dynamic>.from(row as Map)['related_property_id'] as String?)
        .whereType<String>()
        .toSet();
  }
}

final customerActivityRepositoryProvider = Provider<CustomerActivityRepository>((ref) {
  final env = ref.watch(appEnvironmentProvider);
  if (SupabaseBootstrap.isClientReady(env)) {
    return SupabaseCustomerActivityRepository(Supabase.instance.client);
  }
  return const StubCustomerActivityRepository();
});

final customerActivitiesProvider =
    FutureProvider.family<List<CustomerActivity>, String>((ref, customerId) async {
  ref.watch(currentAuthUserIdProvider);
  final repo = ref.watch(customerActivityRepositoryProvider);
  return repo.listForCustomer(customerId);
});
