import 'package:flutter/material.dart';

import 'models/share_card_main_image_config.dart';
import 'models/share_card_region.dart';
import 'models/share_card_theme_definition.dart';
import 'models/share_card_theme_slot.dart';
import 'models/share_card_watermark_style.dart';
import 'share_card_theme_presets.dart';

ShareCardThemeDefinition _t(
  String id,
  String label,
  String assetPath,
  double designWidth,
  double designHeight,
  Map<ShareCardThemeSlot, ShareCardRegion> regions,
  ShareCardMainImageConfig mainImage, {
  double safeHorizontalFraction = 0.045,
  double safeVerticalFraction = 0.028,
  bool textShadows = false,
  double mainImageCornerRadiusFraction = 0.02,
  ShareCardWatermarkStyle watermarkStyle = ShareCardWatermarkStyle.none,
  Color? titleColor,
  Color? subtitleColor,
  Color? priceColor,
  Color? accentColor,
  Color? agentTitleColor,
  Color? agentPhoneColor,
}) {
  return ShareCardThemeDefinition(
    id: id,
    label: label,
    assetPath: assetPath,
    designWidth: designWidth,
    designHeight: designHeight,
    safeHorizontalFraction: safeHorizontalFraction,
    safeVerticalFraction: safeVerticalFraction,
    regions: cloneRegions(regions),
    mainImage: mainImage,
    mainImageCornerRadiusFraction: mainImageCornerRadiusFraction,
    textShadows: textShadows,
    watermarkStyle: watermarkStyle,
    titleColor: titleColor ?? const Color(0xFFFFFFFF),
    subtitleColor: subtitleColor ?? const Color(0xFFE2E8F0),
    priceColor: priceColor ?? const Color(0xFF38BDF8),
    accentColor: accentColor ?? const Color(0xFFF59E0B),
    agentTitleColor: agentTitleColor,
    agentPhoneColor: agentPhoneColor,
  );
}

/// Central registry: `assets/themes` raster backgrounds + slot geometry.
final List<ShareCardThemeDefinition> shareCardThemes = [
  _t('theme_01', 'Tema 1', 'assets/themes/theme1.png', 1080, 1920, kShareCardRegionsStoryLike, kShareCardMainImageStory,
      safeVerticalFraction: 0.028),
  _t('theme_02', 'Tema 2', 'assets/themes/theme2.jpg', 1080, 1080, kShareCardRegionsSquareSplitNavyLeft,
      kShareCardMainImageSquareSplitRight,
      safeVerticalFraction: 0.04,
      mainImageCornerRadiusFraction: 0.045),
  _t('theme_03', 'Tema 3', 'assets/themes/theme3.jpg', 1080, 1350, kShareCardRegionsStoryLike, kShareCardMainImageStory,
      safeVerticalFraction: 0.032),
  _t('theme_04', 'Tema 4', 'assets/themes/theme4.jpg', 1080, 1080, kShareCardRegionsSquarePhotoLeftCopyRight,
      kShareCardMainImageSquareEditorialLeft,
      safeVerticalFraction: 0.04),
  _t(
    'theme_05',
    'Tema 5',
    'assets/themes/theme5.jpg',
    1080,
    1920,
    kShareCardRegionsStoryFiveGallery,
    kShareCardMainImageStoryFiveHero,
    safeVerticalFraction: 0.028,
    textShadows: true,
    titleColor: const Color(0xFF0F172A),
    subtitleColor: const Color(0xFF475569),
    priceColor: const Color(0xFF0369A1),
    accentColor: const Color(0xFFC2410C),
    agentTitleColor: const Color(0xFFFFFFFF),
    agentPhoneColor: const Color(0xFFE2E8F0),
  ),
  _t('theme_06', 'Tema 6', 'assets/themes/theme6.jpg', 1414, 2000, kShareCardRegionsStoryLike, kShareCardMainImageStory,
      safeVerticalFraction: 0.028),
  _t('theme_07', 'Tema 7', 'assets/themes/theme7.jpg', 1080, 1080, kShareCardRegionsSquareLowerBand,
      kShareCardMainImageSquareLowerHero,
      safeVerticalFraction: 0.04,
      textShadows: true),
  _t('theme_08', 'Tema 8', 'assets/themes/theme8.jpg', 1080, 1080, kShareCardRegionsSquareWood,
      kShareCardMainImageSquareWoodHero,
      safeVerticalFraction: 0.04,
      textShadows: true),
  _t('theme_09', 'Tema 9', 'assets/themes/theme9.jpg', 1080, 1080, kShareCardRegionsSquareMagazineStripe,
      kShareCardMainImageSquareMagazineRail,
      safeVerticalFraction: 0.04,
      textShadows: true),
  _t('theme_10', 'Tema 10', 'assets/themes/theme10.jpg', 1080, 1080, kShareCardRegionsSquarePoolMontage,
      kShareCardMainImageSquarePoolHero,
      safeVerticalFraction: 0.04,
      textShadows: true),
  _t('theme_11', 'Tema 11', 'assets/themes/theme11.jpg', 2000, 1414,
      kShareCardRegionsLandscapeCopyLeftImageRight, kShareCardMainImageLandscapeRightCollage,
      safeHorizontalFraction: 0.04, safeVerticalFraction: 0.045),
  _t('theme_12', 'Tema 12', 'assets/themes/theme12.jpg', 1414, 2000, kShareCardRegionsStoryLike, kShareCardMainImageStory,
      safeVerticalFraction: 0.028),
  _t('theme_13', 'Tema 13', 'assets/themes/theme13.jpg', 1414, 2000, kShareCardRegionsStoryLike, kShareCardMainImageStory,
      safeVerticalFraction: 0.028),
  _t('theme_14', 'Tema 14', 'assets/themes/theme14.jpg', 1080, 1350, kShareCardRegionsStoryLike, kShareCardMainImageStory,
      safeVerticalFraction: 0.032),
  _t('theme_15', 'Tema 15', 'assets/themes/theme15.jpg', 1080, 1350, kShareCardRegionsStoryLike, kShareCardMainImageStory,
      safeVerticalFraction: 0.032),
  _t('hestora_story_default', 'Örnek — Hikaye', 'assets/themes/hestora_story_default.png', 1080, 1920, kShareCardRegionsStoryLike,
      kShareCardMainImageStory,
      safeVerticalFraction: 0.028,
      watermarkStyle: ShareCardWatermarkStyle.light),
  _t('hestora_square_default', 'Örnek — Kare', 'assets/themes/hestora_square_default.png', 1080, 1080, kShareCardRegionsSquare,
      kShareCardMainImageSquare,
      safeVerticalFraction: 0.04,
      watermarkStyle: ShareCardWatermarkStyle.light),
];

ShareCardThemeDefinition shareCardThemeById(String id) {
  return shareCardThemes.firstWhere((t) => t.id == id, orElse: () => shareCardThemes.first);
}
