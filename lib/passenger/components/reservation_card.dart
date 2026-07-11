import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../theme.dart';
import 'buttons.dart';
import 'glass_card.dart';
import 'profile_avatar.dart';
import 'status_badge.dart';

/// The large, highlighted "upcoming reservation" card: driver, vehicle,
/// departure, meeting point, ETA, live status and a "Ver detalles" CTA.
class ReservationCard extends StatelessWidget {
  final ActiveTrip trip;
  final String meetingPoint;
  final VoidCallback onViewDetails;
  final VoidCallback? onChat;
  final VoidCallback? onEmergency;

  const ReservationCard({
    super.key,
    required this.trip,
    required this.meetingPoint,
    required this.onViewDetails,
    this.onChat,
    this.onEmergency,
  });

  TripStatus get _status => trip.etaMinutes <= 8 ? TripStatus.driverOnWay : TripStatus.confirmed;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      radius: 22,
      padding: const EdgeInsets.all(22),
      tint: LandingColors.primary.withValues(alpha: 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('TU PRÓXIMO VIAJE', style: LandingType.eyebrow()),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onEmergency != null) ...[
                    GhostIconButton(icon: Icons.sos_rounded, tooltip: 'Emergencia', onTap: onEmergency),
                    const SizedBox(width: 8),
                  ],
                  StatusBadge(status: _status),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          LayoutBuilder(builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 560;
            final driverBlock = Row(
              children: [
                ProfileAvatar(name: trip.driverName, size: 48, background: LandingColors.success, online: true),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(trip.driverName, style: LandingType.cardTitle(size: 16)),
                      Text(trip.car, style: LandingType.body(size: 12.5)),
                    ],
                  ),
                ),
                if (onChat != null)
                  GhostIconButton(icon: Icons.chat_bubble_rounded, tooltip: 'Chatear', onTap: onChat),
              ],
            );

            final infoGrid = Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                _InfoTile(icon: Icons.schedule_rounded, label: 'Llega en', value: '${trip.etaMinutes} min'),
                _InfoTile(icon: Icons.place_rounded, label: 'Punto de encuentro', value: meetingPoint),
                _InfoTile(icon: Icons.flag_rounded, label: 'Llegada estimada', value: '~${trip.etaMinutes + 22} min'),
              ],
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                driverBlock,
                const SizedBox(height: 16),
                infoGrid,
                const SizedBox(height: 20),
                SizedBox(
                  width: isMobile ? double.infinity : null,
                  child: PrimaryButton(label: 'Ver detalles', icon: Icons.arrow_forward_rounded, onTap: onViewDetails, expand: isMobile),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 140),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: LandingColors.primary.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 15, color: LandingColors.primaryLight),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value, style: const TextStyle(color: LandingColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
              Text(label, style: LandingType.body(size: 10.5, color: LandingColors.textTertiary), overflow: TextOverflow.ellipsis),
            ],
          ),
        ],
      ),
    );
  }
}
