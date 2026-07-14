import 'package:flutter/material.dart';

import '../../data/car_colors.dart';
import '../../passenger/components/glass_card.dart';
import '../../passenger/theme.dart';

/// A large, photo-forward vehicle card: gradient-tinted car image, brand +
/// model, rating and a row of spec chips (plate, seats, etc.) — the
/// driver's equivalent of the passenger's favorite-driver card.
class VehicleShowcaseCard extends StatelessWidget {
  final String brandModel;
  final double rating;
  final CarColor carColor;
  final List<(IconData, String)> specs;
  final bool verified;

  const VehicleShowcaseCard({
    super.key,
    required this.brandModel,
    required this.rating,
    required this.carColor,
    required this.specs,
    this.verified = true,
  });

  @override
  Widget build(BuildContext context) {
    final style = carColorStyles[carColor]!;
    return GlassCard(
      radius: 22,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: style.gradient),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: style.glow.withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 12))],
              ),
              padding: const EdgeInsets.all(14),
              child: Image.asset(style.assetPath, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(brandModel, style: LandingType.cardTitle(size: 16), overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFBBF24)),
                        const SizedBox(width: 3),
                        Text('$rating', style: LandingType.body(size: 12.5, color: LandingColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: (verified ? LandingColors.success : LandingColors.warning).withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: (verified ? LandingColors.success : LandingColors.warning).withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(verified ? Icons.verified_rounded : Icons.hourglass_empty_rounded, size: 12, color: verified ? LandingColors.success : LandingColors.warning),
                    const SizedBox(width: 4),
                    Text(
                      verified ? 'Verificado' : 'Pendiente',
                      style: TextStyle(color: verified ? LandingColors.success : LandingColors.warning, fontSize: 10.5, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final spec in specs)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(spec.$1, size: 13, color: LandingColors.textTertiary),
                      const SizedBox(width: 6),
                      Text(spec.$2, style: LandingType.body(size: 11.5, color: LandingColors.textSecondary)),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
