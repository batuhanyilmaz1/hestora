import '../../../features/properties/domain/property.dart';

/// CRM-facing listing payload consumed by [DynamicListingTemplateView].
///
/// Values are mostly display-ready strings so templates stay independent of
/// locale and currency formatting (prepare those at the repository / UI layer).
class ListingData {
  const ListingData({
    required this.id,
    required this.title,
    required this.price,
    this.roomCount,
    this.area,
    this.location,
    this.phone,
    this.imageUrls = const [],
    this.logoUrl,
  });

  final String id;
  final String title;
  final String price;
  final int? roomCount;
  final String? area;
  final String? location;
  final String? phone;
  final List<String> imageUrls;
  final String? logoUrl;

  /// Maps the domain [Property] into a template-friendly row.
  ///
  /// [priceLine] and [areaLine] should already be localized / formatted.
  factory ListingData.fromProperty(
    Property property, {
    required String priceLine,
    String? areaLine,
    String? phone,
    String? logoUrl,
  }) {
    return ListingData(
      id: property.id,
      title: property.title,
      price: priceLine,
      roomCount: property.roomCount,
      area: areaLine,
      location: property.location,
      phone: phone,
      imageUrls: property.imageUrls,
      logoUrl: logoUrl,
    );
  }

  /// Stable sample for previews and tests.
  factory ListingData.mockSample() {
    return const ListingData(
      id: 'demo-listing',
      title: 'Sea-view duplex with private terrace',
      price: '12.500.000 TRY',
      roomCount: 4,
      area: '185 m²',
      location: 'Kadıköy, Istanbul',
      phone: '+90 555 000 00 00',
      imageUrls: ['https://picsum.photos/seed/hestora-template/800/600'],
      logoUrl: null,
    );
  }
}
