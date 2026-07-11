import 'package:flutter/material.dart';

import '../theme.dart';

/// The trip/reservation lifecycle used across the dashboard.
enum TripStatus { pending, confirmed, driverOnWay, inProgress, completed, cancelled }

extension TripStatusX on TripStatus {
  String get label => switch (this) {
        TripStatus.pending => 'Pendiente',
        TripStatus.confirmed => 'Confirmado',
        TripStatus.driverOnWay => 'Conductor en camino',
        TripStatus.inProgress => 'En curso',
        TripStatus.completed => 'Completado',
        TripStatus.cancelled => 'Cancelado',
      };

  Color get color => switch (this) {
        TripStatus.pending => LandingColors.warning,
        TripStatus.confirmed => LandingColors.primaryLight,
        TripStatus.driverOnWay => LandingColors.accent,
        TripStatus.inProgress => LandingColors.success,
        TripStatus.completed => LandingColors.success,
        TripStatus.cancelled => LandingColors.danger,
      };

  IconData get icon => switch (this) {
        TripStatus.pending => Icons.schedule_rounded,
        TripStatus.confirmed => Icons.check_circle_rounded,
        TripStatus.driverOnWay => Icons.directions_car_rounded,
        TripStatus.inProgress => Icons.navigation_rounded,
        TripStatus.completed => Icons.task_alt_rounded,
        TripStatus.cancelled => Icons.cancel_rounded,
      };
}

/// Small colored pill communicating a trip/reservation status.
class StatusBadge extends StatelessWidget {
  final TripStatus status;
  final bool withIcon;

  const StatusBadge({super.key, required this.status, this.withIcon = true});

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (withIcon) ...[
            Icon(status.icon, size: 11, color: color),
            const SizedBox(width: 5),
          ],
          Text(status.label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
