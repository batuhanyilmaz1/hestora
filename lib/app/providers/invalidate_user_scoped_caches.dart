import 'package:flutter_riverpod/flutter_riverpod.dart' show WidgetRef;

import '../../features/customers/data/customer_activity_repository.dart';
import '../../features/customers/data/customer_note_repository.dart';
import '../../features/customers/data/customer_repository.dart';
import '../../features/matching/data/match_providers.dart';
import '../../features/profile/data/profile_repository.dart';
import '../../features/properties/data/property_repository.dart';
import '../../features/redirect/data/redirect_providers.dart';
import '../../features/tasks/data/task_repository.dart';

/// Clears cached user data when the signed-in account changes or logs out.
/// Riverpod [FutureProvider]s keep the previous user's results until invalidated.
void invalidateUserScopedCaches(WidgetRef ref) {
  ref.invalidate(propertiesListProvider);
  ref.invalidate(propertyDetailProvider);
  ref.invalidate(customersListProvider);
  ref.invalidate(customerDetailProvider);
  ref.invalidate(customerActivitiesProvider);
  ref.invalidate(customerNotesProvider);
  ref.invalidate(tasksListProvider);
  ref.invalidate(taskDetailProvider);
  ref.invalidate(profileRowProvider);
  ref.invalidate(redirectLinkForPropertyProvider);
  ref.invalidate(customerMatchesProvider);
  ref.invalidate(propertyMatchesProvider);
  ref.invalidate(customersTotalStrongMatchesProvider);
}
