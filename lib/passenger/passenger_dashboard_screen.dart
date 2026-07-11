import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/mock_data.dart';
import '../data/models.dart';
import '../routing/app_router.dart';
import 'components/passenger_bottom_nav.dart';
import 'components/passenger_sidebar.dart';
import 'components/passenger_topbar.dart';
import 'passenger_section.dart';
import 'sections/dashboard_section.dart';
import 'sections/favorites_section.dart';
import 'sections/history_section.dart';
import 'sections/profile_section.dart';
import 'sections/reservations_section.dart';
import 'sections/search_section.dart';
import 'sections/security_section.dart';
import 'sections/settings_section.dart';
import 'theme.dart';

const double _kMobileBreakpoint = 900;

/// The full RidECI passenger dashboard: a premium, dark, glass "SaaS"
/// interface reusing the landing page's exact design system, with a
/// 260px sidebar + 80px top bar on desktop and a bottom nav on mobile.
class PassengerDashboardScreen extends StatefulWidget {
  const PassengerDashboardScreen({super.key});

  @override
  State<PassengerDashboardScreen> createState() => _PassengerDashboardScreenState();
}

class _PassengerDashboardScreenState extends State<PassengerDashboardScreen> {
  PassengerSection _section = PassengerSection.dashboard;
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigate(PassengerSection section) {
    setState(() => _section = section);
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _logout() => context.go(AppRoutes.landing);

  @override
  Widget build(BuildContext context) {
    final rider = MockData.riderProfile;
    final unread = MockData.notifications.where((n) => n.unread).length;

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
              child: _buildSection(rider),
            ),
          ),
        );

        if (isMobile) {
          return Column(
            children: [
              PassengerTopBar(
                scrollController: _scrollController,
                rider: rider,
                unreadNotifications: unread,
                onNotificationsTap: () => _navigate(PassengerSection.dashboard),
                onSettingsTap: () => _navigate(PassengerSection.settings),
                onProfileTap: () => _navigate(PassengerSection.profile),
              ),
              Expanded(child: content),
              PassengerBottomNav(selected: _section, onSelect: _navigate, onLogout: _logout),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PassengerSidebar(rider: rider, selected: _section, onSelect: _navigate, onLogout: _logout),
            Expanded(
              child: Column(
                children: [
                  PassengerTopBar(
                    scrollController: _scrollController,
                    rider: rider,
                    unreadNotifications: unread,
                    onNotificationsTap: () => _navigate(PassengerSection.dashboard),
                    onSettingsTap: () => _navigate(PassengerSection.settings),
                    onProfileTap: () => _navigate(PassengerSection.profile),
                    onSearchChanged: (q) {
                      if (q.isNotEmpty) _navigate(PassengerSection.search);
                    },
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

  Widget _buildSection(RiderProfile rider) {
    switch (_section) {
      case PassengerSection.dashboard:
        return DashboardSection(
          rider: rider,
          activeTrip: MockData.activeTrip,
          trips: MockData.availableTrips,
          notifications: MockData.notifications,
          onNavigate: _navigate,
        );
      case PassengerSection.search:
        return const SearchSection();
      case PassengerSection.reservations:
        return ReservationsSection(activeTrip: MockData.activeTrip, onViewHistory: () => _navigate(PassengerSection.history));
      case PassengerSection.history:
        return const HistorySection();
      case PassengerSection.favorites:
        return const FavoritesSection();
      case PassengerSection.profile:
        return ProfileSection(rider: rider);
      case PassengerSection.security:
        return const SecuritySection();
      case PassengerSection.settings:
        return const SettingsSection();
    }
  }
}
