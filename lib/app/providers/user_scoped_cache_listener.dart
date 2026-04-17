import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_session_provider.dart';
import 'invalidate_user_scoped_caches.dart';

/// When [authSessionProvider]'s user id changes (login, logout, account switch),
/// drop all cached lists/details so the next user never sees the previous tenant's data.
class UserScopedCacheListener extends ConsumerStatefulWidget {
  const UserScopedCacheListener({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<UserScopedCacheListener> createState() => _UserScopedCacheListenerState();
}

class _UserScopedCacheListenerState extends ConsumerState<UserScopedCacheListener> {
  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<User?>>(authSessionProvider, (prev, next) {
      final prevId = prev?.valueOrNull?.id;
      final nextId = next.valueOrNull?.id;
      if (prevId == nextId) {
        return;
      }
      invalidateUserScopedCaches(ref);
    });
    return widget.child;
  }
}
