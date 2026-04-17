import '../../customers/domain/customer.dart';

class ScoredCustomer {
  const ScoredCustomer({required this.customer, required this.score});

  final Customer customer;
  final double score;
}
