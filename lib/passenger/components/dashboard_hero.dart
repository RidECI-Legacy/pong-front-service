import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme.dart';

/// The dashboard greeting: large "Buenos días, {name}" headline, subtitle,
/// and — on wide screens — the current date and campus status.
class DashboardHero extends StatelessWidget {
  final String name;

  const DashboardHero({super.key, required this.name});

  static String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  static String _formattedDate() {
    const days = ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'];
    const months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    final now = DateTime.now();
    final day = days[now.weekday - 1];
    final month = months[now.month - 1];
    return '${day[0].toUpperCase()}${day.substring(1)}, ${now.day} de $month';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 720;
      final greetingBlock = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${_greeting()}, $name 👋', style: LandingType.sectionTitle(size: isMobile ? 24 : 30)),
          const SizedBox(height: 6),
          Text('¿Listo para compartir un nuevo viaje hoy?', style: LandingType.body(size: 14)),
        ],
      );

      final statusBlock = Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: LandingEffects.glassDecoration(radius: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wb_sunny_rounded, size: 15, color: LandingColors.warning),
                const SizedBox(width: 6),
                Text('22°C · Bogotá', style: LandingType.body(size: 12, color: LandingColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 6),
            Text(_formattedDate(), style: LandingType.body(size: 11.5, color: LandingColors.textTertiary)),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 6, height: 6, decoration: const BoxDecoration(color: LandingColors.success, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text('Campus activo', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: LandingColors.success)),
              ],
            ),
          ],
        ),
      );

      if (isMobile) {
        return greetingBlock.animate().fadeIn(duration: 400.ms).slideY(begin: 0.08, curve: Curves.easeOutCubic);
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: greetingBlock),
          const SizedBox(width: 20),
          statusBlock,
        ],
      ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.08, curve: Curves.easeOutCubic);
    });
  }
}
