import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../passenger/components/glass_card.dart';
import '../../passenger/components/section_title.dart';
import '../../passenger/theme.dart';

/// SECTION "Estadísticas": community-wide impact numbers, role
/// participation and the badges the community has earned.
class AdminStatsSection extends StatelessWidget {
  const AdminStatsSection({super.key});

  static const _roleBreakdown = [
    ('Pasajeros', 0.52, LandingColors.success),
    ('Conductores', 0.31, Color(0xFF8C86E0)),
    ('Acompañantes', 0.17, LandingColors.warning),
  ];

  static const _badges = [
    (Icons.emoji_events_rounded, 'Conductor confiable', 64, LandingColors.success),
    (Icons.favorite_rounded, 'Amigable', 128, LandingColors.danger),
    (Icons.timeline_rounded, 'Pasajero frecuente', 91, LandingColors.primaryLight),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(icon: Icons.query_stats_rounded, title: 'Estadísticas y sostenibilidad', subtitle: 'Impacto ambiental y participación de la comunidad', accent: LandingColors.success),
        const SizedBox(height: 20),
        LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth;
          int columns = 4;
          if (width < 860) columns = 2;
          if (width < 480) columns = 1;
          final gap = 16.0;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (final stat in MockData.impactStatsFooter)
                SizedBox(
                  width: (width - (columns - 1) * gap) / columns,
                  child: GlassCard(
                    radius: 18,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(stat.value, style: LandingType.cardTitle(size: 24, color: LandingColors.success)),
                        const SizedBox(height: 4),
                        Text(stat.label, style: LandingType.body(size: 12)),
                      ],
                    ),
                  ),
                ),
            ],
          );
        }),
        const SizedBox(height: 20),
        LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 860;
          final breakdown = GlassCard(
            radius: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PARTICIPACIÓN POR ROL', style: LandingType.eyebrow(color: LandingColors.textTertiary).copyWith(fontSize: 10.5)),
                const SizedBox(height: 18),
                for (final r in _roleBreakdown) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(r.$1, style: const TextStyle(color: LandingColors.textPrimary, fontSize: 12.5, fontWeight: FontWeight.w600)),
                      Text('${(r.$2 * 100).round()}%', style: TextStyle(color: r.$3, fontSize: 12.5, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: r.$2),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) => LinearProgressIndicator(
                        value: value,
                        minHeight: 8,
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                        valueColor: AlwaysStoppedAnimation(r.$3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
              ],
            ),
          );

          final badges = GlassCard(
            radius: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DISTINTIVOS OTORGADOS', style: LandingType.eyebrow(color: LandingColors.textTertiary).copyWith(fontSize: 10.5)),
                const SizedBox(height: 16),
                for (final b in _badges) ...[
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: b.$4.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(9)),
                        child: Icon(b.$1, size: 16, color: b.$4),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(b.$2, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: LandingColors.textPrimary))),
                      Text('${b.$3}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: b.$4)),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          );

          if (isMobile) {
            return Column(children: [breakdown, const SizedBox(height: 16), badges]);
          }
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [Expanded(child: breakdown), const SizedBox(width: 16), Expanded(child: badges)],
            ),
          );
        }),
      ],
    );
  }
}
