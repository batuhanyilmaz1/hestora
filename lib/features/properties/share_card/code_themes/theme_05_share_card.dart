import 'package:flutter/material.dart';

import 'code_share_card_bits.dart';
import 'code_share_card_context.dart';

/// Tema 5 — üst hero, ortada metin + sağda üç küçük görsel, alt iletişim şeridi.
class Theme05ShareCard extends StatelessWidget {
  const Theme05ShareCard({super.key, required this.ctx});

  final CodeShareCardContext ctx;

  static const _footer = Color(0xFF263238);

  @override
  Widget build(BuildContext context) {
    final s = ctx.scale;
    final main = ctx.data.effectiveMainImageUrl;
    final u1 = pickGalleryUrl(ctx, 1);
    final u2 = pickGalleryUrl(ctx, 2);
    final u3 = pickGalleryUrl(ctx, 3);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 5,
          child: main != null && main.isNotEmpty
              ? codeListingImage(ctx, main, borderRadius: 0)
              : ColoredBox(color: Colors.blue.shade100),
        ),
        Expanded(
          flex: 4,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ColoredBox(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(10 * s),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10 * s, vertical: 6 * s),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD2B48C),
                            borderRadius: BorderRadius.circular(6 * s),
                          ),
                          child: Text(
                            ctx.data.priceLine,
                            style: TextStyle(color: Colors.brown.shade900, fontSize: 12 * s, fontWeight: FontWeight.w900),
                          ),
                        ),
                        SizedBox(height: 8 * s),
                        Text('•', style: TextStyle(fontSize: 14 * s)),
                        SizedBox(height: 6 * s),
                        Text(
                          ctx.data.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black87, fontSize: 12 * s, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(height: 6 * s),
                        codeFeaturesCaption(ctx, fontSize: 10, color: Colors.black87, align: TextAlign.start),
                        SizedBox(height: 4 * s),
                        codeDescriptionBlock(ctx, maxLines: 3, fontSize: 9.5, color: Colors.black54),
                        const Spacer(),
                        Text(ctx.data.locationLine ?? '', style: TextStyle(color: Colors.black45, fontSize: 10 * s)),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: ctx.width * 0.38,
                color: _footer,
                padding: EdgeInsets.symmetric(vertical: 6 * s, horizontal: 4 * s),
                child: Column(
                  children: [
                    Expanded(child: _thumb(ctx, u1 ?? main)),
                    Divider(color: Colors.white24, height: 4 * s),
                    Expanded(child: _thumb(ctx, u2 ?? main)),
                    Divider(color: Colors.white24, height: 4 * s),
                    Expanded(child: _thumb(ctx, u3 ?? main)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 44 * s,
          color: _footer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 20 * s),
              Icon(Icons.language_rounded, color: Colors.white, size: 20 * s),
              Icon(Icons.location_on_rounded, color: Colors.white, size: 20 * s),
            ],
          ),
        ),
      ],
    );
  }

  Widget _thumb(CodeShareCardContext c, String? url) {
    if (url == null || url.isEmpty) {
      return ColoredBox(color: Colors.white10);
    }
    return Padding(
      padding: const EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: codeListingImage(c, url, borderRadius: 4),
      ),
    );
  }
}
