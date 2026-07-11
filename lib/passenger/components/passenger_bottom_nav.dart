import 'package:flutter/material.dart';

import '../passenger_section.dart';
import '../theme.dart';

/// Mobile bottom navigation: Dashboard / Buscar / Reservas / Perfil / Más.
/// "Más" opens a sheet with the remaining sections so every destination
/// stays reachable on small screens.
class PassengerBottomNav extends StatelessWidget {
  final PassengerSection selected;
  final ValueChanged<PassengerSection> onSelect;
  final VoidCallback onLogout;

  const PassengerBottomNav({super.key, required this.selected, required this.onSelect, required this.onLogout});

  static const _primary = [
    PassengerSection.dashboard,
    PassengerSection.search,
    PassengerSection.reservations,
    PassengerSection.profile,
  ];

  static const _more = [
    PassengerSection.history,
    PassengerSection.favorites,
    PassengerSection.security,
    PassengerSection.settings,
  ];

  void _openMore(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: LandingColors.bgSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final section in _more)
                  ListTile(
                    leading: Icon(section.icon, color: LandingColors.textSecondary, size: 20),
                    title: Text(section.label, style: LandingType.body(size: 14, color: LandingColors.textPrimary)),
                    trailing: selected == section ? const Icon(Icons.check_rounded, color: LandingColors.success, size: 18) : null,
                    onTap: () {
                      Navigator.of(context).pop();
                      onSelect(section);
                    },
                  ),
                const Divider(color: LandingColors.glassBorder, height: 1),
                ListTile(
                  leading: const Icon(Icons.logout_rounded, color: LandingColors.danger, size: 20),
                  title: Text('Cerrar sesión', style: LandingType.body(size: 14, color: LandingColors.danger)),
                  onTap: () {
                    Navigator.of(context).pop();
                    onLogout();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final moreActive = _more.contains(selected);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: LandingColors.bgDeepest,
        border: Border(top: BorderSide(color: LandingColors.glassBorder)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (final section in _primary) _NavItem(section: section, active: section == selected, onTap: () => onSelect(section)),
            _NavItem(
              section: null,
              icon: Icons.more_horiz_rounded,
              label: 'Más',
              active: moreActive,
              onTap: () => _openMore(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final PassengerSection? section;
  final IconData? icon;
  final String? label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({this.section, this.icon, this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final resolvedIcon = icon ?? section!.icon;
    final resolvedLabel = label ?? section!.label;
    final color = active ? LandingColors.success : LandingColors.textTertiary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(resolvedIcon, size: 20, color: color),
              const SizedBox(height: 3),
              Text(
                resolvedLabel,
                style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: color),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
