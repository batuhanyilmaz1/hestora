import 'dart:convert';

import 'package:http/http.dart' as http;

/// Open Graph metadata (only meta tags — no full-page scraping).
class OgMetadata {
  const OgMetadata({
    this.title,
    this.description,
    this.imageUrl,
    this.canonicalUrl,
  });

  final String? title;
  final String? description;
  final String? imageUrl;
  final String? canonicalUrl;

  bool get hasAny =>
      (title != null && title!.trim().isNotEmpty) ||
      (description != null && description!.trim().isNotEmpty) ||
      (imageUrl != null && imageUrl!.trim().isNotEmpty);
}

/// Fetches HTML and extracts common Open Graph / Twitter Card tags.
abstract final class OpenGraphService {
  static const _userAgent =
      'Mozilla/5.0 (compatible; HestoraCRM/1.0; +https://hestora.app) AppleWebKit/537.36';

  static Future<OgMetadata> fetch(Uri uri) async {
    final response = await http.get(
      uri,
      headers: {'User-Agent': _userAgent, 'Accept': 'text/html,application/xhtml+xml'},
    );
    if (response.statusCode < 200 || response.statusCode >= 400) {
      throw OgFetchException('HTTP ${response.statusCode}');
    }
    final charset = _charsetFromContentType(response.headers['content-type']);
    final contentType = response.headers['content-type']?.toLowerCase();
    if (contentType != null &&
        contentType.isNotEmpty &&
        !contentType.contains('text/html') &&
        !contentType.contains('application/xhtml+xml')) {
      throw OgFetchException('Unsupported content type');
    }
    final html = _decodeBody(response.bodyBytes, charset);
    if (html.trim().isEmpty) {
      throw OgFetchException('Empty response');
    }
    return _parseHtml(html, uri);
  }

  static String _decodeBody(List<int> bytes, String? charset) {
    if (charset != null && charset.toLowerCase().contains('utf-8')) {
      return utf8.decode(bytes, allowMalformed: true);
    }
    return utf8.decode(bytes, allowMalformed: true);
  }

  static String? _charsetFromContentType(String? ct) {
    if (ct == null) {
      return null;
    }
    final m = RegExp(r'charset=([^;]+)', caseSensitive: false).firstMatch(ct);
    return m?.group(1)?.trim();
  }

  static OgMetadata _parseHtml(String html, Uri base) {
    String? pickOg(String prop) => _metaContent(html, property: 'og:$prop') ?? _metaContent(html, name: 'og:$prop');
    String? pickTwitter(String n) => _metaContent(html, name: 'twitter:$n');

    final title = pickOg('title') ?? pickTwitter('title') ?? _titleFromHead(html);
    final description = pickOg('description') ?? pickTwitter('description') ?? pickTwitter('text');
    final imageRaw = pickOg('image') ?? pickTwitter('image');
    final urlRaw = pickOg('url') ?? pickTwitter('url');

    return OgMetadata(
      title: title?.trim(),
      description: description?.trim(),
      imageUrl: imageRaw != null ? _resolveUrl(base, imageRaw.trim()) : null,
      canonicalUrl: urlRaw != null ? _resolveUrl(base, urlRaw.trim()) : null,
    );
  }

  static String? _metaContent(
    String html, {
    String? property,
    String? name,
  }) {
    final tagPattern = RegExp(r'<meta\b[^>]*>', caseSensitive: false, dotAll: true);
    final targetProperty = property?.toLowerCase();
    final targetName = name?.toLowerCase();

    for (final match in tagPattern.allMatches(html)) {
      final tag = match.group(0);
      if (tag == null) {
        continue;
      }
      final tagProperty = _attributeValue(tag, 'property')?.toLowerCase();
      final tagName = _attributeValue(tag, 'name')?.toLowerCase();
      final content = _attributeValue(tag, 'content');

      final matchesProperty = targetProperty != null && tagProperty == targetProperty;
      final matchesName = targetName != null && tagName == targetName;
      if ((matchesProperty || matchesName) && content != null && content.trim().isNotEmpty) {
        return content;
      }
    }

    return null;
  }

  static String? _titleFromHead(String html) {
    final m = RegExp(r'<title[^>]*>([^<]+)</title>', caseSensitive: false).firstMatch(html);
    return m?.group(1)?.trim();
  }

  static String? _attributeValue(String tag, String attribute) {
    final pattern = RegExp(
      '$attribute\\s*=\\s*(["\\\'])(.*?)\\1',
      caseSensitive: false,
      dotAll: true,
    );
    return pattern.firstMatch(tag)?.group(2)?.trim();
  }

  static String _resolveUrl(Uri base, String ref) {
    if (ref.startsWith('//')) {
      return '${base.scheme}:$ref';
    }
    return base.resolve(ref).toString();
  }
}

class OgFetchException implements Exception {
  OgFetchException(this.message);
  final String message;

  @override
  String toString() => 'OgFetchException: $message';
}
