import 'package:flutter/material.dart';

import 'models/share_card_main_image_config.dart';
import 'models/share_card_region.dart';
import 'models/share_card_theme_slot.dart';

/// Dikey şablonlar: hafif üst bias (cephe / gökyüzü).
const ShareCardMainImageConfig kShareCardMainImageStory = ShareCardMainImageConfig(
  fit: BoxFit.cover,
  alignment: Alignment(0, -0.18),
);

/// Kare şablonlar: hafif üst bias.
const ShareCardMainImageConfig kShareCardMainImageSquare = ShareCardMainImageConfig(
  fit: BoxFit.cover,
  alignment: Alignment(0, -0.12),
);

/// Yatay şablon: ilanı sol “pencere”de tut, hafif içe kaydır.
const ShareCardMainImageConfig kShareCardMainImageLandscape = ShareCardMainImageConfig(
  fit: BoxFit.cover,
  alignment: Alignment(-0.22, 0),
);

/// [theme5.jpg]: üstte geniş hero + sağda üç küçük görsel (CRM’deki 2–4. fotoğraflar).
final Map<ShareCardThemeSlot, ShareCardRegion> kShareCardRegionsStoryFiveGallery = {
  ShareCardThemeSlot.logo: const ShareCardRegion(left: 0.72, top: 0.02, width: 0.26, height: 0.05),
  ShareCardThemeSlot.mainImage: const ShareCardRegion(left: 0.0, top: 0.06, width: 0.70, height: 0.42),
  ShareCardThemeSlot.galleryImage1: const ShareCardRegion(left: 0.725, top: 0.09, width: 0.255, height: 0.11),
  ShareCardThemeSlot.galleryImage2: const ShareCardRegion(left: 0.725, top: 0.215, width: 0.255, height: 0.11),
  ShareCardThemeSlot.galleryImage3: const ShareCardRegion(left: 0.725, top: 0.34, width: 0.255, height: 0.11),
  ShareCardThemeSlot.listingType: const ShareCardRegion(left: 0, top: 0.485, width: 0.32, height: 0.035),
  ShareCardThemeSlot.title: const ShareCardRegion(left: 0, top: 0.52, width: 0.68, height: 0.12),
  ShareCardThemeSlot.price: const ShareCardRegion(left: 0, top: 0.64, width: 0.62, height: 0.065),
  ShareCardThemeSlot.features: const ShareCardRegion(left: 0, top: 0.705, width: 0.68, height: 0.065),
  ShareCardThemeSlot.location: const ShareCardRegion(left: 0, top: 0.765, width: 0.68, height: 0.055),
  ShareCardThemeSlot.agentName: const ShareCardRegion(left: 0, top: 0.84, width: 0.60, height: 0.045),
  ShareCardThemeSlot.agentPhone: const ShareCardRegion(left: 0, top: 0.885, width: 0.60, height: 0.04),
  ShareCardThemeSlot.websiteOrQr: const ShareCardRegion(left: 0.72, top: 0.82, width: 0.26, height: 0.145),
};

const ShareCardMainImageConfig kShareCardMainImageStoryFiveHero = ShareCardMainImageConfig(
  area: ShareCardRegion(left: 0.0, top: 0.06, width: 0.70, height: 0.42),
  fit: BoxFit.cover,
  alignment: Alignment(0, -0.1),
  borderRadiusFraction: 0.028,
);

/// Normalized slots for tall portrait backgrounds (~9:16 or 4:5).
final Map<ShareCardThemeSlot, ShareCardRegion> kShareCardRegionsStoryLike = {
  ShareCardThemeSlot.logo: const ShareCardRegion(left: 0.72, top: 0.02, width: 0.26, height: 0.05),
  ShareCardThemeSlot.mainImage: const ShareCardRegion(left: 0, top: 0.08, width: 1, height: 0.38),
  ShareCardThemeSlot.listingType: const ShareCardRegion(left: 0, top: 0.475, width: 0.28, height: 0.035),
  ShareCardThemeSlot.title: const ShareCardRegion(left: 0, top: 0.515, width: 1, height: 0.14),
  ShareCardThemeSlot.price: const ShareCardRegion(left: 0, top: 0.655, width: 0.62, height: 0.065),
  ShareCardThemeSlot.features: const ShareCardRegion(left: 0, top: 0.72, width: 1, height: 0.07),
  ShareCardThemeSlot.location: const ShareCardRegion(left: 0, top: 0.785, width: 1, height: 0.06),
  ShareCardThemeSlot.agentName: const ShareCardRegion(left: 0, top: 0.86, width: 0.62, height: 0.045),
  ShareCardThemeSlot.agentPhone: const ShareCardRegion(left: 0, top: 0.905, width: 0.62, height: 0.04),
  ShareCardThemeSlot.websiteOrQr: const ShareCardRegion(left: 0.74, top: 0.84, width: 0.24, height: 0.135),
};

