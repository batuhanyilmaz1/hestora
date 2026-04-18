import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/share_card_theme_definition.dart';
import '../models/share_card_theme_slot.dart';

/// Listing photo clipped to template window, honoring [BoxFit] + [Alignment].
class ShareCardMainImage extends StatelessWidget {
  const ShareCardMainImage({
    super.key,
    required this.url,
    required this.theme,
    required this.alignment,
    required this.cornerRadius,
    required this.scale,
  });

  final String url;
  final ShareCardThemeDefinition theme;
  final Alignment alignment;
  final double cornerRadius;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(cornerRadius),
      clipBehavior: Clip.antiAlias,
      child: SizedBox.expand(
        child: Image.network(
          url,
          fit: BoxFit.cover,
          alignment: alignment,
          filterQuality: FilterQuality.medium,
          errorBuilder: (_, _, _) => ColoredBox(
            color: Colors.black.withValues(alpha: 0.35),
            child: Icon(
              Icons.image_not_supported_outlined,
              color: theme.subtitleColor,
              size: 36 * scale,
            ),
          ),
          loadingBuilder: (context, child, progress) {
            if (progress == null) {
              return child;
            }
            return Center(
              child: SizedBox(
                width: 28 * scale,
                height: 28 * scale,
                child: CircularProgressIndicator(strokeWidth: 2, color: theme.priceColor),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Resolves the on-card rect for the listing image (config override or [ShareCardThemeSlot.mainImage]).
Rect shareCardMainImageRect({
  required ShareCardThemeDefinition theme,
  required Size cardSize,
  required EdgeInsets safePadding,
}) {
  final region = theme.mainImage.area ?? theme.region(ShareCardThemeSlot.mainImage);
  if (region == null) {
    return Rect.zero;
  }
  return region.toRect(cardSize: cardSize, safePadding: safePadding);
}

double shareCardMainImageCornerRadius({
  required ShareCardThemeDefinition theme,
  required Size cardSize,
}) {
  final frac = theme.mainImage.resolveBorderRadiusFraction(theme.mainImageCornerRadiusFraction);
  return frac * math.min(cardSize.width, cardSize.height);
}
