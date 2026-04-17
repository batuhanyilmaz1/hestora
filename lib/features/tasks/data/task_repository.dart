import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers/app_environment_provider.dart';
import '../../../core/config/supabase_bootstrap.dart';
import '../domain/hestora_task.dart';

abstract class TaskRepository {
  bool get supportsRemote;

  Future<List<HestoraTask>> list();
  Future<HestoraTask?> getById(String id);
  Future<void> insert({
    required String title,
    String? body,
    DateTime? dueAt,
    String priority = 'normal',
    String status = 'open',
    String? customerId,
    String? propertyId,
  });
  Future<void> update({
    required String id,
    required String title,
    String? body,
    DateTime? dueAt,
    required String priority,
    required String status,
    String? customerId,
    String? propertyId,
  });
  Future<void> updateStatus({
    required String id,
    required String status,
  });
}

class StubTaskRepository implements TaskRepository {
  const StubTaskRepository();

  @override
  bool get supportsRemote => false;

  @override
  Future<HestoraTask?> getById(String id) async => null;

  @override
  Future<List<HestoraTask>> list() async => const [];

  @override
  Future<void> insert({
    required String title,
    String? body,
    DateTime? dueAt,
    String priority = 'normal',
    String status = 'open',
    String? customerId,
    String? propertyId,
  }) async {}

  @override
  Future<void> update({
    required String id,
    required String title,
    String? body,
    DateTime? dueAt,
    required String priority,
    required String status,
    String? customerId,
    String? propertyId,
  }) async {}

  @override
  Future<void> updateStatus({
    required String id,
    required String status,
  }) async {}
}

class SupabaseTaskRepository implements TaskRepository {
  SupabaseTaskRepository(this._client);

  final SupabaseClient _client;

  @override
  bool get supportsRemote => true;

  @override
  Future<List<HestoraTask>> list() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      return const [];
    }
    final rows = await _client
        .from('tasks')
        .select()
        .eq('user_id', uid)
        .eq('archived', false)
        .order('created_at', ascending: false);
    return (rows as List<dynamic>)
        .map((row) => HestoraTask.fromJson(Map<String, dynamic>.from(row as Map)))
        .toList();
  }

  @override
  Future<HestoraTask?> getById(String id) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      return null;
    }

    final row = await _client
        .from('tasks')
        .select()
        .eq('id', id)
        .eq('user_id', uid)
        .maybeSingle();
    if (row == null) {
      return null;
    }

    return HestoraTask.fromJson(Map<String, dynamic>.from(row));
  }

  @override
  Future<void> insert({
    required String title,
    String? body,
    DateTime? dueAt,
    String priority = 'normal',
    String status = 'open',
    String? customerId,
    String? propertyId,
  }) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('Not signed in');
    }
    await _client.from('tasks').insert({
      'user_id': uid,
      'title': title,
      'body': body?.isNotEmpty == true ? body : null,
      'due_at': dueAt?.toUtc().toIso8601String(),
      'priority': priority,
      'status': status,
      'customer_id': customerId?.isNotEmpty == true ? customerId : null,
      'property_id': propertyId?.isNotEmpty == true ? propertyId : null,
    });
  }

  @override
  Future<void> update({
    required String id,
    required String title,
    String? body,
    DateTime? dueAt,
    required String priority,
    required String status,
    String? customerId,
    String? propertyId,
  }) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('Not signed in');
    }
    await _client.from('tasks').update({
      'title': title,
      'body': body?.isNotEmpty == true ? body : null,
      'due_at': dueAt?.toUtc().toIso8601String(),
      'priority': priority,
      'status': status,
      'customer_id': customerId?.isNotEmpty == true ? customerId : null,
      'property_id': propertyId?.isNotEmpty == true ? propertyId : null,
    }).eq('id', id).eq('user_id', uid);
  }

  @override
  Future<void> updateStatus({
    required String id,
    required String status,
  }) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('Not signed in');
    }
    await _client.from('tasks').update({'status': status}).eq('id', id).eq('user_id', uid);
  }
}

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final env = ref.watch(appEnvironmentProvider);
  if (SupabaseBootstrap.isClientReady(env)) {
    return SupabaseTaskRepository(Supabase.instance.client);
  }
  return const StubTaskRepository();
});

final tasksListProvider = FutureProvider<List<HestoraTask>>((ref) async {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.list();
});

final taskDetailProvider = FutureProvider.family<HestoraTask?, String>((ref, id) async {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getById(id);
});
