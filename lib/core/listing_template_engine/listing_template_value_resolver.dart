import 'models/listing_data.dart';
import 'models/listing_template_document.dart';

/// Maps [ListingTemplateBind] keys to concrete strings / URLs for a row.
class ListingTemplateValueResolver {
  const ListingTemplateValueResolver(this.data);

  final ListingData data;

  String? textFor(ListingTemplateBind bind) {
    return switch (bind) {
      ListingTemplateBind.title => data.title,
      ListingTemplateBind.price => data.price,
      ListingTemplateBind.roomCount => data.roomCount?.toString(),
      ListingTemplateBind.area => data.area,
      ListingTemplateBind.location => data.location,
      ListingTemplateBind.phone => data.phone,
      ListingTemplateBind.mainImage => null,
      ListingTemplateBind.imageUrl => null,
      ListingTemplateBind.logo => null,
    };
  }

  String? imageUrlFor(ListingTemplateBind bind, {required int imageIndex}) {
    return switch (bind) {
      ListingTemplateBind.mainImage => data.imageUrls.isNotEmpty ? data.imageUrls.first : null,
      ListingTemplateBind.imageUrl =>
        imageIndex >= 0 && imageIndex < data.imageUrls.length ? data.imageUrls[imageIndex] : null,
      ListingTemplateBind.logo => data.logoUrl,
      _ => null,
    };
  }
}
