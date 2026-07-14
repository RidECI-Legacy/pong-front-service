import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../passenger/components/glass_card.dart';
import '../../passenger/components/statistic_card.dart';
import '../../passenger/theme.dart';
import '../components/co2_chart_card.dart';

/// SECTION "Estadísticas": earnings/rating/impact snapshot, the CO₂ chart
/// and earned badges.
class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = MockData.driverStats;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatisticCard(
          title: 'Tus estadísticas',
          icon: Icons.bar_chart_rounded,
          stats: [
            StatEntry(icon: Icons.route_rounded, value: stats.tripsCompleted, label: 'Viajes completados'),
            StatEntry(icon: Icons.star_rounded, value: stats.rating.round(), label: 'Calificación', color: const Color(0xFFFBBF24)),
            StatEntry(icon: Icons.eco_rounded, value: stats.co2Kg, suffix: 'kg', label: 'CO₂ ahorrado'),
            StatEntry(icon: Icons.savings_rounded, value: stats.earningsCop ~/ 1000, suffix: 'k', label: 'Ganancias del mes'),
          ],
        ),
        const SizedBox(height: 24),
        Co2ChartCard(points: MockData.co2ByMonthDriver),
        const SizedBox(height: 24),
        GlassCard(
          radius: 22,
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('DISTINTIVOS', style: LandingType.eyebrow(color: LandingColors.textTertiary).copyWith(fontSize: 10.5)),
              const SizedBox(height: 16),
              for (final d in MockData.driverDistintivos) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: LandingColors.warning.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(11)),
                      child: Icon(d.icon, size: 18, color: LandingColors.warning),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(d.label, style: LandingType.cardTitle(size: 13)),
                          Text(d.description, style: LandingType.body(size: 11.5, color: LandingColors.textTertiary)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
