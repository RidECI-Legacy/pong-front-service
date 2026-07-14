import 'package:flutter/material.dart';

import '../admin/admin_dashboard_screen.dart';

/// Entry point kept for the router: the actual premium admin dashboard
/// lives under lib/admin/ (components/, sections/) and reuses the
/// RidECI landing design system for full visual consistency with the
/// passenger and driver dashboards.
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminDashboardScreen();
  }
}
