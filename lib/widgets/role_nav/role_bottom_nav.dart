import 'package:flutter/material.dart';

import '../../passenger/theme.dart';
import 'role_nav_item.dart';

/// Mobile bottom navigation shared by every dashboard: shows the first
/// [primaryCount] items directly and folds the rest into a "Más" sheet so
/// every destination stays reachable on small screens.
class RoleBottomNav extends StatelessWidget {
  final List<RoleNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onLogout;
  final Color accent;
  final int primaryCount;

  const RoleBottomNav({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
    required this.onLogout,
    this.accent = LandingColors.success,
    this.primaryCount = 4,
  });

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
                for (var i = primaryCount; i < items.length; i++)
                  ListTile(
                    leading: Icon(items[i].icon, color: LandingColors.textSecondary, size: 20),
                    title: Text(items[i].label, style: LandingType.body(size: 14, color: LandingColors.textPrimary)),
                    trailing: selectedIndex == i ? Icon(Icons.check_rounded, color: accent, size: 18) : null,
                    onTap: () {
                      Navigator.of(context).pop();
                      onSelect(i);
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
    final moreActive = selectedIndex >= primaryCount;
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
            for (var i = 0; i < items.length && i < primaryCount; i++)
              _NavItem(item: items[i], active: i == selectedIndex, accent: accent, onTap: () => onSelect(i)),
            if (items.length > primaryCount)
              _NavItem(
                item: const RoleNavItem(Icons.more_horiz_rounded, 'Más'),
                active: moreActive,
                accent: accent,
                onTap: () => _openMore(context),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final RoleNavItem item;
  final bool active;
  final Color accent;
  final VoidCallback onTap;

  const _NavItem({required this.item, required this.active, required this.accent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = active ? accent : LandingColors.textTertiary;
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
              Icon(item.icon, size: 20, color: color),
              const SizedBox(height: 3),
              Text(
                item.label,
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