/// Normalized slots for square 1:1 backgrounds.
final Map<ShareCardThemeSlot, ShareCardRegion> kShareCardRegionsSquare = {
  ShareCardThemeSlot.logo: const ShareCardRegion(left: 0.72, top: 0.02, width: 0.26, height: 0.085),
  ShareCardThemeSlot.mainImage: const ShareCardRegion(left: 0, top: 0.1, width: 1, height: 0.42),
  ShareCardThemeSlot.listingType: const ShareCardRegion(left: 0, top: 0.535, width: 0.3, height: 0.055),
  ShareCardThemeSlot.title: const ShareCardRegion(left: 0, top: 0.58, width: 1, height: 0.14),
  ShareCardThemeSlot.price: const ShareCardRegion(left: 0, top: 0.72, width: 0.55, height: 0.07),
  ShareCardThemeSlot.features: const ShareCardRegion(left: 0, top: 0.78, width: 1, height: 0.065),
  ShareCardThemeSlot.location: const ShareCardRegion(left: 0, top: 0.84, width: 0.68, height: 0.055),
  ShareCardThemeSlot.agentName: const ShareCardRegion(left: 0, top: 0.895, width: 0.68, height: 0.045),
  ShareCardThemeSlot.agentPhone: const ShareCardRegion(left: 0, top: 0.935, width: 0.68, height: 0.04),
  ShareCardThemeSlot.websiteOrQr: const ShareCardRegion(left: 0.72, top: 0.82, width: 0.26, height: 0.15),
};

/// Normalized slots for wide landscape backgrounds (image left, copy right).
final Map<ShareCardThemeSlot, ShareCardRegion> kShareCardRegionsLandscape = {
  ShareCardThemeSlot.logo: const ShareCardRegion(left: 0.03, top: 0.04, width: 0.2, height: 0.11),
  ShareCardThemeSlot.mainImage: const ShareCardRegion(left: 0.03, top: 0.17, width: 0.44, height: 0.68),
  ShareCardThemeSlot.listingType: const ShareCardRegion(left: 0.52, top: 0.17, width: 0.22, height: 0.07),
  ShareCardThemeSlot.title: const ShareCardRegion(left: 0.52, top: 0.24, width: 0.45, height: 0.2),
  ShareCardThemeSlot.price: const ShareCardRegion(left: 0.52, top: 0.44, width: 0.45, height: 0.09),
  ShareCardThemeSlot.features: const ShareCardRegion(left: 0.52, top: 0.52, width: 0.45, height: 0.09),
  ShareCardThemeSlot.location: const ShareCardRegion(left: 0.52, top: 0.61, width: 0.45, height: 0.09),
  ShareCardThemeSlot.agentName: const ShareCardRegion(left: 0.52, top: 0.74, width: 0.3, height: 0.08),
  ShareCardThemeSlot.agentPhone: const ShareCardRegion(left: 0.52, top: 0.83, width: 0.3, height: 0.07),
  ShareCardThemeSlot.websiteOrQr: const ShareCardRegion(left: 0.84, top: 0.72, width: 0.13, height: 0.2),
};

// --- Per-artwork square layouts (avoid one generic grid on every 1:1 PNG) ---

