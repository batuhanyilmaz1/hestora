class Customer {
  const Customer({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.notes,
    this.tags = const [],
    this.listingIntent,
    this.preferredLocation,
    this.budgetMin,
    this.budgetMax,
    this.roomCount,
    this.areaMinSqm,
    this.areaMaxSqm,
  });

  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String? notes;
  final List<String> tags;
  final String? listingIntent;
  final String? preferredLocation;
  final num? budgetMin;
  final num? budgetMax;
  final int? roomCount;
  final num? areaMinSqm;
  final num? areaMaxSqm;

  factory Customer.fromJson(Map<String, dynamic> json) {
    List<String> parseTags(dynamic v) {
      if (v == null) {
        return const [];
      }
      if (v is List) {
        return v.map((e) => e.toString()).toList();
      }
      return const [];
    }

    return Customer(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      notes: json['notes'] as String?,
      tags: parseTags(json['tags']),
      listingIntent: json['listing_intent'] as String?,
      preferredLocation: json['preferred_location'] as String?,
      budgetMin: json['budget_min'] as num?,
      budgetMax: json['budget_max'] as num?,
      roomCount: json['room_count'] as int?,
      areaMinSqm: json['area_min_sqm'] as num?,
      areaMaxSqm: json['area_max_sqm'] as num?,
    );
  }
}
