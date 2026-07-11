import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../passenger_section.dart';
import '../theme.dart';
import 'profile_avatar.dart';

/// The 260px passenger sidebar: logo, passenger badge, animated nav list
/// and a sign-out action — always dark/glass, matching the landing design.
class PassengerSidebar extends StatelessWidget {
  final RiderProfile rider;
  final PassengerSection selected;
  final ValueChanged<PassengerSection> onSelect;
  final VoidCallback onLogout;

  const PassengerSidebar({
    super.key,
    required this.rider,
    required this.selected,
    required this.onSelect,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: LandingColors.bgDeepest,
        border: Border(right: BorderSide(color: LandingColors.glassBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Image.asset('assets/branding/rideci_icon.png', width: 30, height: 30, fit: BoxFit.cover),
                ),
                const SizedBox(width: 10),
                Text('RidECI', style: LandingType.cardTitle(size: 16)),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: LandingColors.glassBorder),
              ),
              child: Row(
                children: [
                  ProfileAvatar(name: rider.name, size: 32, background: LandingColors.success),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          rider.name,
                          style: LandingType.cardTitle(size: 12.5),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text('Pasajero', style: LandingType.body(size: 10.5, color: LandingColors.success)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              children: [
                for (final section in PassengerSection.values)
                  _NavTile(
                    section: section,
                    active: section == selected,
                    onTap: () => onSelect(section),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Divider(color: LandingColors.glassBorder, height: 1),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
            child: _NavActionTile(icon: Icons.logout_rounded, label: 'Cerrar sesión', onTap: onLogout),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatefulWidget {
  final PassengerSection section;
  final bool active;
  final VoidCallback onTap;

  const _NavTile({required this.section, required this.active, required this.onTap});

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.active;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(11),
          child: InkWell(
            borderRadius: BorderRadius.circular(11),
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              decoration: BoxDecoration(
                color: active ? LandingColors.success.withValues(alpha: 0.14) : (_hover ? Colors.white.withValues(alpha: 0.04) : Colors.transparent),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 3,
                    height: active ? 16 : 0,
                    decoration: BoxDecoration(color: LandingColors.success, borderRadius: BorderRadius.circular(3)),
                  ),
                  SizedBox(width: active ? 9 : 12),
                  Icon(widget.section.icon, size: 18, color: active ? LandingColors.success : LandingColors.textSecondary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.section.label,
                      style: TextStyle(
                        color: active ? LandingColors.textPrimary : LandingColors.textSecondary,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavActionTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavActionTile({required this.icon, required this.label, required this.onTap});

  @override
  State<_NavActionTile> createState() => _NavActionTileState();
}

class _NavActionTileState extends State<_NavActionTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(11),
        child: InkWell(
          borderRadius: BorderRadius.circular(11),
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: _hover ? LandingColors.danger.withValues(alpha: 0.08) : Colors.transparent,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              children: [
                Icon(widget.icon, size: 17, color: _hover ? LandingColors.danger : LandingColors.textTertiary),
                const SizedBox(width: 12),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: _hover ? LandingColors.danger : LandingColors.textTertiary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