/// [theme2.jpg]: navy copy column on the left, photo + QR on the right.
final Map<ShareCardThemeSlot, ShareCardRegion> kShareCardRegionsSquareSplitNavyLeft = {
  ShareCardThemeSlot.logo: const ShareCardRegion(left: 0.02, top: 0.02, width: 0.30, height: 0.075),
  ShareCardThemeSlot.mainImage: const ShareCardRegion(left: 0.36, top: 0.09, width: 0.61, height: 0.50),
  ShareCardThemeSlot.listingType: const ShareCardRegion(left: 0.0, top: 0.10, width: 0.34, height: 0.045),
  ShareCardThemeSlot.title: const ShareCardRegion(left: 0.0, top: 0.15, width: 0.36, height: 0.16),
  ShareCardThemeSlot.price: const ShareCardRegion(left: 0.0, top: 0.31, width: 0.36, height: 0.065),
  ShareCardThemeSlot.features: const ShareCardRegion(left: 0.0, top: 0.38, width: 0.36, height: 0.075),
  ShareCardThemeSlot.location: const ShareCardRegion(left: 0.0, top: 0.46, width: 0.36, height: 0.065),
  ShareCardThemeSlot.agentName: const ShareCardRegion(left: 0.0, top: 0.56, width: 0.36, height: 0.045),
  ShareCardThemeSlot.agentPhone: const ShareCardRegion(left: 0.0, top: 0.61, width: 0.36, height: 0.04),
  ShareCardThemeSlot.websiteOrQr: const ShareCardRegion(left: 0.70, top: 0.76, width: 0.28, height: 0.18),
};

const ShareCardMainImageConfig kShareCardMainImageSquareSplitRight = ShareCardMainImageConfig(
  area: ShareCardRegion(left: 0.36, top: 0.09, width: 0.61, height: 0.50),
  fit: BoxFit.cover,
  alignment: Alignment.center,
  borderRadiusFraction: 0.055,
);

/// [theme4.jpg]: large photo window on the left, typography on the charcoal panel.
final Map<ShareCardThemeSlot, ShareCardRegion> kShareCardRegionsSquarePhotoLeftCopyRight = {
  ShareCardThemeSlot.logo: const ShareCardRegion(left: 0.52, top: 0.03, width: 0.22, height: 0.09),
  ShareCardThemeSlot.mainImage: const ShareCardRegion(left: 0.0, top: 0.10, width: 0.48, height: 0.58),
  ShareCardThemeSlot.listingType: const ShareCardRegion(left: 0.52, top: 0.12, width: 0.44, height: 0.055),
  ShareCardThemeSlot.title: const ShareCardRegion(left: 0.50, top: 0.18, width: 0.48, height: 0.16),
  ShareCardThemeSlot.price: const ShareCardRegion(left: 0.50, top: 0.34, width: 0.44, height: 0.07),
  ShareCardThemeSlot.features: const ShareCardRegion(left: 0.50, top: 0.41, width: 0.48, height: 0.075),
  ShareCardThemeSlot.location: const ShareCardRegion(left: 0.50, top: 0.49, width: 0.48, height: 0.065),
  ShareCardThemeSlot.agentName: const ShareCardRegion(left: 0.50, top: 0.60, width: 0.40, height: 0.045),
  ShareCardThemeSlot.agentPhone: const ShareCardRegion(left: 0.50, top: 0.65, width: 0.40, height: 0.04),
  ShareCardThemeSlot.websiteOrQr: const ShareCardRegion(left: 0.74, top: 0.78, width: 0.24, height: 0.17),
};

const ShareCardMainImageConfig kShareCardMainImageSquareEditorialLeft = ShareCardMainImageConfig(
  area: ShareCardRegion(left: 0.0, top: 0.10, width: 0.48, height: 0.58),
  fit: BoxFit.cover,
  alignment: Alignment.centerLeft,
  borderRadiusFraction: 0.045,
);

/// [theme7.jpg]: keep hero image compact; park dense copy in a lower band.
final Map<ShareCardThemeSlot, ShareCardRegion> kShareCardRegionsSquareLowerBand = {
  ShareCardThemeSlot.logo: const ShareCardRegion(left: 0.70, top: 0.02, width: 0.26, height: 0.085),
  ShareCardThemeSlot.mainImage: const ShareCardRegion(left: 0.0, top: 0.06, width: 1.0, height: 0.36),
  ShareCardThemeSlot.listingType: const ShareCardRegion(left: 0.0, top: 0.425, width: 0.30, height: 0.045),
  ShareCardThemeSlot.title: const ShareCardRegion(left: 0.0, top: 0.465, width: 1.0, height: 0.12),
  ShareCardThemeSlot.price: const ShareCardRegion(left: 0.0, top: 0.585, width: 0.55, height: 0.065),
  ShareCardThemeSlot.features: const ShareCardRegion(left: 0.0, top: 0.645, width: 1.0, height: 0.065),
  ShareCardThemeSlot.location: const ShareCardRegion(left: 0.0, top: 0.705, width: 0.70, height: 0.055),
  ShareCardThemeSlot.agentName: const ShareCardRegion(left: 0.0, top: 0.775, width: 0.65, height: 0.045),
  ShareCardThemeSlot.agentPhone: const ShareCardRegion(left: 0.0, top: 0.82, width: 0.65, height: 0.04),
  ShareCardThemeSlot.websiteOrQr: const ShareCardRegion(left: 0.72, top: 0.78, width: 0.26, height: 0.18),
};

