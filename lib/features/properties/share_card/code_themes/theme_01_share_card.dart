import 'package:flutter/material.dart';

import 'code_share_card_bits.dart';
import 'code_share_card_context.dart';

/// Tema 1 — dikey lacivert / gökyüzü / sağda bilgi kartı (Flutter).
class Theme01ShareCard extends StatelessWidget {
  const Theme01ShareCard({super.key, required this.ctx});

  final CodeShareCardContext ctx;

  static const _navy = Color(0xFF1A237E);
  static const _royal = Color(0xFF3D5AFE);

  @override
  Widget build(BuildContext context) {
    final s = ctx.scale;
    final main = ctx.data.effectiveMainImageUrl;
    return ColoredBox(
      color: _navy,
      child: Column(
        children: [
          SizedBox(height: 8 * s),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10 * s),
            child: DecoratedBox(
              decoration: BoxDecoration(color: _royal, borderRadius: BorderRadius.circular(14 * s)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8 * s, horizontal: 6 * s),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    codeFeatureIconRow(ctx),
                    SizedBox(height: 4 * s),
                    codeFeaturesCaption(ctx, fontSize: 8.2, color: Colors.white.withValues(alpha: 0.9)),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 6 * s),
          Expanded(
            flex: 11,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [_navy, Color(0xFF3949AB)],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          const CodeShareSkyHillsLayer(skyBottomFraction: 0.72),
                          if (main != null && main.isNotEmpty)
                            Positioned.fill(
                              child: Padding(
                                padding: EdgeInsets.only(right: ctx.width * 0.38, top: 6 * s, left: 8 * s),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12 * s),
                                  child: codeListingImage(ctx, main, borderRadius: 12 * s),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 8 * s,
                  top: ctx.height * 0.08,
                  width: ctx.width * 0.36,
                  bottom: ctx.height * 0.28,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16 * s),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.18), blurRadius: 12 * s)],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10 * s),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 4 / 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10 * s),
                              child: main != null && main.isNotEmpty
                                  ? codeListingImage(ctx, main, borderRadius: 10 * s)
                                  : Container(color: const Color(0xFFEEEEEE)),
                            ),
                          ),
                          SizedBox(height: 8 * s),
                          Text(
                            ctx.data.listingTypeLabel,
                            style: TextStyle(
                              color: ctx.theme.accentColor,
                              fontSize: 10 * s,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                            ),
                          ),
                          SizedBox(height: 4 * s),
                          Text(
                            ctx.data.title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: ctx.theme.titleColor == Colors.white ? const Color(0xFF1A237E) : ctx.theme.titleColor,
                              fontSize: 13 * s,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                            ),
                          ),
                          SizedBox(height: 6 * s),
                          codeFeaturesCaption(
                            ctx,
                            fontSize: 9,
                            color: Colors.blueGrey.shade800,
                            align: TextAlign.start,
                            maxLines: 2,
                          ),
                          SizedBox(height: 4 * s),
                          codeDescriptionBlock(
                            ctx,
                            maxLines: 3,
                            fontSize: 9,
                            color: Colors.blueGrey.shade700,
                          ),
                          const Spacer(),
                          Text(
                            ctx.data.priceLine,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: ctx.theme.priceColor,
                              fontSize: 16 * s,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          if ((ctx.data.locationLine ?? '').trim().isNotEmpty) ...[
                            SizedBox(height: 4 * s),
                            Text(
                              ctx.data.locationLine!.trim(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.blueGrey.shade700, fontSize: 10 * s),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: ctx.height * 0.22,
                  left: ctx.width * 0.32,
                  right: ctx.width * 0.32,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFAB00),
                      borderRadius: BorderRadius.circular(20 * s),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6 * s, horizontal: 12 * s),
                      child: Text(
                        ctx.data.priceLine,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.brown.shade900, fontSize: 12 * s, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10 * s, 6 * s, 10 * s, 10 * s),
            child: DecoratedBox(
              decoration: BoxDecoration(color: _royal, borderRadius: BorderRadius.circular(14 * s)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10 * s, horizontal: 16 * s),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 22 * s),
                    SizedBox(width: 6 * s),
                    Icon(Icons.mail_outline_rounded, color: Colors.white, size: 20 * s),
                    SizedBox(width: 6 * s),
                    Icon(Icons.language_rounded, color: Colors.white, size: 22 * s),
                    SizedBox(width: 8 * s),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if ((ctx.data.agentPhone ?? '').trim().isNotEmpty)
                            Text(
                              ctx.data.agentPhone!.trim(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: TextStyle(color: Colors.white, fontSize: 9.5 * s, fontWeight: FontWeight.w600),
                            ),
                          if ((ctx.data.agentEmail ?? '').trim().isNotEmpty) ...[
                            SizedBox(height: 2 * s),
                            Text(
                              ctx.data.agentEmail!.trim(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: TextStyle(color: Colors.white70, fontSize: 8.5 * s),
                            ),
                          ],
                          if ((ctx.data.websiteFallbackLine ?? '').trim().isNotEmpty) ...[
                            SizedBox(height: 2 * s),
                            Text(
                              ctx.data.websiteFallbackLine!.trim(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: TextStyle(color: Colors.white54, fontSize: 8 * s),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
