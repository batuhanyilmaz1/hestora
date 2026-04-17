import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'models/listing_template_document.dart';

/// Parses a template JSON asset into [ListingTemplateDocument].
///
/// Coordinates `x`, `y`, `width`, `height` are **normalized** (0–1) inside the
/// padded content area (same convention as the share-card region model).
class ListingTemplateJson {
  const ListingTemplateJson._();

  static Future<ListingTemplateDocument> parseAsset(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    return parse(raw);
  }

  static ListingTemplateDocument parse(String jsonText) {
    final dynamic root = _decode(jsonText);
    if (root is! Map) {
      throw const FormatException('Template root must be a JSON object');
    }
    final map = Map<String, dynamic>.from(root);
    final id = map.stringOrThrow('id');
    final label = map.stringOrThrow('label');
    final designWidth = map.doubleOrThrow('designWidth');
    final designHeight = map.doubleOrThrow('designHeight');
    final backgroundAsset = map.stringOrThrow('backgroundAsset');
    final safeH = map.optionalDouble('safeHorizontalFraction') ?? 0.045;
    final safeV = map.optionalDouble('safeVerticalFraction') ?? 0.04;
    final bgFit = _parseBoxFit(map.optionalString('backgroundFit')) ?? BoxFit.cover;
    final bgClip = map.optionalDouble('backgroundClipRadiusFraction') ?? 0;

    final rawFields = map['fields'];
    if (rawFields is! List) {
      throw FormatException('Template "$id" must include a "fields" array');
    }

    final fields = <ListingTemplateField>[];
    for (final item in rawFields) {
      if (item is! Map) {
        continue;
      }
      fields.add(_parseField(Map<String, dynamic>.from(item)));
    }

    return ListingTemplateDocument(
      id: id,
      label: label,
      designWidth: designWidth,
      designHeight: designHeight,
      backgroundAsset: backgroundAsset,
      safeHorizontalFraction: safeH,
      safeVerticalFraction: safeV,
      fields: fields,
      backgroundFit: bgFit,
      backgroundClipRadiusFraction: bgClip,
    );
  }

  static dynamic _decode(String jsonText) {
    try {
      final t = jsonText.trim();
      if (t.isEmpty) {
        return <String, dynamic>{};
      }
      return jsonDecode(t);
    } catch (e, st) {
      Error.throwWithStackTrace(
        FormatException('Invalid template JSON: $e'),
        st,
      );
    }
  }
}

extension _MapExt on Map<String, dynamic> {
  String stringOrThrow(String key) {
    final v = this[key];
    if (v is String && v.trim().isNotEmpty) {
      return v.trim();
    }
    throw FormatException('Missing string "$key"');
  }

  String? optionalString(String key) {
    final v = this[key];
    return v is String ? v.trim() : null;
  }

  double doubleOrThrow(String key) {
    final v = this[key];
    final n = _asDouble(v);
    if (n == null) {
      throw FormatException('Missing number "$key"');
    }
    return n;
  }

  double? optionalDouble(String key) => _asDouble(this[key]);

  int? optionalInt(String key) {
    final v = this[key];
    if (v is int) {
      return v;
    }
    if (v is num) {
      return v.round();
    }
    return null;
  }
}

double? _asDouble(Object? v) {
  if (v is num) {
    return v.toDouble();
  }
  if (v is String) {
    return double.tryParse(v.trim());
  }
  return null;
}

ListingTemplateField _parseField(Map<String, dynamic> m) {
  final type = m.stringOrThrow('type').toLowerCase();
  final bind = _parseBind(m.stringOrThrow('bind'));
  final left = m.doubleOrThrow('x');
  final top = m.doubleOrThrow('y');
  final width = m.doubleOrThrow('width');
  final height = m.doubleOrThrow('height');
  final imageIndex = m.optionalInt('imageIndex') ?? 0;

  final kind = switch (type) {
    'text' => ListingTemplateFieldKind.text,
    'image' => ListingTemplateFieldKind.image,
    _ => throw FormatException('Unknown field type "$type"'),
  };

  if (kind == ListingTemplateFieldKind.text) {
    if (bind == ListingTemplateBind.mainImage ||
        bind == ListingTemplateBind.imageUrl ||
        bind == ListingTemplateBind.logo) {
      throw FormatException('bind "$bind" is not valid for type "text"');
    }
  } else {
    if (bind != ListingTemplateBind.mainImage &&
        bind != ListingTemplateBind.imageUrl &&
        bind != ListingTemplateBind.logo) {
      throw FormatException('bind "$bind" is not valid for type "image"');
    }
  }

  final text = _parseTextStyle(m);
  final image = _parseImageSpec(m);

  return ListingTemplateField(
    kind: kind,
    bind: bind,
    left: left,
    top: top,
    width: width,
    height: height,
    imageIndex: imageIndex,
    textStyle: text,
    imageSpec: image,
  );
}

