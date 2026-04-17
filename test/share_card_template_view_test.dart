import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hestora/features/properties/share_card/models/share_card_layout_data.dart';
import 'package:hestora/features/properties/share_card/share_card_themes.dart';
import 'package:hestora/features/properties/share_card/widgets/property_share_card_template_view.dart';

void main() {
  testWidgets('PropertyShareCardTemplateView shows mock title', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PropertyShareCardTemplateView(
            theme: shareCardThemes.first,
            data: ShareCardLayoutData.mockSample(),
            width: 360,
            height: 640,
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.textContaining('Sea-view'), findsOneWidget);
  });
}
