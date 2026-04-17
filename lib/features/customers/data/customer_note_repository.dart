import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers/app_environment_provider.dart';
import '../../../core/config/supabase_bootstrap.dart';
import '../domain/customer_note.dart';

abstract class CustomerNoteRepository {
  bool get supportsRemote;

  Future<List<CustomerNote>> listForCustomer(String customerId);
  Future<void> insert({
    required String customerId,
    required String body,
  });
}

class StubCustomerNoteRepository implements CustomerNoteRepository {
  const StubCustomerNoteRepository();

  @override
  bool get supportsRemote => false;

  @override
  Future<List<CustomerNote>> listForCustomer(String customerId) async => const [];

  @override
  Future<void> insert({
    required String customerId,
    required String body,
  }) async {}
}

class SupabaseCustomerNoteRepository implements CustomerNoteRepository {
  SupabaseCustomerNoteRepository(this._client);

  final SupabaseClient _client;

  @override
  bool get supportsRemote => true;

  @override
  Future<List<CustomerNote>> listForCustomer(String customerId) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      return const [];
    }

    final rows = await _client
        .from('customer_notes')
        .select()
        .eq('customer_id', customerId)
        .eq('user_id', uid)
        .order('created_at', ascending: false);

    return (rows as List<dynamic>)
        .map((row) => CustomerNote.fromJson(Map<String, dynamic>.from(row as Map)))
        .toList();
  }

  @override
  Future<void> insert({
    required String customerId,
    required String body,
  }) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('Not signed in');
    }

    await _client.from('customer_notes').insert({
      'customer_id': customerId,
      'user_id': uid,
      'body': body,
    });
  }
}

final customerNoteRepositoryProvider = Provider<CustomerNoteRepository>((ref) {
  final env = ref.watch(appEnvironmentProvider);
  if (SupabaseBootstrap.isClientReady(env)) {
    return SupabaseCustomerNoteRepository(Supabase.instance.client);
  }
  return const StubCustomerNoteRepository();
});

final customerNotesProvider =
    FutureProvider.family<List<CustomerNote>, String>((ref, customerId) async {
  final repo = ref.watch(customerNoteRepositoryProvider);
  return repo.listForCustomer(customerId);
});
