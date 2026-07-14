import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/mock_data.dart';
import '../data/models.dart';
import '../passenger/theme.dart';
import '../routing/app_router.dart';
import '../widgets/role_nav/role_bottom_nav.dart';
import '../widgets/role_nav/role_nav_item.dart';
import '../widgets/role_nav/role_sidebar.dart';
import '../widgets/role_nav/role_topbar.dart';
import 'admin_section.dart';
import 'sections/active_trips_section.dart';
import 'sections/institutional_section.dart';
import 'sections/reports_section.dart';
import 'sections/stats_section.dart';
import 'sections/users_section.dart';
import 'sections/validations_section.dart';

const double _kMobileBreakpoint = 900;
const _kAdminAccent = LandingColors.warning;
const _kAdminName = 'Equipo RidECI';

/// The full RidECI admin dashboard, rebuilt on the same premium dark
/// "SaaS" design system as the passenger and driver dashboards
/// (DesignSystem.md / UI_Guidelines.md).
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  AdminSection _section = AdminSection.validations;
  final _scrollController = ScrollController();
  late List<ValidationRequest> _requests = List.of(MockData.validationRequests);
  late List<SecurityReport> _reports = List.of(MockData.securityReports);

  static final _navItems = [for (final s in AdminSection.values) RoleNavItem(s.icon, s.label)];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigate(AdminSection section) {
    setState(() => _section = section);
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }

  void _logout() => context.go(AppRoutes.landing);

  void _resolveRequest(ValidationRequest request) => setState(() => _requests.remove(request));

  void _updateReportStatus(SecurityReport report, String status) => setState(() => report.status = status);

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

        if (isMobile) {
          return Column(
            children: [
              RoleTopBar(
                scrollController: _scrollController,
                userName: _kAdminName,
                roleLabel: 'Administrador',
                accent: _kAdminAccent,
                unreadNotifications: _requests.length,
                onNotificationsTap: () => _navigate(AdminSection.validations),
                onSettingsTap: () => _navigate(AdminSection.institutional),
                onProfileTap: () => _navigate(AdminSection.users),
              ),
              Expanded(child: content),
              RoleBottomNav(items: _navItems, selectedIndex: AdminSection.values.indexOf(_section), onSelect: (i) => _navigate(AdminSection.values[i]), onLogout: _logout, accent: _kAdminAccent),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RoleSidebar(
              userName: _kAdminName,
              roleLabel: 'Administrador',
              accent: _kAdminAccent,
              items: _navItems,
              selectedIndex: AdminSection.values.indexOf(_section),
              onSelect: (i) => _navigate(AdminSection.values[i]),
              onLogout: _logout,
            ),
            Expanded(
              child: Column(
                children: [
                  RoleTopBar(
                    scrollController: _scrollController,
                    userName: _kAdminName,
                    roleLabel: 'Administrador',
                    accent: _kAdminAccent,
                    unreadNotifications: _requests.length,
                    onNotificationsTap: () => _navigate(AdminSection.validations),
                    onSettingsTap: () => _navigate(AdminSection.institutional),
                    onProfileTap: () => _navigate(AdminSection.users),
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
      case AdminSection.validations:
        return ValidationsSection(requests: _requests, onApprove: _resolveRequest, onSuspend: _resolveRequest);
      case AdminSection.trips:
        return const ActiveTripsSection();
      case AdminSection.reports:
        return ReportsSection(reports: _reports, onStatusChange: _updateReportStatus);
      case AdminSection.stats:
        return const AdminStatsSection();
      case AdminSection.users:
        return const UsersSection();
      case AdminSection.institutional:
        return const InstitutionalSection();
    }
  }
}
