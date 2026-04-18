import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers/app_environment_provider.dart';
import '../../../app/providers/auth_session_provider.dart';
import '../../../core/config/supabase_bootstrap.dart';
import '../../../core/storage/supabase_storage_paths.dart';

class ProfileRow {
  const ProfileRow({
    required this.id,
    this.displayName,
    this.avatarUrl,
    this.phone,
  });

  final String id;
  final String? displayName;
  final String? avatarUrl;
  final String? phone;

  factory ProfileRow.fromJson(Map<String, dynamic> json) {
    return ProfileRow(
      id: json['id'] as String,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      phone: json['phone'] as String?,
    );
  }
}

abstract class ProfileRepository {
  bool get supportsRemote;
  Future<ProfileRow?> fetchCurrent();
  Future<String> uploadAvatarAndSaveUrl(XFile file);
  Future<void> updateDisplayName(String displayName);
  Future<void> updateEmail(String email);
  Future<void> updatePhone(String phone);
}

class StubProfileRepository implements ProfileRepository {
  const StubProfileRepository();

  @override
  bool get supportsRemote => false;

  @override
  Future<ProfileRow?> fetchCurrent() async => null;

  @override
  Future<String> uploadAvatarAndSaveUrl(XFile file) async =>
      throw UnsupportedError('Supabase not configured');

  @override
  Future<void> updateDisplayName(String displayName) async =>
      throw UnsupportedError('Supabase not configured');

  @override
  Future<void> updateEmail(String email) async =>
      throw UnsupportedError('Supabase not configured');

  @override
  Future<void> updatePhone(String phone) async =>
      throw UnsupportedError('Supabase not configured');
}

class SupabaseProfileRepository implements ProfileRepository {
  SupabaseProfileRepository(this._client);

  final SupabaseClient _client;

  @override
  bool get supportsRemote => true;

  @override
  Future<ProfileRow?> fetchCurrent() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      return null;
    }
    final row = await _client.from('profiles').select().eq('id', uid).maybeSingle();
    if (row == null) {
      return null;
    }
    return ProfileRow.fromJson(Map<String, dynamic>.from(row));
  }

  @override
  Future<String> uploadAvatarAndSaveUrl(XFile file) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('Not signed in');
    }
    final bytes = await file.readAsBytes();
    final mime = lookupMimeType(file.path, headerBytes: bytes) ?? 'image/jpeg';
    final ext = mime.contains('png')
        ? 'png'
        : mime.contains('webp')
            ? 'webp'
            : 'jpg';
    final path = '$uid/avatar.$ext';
    await _client.storage.from(kBucketAvatars).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: mime, upsert: true),
        );
    final publicUrl = _client.storage.from(kBucketAvatars).getPublicUrl(path);
    await _client.from('profiles').update({'avatar_url': publicUrl}).eq('id', uid);
    return publicUrl;
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('Not signed in');
    }
    final v = displayName.trim();
    await _client.from('profiles').update({'display_name': v}).eq('id', uid);
    await _client.auth.updateUser(UserAttributes(data: <String, dynamic>{'full_name': v}));
  }

  @override
  Future<void> updateEmail(String email) async {
    final v = email.trim();
    if (v.isEmpty) {
      return;
    }
    await _client.auth.updateUser(UserAttributes(email: v));
  }

  @override
  Future<void> updatePhone(String phone) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('Not signed in');
    }
    final v = phone.trim();
    await _client.from('profiles').update({'phone': v.isEmpty ? null : v}).eq('id', uid);
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final env = ref.watch(appEnvironmentProvider);
  if (SupabaseBootstrap.isClientReady(env)) {
    return SupabaseProfileRepository(Supabase.instance.client);
  }
  return const StubProfileRepository();
});

final profileRowProvider = FutureProvider<ProfileRow?>((ref) async {
  final uid = ref.watch(currentAuthUserIdProvider);
  final repo = ref.watch(profileRepositoryProvider);
  if (!repo.supportsRemote || uid == null) {
    return null;
  }
  return repo.fetchCurrent();
});
