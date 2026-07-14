import 'package:flutter/material.dart';

import '../../passenger/components/profile_avatar.dart';
import '../../passenger/theme.dart';
import 'role_nav_item.dart';

/// The 260px role sidebar shared by every dashboard (passenger, driver,
/// admin): logo, role badge, animated nav list and a sign-out action —
/// always dark/glass, matching the landing design. [accent] tints the
/// active nav item and the role badge so each role keeps a distinct
/// identity while still feeling like the same product.
class RoleSidebar extends StatelessWidget {
  final String userName;
  final String roleLabel;
  final Color accent;
  final List<RoleNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onLogout;

  const RoleSidebar({
    super.key,
    required this.userName,
    required this.roleLabel,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
    required this.onLogout,
    this.accent = LandingColors.success,
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
                  ProfileAvatar(name: userName, size: 32, background: accent),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(userName, style: LandingType.cardTitle(size: 12.5), overflow: TextOverflow.ellipsis),
                        Text(roleLabel, style: LandingType.body(size: 10.5, color: accent)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: items.length,
              itemBuilder: (context, i) => _NavTile(
                item: items[i],
                active: i == selectedIndex,
                accent: accent,
                onTap: () => onSelect(i),
              ),
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
  final RoleNavItem item;
  final bool active;
  final Color accent;
  final VoidCallback onTap;

  const _NavTile({required this.item, required this.active, required this.accent, required this.onTap});

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.active;
    final accent = widget.accent;
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
                color: active ? accent.withValues(alpha: 0.14) : (_hover ? Colors.white.withValues(alpha: 0.04) : Colors.transparent),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 3,
                    height: active ? 16 : 0,
                    decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(3)),
                  ),
                  SizedBox(width: active ? 9 : 12),
                  Icon(widget.item.icon, size: 18, color: active ? accent : LandingColors.textSecondary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.item.label,
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
