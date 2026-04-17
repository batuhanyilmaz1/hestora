import '../../properties/domain/property.dart';

class ScoredProperty {
  const ScoredProperty({required this.property, required this.score});

  final Property property;
  final double score;
}
