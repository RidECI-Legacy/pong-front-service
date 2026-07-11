import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class TripListItem extends StatelessWidget {
  final String name;
  final String subtitle;
  final String amountLabel;
  final String status;
  final Color statusColor;
  final Color avatarColor;
  final IconData? statusIcon;

  const TripListItem({
    super.key,
    required this.name,
    required this.subtitle,
    required this.amountLabel,
    required this.status,
    required this.statusColor,
    this.avatarColor = AppColors.mint,
    this.statusIcon,
  });

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length < 2) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: avatarColor.withValues(alpha: 0.18),
            child: Text(
              _initials,
              style: TextStyle(color: avatarColor, fontWeight: FontWeight.w800, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: AppColors.textDark)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (statusIcon != null) ...[
                      Icon(statusIcon, size: 10, color: statusColor),
                      const SizedBox(width: 4),
                    ],
                    Text(status, style: TextStyle(color: statusColor, fontSize: 10.5, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(amountLabel, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5, color: AppColors.textDark)),
            ],
          ),
        ],
      ),
    );
  }
}
