import 'package:flutter/material.dart';

import 'share_card_region.dart';

/// Normalized interest point on the source image (0–1). Maps to [Alignment].
class ShareCardFocalPoint {
  const ShareCardFocalPoint(this.x, this.y);

  /// 0 = left, 1 = right.
  final double x;

  /// 0 = top, 1 = bottom.
  final double y;

  Alignment toAlignment() => Alignment(x * 2 - 1, y * 2 - 1);
}

/// Per-template configuration for the listing photo (hybrid: layout + alignment + fit).
///
/// When [focalPoint] is set it overrides [alignment] for the default framing.
/// [area] overrides [ShareCardThemeSlot.mainImage] **only** for the raster layer
/// (text slots stay on the main template map).
class ShareCardMainImageConfig {
  const ShareCardMainImageConfig({
    this.area,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.focalPoint,
    this.borderRadiusFraction,
  });

  /// Optional rect in normalized **content** coordinates (same space as [ShareCardRegion]).
  /// When null, the slot [ShareCardThemeSlot.mainImage] from the theme map is used.
  final ShareCardRegion? area;

  final BoxFit fit;

  /// Baseline framing when no [focalPoint] and no user/smart override.
  final Alignment alignment;

  /// Designer default “look at this point” (wins over [alignment] when non-null).
  final ShareCardFocalPoint? focalPoint;

  /// Corner radius for this image only, as a fraction of card shortest side.
  /// When null, [ShareCardThemeDefinition.mainImageCornerRadiusFraction] is used.
  final double? borderRadiusFraction;

  /// Template-only default (ignores runtime smart/user alignment).
  Alignment templateAlignment() {
    if (focalPoint != null) {
      return focalPoint!.toAlignment();
    }
    return alignment;
  }

  double resolveBorderRadiusFraction(double themeDefault) => borderRadiusFraction ?? themeDefault;
}
