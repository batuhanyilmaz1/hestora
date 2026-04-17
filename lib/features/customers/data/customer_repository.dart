import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers/app_environment_provider.dart';
import '../../../core/config/supabase_bootstrap.dart';
import '../domain/customer.dart';

abstract class CustomerRepository {
  bool get supportsRemote;

  Future<List<Customer>> list();
  Future<Customer?> getById(String id);
  Future<String> insert({
    required String name,
    String? phone,
    String? notes,
    String? email,
    String? listingIntent,
    String? preferredLocation,
    num? budgetMin,
    num? budgetMax,
    int? roomCount,
    num? areaMinSqm,
    num? areaMaxSqm,
    List<String>? tags,
  });

  Future<void> update({
    required String id,
    required String name,
    String? phone,
    String? notes,
    String? email,
    String? listingIntent,
    String? preferredLocation,
    num? budgetMin,
    num? budgetMax,
    int? roomCount,
    num? areaMinSqm,
    num? areaMaxSqm,
    List<String>? tags,
  });
}

class StubCustomerRepository implements CustomerRepository {
  const StubCustomerRepository();

  @override
  bool get supportsRemote => false;

  @override
  Future<List<Customer>> list() async => const [];

  @override
  Future<Customer?> getById(String id) async => null;

  @override
  Future<String> insert({
    required String name,
    String? phone,
    String? notes,
    String? email,
    String? listingIntent,
    String? preferredLocation,
    num? budgetMin,
    num? budgetMax,
    int? roomCount,
    num? areaMinSqm,
    num? areaMaxSqm,
    List<String>? tags,
  }) async => '';

  @override
  Future<void> update({
    required String id,
    required String name,
    String? phone,
    String? notes,
    String? email,
    String? listingIntent,
    String? preferredLocation,
    num? budgetMin,
    num? budgetMax,
    int? roomCount,
    num? areaMinSqm,
    num? areaMaxSqm,
    List<String>? tags,
  }) async {}
}

class SupabaseCustomerRepository implements CustomerRepository {
  SupabaseCustomerRepository(this._client);

  final SupabaseClient _client;

  @override
  bool get supportsRemote => true;

  @override
  Future<List<Customer>> list() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      return const [];
    }
    final rows = await _client
        .from('customers')
        .select()
        .eq('user_id', uid)
        .eq('archived', false)
        .order('created_at', ascending: false);
    return (rows as List<dynamic>)
        .map((e) => Customer.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<Customer?> getById(String id) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      return null;
    }
    final row = await _client
        .from('customers')
        .select()
        .eq('id', id)
        .eq('user_id', uid)
        .maybeSingle();
    if (row == null) {
      return null;
    }
    return Customer.fromJson(Map<String, dynamic>.from(row));
  }

  @override
  Future<String> insert({
    required String name,
    String? phone,
    String? notes,
    String? email,
    String? listingIntent,
    String? preferredLocation,
    num? budgetMin,
    num? budgetMax,
    int? roomCount,
    num? areaMinSqm,
    num? areaMaxSqm,
    List<String>? tags,
  }) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('Not signed in');
    }
    final row = await _client.from('customers').insert({
      'user_id': uid,
      'name': name,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
      if (email != null && email.isNotEmpty) 'email': email,
      if (listingIntent != null && listingIntent.isNotEmpty) 'listing_intent': listingIntent,
      if (preferredLocation != null && preferredLocation.isNotEmpty) 'preferred_location': preferredLocation,
      if (budgetMin != null) 'budget_min': budgetMin,
      if (budgetMax != null) 'budget_max': budgetMax,
      if (roomCount != null) 'room_count': roomCount,
      if (areaMinSqm != null) 'area_min_sqm': areaMinSqm,
      if (areaMaxSqm != null) 'area_max_sqm': areaMaxSqm,
      if (tags != null && tags.isNotEmpty) 'tags': tags,
    }).select('id').single();
    return Map<String, dynamic>.from(row)['id'] as String;
  }

  @override
  Future<void> update({
    required String id,
    required String name,
    String? phone,
    String? notes,
    String? email,
    String? listingIntent,
    String? preferredLocation,
    num? budgetMin,
    num? budgetMax,
    int? roomCount,
    num? areaMinSqm,
    num? areaMaxSqm,
    List<String>? tags,
  }) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('Not signed in');
    }
    await _client.from('customers').update({
      'name': name,
      'phone': (phone != null && phone.isNotEmpty) ? phone : null,
      'notes': (notes != null && notes.isNotEmpty) ? notes : null,
      'email': (email != null && email.isNotEmpty) ? email : null,
      'listing_intent': (listingIntent != null && listingIntent.isNotEmpty) ? listingIntent : null,
      'preferred_location': (preferredLocation != null && preferredLocation.isNotEmpty) ? preferredLocation : null,
      'budget_min': budgetMin,
      'budget_max': budgetMax,
      'room_count': roomCount,
      'area_min_sqm': areaMinSqm,
      'area_max_sqm': areaMaxSqm,
      if (tags != null) 'tags': tags,
    }).eq('id', id).eq('user_id', uid);
  }
}

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final env = ref.watch(appEnvironmentProvider);
  if (SupabaseBootstrap.isClientReady(env)) {
    return SupabaseCustomerRepository(Supabase.instance.client);
  }
  return const StubCustomerRepository();
});

final customersListProvider = FutureProvider<List<Customer>>((ref) async {
  final repo = ref.watch(customerRepositoryProvider);
  return repo.list();
});

final customerDetailProvider = FutureProvider.family<Customer?, String>((ref, id) async {
  final repo = ref.watch(customerRepositoryProvider);
  return repo.getById(id);
});
