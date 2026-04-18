import 'package:flutter/material.dart';

import 'code_share_card_bits.dart';
import 'code_share_card_context.dart';

/// Tema 6 — üst beyaz + sağda büyük görsel, alt kahverengi soyut alan.
class Theme06ShareCard extends StatelessWidget {
  const Theme06ShareCard({super.key, required this.ctx});

  final CodeShareCardContext ctx;

  static const _brown = Color(0xFF3E322E);
  static const _tan = Color(0xFFC4A574);

  @override
  Widget build(BuildContext context) {
    final s = ctx.scale;
    final main = ctx.data.effectiveMainImageUrl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 35,
          child: ColoredBox(
            color: Colors.white,
            child: Stack(
              children: [
                Positioned(
                  right: 10 * s,
                  top: 12 * s,
                  bottom: 8 * s,
                  width: ctx.width * 0.42,
                  child: main != null && main.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16 * s),
                          child: codeListingImage(ctx, main, borderRadius: 16 * s),
                        )
                      : DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.circular(16 * s),
                          ),
                        ),
                ),
                Positioned(left: 12 * s, top: 14 * s, child: _blob(s)),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 65,
          child: ColoredBox(
            color: _brown,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -18 * s,
                  left: 14 * s,
                  right: 14 * s,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14 * s),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8 * s)],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12 * s, vertical: 10 * s),
                      child: Text(
                        ctx.data.priceLine,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: _brown, fontSize: 15 * s, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 14 * s,
                  right: 14 * s,
                  top: 36 * s,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ctx.data.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 14 * s, fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: 8 * s),
                      Text(
                        ctx.data.featuresLine,
                        style: TextStyle(color: Colors.white70, fontSize: 11 * s),
                      ),
                      if ((ctx.data.locationLine ?? '').trim().isNotEmpty) ...[
                        SizedBox(height: 6 * s),
                        Text(
                          ctx.data.locationLine!.trim(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white60, fontSize: 10 * s),
                        ),
                      ],
                      SizedBox(height: 8 * s),
                      codeDescriptionBlock(ctx, maxLines: 4, fontSize: 9.5, color: Colors.white54),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 14 * s,
                  left: 14 * s,
                  child: Row(
                    children: [
                      _circleIcon(Icons.phone_rounded, s),
                      SizedBox(width: 12 * s),
                      _circleIcon(Icons.mail_outline_rounded, s),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 14 * s,
                  right: 14 * s,
                  child: Text(
                    [
                      if ((ctx.data.agentPhone ?? '').trim().isNotEmpty) ctx.data.agentPhone!.trim(),
                      if ((ctx.data.agentEmail ?? '').trim().isNotEmpty) ctx.data.agentEmail!.trim(),
                      if ((ctx.data.agentName ?? '').trim().isNotEmpty) ctx.data.agentName!.trim(),
                    ].join('\n'),
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.white70, fontSize: 9 * s, height: 1.25),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _blob(double s) {
    return Container(
      width: 40 * s,
      height: 28 * s,
      decoration: BoxDecoration(
        color: _brown.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20 * s),
        border: Border.all(color: _tan.withValues(alpha: 0.6)),
      ),
    );
  }

  Widget _circleIcon(IconData d, double s) {
    return Container(
      padding: EdgeInsets.all(8 * s),
      decoration: BoxDecoration(color: _tan.withValues(alpha: 0.35), shape: BoxShape.circle),
      child: Icon(d, color: Colors.white, size: 16 * s),
    );
  }
}
