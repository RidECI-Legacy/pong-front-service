import 'package:flutter/material.dart';

import '../theme.dart';
import 'buttons.dart';
import 'glass_card.dart';

/// The dashboard's security section: emergency button, report incident,
/// ride tracking, verified-community badge and safety tips. Uses the
/// primary/accent palette rather than alarming reds so it stands out
/// without feeling like a warning.
class SecurityCard extends StatelessWidget {
  final VoidCallback onEmergency;
  final VoidCallback onReport;
  final VoidCallback onOpenCenter;

  const SecurityCard({super.key, required this.onEmergency, required this.onReport, required this.onOpenCenter});

  static const _tips = [
    'Comparte tu ubicación en tiempo real con tu contacto de confianza durante el viaje.',
    'Verifica que la placa y el conductor coincidan con lo mostrado en la app antes de subir.',
    'Evita compartir información personal sensible con conductores o pasajeros desconocidos.',
  ];

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      radius: 22,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: LandingColors.primary.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.shield_rounded, size: 20, color: LandingColors.primaryLight),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Seguridad', style: LandingType.cardTitle(size: 16)),
                    Text('Comunidad verificada · ayuda a un toque', style: LandingType.body(size: 11.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LayoutBuilder(builder: (context, constraints) {
            final columns = constraints.maxWidth < 420 ? 1 : 2;
            final gap = 10.0;
            final width = (constraints.maxWidth - (columns - 1) * gap) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                SizedBox(width: width, child: _MiniAction(icon: Icons.sos_rounded, label: 'Botón de emergencia', color: LandingColors.danger, onTap: onEmergency)),
                SizedBox(width: width, child: _MiniAction(icon: Icons.flag_outlined, label: 'Reportar incidente', color: LandingColors.warning, onTap: onReport)),
                SizedBox(width: width, child: const _MiniAction(icon: Icons.my_location_rounded, label: 'Rastreo en vivo activo', color: LandingColors.accent)),
                SizedBox(width: width, child: const _MiniAction(icon: Icons.verified_user_rounded, label: 'Comunidad verificada', color: LandingColors.success)),
              ],
            );
          }),
          const SizedBox(height: 18),
          Text('CONSEJOS DE SEGURIDAD', style: LandingType.eyebrow(color: LandingColors.textTertiary).copyWith(fontSize: 10)),
          const SizedBox(height: 10),
          for (final tip in _tips) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_outline_rounded, size: 14, color: LandingColors.success),
                const SizedBox(width: 8),
                Expanded(child: Text(tip, style: LandingType.body(size: 11.5))),
              ],
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 8),
          PrimaryButton(label: 'Centro de Seguridad', icon: Icons.security_rounded, onTap: onOpenCenter, expand: true),
        ],
      ),
    );
  }
}

class _MiniAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _MiniAction({required this.icon, required this.label, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha: 0.25))),
          child: Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 9),
              Expanded(child: Text(label, style: TextStyle(color: color, fontSize: 11.5, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
      ),
    );
  }
}
