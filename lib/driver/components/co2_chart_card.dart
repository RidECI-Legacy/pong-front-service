import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/models.dart';
import '../../passenger/components/glass_card.dart';
import '../../passenger/theme.dart';

/// Minimal animated bar chart card — CO2 saved per month — matching the
/// "Charts: dark background, rounded, minimal grid, animated values" spec
/// from the design system.
class Co2ChartCard extends StatelessWidget {
  final List<Co2MonthPoint> points;
  const Co2ChartCard({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    final maxKg = points.map((p) => p.kg).reduce((a, b) => a > b ? a : b);
    return GlassCard(
      radius: 22,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: LandingColors.success.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.eco_rounded, size: 20, color: LandingColors.success),
              ),
              const SizedBox(width: 12),
              Text('CO₂ ahorrado por mes', style: LandingType.cardTitle(size: 16)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final p in points)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${p.kg.toStringAsFixed(0)}kg', style: LandingType.body(size: 10, color: LandingColors.textTertiary).copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 8 + (p.kg / maxKg) * 60),
                            duration: const Duration(milliseconds: 900),
                            curve: Curves.easeOutCubic,
                            builder: (context, height, _) => ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                height: height,
                                decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [LandingColors.success, LandingColors.accent])),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(p.label, style: LandingType.body(size: 10.5, color: LandingColors.textTertiary).copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, curve: Curves.easeOutCubic);
  }
}
