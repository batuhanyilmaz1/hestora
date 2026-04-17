import 'package:flutter/material.dart';

import 'share_card_main_image_config.dart';
import 'share_card_region.dart';
import 'share_card_theme_slot.dart';
import 'share_card_watermark_style.dart';

/// Declarative layout for one share-card theme. Add new entries to [shareCardThemes].
class ShareCardThemeDefinition {
  const ShareCardThemeDefinition({
    required this.id,
    required this.label,
    required this.assetPath,
    required this.designWidth,
    required this.designHeight,
    required this.safeHorizontalFraction,
    required this.safeVerticalFraction,
    required this.regions,
    required this.mainImage,
    this.logoAssetPath = 'assets/logo/LOGO.svg',
    this.titleColor = const Color(0xFFFFFFFF),
    this.subtitleColor = const Color(0xFFE2E8F0),
    this.priceColor = const Color(0xFF38BDF8),
    this.accentColor = const Color(0xFFF59E0B),
    this.mainImageCornerRadiusFraction = 0.02,
    this.textShadows = false,
    this.watermarkStyle = ShareCardWatermarkStyle.none,
    this.agentTitleColor,
    this.agentPhoneColor,
  });

  /// Stable key for prefs / analytics.
  final String id;
  final String label;

  /// PNG (or raster) background under dynamic overlays.
  final String assetPath;

  /// Reference pixel size the [regions] were authored against (for font scaling).
  final double designWidth;
  final double designHeight;

  /// Safe area as a fraction of card width (applied left + right).
  final double safeHorizontalFraction;

  /// Safe area as a fraction of card height (applied top + bottom).
  final double safeVerticalFraction;

  /// Placements for overlays; omit a slot by not including it in the map.
  final Map<ShareCardThemeSlot, ShareCardRegion> regions;

  /// Listing photo: rect override, [BoxFit], default alignment / focal.
  final ShareCardMainImageConfig mainImage;

  /// Shown in the [ShareCardThemeSlot.logo] region when present.
  final String? logoAssetPath;

  final Color titleColor;
  final Color subtitleColor;
  final Color priceColor;
  final Color accentColor;

  /// Corner radius for the main listing photo, as a fraction of card shortest side.
  final double mainImageCornerRadiusFraction;

  /// Soft shadow behind overlay text for busy / high-contrast templates (e.g. photos).
  final bool textShadows;

  /// Optional HESTORA watermark on blank / default templates.
  final ShareCardWatermarkStyle watermarkStyle;

  /// Overrides [titleColor] for [ShareCardThemeSlot.agentName] when set.
  final Color? agentTitleColor;

  /// Overrides [subtitleColor] for [ShareCardThemeSlot.agentPhone] when set.
  final Color? agentPhoneColor;

  double get aspectRatio => designWidth / designHeight;

  EdgeInsets paddingFor(Size cardSize) => EdgeInsets.symmetric(
        horizontal: cardSize.width * safeHorizontalFraction,
        vertical: cardSize.height * safeVerticalFraction,
      );

  ShareCardRegion? region(ShareCardThemeSlot slot) => regions[slot];
}
