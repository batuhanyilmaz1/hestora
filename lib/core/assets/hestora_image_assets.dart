/// Bundled marketing / handoff images (see `assets/splash`, `assets/onboarding`).
abstract final class HestoraImageAssets {
  static const List<String> splashSequence = <String>[
    'assets/splash/splash_01.jpg',
    'assets/splash/splash_02.jpg',
    'assets/splash/splash_03.jpg',
  ];

  /// First splash frame — useful as in-app logo thumbnail where SVG is heavy.
  static const String splashBrandThumb = 'assets/splash/splash_01.jpg';

  static const int onboardingSlideCount = 14;

  static String onboardingSlide(int oneBasedIndex) {
    assert(oneBasedIndex >= 1 && oneBasedIndex <= onboardingSlideCount);
    final n = oneBasedIndex.toString().padLeft(2, '0');
    return 'assets/onboarding/onboarding_$n.jpg';
  }

  static List<String> get onboardingSlides => List<String>.generate(
        onboardingSlideCount,
        (i) => onboardingSlide(i + 1),
      );
}
