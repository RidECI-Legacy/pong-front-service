import 'package:flutter/material.dart';

import '../../data/car_colors.dart';
import '../../data/models.dart';
import '../theme.dart';
import 'buttons.dart';
import 'glass_card.dart';
import 'profile_avatar.dart';

/// Favorite-driver card: photo, name, rating, a colored vehicle thumbnail
/// (matching the car's real color/photo, as used across the rest of the
/// app), trips shared together and a "Ver Perfil" button.
class FavoriteDriverCard extends StatelessWidget {
  final TripOffer driver;
  final int tripsTogether;
  final VoidCallback onViewProfile;

  const FavoriteDriverCard({super.key, required this.driver, required this.tripsTogether, required this.onViewProfile});

  @override
  Widget build(BuildContext context) {
    final carStyle = carColorStyles[driver.carColor]!;
    return SizedBox(
      width: 220,
      child: GlassCard(
        radius: 18,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                ProfileAvatar(name: driver.driverName, size: 44, background: LandingColors.accent),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(driver.driverName, style: LandingType.cardTitle(size: 13), overflow: TextOverflow.ellipsis),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 12, color: Color(0xFFFBBF24)),
                          const SizedBox(width: 3),
                          Text('${driver.rating}', style: LandingType.body(size: 11.5, color: LandingColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 52,
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: carStyle.gradient),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: carStyle.glow.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Image.asset(carStyle.assetPath, fit: BoxFit.contain),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(driver.car, style: LandingType.body(size: 11.5, color: LandingColors.textPrimary).copyWith(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                      Row(
                        children: [
                          Icon(Icons.route_outlined, size: 11, color: LandingColors.textTertiary),
                          const SizedBox(width: 4),
                          Expanded(child: Text('$tripsTogether viajes juntos', style: LandingType.body(size: 10.5), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SecondaryButton(label: 'Ver Perfil', onTap: onViewProfile, expand: true),
          ],
        ),
      ),
    );
  }
}
