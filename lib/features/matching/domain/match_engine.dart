import '../../customers/domain/customer.dart';
import '../../properties/domain/property.dart';

/// Deterministic compatibility score (0–100). Strong match ≥ 75.
abstract final class MatchEngine {
  static const double strongMatchThreshold = 75;

  static double score(Customer c, Property p) {
    double s = 0;

    final loc = (c.preferredLocation ?? '').trim().toLowerCase();
    final ploc = (p.location ?? '').trim().toLowerCase();
    if (loc.isNotEmpty && ploc.isNotEmpty) {
      if (ploc.contains(loc) || loc.contains(ploc)) {
        s += 28;
      } else {
        final locTokens = loc.split(RegExp(r'\s+')).where((e) => e.length > 2).toSet();
        final pTokens = ploc.split(RegExp(r'\s+')).where((e) => e.length > 2).toSet();
        final overlap = locTokens.intersection(pTokens);
        if (overlap.isNotEmpty) {
          s += 14;
        }
      }
    }

    final intent = (c.listingIntent ?? '').toLowerCase();
    if (intent.contains('rent') || intent.contains('kira')) {
      if (p.listingType == 'rent') {
        s += 26;
      }
    } else if (intent.contains('sale') || intent.contains('sat')) {
      if (p.listingType == 'sale') {
        s += 26;
      }
    } else {
      s += 10;
    }

    final price = p.price;
    if (price != null) {
      final maxB = c.budgetMax;
      final minB = c.budgetMin;
      if (maxB != null) {
        if (price <= maxB) {
          s += 22;
        } else if (price <= maxB * 1.2) {
          s += 12;
        }
      }
      if (minB != null && price >= minB) {
        s += 6;
      }
    }

    final cr = c.roomCount;
    final pr = p.roomCount;
    if (cr != null && pr != null && cr == pr) {
      s += 14;
    }

    final ca = c.areaMinSqm;
    final pa = p.areaSqm;
    if (ca != null && pa != null && pa >= ca) {
      s += 8;
    }
    final cmax = c.areaMaxSqm;
    if (cmax != null && pa != null && pa <= cmax) {
      s += 4;
    }

    if (s > 100) {
      return 100;
    }
    return s;
  }

  static bool isStrong(double score) => score >= strongMatchThreshold;
}
