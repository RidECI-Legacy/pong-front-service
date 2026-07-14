import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../components/community_rating_card.dart';
import '../components/glass_card.dart';
import '../components/profile_avatar.dart';
import '../components/statistic_card.dart';
import '../theme.dart';

/// SECTION "Mi Perfil": identity, badges, community rating and impact.
class ProfileSection extends StatelessWidget {
  final RiderProfile rider;
  const ProfileSection({super.key, required this.rider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassCard(
          radius: 20,
          child: Row(
            children: [
              ProfileAvatar(name: rider.name, size: 56, background: LandingColors.success, ring: true),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(rider.name, style: LandingType.cardTitle(size: 19)),
                    const SizedBox(height: 4),
                    Text(rider.faculty, style: LandingType.body(size: 12.5)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 15, color: Color(0xFFFBBF24)),
                        const SizedBox(width: 4),
                        Text('${rider.rating} · ${rider.trips} viajes', style: LandingType.body(size: 12.5, color: LandingColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 320.ms).slideY(begin: 0.06, curve: Curves.easeOutCubic),
        const SizedBox(height: 24),
        Text('Distintivos', style: LandingType.cardTitle(size: 16)),
        const SizedBox(height: 14),
        LayoutBuilder(builder: (context, constraints) {
          final columns = constraints.maxWidth < 700 ? 1 : 3;
          final gap = 14.0;
          final width = (constraints.maxWidth - (columns - 1) * gap) / columns;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (final indexed in MockData.passengerDistintivos.asMap().entries)
                SizedBox(
                  width: width,
                  child: GlassCard(
                    radius: 16,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: LandingColors.warning.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(11)),
                          child: Icon(indexed.value.icon, size: 18, color: LandingColors.warning),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(indexed.value.label, style: LandingType.cardTitle(size: 12.5)),
                              Text(indexed.value.description, style: LandingType.body(size: 11, color: LandingColors.textTertiary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate(delay: (60 * indexed.key).ms).fadeIn(duration: 280.ms).slideY(begin: 0.06, curve: Curves.easeOutCubic),
            ],
          );
        }),
        const SizedBox(height: 24),
        LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 900;
          final rating = CommunityRatingCard(
            rating: rider.rating,
            completedRides: rider.trips,
            reviews: const [
              ReviewSnippet(author: 'Camilo Rojas', rating: 5, comment: 'Excelente pasajera, muy puntual.'),
            ],
          );
          final impact = StatisticCard(
            title: 'Tu impacto',
            icon: Icons.eco_rounded,
            stats: [
              StatEntry(icon: Icons.eco_rounded, value: rider.co2Kg, suffix: 'kg', label: 'CO₂ ahorrado'),
              StatEntry(icon: Icons.savings_rounded, value: rider.savedCop ~/ 1000, suffix: 'k', label: 'Ahorrado'),
              StatEntry(icon: Icons.directions_car_rounded, value: rider.trips, label: 'Viajes'),
            ],
          );
          if (isMobile) return Column(children: [rating, const SizedBox(height: 20), impact]);
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: rating), const SizedBox(width: 20), Expanded(child: impact)]);
        }),
      ],
    );
  }
}
