import 'package:flutter_test/flutter_test.dart';
import 'package:hestora/core/listing_template_engine/listing_template_json.dart';
import 'package:hestora/core/listing_template_engine/listing_template_value_resolver.dart';
import 'package:hestora/core/listing_template_engine/models/listing_data.dart';
import 'package:hestora/core/listing_template_engine/models/listing_template_document.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('ListingTemplateJson parses sample asset', () async {
    final doc = await ListingTemplateJson.parseAsset('assets/themes/json/listing_square_sample.json');
    expect(doc.id, 'json_square_sample');
    expect(doc.fields.length, greaterThan(3));
    expect(doc.fields.where((f) => f.kind == ListingTemplateFieldKind.text), isNotEmpty);
  });

  test('ListingTemplateValueResolver maps CRM fields', () {
    const data = ListingData(
      id: '1',
      title: 'T',
      price: '100 TRY',
      roomCount: 3,
      area: '120 m²',
      location: 'X',
      phone: '555',
      imageUrls: ['https://example.com/a.jpg', 'https://example.com/b.jpg'],
      logoUrl: 'https://example.com/logo.png',
    );
    final r = ListingTemplateValueResolver(data);
    expect(r.textFor(ListingTemplateBind.title), 'T');
    expect(r.textFor(ListingTemplateBind.roomCount), '3');
    expect(r.imageUrlFor(ListingTemplateBind.mainImage, imageIndex: 0), 'https://example.com/a.jpg');
    expect(r.imageUrlFor(ListingTemplateBind.imageUrl, imageIndex: 1), 'https://example.com/b.jpg');
    expect(r.imageUrlFor(ListingTemplateBind.logo, imageIndex: 0), 'https://example.com/logo.png');
  });
}
