import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../customers/data/customer_repository.dart';
import '../../customers/domain/customer.dart';
import '../../properties/data/property_repository.dart';
import '../domain/match_engine.dart';
import '../domain/scored_customer.dart';
import '../domain/scored_property.dart';

final customerMatchesProvider =
    FutureProvider.family<List<ScoredProperty>, String>((ref, customerId) async {
  final customers = ref.watch(customerRepositoryProvider);
  final propsRepo = ref.watch(propertyRepositoryProvider);
  final c = await customers.getById(customerId);
  final props = await propsRepo.list();
  if (c == null) {
    return const [];
  }
  final list = props
      .map((p) => ScoredProperty(property: p, score: MatchEngine.score(c, p)))
      .where((s) => s.score > 0)
      .toList()
    ..sort((a, b) => b.score.compareTo(a.score));
  return list.take(24).toList();
});

final propertyMatchesProvider =
    FutureProvider.family<List<ScoredCustomer>, String>((ref, propertyId) async {
  final customersRepo = ref.watch(customerRepositoryProvider);
  final propsRepo = ref.watch(propertyRepositoryProvider);
  final p = await propsRepo.getById(propertyId);
  final customers = await customersRepo.list();
  if (p == null) {
    return const [];
  }
  final list = customers
      .map((c) => ScoredCustomer(customer: c, score: MatchEngine.score(c, p)))
      .where((s) => s.score > 0)
      .toList()
    ..sort((a, b) => b.score.compareTo(a.score));
  return list.take(24).toList();
});

/// Güçlü eşleşme (≥ [MatchEngine.strongMatchThreshold]) sayısı, tüm müşteri–ilan çiftleri.
final customersTotalStrongMatchesProvider = FutureProvider<int>((ref) async {
  final customers = await ref.read(customerRepositoryProvider).list();
  final props = await ref.read(propertyRepositoryProvider).list();
  var n = 0;
  for (final Customer c in customers) {
    for (final p in props) {
      final s = MatchEngine.score(c, p);
      if (MatchEngine.isStrong(s)) {
        n++;
      }
    }
  }
  return n;
});
