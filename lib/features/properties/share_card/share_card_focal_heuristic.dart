import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as im;

/// Deterministic focal hint (no ML): 4×4 grid, highest luminance-variance cell → [Alignment].
Alignment shareCardFocalSuggestAlignment(Uint8List bytes) {
  im.Image? decoded;
  try {
    decoded = im.decodeImage(bytes);
  } catch (_) {
    return Alignment.center;
  }
  if (decoded == null) {
    return Alignment.center;
  }

  const targetW = 200;
  final small = decoded.width > targetW ? im.copyResize(decoded, width: targetW) : decoded;
  final w = small.width;
  final h = small.height;
  if (w < 8 || h < 8) {
    return Alignment.center;
  }

  const gw = 4;
  const gh = 4;

  var bestScore = -1.0;
  var bestI = 1;
  var bestJ = 1;

  for (var j = 0; j < gh; j++) {
    for (var i = 0; i < gw; i++) {
      final score = _cellVariance(small, i, j, gw, gh);
      if (score > bestScore) {
        bestScore = score;
        bestI = i;
        bestJ = j;
      }
    }
  }

  final nx = (bestI + 0.5) / gw;
  final ny = (bestJ + 0.5) / gh;
  const strength = 0.92;
  return Alignment((nx - 0.5) * 2 * strength, (ny - 0.5) * 2 * strength);
}

double _cellVariance(im.Image img, int ci, int cj, int gw, int gh) {
  final w = img.width;
  final h = img.height;
  final x0 = (ci * w / gw).floor();
  final x1 = ((ci + 1) * w / gw).ceil().clamp(1, w);
  final y0 = (cj * h / gh).floor();
  final y1 = ((cj + 1) * h / gh).ceil().clamp(1, h);

  final lums = <double>[];
  const step = 3;
  for (var y = y0; y < y1; y += step) {
    for (var x = x0; x < x1; x += step) {
      final p = img.getPixelSafe(x, y);
      if (!p.isValid) {
        continue;
      }
      lums.add(p.luminance.toDouble());
    }
  }
  if (lums.length < 2) {
    return 0;
  }
  final mean = lums.reduce((a, b) => a + b) / lums.length;
  var acc = 0.0;
  for (final v in lums) {
    final d = v - mean;
    acc += d * d;
  }
  return acc / lums.length;
}

Future<Alignment> shareCardFocalSuggestAlignmentAsync(Uint8List bytes) {
  return compute(shareCardFocalSuggestAlignment, bytes);
}
