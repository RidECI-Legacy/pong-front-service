import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../data/models.dart';
import '../../passenger/components/buttons.dart';
import '../../passenger/components/glass_card.dart';
import '../../passenger/components/status_badge.dart';
import '../../passenger/theme.dart';
import '../../widgets/live_route_map.dart';
import 'passenger_row.dart';

/// The driver's "trip in progress" hub: status, quick stats, a live
/// TomTom route map and the confirmed-passenger list with per-passenger
/// chat/report actions — everything needed to run the current trip
/// without leaving the dashboard.
class CurrentTripCard extends StatelessWidget {
  final List<ConfirmedPassenger> passengers;
  final VoidCallback onEmergency;
  final void Function(ConfirmedPassenger passenger) onChatPassenger;
  final void Function(ConfirmedPassenger passenger) onReportPassenger;

  const CurrentTripCard({
    super.key,
    required this.passengers,
    required this.onEmergency,
    required this.onChatPassenger,
    required this.onReportPassenger,
  });

  // Same real Bogotá commute points used by the passenger dashboard map.
  static const _origin = LatLng(4.7108, -74.1132);
  static const _destination = LatLng(4.7620, -74.0445);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      radius: 22,
      padding: const EdgeInsets.all(22),
      tint: LandingColors.primary.withValues(alpha: 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('VIAJE EN CURSO', style: LandingType.eyebrow()),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GhostIconButton(icon: Icons.sos_rounded, tooltip: 'Emergencia', onTap: onEmergency),
                  const SizedBox(width: 8),
                  const StatusBadge(status: TripStatus.inProgress),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 20,
            runSpacing: 14,
            children: const [
              _InfoTile(icon: Icons.schedule_rounded, label: 'Duración', value: '18 min'),
              _InfoTile(icon: Icons.savings_rounded, label: 'Ganancia', value: '\$13.500'),
              _InfoTile(icon: Icons.near_me_rounded, label: 'Distancia', value: '9.2 km'),
              _InfoTile(icon: Icons.groups_rounded, label: 'Pasajeros', value: '2/3'),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 260,
              child: LiveRouteMap(
                origin: _origin,
                destination: _destination,
                originLabel: 'Portal 80',
                destinationLabel: 'Escuela Ing. Julio Garavito',
                driverName: 'Tú',
                etaMinutes: 18,
                progress: 0.45,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('PASAJEROS CONFIRMADOS', style: LandingType.eyebrow(color: LandingColors.textTertiary).copyWith(fontSize: 10.5)),
              Text('${passengers.length} en el viaje', style: LandingType.body(size: 11, color: LandingColors.textTertiary)),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: [
                for (var i = 0; i < passengers.length; i++) ...[
                  PassengerRow(
                    passenger: passengers[i],
                    onChat: () => onChatPassenger(passengers[i]),
                    onReport: () => onReportPassenger(passengers[i]),
                  ),
                  if (i != passengers.length - 1) Divider(height: 1, color: LandingColors.glassBorder),
                ],
              ],
            ),
          ),
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
      constraints: const BoxConstraints(minWidth: 120),
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
              Text(value, style: const TextStyle(color: LandingColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
              Text(label, style: LandingType.body(size: 10.5, color: LandingColors.textTertiary)),
            ],
          ),
        ],
      ),
    );
  }
}
