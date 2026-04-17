import 'dart:convert';

import 'package:flutter/services.dart';

/// Copy for onboarding lives in [assets/onboarding/onboarding_content.json].
class OnboardingSlideCopy {
  const OnboardingSlideCopy({required this.title, required this.body});

  final String title;
  final String body;
}

class OnboardingContentBundle {
  const OnboardingContentBundle({
    required this.slides,
    required this.nextLabel,
    required this.skipLabel,
    required this.startLabel,
  });

  final List<OnboardingSlideCopy> slides;
  final String nextLabel;
  final String skipLabel;
  final String startLabel;
}

abstract final class OnboardingContentLoader {
  static const _assetPath = 'assets/onboarding/onboarding_content.json';

  /// [languageCode] is typically `Localizations.localeOf(context).languageCode`.
  static Future<OnboardingContentBundle> load(String languageCode) async {
    final raw = await rootBundle.loadString(_assetPath);
    final root = jsonDecode(raw) as Map<String, dynamic>;
    final lang = (root[languageCode] ?? root['en']) as Map<String, dynamic>;
    final slidesJson = lang['slides'] as List<dynamic>;
    final slides = slidesJson
        .map((e) {
          final m = e as Map<String, dynamic>;
          return OnboardingSlideCopy(
            title: m['title'] as String,
            body: m['body'] as String,
          );
        })
        .toList(growable: false);
    return OnboardingContentBundle(
      slides: slides,
      nextLabel: lang['next'] as String,
      skipLabel: lang['skip'] as String,
      startLabel: lang['start'] as String,
    );
  }
}
