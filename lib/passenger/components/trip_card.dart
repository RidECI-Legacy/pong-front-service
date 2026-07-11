import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../theme.dart';
import 'buttons.dart';
import 'glass_card.dart';
import 'profile_avatar.dart';

/// A recommended-trip card: driver, rating, vehicle, seats, schedule, price
/// and a "Reservar" CTA, with an animated favorite toggle.
class TripCard extends StatefulWidget {
  final TripOffer trip;
  final VoidCallback onReserve;
  final bool initiallyFavorite;

  const TripCard({super.key, required this.trip, required this.onReserve, this.initiallyFavorite = false});

  @override
  State<TripCard> createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
  late bool _favorite = widget.initiallyFavorite;

  String _formatCop(int value) {
    final s = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final posFromEnd = s.length - i;
      buffer.write(s[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buffer.write('.');
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    return GlassCard(
      radius: 20,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ProfileAvatar(name: trip.driverName, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(trip.driverName, style: LandingType.cardTitle(size: 14)),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 13, color: Color(0xFFFBBF24)),
                        const SizedBox(width: 3),
                        Text('${trip.rating}', style: LandingType.body(size: 12, color: LandingColors.textSecondary)),
                        const SizedBox(width: 8),
                        Icon(Icons.directions_car_rounded, size: 12, color: LandingColors.textTertiary),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(trip.car, style: LandingType.body(size: 12), overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _FavoriteButton(active: _favorite, onTap: () => setState(() => _favorite = !_favorite)),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('RUTA', style: LandingType.eyebrow(color: LandingColors.textTertiary).copyWith(fontSize: 9)),
                      const SizedBox(height: 3),
                      Text('${trip.origin} → ${trip.destination}', style: const TextStyle(color: LandingColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _MiniStat(icon: Icons.schedule_rounded, label: 'Salida', value: trip.time)),
              Expanded(child: _MiniStat(icon: Icons.event_seat_rounded, label: 'Cupos', value: '${trip.seats}')),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('\$${_formatCop(trip.price)}', style: LandingType.cardTitle(size: 17, color: LandingColors.success)),
                  Text('por persona', style: LandingType.body(size: 10.5, color: LandingColors.textTertiary)),
                ],
              ),
              const Spacer(),
              PrimaryButton(label: 'Reservar', onTap: widget.onReserve, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MiniStat({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: LandingColors.textTertiary),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: const TextStyle(color: LandingColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w700)),
            Text(label, style: LandingType.body(size: 9.5, color: LandingColors.textTertiary)),
          ],
        ),
      ],
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;
  const _FavoriteButton({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: AnimatedScale(
            scale: active ? 1.15 : 1.0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.elasticOut,
            child: Icon(
              active ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              size: 20,
              color: active ? LandingColors.danger : LandingColors.textTertiary,
            ),
          ),
        ),
      ),
    );
  }
}
