import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../listing_template_value_resolver.dart';
import '../models/listing_data.dart';
import '../models/listing_template_document.dart';

/// Renders [template] by stacking a raster background and JSON-driven fields.
///
/// Coordinates in the template are normalized (0–1) inside the padded content
/// area, matching the share-card engine convention.
class DynamicListingTemplateView extends StatelessWidget {
  const DynamicListingTemplateView({
    super.key,
    required this.template,
    required this.data,
    required this.width,
    required this.height,
  });

  final ListingTemplateDocument template;
  final ListingData data;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final size = Size(width, height);
    final pad = template.paddingFor(size);
    final scale = (width / template.designWidth).clamp(0.65, 1.35);
    final clipR = template.backgroundClipRadiusFraction * math.min(size.width, size.height);
    final resolver = ListingTemplateValueResolver(data);

    final children = <Widget>[
      Positioned.fill(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(clipR),
          child: Image.asset(
            template.backgroundAsset,
            fit: template.backgroundFit,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    ];

    for (final field in template.fields) {
      final rect = field.toRect(cardSize: size, safePadding: pad);
      if (rect.width <= 1 || rect.height <= 1) {
        continue;
      }

      if (field.kind == ListingTemplateFieldKind.text) {
        final raw = resolver.textFor(field.bind);
        final text = (raw ?? '').trim();
        if (text.isEmpty) {
          continue;
        }
        final spec = field.textStyle;
        children.add(
          Positioned(
            left: rect.left,
            top: rect.top,
            width: rect.width,
            height: rect.height,
            child: Text(
              text,
              textAlign: spec.textAlign,
              maxLines: spec.maxLines,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: spec.color,
                fontSize: spec.fontSize * scale,
                fontWeight: spec.fontWeight,
                height: spec.lineHeight,
                letterSpacing: spec.letterSpacing,
              ),
            ),
          ),
        );
      } else {
        final url = resolver.imageUrlFor(field.bind, imageIndex: field.imageIndex);
        if (url == null || url.isEmpty) {
          continue;
        }
        final radiusPx = field.imageSpec.borderRadiusDesignPx * (width / template.designWidth);
        children.add(
          Positioned(
            left: rect.left,
            top: rect.top,
            width: rect.width,
            height: rect.height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radiusPx),
              clipBehavior: Clip.antiAlias,
              child: _TemplateImage(
                source: url,
                fit: field.imageSpec.fit,
                alignment: field.imageSpec.alignment,
                scale: scale,
              ),
            ),
          ),
        );
      }
    }

    return SizedBox(
      width: width,
      height: height,
      child: Stack(fit: StackFit.expand, children: children),
    );
  }
}

class _TemplateImage extends StatelessWidget {
  const _TemplateImage({
    required this.source,
    required this.fit,
    required this.alignment,
    required this.scale,
  });

  final String source;
  final BoxFit fit;
  final Alignment alignment;
  final double scale;

  bool get _isAsset => source.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    if (_isAsset) {
      return Image.asset(
        source,
        fit: fit,
        alignment: alignment,
        filterQuality: FilterQuality.medium,
        errorBuilder: (_, _, _) => _broken(scale),
      );
    }
    return Image.network(
      source,
      fit: fit,
      alignment: alignment,
      filterQuality: FilterQuality.medium,
      errorBuilder: (_, _, _) => _broken(scale),
      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return child;
        }
        return Center(
          child: SizedBox(
            width: 28 * scale,
            height: 28 * scale,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }

  static Widget _broken(double scale) {
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.35),
      child: Icon(
        Icons.image_not_supported_outlined,
        color: Colors.white.withValues(alpha: 0.85),
        size: 36 * scale,
      ),
    );
  }
}
