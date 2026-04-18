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
    this.agentEmail,
    this.agentAvatarUrl,
    this.footerContactLine,
    this.qrPayload,
    this.websiteFallbackLine,
    this.description,
  });

  final String title;
  final String priceLine;
  final String featuresLine;
  final String listingTypeLabel;
  final String? locationLine;

  /// İlan oluştururken girilen açıklama (kartlarda birkaç satırla gösterilir).
  final String? description;
  final String? mainImageUrl;

  /// Full gallery from CRM (`property.imageUrls`). Slot 0 drives [mainImageUrl] when set.
  final List<String> listingImageUrls;

  final String? agentName;
  final String? agentPhone;

  /// Emlakçı e-postası (çoğunlukla oturum e-postasından doldurulur).
  final String? agentEmail;

  /// Agent / office avatar for themes that expose a circular logo slot.
  final String? agentAvatarUrl;

  /// Combined contact strip for templates that reserve a single footer line.
  final String? footerContactLine;

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
  ShareCardLayoutData copyWith({
    String? title,
    String? priceLine,
    String? featuresLine,
    String? listingTypeLabel,
    String? locationLine,
    String? mainImageUrl,
    List<String>? listingImageUrls,
    String? agentName,
    String? agentPhone,
    String? agentEmail,
    String? agentAvatarUrl,
    String? footerContactLine,
    String? qrPayload,
    String? websiteFallbackLine,
    String? description,
  }) {
    return ShareCardLayoutData(
      title: title ?? this.title,
      priceLine: priceLine ?? this.priceLine,
      featuresLine: featuresLine ?? this.featuresLine,
      listingTypeLabel: listingTypeLabel ?? this.listingTypeLabel,
      locationLine: locationLine ?? this.locationLine,
      mainImageUrl: mainImageUrl ?? this.mainImageUrl,
      listingImageUrls: listingImageUrls ?? this.listingImageUrls,
      agentName: agentName ?? this.agentName,
      agentPhone: agentPhone ?? this.agentPhone,
      agentEmail: agentEmail ?? this.agentEmail,
      agentAvatarUrl: agentAvatarUrl ?? this.agentAvatarUrl,
      footerContactLine: footerContactLine ?? this.footerContactLine,
      qrPayload: qrPayload ?? this.qrPayload,
      websiteFallbackLine: websiteFallbackLine ?? this.websiteFallbackLine,
      description: description ?? this.description,
    );
  }

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
    String? description,
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
      agentEmail: null,
      agentAvatarUrl: null,
      footerContactLine: null,
      qrPayload: (url != null && url.isNotEmpty) ? url : null,
      websiteFallbackLine: url,
      description: description,
    );
  }

  /// Sample listing for widget tests / local previews.
  factory ShareCardLayoutData.mockSample() {
    return const ShareCardLayoutData(
      title: 'Sea-view duplex with private terrace',
      priceLine: '12.500.000 TRY',
      featuresLine: 'Rooms 4+ · Baths 2 · 185 m²',
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
      agentEmail: 'agent@example.com',
      agentAvatarUrl: 'https://picsum.photos/seed/hestora-agent/200/200',
      footerContactLine: '+90 555 000 00 00 · example.com/listings/demo · agent@example.com',
      qrPayload: 'https://example.com/listings/demo',
      websiteFallbackLine: 'example.com/listings/demo',
      description:
          'Panoramic sea view, smart home wiring, two parking spaces. Walking distance to metro and marina.',
    );
  }
}
