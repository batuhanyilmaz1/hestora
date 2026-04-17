import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/share_card_layout_data.dart';
import '../models/share_card_theme_definition.dart';
import '../models/share_card_theme_slot.dart';
import '../models/share_card_watermark_style.dart';
import 'share_card_brand_watermark.dart';
import 'share_card_main_image.dart';

/// Renders [data] on top of [theme] using a deterministic [Stack] + [Positioned] layout.
///
/// [listingImageAlignment] overrides template / smart framing for the listing photo only.
class PropertyShareCardTemplateView extends StatelessWidget {
  const PropertyShareCardTemplateView({
    super.key,
    required this.theme,
    required this.data,
    required this.width,
    required this.height,
    this.listingImageAlignment,
  });

  final ShareCardThemeDefinition theme;
  final ShareCardLayoutData data;
  final double width;
  final double height;

  /// When null, uses [ShareCardMainImageConfig.templateAlignment].
  final Alignment? listingImageAlignment;

  @override
  Widget build(BuildContext context) {
    final size = Size(width, height);
    final pad = theme.paddingFor(size);
    final scale = (width / theme.designWidth).clamp(0.65, 1.35);
    final radius = theme.mainImageCornerRadiusFraction * math.min(size.width, size.height);

    TextStyle slotStyle(TextStyle base) {
      if (!theme.textShadows) {
        return base;
      }
      return base.copyWith(
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 3 * scale,
            offset: Offset(0, 1 * scale),
          ),
          Shadow(
            color: Colors.black.withValues(alpha: 0.32),
            blurRadius: 10 * scale,
            offset: Offset.zero,
          ),
        ],
      );
    }

    Widget? positionedSlot(ShareCardThemeSlot slot, Widget child) {
      final def = theme.region(slot);
      if (def == null) {
        return null;
      }
      final rect = def.toRect(cardSize: size, safePadding: pad);
      return Positioned(
        left: rect.left,
        top: rect.top,
        width: rect.width,
        height: rect.height,
        child: child,
      );
    }

    final children = <Widget>[
      Positioned.fill(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius * 0.35),
          child: Image.asset(
            theme.assetPath,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
      if (theme.watermarkStyle != ShareCardWatermarkStyle.none)
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius * 0.35),
            child: ShareCardBrandWatermark(style: theme.watermarkStyle),
          ),
        ),
    ];

    final imgRect = shareCardMainImageRect(theme: theme, cardSize: size, safePadding: pad);
    final listingAlign = listingImageAlignment ?? theme.mainImage.templateAlignment();
    final imgRadius = shareCardMainImageCornerRadius(theme: theme, cardSize: size);
    final mainUrl = data.effectiveMainImageUrl;

    if (imgRect.width > 1 && imgRect.height > 1 && (mainUrl?.isNotEmpty ?? false)) {
      children.add(
        Positioned(
          left: imgRect.left,
          top: imgRect.top,
          width: imgRect.width,
          height: imgRect.height,
          child: ShareCardMainImage(
            url: mainUrl!,
            theme: theme,
            alignment: listingAlign,
            cornerRadius: imgRadius,
            scale: scale,
          ),
        ),
      );
    }

    void addGalleryImage(ShareCardThemeSlot slot, int urlIndex) {
      final def = theme.region(slot);
      if (def == null) {
        return;
      }
      final urls = data.normalizedListingImageUrls;
      if (urlIndex < 0 || urlIndex >= urls.length) {
        return;
      }
      final url = urls[urlIndex];
      if (url.isEmpty) {
        return;
      }
      final rect = def.toRect(cardSize: size, safePadding: pad);
      if (rect.width <= 1 || rect.height <= 1) {
        return;
      }
      final r = math.min(rect.width, rect.height) * 0.09;
      children.add(
        Positioned(
          left: rect.left,
          top: rect.top,
          width: rect.width,
          height: rect.height,
          child: ShareCardMainImage(
            url: url,
            theme: theme,
            alignment: Alignment.center,
            cornerRadius: r,
            scale: scale,
          ),
        ),
      );
    }

    addGalleryImage(ShareCardThemeSlot.galleryImage1, 1);
    addGalleryImage(ShareCardThemeSlot.galleryImage2, 2);
    addGalleryImage(ShareCardThemeSlot.galleryImage3, 3);

    void addText(
      ShareCardThemeSlot slot,
      String text, {
      required TextStyle style,
      int maxLines = 2,
      TextAlign align = TextAlign.start,
    }) {
      if (text.trim().isEmpty) {
        return;
      }
      final w = positionedSlot(
        slot,
        Text(
          text,
          textAlign: align,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: slotStyle(style),
        ),
      );
      if (w != null) {
        children.add(w);
      }
    }

    addText(
      ShareCardThemeSlot.listingType,
      data.listingTypeLabel,
      style: TextStyle(
        color: theme.accentColor,
        fontSize: 12 * scale,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
      ),
      maxLines: 1,
    );

    addText(
      ShareCardThemeSlot.title,
      data.title,
      style: TextStyle(
        color: theme.titleColor,
        fontSize: 20 * scale,
        fontWeight: FontWeight.w800,
        height: 1.15,
      ),
      maxLines: 3,
    );

    addText(
      ShareCardThemeSlot.price,
      data.priceLine,
      style: TextStyle(
        color: theme.priceColor,
        fontSize: 22 * scale,
        fontWeight: FontWeight.w800,
      ),
      maxLines: 1,
    );

    addText(
      ShareCardThemeSlot.features,
      data.featuresLine,
      style: TextStyle(
        color: theme.subtitleColor,
        fontSize: 13 * scale,
        fontWeight: FontWeight.w600,
      ),
      maxLines: 2,
    );

    addText(
      ShareCardThemeSlot.location,
      data.locationLine ?? '',
      style: TextStyle(
        color: theme.subtitleColor,
        fontSize: 12 * scale,
        fontWeight: FontWeight.w500,
      ),
      maxLines: 2,
    );

    addText(
      ShareCardThemeSlot.agentName,
      data.agentName ?? '',
      style: TextStyle(
        color: theme.agentTitleColor ?? theme.titleColor,
        fontSize: 13 * scale,
        fontWeight: FontWeight.w700,
      ),
      maxLines: 1,
    );

    addText(
      ShareCardThemeSlot.agentPhone,
      data.agentPhone ?? '',
      style: TextStyle(
        color: theme.agentPhoneColor ?? theme.subtitleColor,
        fontSize: 12 * scale,
        fontWeight: FontWeight.w600,
      ),
      maxLines: 1,
    );

    final qrSlot = theme.region(ShareCardThemeSlot.websiteOrQr);
    if (qrSlot != null) {
      final rect = qrSlot.toRect(cardSize: size, safePadding: pad);
      final payload = data.qrPayload?.trim() ?? '';
      if (payload.isNotEmpty) {
        final side = math.min(rect.width, rect.height) * 0.92;
        children.add(
          Positioned(
            left: rect.left + (rect.width - side) / 2,
            top: rect.top + (rect.height - side) / 2,
            width: side,
            height: side,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6 * scale),
              ),
              child: Padding(
                padding: EdgeInsets.all(3 * scale),
                child: QrImageView(
                  data: payload,
                  version: QrVersions.auto,
                  gapless: true,
                ),
              ),
            ),
          ),
        );
      } else if ((data.websiteFallbackLine ?? '').trim().isNotEmpty) {
        children.add(
          positionedSlot(
            ShareCardThemeSlot.websiteOrQr,
            Center(
              child: Text(
                data.websiteFallbackLine!.trim(),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: slotStyle(
                  TextStyle(
                    color: theme.subtitleColor,
                    fontSize: 10 * scale,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
              ),
            ),
          )!,
        );
      }
    }

    final logoPath = theme.logoAssetPath;
    if (logoPath != null && logoPath.toLowerCase().endsWith('.svg')) {
      final w = positionedSlot(
        ShareCardThemeSlot.logo,
        SvgPicture.asset(
          logoPath,
          fit: BoxFit.contain,
          alignment: Alignment.centerRight,
        ),
      );
      if (w != null) {
        children.add(w);
      }
    }

    return SizedBox(
      width: width,
      height: height,
      child: Stack(fit: StackFit.expand, children: children),
    );
  }
}
