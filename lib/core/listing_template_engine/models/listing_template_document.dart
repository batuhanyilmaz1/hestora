import 'package:flutter/material.dart';

/// Root JSON document for one raster template + overlay fields.
class ListingTemplateDocument {
  const ListingTemplateDocument({
    required this.id,
    required this.label,
    required this.designWidth,
    required this.designHeight,
    required this.backgroundAsset,
    required this.safeHorizontalFraction,
    required this.safeVerticalFraction,
    required this.fields,
    this.backgroundFit = BoxFit.cover,
    this.backgroundClipRadiusFraction = 0,
  });

  final String id;
  final String label;

  /// Authoring resolution used for font-size scaling.
  final double designWidth;
  final double designHeight;

  /// PNG/JPEG under `assets/themes/` (or other declared asset bundles).
  final String backgroundAsset;

  final double safeHorizontalFraction;
  final double safeVerticalFraction;

  final List<ListingTemplateField> fields;

  final BoxFit backgroundFit;

  /// Corner radius for the full card clip, as a fraction of shortest side.
  final double backgroundClipRadiusFraction;

  double get aspectRatio => designWidth / designHeight;

  EdgeInsets paddingFor(Size cardSize) => EdgeInsets.symmetric(
        horizontal: cardSize.width * safeHorizontalFraction,
        vertical: cardSize.height * safeVerticalFraction,
      );
}

/// Supported `type` values in template JSON.
enum ListingTemplateFieldKind { text, image }

/// Binds a JSON field entry to [ListingData] getters.
enum ListingTemplateBind {
  title,
  price,
  roomCount,
  area,
  location,
  phone,
  /// First URL in [ListingData.imageUrls].
  mainImage,
  /// Optional gallery slot; requires [imageIndex].
  imageUrl,
  logo,
}

class ListingTemplateField {
  const ListingTemplateField({
    required this.kind,
    required this.bind,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    this.imageIndex = 0,
    this.textStyle = const ListingTemplateTextStyleSpec(),
    this.imageSpec = const ListingTemplateImageSpec(),
  });

  final ListingTemplateFieldKind kind;
  final ListingTemplateBind bind;

  /// Normalized 0–1 rectangle inside the **content** rect (after safe padding).
  final double left;
  final double top;
  final double width;
  final double height;

  /// Used when [bind] is [ListingTemplateBind.imageUrl].
  final int imageIndex;

  final ListingTemplateTextStyleSpec textStyle;
  final ListingTemplateImageSpec imageSpec;

  Rect toRect({required Size cardSize, required EdgeInsets safePadding}) {
    final innerLeft = safePadding.left;
    final innerTop = safePadding.top;
    final innerW = cardSize.width - safePadding.horizontal;
    final innerH = cardSize.height - safePadding.vertical;
    return Rect.fromLTWH(
      innerLeft + left * innerW,
      innerTop + top * innerH,
      width * innerW,
      height * innerH,
    );
  }
}

class ListingTemplateTextStyleSpec {
  const ListingTemplateTextStyleSpec({
    this.fontSize = 14,
    this.fontWeight = FontWeight.w600,
    this.color = const Color(0xFFFFFFFF),
    this.textAlign = TextAlign.start,
    this.maxLines = 2,
    this.lineHeight,
    this.letterSpacing,
  });

  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final int maxLines;
  final double? lineHeight;
  final double? letterSpacing;
}

class ListingTemplateImageSpec {
  const ListingTemplateImageSpec({
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.borderRadiusDesignPx = 0,
  });

  final BoxFit fit;
  final Alignment alignment;

  /// Radius in **design** pixels; scaled with the card relative to [ListingTemplateDocument.designWidth].
  final double borderRadiusDesignPx;
}
