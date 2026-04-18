import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../app/providers/app_environment_provider.dart';
import '../../../app/providers/auth_session_provider.dart';
import '../../../core/config/supabase_bootstrap.dart';
import '../../../core/storage/supabase_storage_paths.dart';
import '../domain/property.dart';

abstract class PropertyRepository {
  bool get supportsRemote;

  Future<List<Property>> list();
  Future<Property?> getById(String id);
  Future<void> insert({
    required String title,
    required String listingType,
    String? location,
    num? price,
    String? description,
    String? listingUrl,
    int? roomCount,
    int? bathroomCount,
    num? areaSqm,
    List<XFile> images,
  });

  Future<void> update({
    required String id,
    required String title,
    required String listingType,
    String? location,
    num? price,
    String? description,
    String? listingUrl,
    int? roomCount,
    int? bathroomCount,
    num? areaSqm,
    List<XFile> newImages,
  });

  Future<void> markAsSold(String id);
}

class StubPropertyRepository implements PropertyRepository {
  const StubPropertyRepository();

  @override
  bool get supportsRemote => false;

  @override
  Future<List<Property>> list() async => const [];

  @override
  Future<Property?> getById(String id) async => null;

  @override
  Future<void> insert({
    required String title,
    required String listingType,
    String? location,
    num? price,
    String? description,
    String? listingUrl,
    int? roomCount,
    int? bathroomCount,
    num? areaSqm,
    List<XFile> images = const [],
  }) async {}

  @override
  Future<void> update({
    required String id,
    required String title,
    required String listingType,
    String? location,
    num? price,
    String? description,
    String? listingUrl,
    int? roomCount,
    int? bathroomCount,
    num? areaSqm,
    List<XFile> newImages = const [],
  }) async {}

  @override
  Future<void> markAsSold(String id) async {}
}

class SupabasePropertyRepository implements PropertyRepository {
  SupabasePropertyRepository(this._client);

  final SupabaseClient _client;
  static const _uuid = Uuid();

  @override
  bool get supportsRemote => true;

  List<String> _imageUrlsFromRow(Map<String, dynamic> json) {
    final media = json['property_media'];
    if (media is! List || media.isEmpty) {
      return const [];
    }
    final rows = media.map((e) => Map<String, dynamic>.from(e as Map)).toList()
      ..sort((a, b) => ((a['sort_order'] as num?)?.toInt() ?? 0)
          .compareTo((b['sort_order'] as num?)?.toInt() ?? 0));
    return rows.map((m) {
      final path = m['storage_path'] as String;
      return _client.storage.from(kBucketPropertyImages).getPublicUrl(path);
    }).toList();
  }

  Map<String, dynamic> _stripMedia(Map<String, dynamic> json) {
    final copy = Map<String, dynamic>.from(json);
    copy.remove('property_media');
    return copy;
  }

  @override
  Future<List<Property>> list() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      return const [];
    }
    final rows = await _client
        .from('properties')
        .select('*, property_media(*)')
        .eq('user_id', uid)
        .order('created_at', ascending: false);
    return (rows as List<dynamic>).map((e) {
      final m = Map<String, dynamic>.from(e as Map);
      return Property.fromJson(
        _stripMedia(m),
        imageUrls: _imageUrlsFromRow(m),
      );
    }).toList();
  }

  @override
  Future<Property?> getById(String id) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      return null;
    }
    final row = await _client
        .from('properties')
        .select('*, property_media(*)')
        .eq('id', id)
        .eq('user_id', uid)
        .maybeSingle();
    if (row == null) {
      return null;
    }
    final m = Map<String, dynamic>.from(row);
    return Property.fromJson(
      _stripMedia(m),
      imageUrls: _imageUrlsFromRow(m),
    );
  }

  Future<void> _uploadPropertyImages(String propertyId, List<XFile> files) async {
    if (files.isEmpty) {
      return;
    }
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('Not signed in');
    }
    for (var i = 0; i < files.length; i++) {
      final file = files[i];
      final bytes = await file.readAsBytes();
      final mimeType = lookupMimeType(file.path, headerBytes: bytes) ?? 'image/jpeg';
      final ext = mimeType.contains('png')
          ? 'png'
          : mimeType.contains('webp')
              ? 'webp'
              : 'jpg';
      final path = '$uid/$propertyId/${_uuid.v4()}.$ext';
      await _client.storage.from(kBucketPropertyImages).uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(contentType: mimeType, upsert: false),
          );
      await _client.from('property_media').insert({
        'property_id': propertyId,
        'storage_path': path,
        'sort_order': i,
      });
    }
  }

  @override
  Future<void> insert({
    required String title,
    required String listingType,
    String? location,
    num? price,
    String? description,
    String? listingUrl,
    int? roomCount,
    int? bathroomCount,
    num? areaSqm,
    List<XFile> images = const [],
  }) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('Not signed in');
    }
    final row = await _client.from('properties').insert({
      'user_id': uid,
      'title': title,
      'listing_type': listingType,
      if (location != null && location.isNotEmpty) 'location': location,
      if (price != null) 'price': price,
      if (description != null && description.isNotEmpty) 'description': description,
      if (listingUrl != null && listingUrl.isNotEmpty) 'listing_url': listingUrl,
      if (roomCount != null) 'room_count': roomCount,
      if (bathroomCount != null) 'bathroom_count': bathroomCount,
      if (areaSqm != null) 'area_sqm': areaSqm,
    }).select('id').single();
    final id = row['id'] as String;
    await _uploadPropertyImages(id, images);
  }

  @override
  Future<void> update({
    required String id,
    required String title,
    required String listingType,
    String? location,
    num? price,
    String? description,
    String? listingUrl,
    int? roomCount,
    int? bathroomCount,
    num? areaSqm,
    List<XFile> newImages = const [],
  }) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('Not signed in');
    }
    await _client.from('properties').update({
      'title': title,
      'listing_type': listingType,
      'location': (location != null && location.isNotEmpty) ? location : null,
      'price': price,
      'description': (description != null && description.isNotEmpty) ? description : null,
      'listing_url': (listingUrl != null && listingUrl.isNotEmpty) ? listingUrl : null,
      'room_count': roomCount,
      'bathroom_count': bathroomCount,
      'area_sqm': areaSqm,
    }).eq('id', id).eq('user_id', uid);
    await _uploadPropertyImages(id, newImages);
  }

  @override
  Future<void> markAsSold(String id) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('Not signed in');
    }
    await _client.from('properties').update({'active': false}).eq('id', id).eq('user_id', uid);
  }
}

final propertyRepositoryProvider = Provider<PropertyRepository>((ref) {
  final env = ref.watch(appEnvironmentProvider);
  if (SupabaseBootstrap.isClientReady(env)) {
    return SupabasePropertyRepository(Supabase.instance.client);
  }
  return const StubPropertyRepository();
});

final propertiesListProvider = FutureProvider<List<Property>>((ref) async {
  ref.watch(currentAuthUserIdProvider);
  final repo = ref.watch(propertyRepositoryProvider);
  return repo.list();
});

final propertyDetailProvider = FutureProvider.family<Property?, String>((ref, id) async {
  ref.watch(currentAuthUserIdProvider);
  final repo = ref.watch(propertyRepositoryProvider);
  return repo.getById(id);
});
