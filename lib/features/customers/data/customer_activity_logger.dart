import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../matching/domain/scored_customer.dart';
import '../../matching/domain/scored_property.dart';
import '../domain/customer_activity.dart';
import 'customer_activity_repository.dart';

class CustomerActivityLogger {
  const CustomerActivityLogger(this._repository);

  final CustomerActivityRepository _repository;

  Future<void> logMatchedProperties({
    required String customerId,
    required Iterable<ScoredProperty> scoredProperties,
  }) async {
    if (!_repository.supportsRemote) {
      return;
    }

    final scored = scoredProperties
        .where((item) => item.property.id.trim().isNotEmpty)
        .toList(growable: false);
    if (scored.isEmpty) {
      return;
    }

    final existingIds = await _repository.findRelatedPropertyIds(
      customerId: customerId,
      type: CustomerActivityType.propertyMatched,
      propertyIds: scored.map((item) => item.property.id),
    );

    for (final item in scored) {
      if (existingIds.contains(item.property.id)) {
        continue;
      }

      await _repository.insert(
        customerId: customerId,
        type: CustomerActivityType.propertyMatched,
        body: item.property.title,
        relatedPropertyId: item.property.id,
        metadata: <String, dynamic>{'score': item.score},
      );
    }
  }

  Future<void> logMatchedCustomersForProperty({
    required String propertyId,
    required String propertyTitle,
    required Iterable<ScoredCustomer> scoredCustomers,
  }) async {
    if (!_repository.supportsRemote) {
      return;
    }

    for (final item in scoredCustomers) {
      final existingIds = await _repository.findRelatedPropertyIds(
        customerId: item.customer.id,
        type: CustomerActivityType.propertyMatched,
        propertyIds: <String>[propertyId],
      );
      if (existingIds.contains(propertyId)) {
        continue;
      }

      await _repository.insert(
        customerId: item.customer.id,
        type: CustomerActivityType.propertyMatched,
        body: propertyTitle,
        relatedPropertyId: propertyId,
        metadata: <String, dynamic>{'score': item.score},
      );
    }
  }

  Future<void> logPropertyShared({
    required String customerId,
    required String propertyId,
    required String propertyTitle,
    String? source,
  }) async {
    if (!_repository.supportsRemote) {
      return;
    }

    await _repository.insert(
      customerId: customerId,
      type: CustomerActivityType.propertyShared,
      body: propertyTitle,
      relatedPropertyId: propertyId,
      metadata: source == null ? null : <String, dynamic>{'source': source},
    );
  }
}

final customerActivityLoggerProvider = Provider<CustomerActivityLogger>((ref) {
  final repository = ref.watch(customerActivityRepositoryProvider);
  return CustomerActivityLogger(repository);
});
