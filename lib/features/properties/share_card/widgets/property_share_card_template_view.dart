import 'package:flutter/material.dart';

import '../code_themes/code_share_card_context.dart';
import '../code_themes/code_share_card_factory.dart';
import '../models/share_card_layout_data.dart';
import '../models/share_card_theme_definition.dart';
import 'raster_property_share_card_template_view.dart';

/// İlan paylaşım kartı: `theme_01`–`theme_15` saf Flutter; `hestora_*` PNG şablon.
///
/// [listingImageAlignment] yalnızca ilan fotoğrafı için kullanılır.
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
  final Alignment? listingImageAlignment;

  @override
  Widget build(BuildContext context) {
    if (isFlutterCodeShareTheme(theme.id)) {
      final align = listingImageAlignment ?? theme.mainImage.templateAlignment();
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          width: width,
          height: height,
          child: buildFlutterCodeShareCard(
            theme: theme,
            data: data,
            width: width,
            height: height,
            listingImageAlignment: align,
          ),
        ),
      );
    }
    return RasterPropertyShareCardTemplateView(
      theme: theme,
      data: data,
      width: width,
      height: height,
      listingImageAlignment: listingImageAlignment,
    );
  }
}
