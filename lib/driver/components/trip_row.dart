import 'package:flutter/material.dart';

import '../../passenger/components/status_badge.dart';
import '../../passenger/theme.dart';

/// A single trip row shared by "Mis viajes" and the dashboard history list:
/// route icon, title/subtitle, amount and a status pill. Reuses the
/// passenger [StatusBadge]/[TripStatus] so trip states read identically
/// across every role.
class TripRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amountLabel;
  final TripStatus status;
  final Color amountColor;

  const TripRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amountLabel,
    required this.status,
    this.amountColor = LandingColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: LandingColors.primary.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(11)),
            child: const Icon(Icons.route_rounded, size: 17, color: LandingColors.primaryLight),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: LandingType.cardTitle(size: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(subtitle, style: LandingType.body(size: 11.5), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(amountLabel, style: TextStyle(color: amountColor, fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              StatusBadge(status: status, withIcon: false),
            ],
          ),
        ],
      ),
    );
  }
}
