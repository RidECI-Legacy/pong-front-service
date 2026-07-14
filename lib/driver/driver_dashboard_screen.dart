import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../passenger/theme.dart';
import '../routing/app_router.dart';
import '../widgets/role_nav/role_bottom_nav.dart';
import '../widgets/role_nav/role_nav_item.dart';
import '../widgets/role_nav/role_sidebar.dart';
import '../widgets/role_nav/role_topbar.dart';
import 'components/availability_toggle.dart';
import 'driver_section.dart';
import 'sections/create_trip_section.dart';
import 'sections/dashboard_section.dart';
import 'sections/my_trips_section.dart';
import 'sections/security_section.dart';
import 'sections/stats_section.dart';
import 'sections/vehicle_section.dart';

const double _kMobileBreakpoint = 900;
const _kDriverAccent = LandingColors.primaryLight;
const _kDriverName = 'Camilo Rojas';

/// The full RidECI driver dashboard, rebuilt on the same premium dark
/// "SaaS" design system as the passenger dashboard (DesignSystem.md /
/// UI_Guidelines.md): 260px sidebar + 80px top bar on desktop, bottom nav
/// on mobile, all glass cards, consistent spacing and motion.
class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  DriverSection _section = DriverSection.dashboard;
  bool _available = true;
  final _scrollController = ScrollController();

  static final _navItems = [for (final s in DriverSection.values) RoleNavItem(s.icon, s.label)];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigate(DriverSection section) {
    setState(() => _section = section);
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }

  void _logout() => context.go(AppRoutes.landing);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LandingColors.bgDeepest,
      body: LayoutBuilder(builder: (context, constraints) {
        final isMobile = constraints.maxWidth < _kMobileBreakpoint;

        final content = SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.fromLTRB(isMobile ? 16 : 32, 20, isMobile ? 16 : 32, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1600),
              child: _buildSection(),
            ),
          ),
        );

        final trailing = AvailabilityToggle(available: _available, onTap: () => setState(() => _available = !_available));

        if (isMobile) {
          return Column(
            children: [
              RoleTopBar(
                scrollController: _scrollController,
                userName: _kDriverName,
                roleLabel: 'Conductor',
                accent: _kDriverAccent,
                unreadNotifications: 0,
                onNotificationsTap: () => _navigate(DriverSection.dashboard),
                onSettingsTap: () => _navigate(DriverSection.dashboard),
                onProfileTap: () => _navigate(DriverSection.vehicle),
                trailing: trailing,
              ),
              Expanded(child: content),
              RoleBottomNav(items: _navItems, selectedIndex: DriverSection.values.indexOf(_section), onSelect: (i) => _navigate(DriverSection.values[i]), onLogout: _logout, accent: _kDriverAccent),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RoleSidebar(
              userName: _kDriverName,
              roleLabel: 'Conductor',
              accent: _kDriverAccent,
              items: _navItems,
              selectedIndex: DriverSection.values.indexOf(_section),
              onSelect: (i) => _navigate(DriverSection.values[i]),
              onLogout: _logout,
            ),
            Expanded(
              child: Column(
                children: [
                  RoleTopBar(
                    scrollController: _scrollController,
                    userName: _kDriverName,
                    roleLabel: 'Conductor',
                    accent: _kDriverAccent,
                    unreadNotifications: 0,
                    onNotificationsTap: () => _navigate(DriverSection.dashboard),
                    onSettingsTap: () => _navigate(DriverSection.dashboard),
                    onProfileTap: () => _navigate(DriverSection.vehicle),
                    trailing: trailing,
                  ),
                  Expanded(child: content),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSection() {
    switch (_section) {
      case DriverSection.dashboard:
        return DriverDashboardSection(driverName: _kDriverName, onNavigate: _navigate);
      case DriverSection.createTrip:
        return const CreateTripSection();
      case DriverSection.myTrips:
        return const MyTripsSection();
      case DriverSection.vehicle:
        return const VehicleSection();
      case DriverSection.stats:
        return const StatsSection();
      case DriverSection.security:
        return const DriverSecuritySection();
    }
  }
}