const ShareCardMainImageConfig kShareCardMainImageSquareLowerHero = ShareCardMainImageConfig(
  area: ShareCardRegion(left: 0.0, top: 0.06, width: 1.0, height: 0.36),
  fit: BoxFit.cover,
  alignment: Alignment(0, -0.12),
  borderRadiusFraction: 0.03,
);

/// [theme8.jpg]: large circular hero on the left, copy on the right / lower band.
final Map<ShareCardThemeSlot, ShareCardRegion> kShareCardRegionsSquareWood = {
  ShareCardThemeSlot.logo: const ShareCardRegion(left: 0.68, top: 0.03, width: 0.28, height: 0.085),
  ShareCardThemeSlot.mainImage: const ShareCardRegion(left: 0.02, top: 0.06, width: 0.56, height: 0.48),
  ShareCardThemeSlot.listingType: const ShareCardRegion(left: 0.62, top: 0.08, width: 0.35, height: 0.05),
  ShareCardThemeSlot.title: const ShareCardRegion(left: 0.58, top: 0.13, width: 0.40, height: 0.14),
  ShareCardThemeSlot.price: const ShareCardRegion(left: 0.58, top: 0.27, width: 0.40, height: 0.07),
  ShareCardThemeSlot.features: const ShareCardRegion(left: 0.58, top: 0.34, width: 0.40, height: 0.065),
  ShareCardThemeSlot.location: const ShareCardRegion(left: 0.04, top: 0.56, width: 0.58, height: 0.065),
  ShareCardThemeSlot.agentName: const ShareCardRegion(left: 0.04, top: 0.63, width: 0.52, height: 0.045),
  ShareCardThemeSlot.agentPhone: const ShareCardRegion(left: 0.04, top: 0.68, width: 0.52, height: 0.04),
  ShareCardThemeSlot.websiteOrQr: const ShareCardRegion(left: 0.72, top: 0.80, width: 0.26, height: 0.16),
};

const ShareCardMainImageConfig kShareCardMainImageSquareWoodHero = ShareCardMainImageConfig(
  area: ShareCardRegion(left: 0.02, top: 0.06, width: 0.56, height: 0.48),
  fit: BoxFit.cover,
  alignment: Alignment.topCenter,
  borderRadiusFraction: 0.22,
);

/// [theme9.jpg]: narrow gallery rail + dominant right column.
final Map<ShareCardThemeSlot, ShareCardRegion> kShareCardRegionsSquareMagazineStripe = {
  ShareCardThemeSlot.logo: const ShareCardRegion(left: 0.02, top: 0.04, width: 0.22, height: 0.08),
  ShareCardThemeSlot.mainImage: const ShareCardRegion(left: 0.03, top: 0.12, width: 0.30, height: 0.38),
  ShareCardThemeSlot.listingType: const ShareCardRegion(left: 0.36, top: 0.10, width: 0.30, height: 0.055),
  ShareCardThemeSlot.title: const ShareCardRegion(left: 0.36, top: 0.16, width: 0.60, height: 0.16),
  ShareCardThemeSlot.price: const ShareCardRegion(left: 0.36, top: 0.30, width: 0.60, height: 0.07),
  ShareCardThemeSlot.features: const ShareCardRegion(left: 0.36, top: 0.37, width: 0.60, height: 0.075),
  ShareCardThemeSlot.location: const ShareCardRegion(left: 0.36, top: 0.45, width: 0.58, height: 0.065),
  ShareCardThemeSlot.agentName: const ShareCardRegion(left: 0.36, top: 0.54, width: 0.50, height: 0.045),
  ShareCardThemeSlot.agentPhone: const ShareCardRegion(left: 0.36, top: 0.59, width: 0.50, height: 0.04),
  ShareCardThemeSlot.websiteOrQr: const ShareCardRegion(left: 0.72, top: 0.72, width: 0.24, height: 0.18),
};

