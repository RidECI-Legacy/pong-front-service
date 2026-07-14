import 'package:flutter/material.dart';

import '../components/glass_card.dart';
import '../components/section_title.dart';
import '../theme.dart';

/// SECTION "Configuración": lightweight preference toggles. No detailed
/// spec was provided for this destination, so it stays intentionally
/// simple rather than inventing unrelated functionality.
class SettingsSection extends StatefulWidget {
  const SettingsSection({super.key});

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _shareLocationAlways = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(icon: Icons.settings_rounded, title: 'Configuración', subtitle: 'Notificaciones y privacidad', accent: LandingColors.textSecondary),
        const SizedBox(height: 20),
        GlassCard(
          radius: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('NOTIFICACIONES', style: LandingType.eyebrow(color: LandingColors.textTertiary).copyWith(fontSize: 10)),
              const SizedBox(height: 8),
              _SettingsSwitch(
                title: 'Notificaciones push',
                subtitle: 'Recibe alertas cuando tu conductor esté en camino.',
                value: _pushNotifications,
                onChanged: (v) => setState(() => _pushNotifications = v),
              ),
              _SettingsSwitch(
                title: 'Notificaciones por correo',
                subtitle: 'Resumen semanal de tus viajes e impacto.',
                value: _emailNotifications,
                onChanged: (v) => setState(() => _emailNotifications = v),
              ),
              const Divider(color: LandingColors.glassBorder, height: 28),
              Text('PRIVACIDAD', style: LandingType.eyebrow(color: LandingColors.textTertiary).copyWith(fontSize: 10)),
              const SizedBox(height: 8),
              _SettingsSwitch(
                title: 'Compartir ubicación siempre',
                subtitle: 'En vez de solo durante viajes activos.',
                value: _shareLocationAlways,
                onChanged: (v) => setState(() => _shareLocationAlways = v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitch({required this.title, required this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: LandingType.cardTitle(size: 13)),
                const SizedBox(height: 3),
                Text(subtitle, style: LandingType.body(size: 11.5, color: LandingColors.textTertiary)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: LandingColors.success),
        ],
      ),
    );
  }
}
