import '../../domain/property.dart';

/// Everything the template renderer needs besides the theme definition.
class ShareCardLayoutData {
  const ShareCardLayoutData({
    required this.title,
    required this.priceLine,
    required this.featuresLine,
    required this.listingTypeLabel,
    this.locationLine,
    this.mainImageUrl,
    this.listingImageUrls = const [],
    this.agentName,
    this.agentPhone,
    this.qrPayload,
    this.websiteFallbackLine,
  });

  final String title;
  final String priceLine;
  final String featuresLine;
  final String listingTypeLabel;
  final String? locationLine;
  final String? mainImageUrl;

  /// Full gallery from CRM (`property.imageUrls`). Slot 0 drives [mainImageUrl] when set.
  final List<String> listingImageUrls;

  final String? agentName;
  final String? agentPhone;

  /// When non-empty, [ShareCardThemeSlot.websiteOrQr] shows a QR code.
  final String? qrPayload;

  /// Shown in the website/QR slot when [qrPayload] is null or empty.
  final String? websiteFallbackLine;

  /// Primary listing photo for the main slot (backward compatible with [mainImageUrl]).
  String? get effectiveMainImageUrl {
    final u = mainImageUrl?.trim();
    if (u != null && u.isNotEmpty) {
      return u;
    }
    final all = normalizedListingImageUrls;
    return all.isEmpty ? null : all.first;
  }

  /// Non-empty URLs in gallery order (for [ShareCardThemeSlot.galleryImage1]…).
  List<String> get normalizedListingImageUrls {
    if (listingImageUrls.isNotEmpty) {
      return listingImageUrls.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
    final u = mainImageUrl?.trim();
    if (u != null && u.isNotEmpty) {
      return [u];
    }
    return const [];
  }

  factory ShareCardLayoutData.fromProperty(
    Property property, {
    required String priceLine,
    required String featuresLine,
    required String listingTypeLabel,
    String? agentName,
    String? agentPhone,
  }) {
    final url = property.listingUrl?.trim();
    return ShareCardLayoutData(
      title: property.title,
      priceLine: priceLine,
      featuresLine: featuresLine,
      listingTypeLabel: listingTypeLabel,
      locationLine: property.location,
      mainImageUrl: property.imageUrls.isNotEmpty ? property.imageUrls.first : null,
      listingImageUrls: List<String>.from(property.imageUrls),
      agentName: agentName,
      agentPhone: agentPhone,
      qrPayload: (url != null && url.isNotEmpty) ? url : null,
      websiteFallbackLine: url,
    );
  }

  /// Sample listing for widget tests / local previews.
  factory ShareCardLayoutData.mockSample() {
    return const ShareCardLayoutData(
      title: 'Sea-view duplex with private terrace',
      priceLine: '12.500.000 TRY',
      featuresLine: '4+1 · 2 bath · 185 m²',
      listingTypeLabel: 'Sale',
      locationLine: 'Kadıköy, Istanbul',
      mainImageUrl: 'https://picsum.photos/seed/hestora-share/800/600',
      listingImageUrls: [
        'https://picsum.photos/seed/hestora-share/800/600',
        'https://picsum.photos/seed/hestora-g2/480/480',
        'https://picsum.photos/seed/hestora-g3/480/480',
        'https://picsum.photos/seed/hestora-g4/480/480',
      ],
      agentName: 'Demo Agent',
      agentPhone: '+90 555 000 00 00',
      qrPayload: 'https://example.com/listings/demo',
      websiteFallbackLine: 'example.com/listings/demo',
    );
  }
}
