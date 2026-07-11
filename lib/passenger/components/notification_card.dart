import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../theme.dart';

/// A single notification row with an unread accent stripe/dot.
class NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback? onTap;

  const NotificationCard({super.key, required this.notification, this.onTap});

  IconData get _icon {
    final t = notification.title.toLowerCase();
    if (t.contains('camino') || t.contains('conductor')) return Icons.directions_car_rounded;
    if (t.contains('confirm')) return Icons.check_circle_rounded;
    if (t.contains('calific')) return Icons.star_rounded;
    if (t.contains('final')) return Icons.flag_rounded;
    return Icons.notifications_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final unread = notification.unread;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: unread ? LandingColors.accent.withValues(alpha: 0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: unread ? LandingColors.accent.withValues(alpha: 0.2) : LandingColors.glassBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: (unread ? LandingColors.accent : LandingColors.textTertiary).withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_icon, size: 16, color: unread ? LandingColors.accent : LandingColors.textTertiary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(notification.title, style: LandingType.cardTitle(size: 12.5)),
                    const SizedBox(height: 3),
                    Text(notification.subtitle, style: LandingType.body(size: 11.5, color: LandingColors.textSecondary)),
                    const SizedBox(height: 5),
                    Text(notification.time, style: LandingType.body(size: 10, color: LandingColors.textTertiary).copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              if (unread) Container(width: 7, height: 7, margin: const EdgeInsets.only(top: 4), decoration: const BoxDecoration(color: LandingColors.accent, shape: BoxShape.circle)),
            ],
          ),
        ),
      ),
    );
  }
}
