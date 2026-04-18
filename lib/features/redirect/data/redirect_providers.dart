import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/auth_session_provider.dart';
import 'redirect_repository.dart';
import '../domain/redirect_link.dart';

final redirectLinkForPropertyProvider =
    FutureProvider.family<RedirectLink?, String>((ref, propertyId) async {
  ref.watch(currentAuthUserIdProvider);
  final r = ref.watch(redirectRepositoryProvider);
  return r.findByPropertyId(propertyId);
});