const ShareCardMainImageConfig kShareCardMainImageSquareMagazineRail = ShareCardMainImageConfig(
  area: ShareCardRegion(left: 0.03, top: 0.12, width: 0.30, height: 0.38),
  fit: BoxFit.cover,
  alignment: Alignment.center,
  borderRadiusFraction: 0.5,
);

/// [theme10.jpg]: hero window top-right, details across lower montage.
final Map<ShareCardThemeSlot, ShareCardRegion> kShareCardRegionsSquarePoolMontage = {
  ShareCardThemeSlot.logo: const ShareCardRegion(left: 0.02, top: 0.04, width: 0.20, height: 0.08),
  ShareCardThemeSlot.mainImage: const ShareCardRegion(left: 0.48, top: 0.06, width: 0.50, height: 0.42),
  ShareCardThemeSlot.listingType: const ShareCardRegion(left: 0.04, top: 0.14, width: 0.42, height: 0.05),
  ShareCardThemeSlot.title: const ShareCardRegion(left: 0.04, top: 0.28, width: 0.50, height: 0.12),
  ShareCardThemeSlot.price: const ShareCardRegion(left: 0.04, top: 0.40, width: 0.48, height: 0.065),
  ShareCardThemeSlot.features: const ShareCardRegion(left: 0.52, top: 0.52, width: 0.44, height: 0.075),
  ShareCardThemeSlot.location: const ShareCardRegion(left: 0.04, top: 0.50, width: 0.44, height: 0.055),
  ShareCardThemeSlot.agentName: const ShareCardRegion(left: 0.04, top: 0.68, width: 0.44, height: 0.045),
  ShareCardThemeSlot.agentPhone: const ShareCardRegion(left: 0.04, top: 0.73, width: 0.44, height: 0.04),
  ShareCardThemeSlot.websiteOrQr: const ShareCardRegion(left: 0.78, top: 0.84, width: 0.18, height: 0.12),
};

const ShareCardMainImageConfig kShareCardMainImageSquarePoolHero = ShareCardMainImageConfig(
  area: ShareCardRegion(left: 0.48, top: 0.06, width: 0.50, height: 0.42),
  fit: BoxFit.cover,
  alignment: Alignment.topCenter,
  borderRadiusFraction: 0.05,
);

/// [theme11.jpg]: copy on the left white panel, collage on the right.
final Map<ShareCardThemeSlot, ShareCardRegion> kShareCardRegionsLandscapeCopyLeftImageRight = {
  ShareCardThemeSlot.logo: const ShareCardRegion(left: 0.04, top: 0.05, width: 0.18, height: 0.12),
  ShareCardThemeSlot.mainImage: const ShareCardRegion(left: 0.42, top: 0.10, width: 0.54, height: 0.72),
  ShareCardThemeSlot.listingType: const ShareCardRegion(left: 0.06, top: 0.14, width: 0.30, height: 0.07),
  ShareCardThemeSlot.title: const ShareCardRegion(left: 0.06, top: 0.22, width: 0.34, height: 0.20),
  ShareCardThemeSlot.price: const ShareCardRegion(left: 0.06, top: 0.42, width: 0.34, height: 0.09),
  ShareCardThemeSlot.features: const ShareCardRegion(left: 0.06, top: 0.50, width: 0.34, height: 0.09),
  ShareCardThemeSlot.location: const ShareCardRegion(left: 0.06, top: 0.59, width: 0.34, height: 0.09),
  ShareCardThemeSlot.agentName: const ShareCardRegion(left: 0.06, top: 0.72, width: 0.32, height: 0.08),
  ShareCardThemeSlot.agentPhone: const ShareCardRegion(left: 0.06, top: 0.81, width: 0.32, height: 0.07),
  ShareCardThemeSlot.websiteOrQr: const ShareCardRegion(left: 0.22, top: 0.73, width: 0.14, height: 0.2),
};

const ShareCardMainImageConfig kShareCardMainImageLandscapeRightCollage = ShareCardMainImageConfig(
  area: ShareCardRegion(left: 0.42, top: 0.10, width: 0.54, height: 0.72),
  fit: BoxFit.cover,
  alignment: Alignment.center,
  borderRadiusFraction: 0.03,
);

Map<ShareCardThemeSlot, ShareCardRegion> cloneRegions(Map<ShareCardThemeSlot, ShareCardRegion> source) =>
    Map<ShareCardThemeSlot, ShareCardRegion>.from(source);
