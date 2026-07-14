import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../passenger/components/buttons.dart';
import '../../passenger/components/profile_avatar.dart';
import '../../passenger/theme.dart';

/// One confirmed/pending passenger on the driver's current trip: avatar,
/// name, pickup point, a status pill and a quick "reportar" action.
class PassengerRow extends StatelessWidget {
  final ConfirmedPassenger passenger;
  final VoidCallback onReport;
  final VoidCallback? onChat;

  const PassengerRow({super.key, required this.passenger, required this.onReport, this.onChat});

  @override
  Widget build(BuildContext context) {
    final pending = passenger.status == 'Pendiente';
    final color = pending ? LandingColors.warning : LandingColors.success;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          ProfileAvatar(name: passenger.name, size: 34),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(passenger.name, style: LandingType.cardTitle(size: 13), overflow: TextOverflow.ellipsis),
                Row(
                  children: [
                    Icon(Icons.place_rounded, size: 11, color: LandingColors.textTertiary),
                    const SizedBox(width: 3),
                    Expanded(child: Text(passenger.pickup, style: LandingType.body(size: 11.5), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(pending ? Icons.hourglass_empty_rounded : Icons.check_circle_rounded, size: 11, color: color),
                const SizedBox(width: 4),
                Text(passenger.status, style: TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          if (onChat != null) GhostIconButton(icon: Icons.chat_bubble_outline_rounded, tooltip: 'Chatear', onTap: onChat, size: 34),
          GhostIconButton(icon: Icons.flag_outlined, tooltip: 'Reportar pasajero', onTap: onReport, size: 34),
        ],
      ),
    );
  }
}
