class Property {
  const Property({
    required this.id,
    required this.title,
    this.description,
    required this.listingType,
    required this.active,
    this.price,
    this.currency,
    this.location,
    this.listingUrl,
    this.shareClickCount = 0,
    this.roomCount,
    this.bathroomCount,
    this.areaSqm,
    this.imageUrls = const [],
  });

  final String id;
  final String title;
  final String? description;
  /// `sale` or `rent` (matches DB `listing_type`).
  final String listingType;
  final bool active;
  final num? price;
  final String? currency;
  final String? location;
  final String? listingUrl;
  final int shareClickCount;
  final int? roomCount;
  final int? bathroomCount;
  final num? areaSqm;
  /// Public URLs from `property_media` + Storage.
  final List<String> imageUrls;

  factory Property.fromJson(
    Map<String, dynamic> json, {
    List<String> imageUrls = const [],
  }) {
    return Property(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      listingType: (json['listing_type'] as String?) ?? 'sale',
      active: json['active'] as bool? ?? true,
      price: json['price'] as num?,
      currency: json['currency'] as String?,
      location: json['location'] as String?,
      listingUrl: json['listing_url'] as String?,
      shareClickCount: json['share_click_count'] as int? ?? 0,
      roomCount: json['room_count'] as int?,
      bathroomCount: json['bathroom_count'] as int?,
      areaSqm: json['area_sqm'] as num?,
      imageUrls: imageUrls,
    );
  }
}
