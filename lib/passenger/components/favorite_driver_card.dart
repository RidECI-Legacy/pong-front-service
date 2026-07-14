import 'package:flutter/material.dart';

import '../../data/car_colors.dart';
import '../../data/models.dart';
import '../theme.dart';
import 'buttons.dart';
import 'glass_card.dart';
import 'profile_avatar.dart';

/// A favorite driver plus the extra context that makes the "Favoritos"
/// screen useful at a glance — trips shared, when you last rode together,
/// whether they're online right now, and an earned badge — without
/// touching the core data models used by the rest of the app.
class FavoriteDriverEntry {
  final TripOffer driver;
  final int tripsTogether;
  final String lastTripLabel;
  final String? badge;
  final bool onlineNow;

  const FavoriteDriverEntry({
    required this.driver,
    required this.tripsTogether,
    required this.lastTripLabel,
    this.badge,
    this.onlineNow = false,
  });
}

/// Favorite-driver card: a car-colored accent bar, photo with live-status
/// dot, rating, a reputation badge, vehicle thumbnail, usual route, trips
/// shared together, last trip together, a one-tap "quitar de favoritos"
/// toggle and quick actions (message / profile). Every field already
/// exists on the underlying trip data — this just puts it on screen so the
/// card reads as a small dossier instead of a mostly-empty tile.
class FavoriteDriverCard extends StatelessWidget {
  final FavoriteDriverEntry entry;
  final VoidCallback onViewProfile;
  final VoidCallback onMessage;
  final VoidCallback onToggleFavorite;

  const FavoriteDriverCard({
    super.key,
    required this.entry,
    required this.onViewProfile,
    required this.onMessage,
    required this.onToggleFavorite,
  });

  (String, Color) get _tier {
    final rating = entry.driver.rating;
    if (entry.badge != null) return (entry.badge!, const Color(0xFFFBBF24));
    if (rating >= 4.9) return ('Conductor top', const Color(0xFFFBBF24));
    if (rating >= 4.7) return ('Muy confiable', const Color(0xFFB9C3D6));
    return ('Favorito', const Color(0xFFCD8032));
  }

  @override
  Widget build(BuildContext context) {
    final driver = entry.driver;
    final carStyle = carColorStyles[driver.carColor]!;
    final (badgeLabel, badgeColor) = _tier;

    return SizedBox(
      width: 236,
      child: GlassCard(
        radius: 18,
        padding: EdgeInsets.zero,
        tint: carStyle.glow.withValues(alpha: 0.045),
        onTap: onViewProfile,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Decorative accent bar matching the driver's own car color —
            // a quick visual fingerprint that also breaks up the grid so
            // every card doesn't read identically at a glance.
            Container(
              height: 4,
              decoration: BoxDecoration(gradient: LinearGradient(colors: carStyle.gradient)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileAvatar(name: driver.driverName, size: 44, background: LandingColors.accent, online: entry.onlineNow),
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
                                if (entry.onlineNow) ...[
                                  const SizedBox(width: 8),
                                  Container(width: 3, height: 3, decoration: const BoxDecoration(color: LandingColors.success, shape: BoxShape.circle)),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      'En línea',
                                      style: LandingType.body(size: 10.5, color: LandingColors.success),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      _FavoriteToggle(onTap: onToggleFavorite),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _Badge(label: badgeLabel, color: badgeColor),
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
                                Expanded(child: Text('${entry.tripsTogether} viajes juntos', style: LandingType.body(size: 10.5), overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Usual route — real trip data that already existed on
                  // TripOffer but wasn't shown here before.
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('RUTA HABITUAL', style: LandingType.eyebrow(color: LandingColors.textTertiary).copyWith(fontSize: 8.5)),
                        const SizedBox(height: 3),
                        Text(
                          '${driver.origin} → ${driver.destination}',
                          style: const TextStyle(color: LandingColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.schedule_rounded, size: 12, color: LandingColors.textTertiary),
                      const SizedBox(width: 5),
                      Expanded(child: Text('Último viaje: ${entry.lastTripLabel}', style: LandingType.body(size: 10.5), overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: SecondaryButton(label: 'Ver perfil', onTap: onViewProfile)),
                      const SizedBox(width: 8),
                      GhostIconButton(icon: Icons.chat_bubble_outline_rounded, tooltip: 'Enviar mensaje', onTap: onMessage, size: 40),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.workspace_premium_rounded, size: 11, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _FavoriteToggle extends StatefulWidget {
  final VoidCallback onTap;
  const _FavoriteToggle({required this.onTap});

  @override
  State<_FavoriteToggle> createState() => _FavoriteToggleState();
}

class _FavoriteToggleState extends State<_FavoriteToggle> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Quitar de favoritos',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _hover ? 1.15 : 1.0,
            duration: const Duration(milliseconds: 140),
            child: const Icon(Icons.star_rounded, size: 20, color: Color(0xFFFBBF24)),
          ),
        ),
      ),
    );
  }
}
