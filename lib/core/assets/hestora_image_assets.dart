/// Bundled marketing / handoff images (see `assets/onboarding`).
abstract final class HestoraImageAssets {
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
