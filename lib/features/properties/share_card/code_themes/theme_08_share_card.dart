import 'package:flutter/material.dart';

import 'code_share_card_bits.dart';
import 'code_share_card_context.dart';

/// Tema 8 — kare, ahşap hissi arka plan + dairesel görseller + dalgalı alt alan.
class Theme08ShareCard extends StatelessWidget {
  const Theme08ShareCard({super.key, required this.ctx});

  final CodeShareCardContext ctx;

  @override
  Widget build(BuildContext context) {
    final s = ctx.scale;
    final urls = galleryUrls(ctx);
    final main = urls.isNotEmpty ? urls.first : ctx.data.effectiveMainImageUrl;
    return CustomPaint(
      painter: _WoodPainter(),
      child: Stack(
        children: [
          Positioned(
            left: -ctx.width * 0.08,
            top: ctx.height * 0.06,
            child: _circle(ctx, main, ctx.width * 0.42, thickBorder: true),
          ),
          Positioned(
            right: ctx.width * 0.08,
            top: ctx.height * 0.1,
            child: _circle(ctx, pickGalleryUrl(ctx, 1) ?? main, ctx.width * 0.28, thickBorder: false),
          ),
          Positioned(
            left: ctx.width * 0.28,
            top: ctx.height * 0.28,
            child: _circle(ctx, pickGalleryUrl(ctx, 2) ?? main, ctx.width * 0.22, thickBorder: true, lightBorder: true),
          ),
          Positioned(
            left: 12 * s,
            top: ctx.height * 0.42,
            child: Column(
              children: List.generate(
                5,
                (_) => Padding(
                  padding: EdgeInsets.only(bottom: 6 * s),
                  child: Icon(Icons.keyboard_arrow_down_rounded, size: 14 * s, color: Colors.black54),
                ),
              ),
            ),
          ),
          Positioned(
            right: 10 * s,
            bottom: 10 * s,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(ctx.data.title, style: TextStyle(fontSize: 11 * s, fontWeight: FontWeight.w800, color: Colors.black87)),
                    SizedBox(height: 4 * s),
                    codeFeaturesCaption(ctx, fontSize: 9, color: Colors.black87, align: TextAlign.end),
                    SizedBox(height: 2 * s),
                    if ((ctx.data.locationLine ?? '').trim().isNotEmpty)
                      Text(
                        ctx.data.locationLine!.trim(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 8.5 * s, color: Colors.black54),
                      ),
                    SizedBox(height: 4 * s),
                    Text(ctx.data.priceLine, style: TextStyle(fontSize: 13 * s, fontWeight: FontWeight.w900, color: Colors.brown.shade800)),
                  ],
                ),
                SizedBox(width: 8 * s),
                Container(
                  padding: EdgeInsets.all(8 * s),
                  decoration: const BoxDecoration(color: Color(0xFF424242), shape: BoxShape.circle),
                  child: Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 16 * s),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circle(CodeShareCardContext c, String? url, double d, {required bool thickBorder, bool lightBorder = false}) {
    if (url == null || url.isEmpty) {
      return Container(
        width: d,
        height: d,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade300,
          border: Border.all(color: lightBorder ? Colors.white : const Color(0xFF424242), width: thickBorder ? 5 : 1),
        ),
      );
    }
    return Container(
      width: d,
      height: d,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: lightBorder ? Colors.white : const Color(0xFF424242), width: thickBorder ? 5 : 1),
      ),
      child: ClipOval(child: codeListingImage(c, url, borderRadius: d / 2)),
    );
  }
}

class _WoodPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final base = Paint()..color = const Color(0xFFF2EEE9);
    canvas.drawRect(Offset.zero & size, base);
    final line = Paint()
      ..color = const Color(0x1A000000)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 14) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    }
    final wave = Path()
      ..moveTo(size.width * 0.35, size.height * 0.72)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.68, size.width, size.height * 0.76)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * 0.25, size.height)
      ..close();
    canvas.drawPath(wave, Paint()..color = const Color(0xFF5D5D5A));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
