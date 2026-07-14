import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../passenger/components/buttons.dart';
import '../../passenger/components/glass_card.dart';
import '../../passenger/components/security_card.dart';
import '../../passenger/passenger_actions.dart';
import '../../passenger/theme.dart';

/// SECTION "Seguridad": emergency + report tools, reused verbatim from the
/// passenger design system, plus a list of reports the driver has filed
/// about their own passengers.
class DriverSecuritySection extends StatelessWidget {
  const DriverSecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Centro de seguridad', style: LandingType.cardTitle(size: 18)),
        const SizedBox(height: 16),
        LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 900;
          final security = SecurityCard(
            onEmergency: () => showEmergencyDialog(context),
            onReport: () => showActionSnack(context, 'Abriendo formulario de reporte…', icon: Icons.flag_rounded),
            onOpenCenter: () => showActionSnack(context, 'Ya estás en el Centro de Seguridad.'),
          );
          final reports = GlassCard(
            radius: 22,
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('REPORTES SOBRE MIS PASAJEROS', style: LandingType.eyebrow(color: LandingColors.textTertiary).copyWith(fontSize: 10.5)),
                const SizedBox(height: 14),
                if (MockData.myFiledReports.isEmpty)
                  Text('No has presentado reportes.', style: LandingType.body(size: 12.5))
                else
                  for (final r in MockData.myFiledReports) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(r.reportedUser, style: LandingType.cardTitle(size: 13)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: LandingColors.warning.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(999)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.hourglass_empty_rounded, size: 10, color: LandingColors.warning),
                                    const SizedBox(width: 4),
                                    Text(r.status, style: const TextStyle(color: LandingColors.warning, fontSize: 10.5, fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(r.description, style: LandingType.body(size: 12)),
                        ],
                      ),
                    ),
                  ],
                const SizedBox(height: 4),
                SecondaryButton(
                  label: 'Reportar un pasajero',
                  icon: Icons.flag_outlined,
                  expand: true,
                  onTap: () => showActionSnack(context, 'Abriendo formulario para reportar a un pasajero…', icon: Icons.flag_rounded),
                ),
              ],
            ),
          );

          if (isMobile) {
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [security, const SizedBox(height: 20), reports]);
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 6, child: security),
              const SizedBox(width: 24),
              Expanded(flex: 5, child: reports),
            ],
          );
        }),
      ],
    );
  }
}