ListingTemplateBind _parseBind(String raw) {
  final s = raw.trim().toLowerCase();
  return switch (s) {
    'title' => ListingTemplateBind.title,
    'price' => ListingTemplateBind.price,
    'roomcount' => ListingTemplateBind.roomCount,
    'room_count' => ListingTemplateBind.roomCount,
    'area' => ListingTemplateBind.area,
    'location' => ListingTemplateBind.location,
    'phone' => ListingTemplateBind.phone,
    'mainimage' => ListingTemplateBind.mainImage,
    'main_image' => ListingTemplateBind.mainImage,
    'imageurl' => ListingTemplateBind.imageUrl,
    'image_url' => ListingTemplateBind.imageUrl,
    'logo' => ListingTemplateBind.logo,
    _ => throw FormatException('Unknown bind "$raw"'),
  };
}

ListingTemplateTextStyleSpec _parseTextStyle(Map<String, dynamic> m) {
  final fontSize = m.optionalDouble('fontSize') ?? 14;
  final weight = _parseFontWeight(m.optionalString('fontWeight')) ?? FontWeight.w600;
  final color = _parseColor(m.optionalString('color')) ?? const Color(0xFFFFFFFF);
  final align = _parseTextAlign(m.optionalString('textAlign')) ?? TextAlign.start;
  final maxLines = m.optionalInt('maxLines') ?? 2;
  final lineHeight = m.optionalDouble('lineHeight');
  final letterSpacing = m.optionalDouble('letterSpacing');
  return ListingTemplateTextStyleSpec(
    fontSize: fontSize,
    fontWeight: weight,
    color: color,
    textAlign: align,
    maxLines: maxLines,
    lineHeight: lineHeight,
    letterSpacing: letterSpacing,
  );
}

ListingTemplateImageSpec _parseImageSpec(Map<String, dynamic> m) {
  final fit = _parseBoxFit(m.optionalString('fit')) ?? BoxFit.cover;
  final alignment = _parseAlignment(m.optionalString('alignment')) ?? Alignment.center;
  final radius = m.optionalDouble('borderRadius') ?? 0;
  return ListingTemplateImageSpec(
    fit: fit,
    alignment: alignment,
    borderRadiusDesignPx: radius,
  );
}

FontWeight? _parseFontWeight(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  final s = raw.trim().toLowerCase();
  if (s == 'bold') {
    return FontWeight.bold;
  }
  if (s == 'normal' || s == 'regular') {
    return FontWeight.w400;
  }
  final match = RegExp(r'^w(\d{3})$').firstMatch(s);
  if (match != null) {
    final v = int.tryParse(match.group(1)!);
    if (v != null && v >= 100 && v <= 900 && v % 100 == 0) {
      return FontWeight.values.firstWhere((w) => w.value == v);
    }
  }
  return null;
}

Color? _parseColor(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  var s = raw.trim();
  if (s.startsWith('#')) {
    s = s.substring(1);
  }
  if (s.length == 6) {
    final value = int.tryParse(s, radix: 16);
    if (value == null) {
      return null;
    }
    return Color(0xFF000000 | value);
  }
  if (s.length == 8) {
    final value = int.tryParse(s, radix: 16);
    if (value == null) {
      return null;
    }
    return Color(value);
  }
  return null;
}

TextAlign? _parseTextAlign(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  switch (raw.trim().toLowerCase()) {
    case 'left':
    case 'start':
      return TextAlign.start;
    case 'right':
    case 'end':
      return TextAlign.end;
    case 'center':
      return TextAlign.center;
    case 'justify':
      return TextAlign.justify;
    default:
      return null;
  }
}

BoxFit? _parseBoxFit(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  switch (raw.trim().toLowerCase()) {
    case 'fill':
      return BoxFit.fill;
    case 'contain':
      return BoxFit.contain;
    case 'cover':
      return BoxFit.cover;
    case 'fitwidth':
    case 'fit_width':
      return BoxFit.fitWidth;
    case 'fitheight':
    case 'fit_height':
      return BoxFit.fitHeight;
    case 'scaledown':
    case 'scale_down':
      return BoxFit.scaleDown;
    default:
      return null;
  }
}

Alignment? _parseAlignment(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  final s = raw.trim().toLowerCase().replaceAll(' ', '').replaceAll('-', '');
  switch (s) {
    case 'center':
      return Alignment.center;
    case 'topleft':
      return Alignment.topLeft;
    case 'topcenter':
      return Alignment.topCenter;
    case 'topright':
      return Alignment.topRight;
    case 'centerleft':
      return Alignment.centerLeft;
    case 'centerright':
      return Alignment.centerRight;
    case 'bottomleft':
      return Alignment.bottomLeft;
    case 'bottomcenter':
      return Alignment.bottomCenter;
    case 'bottomright':
      return Alignment.bottomRight;
    default:
      return null;
  }
}
