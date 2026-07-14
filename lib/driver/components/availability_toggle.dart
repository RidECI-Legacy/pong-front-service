import 'package:flutter/material.dart';

import '../../passenger/theme.dart';

/// Tappable "Disponible / No disponible" pill shown in the driver topbar —
/// lets the driver signal at a glance (and with one tap) whether they're
/// open to new trip requests right now (Nielsen: visibility of system
/// status, user control & freedom).
class AvailabilityToggle extends StatelessWidget {
  final bool available;
  final VoidCallback onTap;

  const AvailabilityToggle({super.key, required this.available, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = available ? LandingColors.success : LandingColors.textTertiary;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: color.withValues(alpha: 0.35)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(
                available ? 'Disponible' : 'No disponible',
                style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
