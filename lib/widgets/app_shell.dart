import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routing/app_router.dart';
import '../theme/app_theme.dart';
import 'app_sidebar.dart';
import 'notifications_bell.dart';
import 'theme_toggle_button.dart';

const double kMobileBreakpoint = 860;

class AppShell extends StatelessWidget {
  final IconData roleIcon;
  final String roleLabel;
  final String title;
  final String subtitle;
  final String avatarInitials;
  final List<SidebarItem> navItems;
  final int navSelectedIndex;
  final ValueChanged<int> onNavSelect;
  final Widget child;
  final Widget? trailing;

  const AppShell({
    super.key,
    required this.roleIcon,
    required this.roleLabel,
    required this.title,
    required this.subtitle,
    required this.avatarInitials,
    required this.navItems,
    required this.navSelectedIndex,
    required this.onNavSelect,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        color: AppColors.bg,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < kMobileBreakpoint;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!isMobile)
                  AppSidebar(
                    roleIcon: roleIcon,
                    roleLabel: roleLabel,
                    avatarInitials: avatarInitials,
                    items: navItems,
                    selectedIndex: navSelectedIndex,
                    onSelect: onNavSelect,
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      isMobile ? 16 : 32,
                      isMobile ? 16 : 20,
                      isMobile ? 16 : 32,
                      isMobile ? 16 : 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, isMobile),
                        if (isMobile) ...[
                          const SizedBox(height: 16),
                          _buildMobileNav(),
                        ],
                        const SizedBox(height: 20),
                        child,
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMobileNav() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < navItems.length; i++) ...[
            _MobileNavChip(
              item: navItems[i],
              active: i == navSelectedIndex,
              onTap: () => onNavSelect(i),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(fontSize: 13, color: AppColors.textMuted),
        ),
      ],
    );

    final bell = Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const NotificationsBell(),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: titleBlock),
              const ThemeToggleButton(),
              const SizedBox(width: 10),
              bell,
            ],
          ),
          if (trailing != null) ...[const SizedBox(height: 12), trailing!],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: titleBlock),
        if (trailing != null) ...[trailing!, const SizedBox(width: 16)],
        const ThemeToggleButton(),
        const SizedBox(width: 12),
        bell,
      ],
    );
  }
}

class _MobileNavChip extends StatelessWidget {
  final SidebarItem item;
  final bool active;
  final VoidCallback onTap;

  const _MobileNavChip(
      {required this.item, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? AppColors.textDark : AppColors.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: active ? Colors.transparent : AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon,
                  size: 15, color: active ? Colors.white : AppColors.textMuted),
              const SizedBox(width: 8),
              Text(
                item.label,
                style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: active ? Colors.white : AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
