import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

/// Result of OpenAI extraction for the AI customer import flow.
class OpenAiCustomerExtractResult {
  const OpenAiCustomerExtractResult({
    this.name,
    this.phone,
    this.notes,
    this.preferredLocation,
    this.email,
  });

  final String? name;
  final String? phone;
  final String? notes;
  final String? preferredLocation;
  final String? email;
}

/// Calls OpenAI Chat Completions (JSON) with optional vision input.
abstract final class OpenAiCustomerExtractionService {
  static final Uri _endpoint = Uri.parse('https://api.openai.com/v1/chat/completions');
  static const String _model = 'gpt-4o-mini';

  static String _imageDataUrl(Uint8List bytes) {
    if (bytes.length >= 2 && bytes[0] == 0xff && bytes[1] == 0xd8) {
      return 'data:image/jpeg;base64,${base64Encode(bytes)}';
    }
    if (bytes.length >= 8 && bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4e && bytes[3] == 0x47) {
      return 'data:image/png;base64,${base64Encode(bytes)}';
    }
    return 'data:image/jpeg;base64,${base64Encode(bytes)}';
  }

  /// [pastedText] and/or [imageBytes] must be provided.
  static Future<OpenAiCustomerExtractResult> extract({
    required String apiKey,
    Uint8List? imageBytes,
    String? pastedText,
  }) async {
    final text = pastedText?.trim() ?? '';
    if (text.isEmpty && (imageBytes == null || imageBytes.isEmpty)) {
      throw OpenAiCustomerExtractException('empty_input');
    }

    final userContent = <Object>[];
    userContent.add({
      'type': 'text',
      'text': '''
You extract real-estate CRM customer fields from Turkish or English chat screenshots / pasted text.
Focus on the contact's full name and main phone number shown in the screenshot.
Return a single JSON object with keys only:
"name" (string|null), "phone" (string|null, digits with optional +90),
"notes" (string|null), "preferred_location" (string|null), "email" (string|null).
Use null when unknown. Do not invent phone numbers.''',
    });
    if (text.isNotEmpty) {
      userContent.add({
        'type': 'text',
        'text': 'Pasted text:\n$text',
      });
    }
    if (imageBytes != null && imageBytes.isNotEmpty) {
      userContent.add({
        'type': 'image_url',
        'image_url': {'url': _imageDataUrl(imageBytes)},
      });
    }

    final body = jsonEncode({
      'model': _model,
      'response_format': {'type': 'json_object'},
      'messages': [
        {
          'role': 'user',
          'content': userContent,
        },
      ],
    });

    final res = await http.post(
      _endpoint,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw OpenAiCustomerExtractException(
        'http_${res.statusCode}',
        detail: res.body.length > 400 ? '${res.body.substring(0, 400)}…' : res.body,
      );
    }

    final decoded = jsonDecode(res.body) as Map<String, dynamic>;
    final choices = decoded['choices'] as List<dynamic>?;
    final msg = choices != null && choices.isNotEmpty
        ? (choices.first as Map<String, dynamic>)['message'] as Map<String, dynamic>?
        : null;
    final content = msg?['content'] as String?;
    if (content == null || content.trim().isEmpty) {
      throw OpenAiCustomerExtractException('empty_content');
    }

    Map<String, dynamic> parsed;
    try {
      parsed = jsonDecode(content) as Map<String, dynamic>;
    } catch (_) {
      throw OpenAiCustomerExtractException('invalid_json', detail: content);
    }

    String? s(String key) {
      final v = parsed[key];
      if (v == null) {
        return null;
      }
      final t = v.toString().trim();
      return t.isEmpty ? null : t;
    }

    return OpenAiCustomerExtractResult(
      name: s('name'),
      phone: s('phone'),
      notes: s('notes'),
      preferredLocation: s('preferred_location'),
      email: s('email'),
    );
  }
}

class OpenAiCustomerExtractException implements Exception {
  OpenAiCustomerExtractException(this.code, {this.detail});

  final String code;
  final String? detail;

  @override
  String toString() => detail != null ? 'OpenAiCustomerExtractException($code): $detail' : 'OpenAiCustomerExtractException($code)';
}
