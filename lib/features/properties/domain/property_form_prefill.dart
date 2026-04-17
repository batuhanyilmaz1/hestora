/// Passed via [GoRouterState.extra] when opening [PropertyFormPage] after OG import.
class PropertyFormPrefill {
  const PropertyFormPrefill({
    this.title,
    this.description,
    this.listingUrl,
    this.ogImageUrl,
  });

  final String? title;
  final String? description;
  final String? listingUrl;
  final String? ogImageUrl;
}
