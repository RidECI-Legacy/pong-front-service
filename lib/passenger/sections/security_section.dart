import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../components/glass_card.dart';
import '../components/section_title.dart';
import '../components/security_card.dart';
import '../passenger_actions.dart';
import '../theme.dart';

/// SECTION "Seguridad": the full security center, plus the trusted
/// emergency contact on file.
class SecuritySection extends StatelessWidget {
  const SecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    final contact = MockData.emergencyContact;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(icon: Icons.shield_rounded, title: 'Centro de seguridad', subtitle: 'Emergencia, reportes y consejos de seguridad', accent: LandingColors.primaryLight),
        const SizedBox(height: 20),
        LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 900;
          final security = SecurityCard(
            onEmergency: () => showEmergencyDialog(context),
            onReport: () => showActionSnack(context, 'Abriendo formulario de reporte…', icon: Icons.flag_rounded),
            onOpenCenter: () => showActionSnack(context, 'Ya estás en el Centro de Seguridad.'),
          );
          final contactCard = GlassCard(
            radius: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CONTACTO DE CONFIANZA', style: LandingType.eyebrow(color: LandingColors.textTertiary).copyWith(fontSize: 10)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: LandingColors.primary.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.person_rounded, size: 20, color: LandingColors.primaryLight),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(contact.name, style: LandingType.cardTitle(size: 13.5)),
                          Text('${contact.relation} · ${contact.phone}', style: LandingType.body(size: 11.5)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Este contacto recibirá tu ubicación en tiempo real si activas el botón de emergencia durante un viaje.',
                  style: LandingType.body(size: 11.5),
                ),
              ],
            ),
          );
          if (isMobile) return Column(children: [security, const SizedBox(height: 20), contactCard]);
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 3, child: security), const SizedBox(width: 20), Expanded(flex: 2, child: contactCard)]);
        }),
      ],
    );
  }
}
